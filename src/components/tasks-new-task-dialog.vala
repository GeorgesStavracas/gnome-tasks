/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * tasks-new-task-dialog.c
 * Copyright (C) 2014 Georges Basile Stavracas Neto <georges.stavracas@gmail.com>
 * 
 * Tasks is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Tasks is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

namespace Tasks
{

[GtkTemplate (ui = "/apps/tasks/resources/new-task-dialog.ui")]
public class NewTaskDialog : Gtk.Dialog
{
  [GtkChild]
  private Gtk.HeaderBar headerbar;
  [GtkChild]
  private Gtk.Popover calendar_popover;
  [GtkChild]
  private Gtk.Popover time_popover;
  [GtkChild]
  private Gtk.ToggleButton calendar_toggle;
  [GtkChild]
  private Gtk.ToggleButton time_toggle;
  [GtkChild]
  private Gtk.MenuButton list_button;
  [GtkChild]
  private Gtk.Entry name_entry;
  [GtkChild]
  private Gtk.Calendar calendar;
  [GtkChild]
  private Gtk.SpinButton hour_spin;
  [GtkChild]
  private Gtk.SpinButton minute_spin;
  [GtkChild]
  private Gtk.Label time_label;
  [GtkChild]
  private Gtk.Label date_label;
  [GtkChild]
  private Gtk.Label all_day_label;
  [GtkChild]
  private Gtk.Label list_label;
  [GtkChild]
  private Gtk.CheckButton all_day_check;
  [GtkChild]
  private Gtk.Button cancel_button;
  [GtkChild]
  private Gtk.Button create_button;

  protected unowned Tasks.Application app;

  private GLib.SimpleActionGroup action_group;
  private GLib.SimpleAction action;

  private DataSource selected_source;
  private List? selected_list = null;

  private Gee.HashMap<string, unowned Tasks.DataSource> lists_map;

  public NewTaskDialog (Tasks.Application app)
  {
    this.app = app;
    this.set_titlebar (headerbar);

    calendar_toggle.bind_property ("active", calendar_popover, "visible", GLib.BindingFlags.BIDIRECTIONAL);
    time_toggle.bind_property ("active", time_popover, "visible", GLib.BindingFlags.BIDIRECTIONAL);
    hour_spin.bind_property ("sensitive", all_day_check, "active", GLib.BindingFlags.BIDIRECTIONAL |
                                                                   GLib.BindingFlags.INVERT_BOOLEAN);
    minute_spin.bind_property ("sensitive", all_day_check, "active", GLib.BindingFlags.BIDIRECTIONAL |
                                                                   GLib.BindingFlags.INVERT_BOOLEAN);

    hour_spin.activate.connect (()=>{time_popover.visible = false;}); /* lambda function to hide the popover */
    hour_spin.output.connect (this.on_output);
    minute_spin.activate.connect (()=>{time_popover.visible = false;});
    minute_spin.output.connect (this.on_output);
    time_popover.hide.connect (this.on_time_popover_hidden);

    calendar.day_selected.connect (this.on_calendar_day_selected);
    calendar.day_selected_double_click.connect (this.on_calendar_day_selected_double_click);

    cancel_button.clicked.connect_after (on_header_button_clicked);
    create_button.clicked.connect_after (on_header_button_clicked);

    this.fill_source_list ();

    this.set_calendar_toggle_text ();
  }

  protected void fill_source_list ()
  {
    unowned Gee.LinkedList<DataSource> sources;
    GLib.Menu menu;

    sources = Manager.instance.sources;
    action_group = new GLib.SimpleActionGroup ();
    action = new GLib.SimpleAction ("item_selected", GLib.VariantType.STRING);
    menu = new GLib.Menu ();

    lists_map = new Gee.HashMap<string, unowned Tasks.DataSource> ();

    this.insert_action_group ("new_task", action_group);
    action_group.add_action (action);

    action.activate.connect (this.on_source_item_selected);

    /* Fill the sources menu */
    foreach (DataSource source in sources)
    {
      /* FIXME: should add something like 'source.support_listless_task ()' */
      add_source_entry (menu, source);

      foreach (Tasks.List list in source.get_lists ())
        add_source_entry (menu, source, list);
    }

    list_button.menu_model = menu;
  }

  /**
   * Add a source to the sources' list.
   */
  private void add_source_entry (Menu menu, DataSource source, List? list = null)
  {
    GLib.Variant variant;
    GLib.MenuItem item;
    string text, list_name, key;

    /* Select the list name */
    if (list == null)
      list_name = _("Default");
    else
      list_name = list.name;

    text = list_name + " (" + source.get_name () + ")";
    key = source.get_name () + ":" + list_name;

    item = new MenuItem (text, null);
    variant = new Variant.string (key);

    item.set_action_and_target_value ("new_task.item_selected", variant);
    menu.append_item (item);

    lists_map.set (source.get_name (), source);

    /**
     * Select Local source -> default list as the default list
     * by sending a fake SimpleAction:activate signal
     */
    if (key == _("Local")+":"+list_name)
    {
      this.action.activate (variant);
    }
  }

  private void on_source_item_selected (Variant? parameter)
  {
    string key;
    string[] values;

    if (parameter == null)
      return;

    parameter.get ("s", out key);
    values = key.split (":");

    list_label.label = values[1] + " (" + values[0] + ")";

    this.selected_source = lists_map.get (values[0]);
    this.selected_list = null;

    /* Select the list from the source */
    foreach (List l in this.selected_source.get_lists ())
    {
      /* If list name is 'default', no list should be selected */
      if (values[1] != _("Default") && values[1] == l.name)
      {
        this.selected_list = l;
      }

      var tasks = this.selected_source.get_tasks (l);

      foreach (Task t in tasks)
      {
        /* TODO: populate parent list */
      }
    }
  }

  private void on_header_button_clicked (Gtk.Button button)
  {
    if (button == create_button)
      create_task ();

    this.close ();
  }

  private void create_task ()
  {
    Task task;

    task = new Task (-1, name_entry.text, this.selected_source);

    /* Select the task list */
    if (this.selected_list == null)
      task.list_id = -1;
    else
      task.list_id = this.selected_list.id;

    /* Create the task */
    this.selected_source.create_task (task);
  }

  private void on_calendar_day_selected ()
  {
    this.set_calendar_toggle_text ();
  }

  private void on_calendar_day_selected_double_click ()
  {
    this.set_calendar_toggle_text ();
    calendar_popover.visible = false;
  }

  private void on_time_popover_hidden ()
  {
    this.set_hour_toggle_text ();
  }

  private void set_calendar_toggle_text ()
  {
    string toggle_text;
    GLib.Settings settings;

    /* Format date according to the user preferences */
    settings = Settings.instance.settings;
    toggle_text = settings.get_string ("date-format");

    toggle_text = toggle_text.replace ("dd", calendar.day.to_string ())
                             .replace ("mm", (calendar.month+1).to_string ()) // Months range from 0~11
                             .replace ("YYYY", calendar.year.to_string ());

    date_label.label = toggle_text;
  }

  private void set_hour_toggle_text ()
  {
    string time_text;

    if (all_day_check.active)
      time_text = all_day_label.label;
    else
    {
      time_text = (hour_spin.value < 10 ? "0"+hour_spin.text : hour_spin.text)
                  + ":"
                  + (minute_spin.value < 10 ? "0"+minute_spin.text : minute_spin.text);
    }

    time_label.label = time_text;
  }

  private bool on_output (Gtk.SpinButton button)
  {
    button.set_text ("%02d".printf (button.get_value_as_int ()));
    return true;
  }
}

}
