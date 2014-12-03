/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * tasks-window.c
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

public static void clear_listbox (Gtk.ListBox list)
{
  foreach (Gtk.Widget widget in list.get_children ())
    list.remove (widget);
}

[GtkTemplate (ui = "/apps/tasks/resources/window.ui")]
public class Window : Gtk.ApplicationWindow
{
  [GtkChild]
  public Gtk.Overlay overlay;
  [GtkChild]
  public Gtk.Paned tasks_paned;
  [GtkChild]
  public Gtk.ListBox tasks_list;
  [GtkChild]
  public Gtk.ListBox lists_listbox;
  [GtkChild]
  public Gtk.Button back_button;
  [GtkChild]
  public Gtk.MenuButton menu_button;
  [GtkChild]
  public Gtk.Button new_task_button;
  [GtkChild]
  public Gtk.Stack stack1;
  [GtkChild]
  private TaskView task_view;
  [GtkChild]
  private Gtk.SearchBar searchbar;

  protected unowned Tasks.Application app;

  private Gee.LinkedList<unowned Task> current_task_list;

  public Window (Tasks.Application app) {
    Object(application: app);
    this.app = app;

    overlay.show_all ();

    /* Tasks are always sorted */
    tasks_list.set_sort_func (Tasks.sort_task_rows);

    current_task_list = new Gee.LinkedList<unowned Task> ();

    setup_signals ();
    setup_lists ();
    setup_menu ();
  }

  private void setup_lists ()
  {
    /* default lists */
    Manager.instance.register_default_lists ();

    foreach (var source in Manager.instance.sources)
    {
      foreach (List l in source.get_lists ())
      {
        this.add_list (l);
      }
    }
  }

  private void setup_signals ()
  {
    Manager manager;

    manager = Manager.instance;
    manager.register_list.connect (this.add_list);

    back_button.bind_property ("visible", new_task_button, "visible", GLib.BindingFlags.BIDIRECTIONAL |
                                                                      GLib.BindingFlags.INVERT_BOOLEAN);

    tasks_list.row_activated.connect (this.set_task);
    lists_listbox.row_selected.connect (this.set_list);
    back_button.clicked.connect (this.on_back_button_clicked);
    new_task_button.clicked.connect (this.on_new_task_button_clicked);

    this.key_press_event.connect ((event)=>
    {
      if (stack1.visible_child_name == "details")
        return false;

      return searchbar.handle_event (event);
    });
  }

  private void set_task (Gtk.ListBoxRow? obj)
  {
    TaskRow row;

    row = obj as TaskRow;
    task_view.task = row.task;

    back_button.visible = true;
    stack1.visible_child_name = "details";
  }

  private void set_list (Gtk.ListBox unused, Gtk.ListBoxRow? obj)
  {
    ListRow row;
    weak DataSource? source;

    if (obj == null)
      return;

    row = obj as ListRow;
    source = row.list.source;

    /* Clear the lists */
    Tasks.clear_listbox (tasks_list);
    current_task_list.clear ();

    /**
     * If the source is null, it fetches the tasks
     * from every source available.
     */
    if (source == null)
    {
      Manager manager;
      manager = Manager.instance;

      foreach (DataSource s in manager.sources)
        current_task_list.add_all (s.get_tasks (row.list));
    }
    else
    {
      current_task_list.add_all (source.get_tasks (row.list));
    }

    append_tasks (current_task_list);
  }

  private void on_back_button_clicked ()
  {
    task_view.task.source.update_task (task_view.task);
    new_task_button.visible = true;
    stack1.visible_child_name = "tasks";
  }

  private void on_new_task_button_clicked ()
  {
    NewTaskDialog dialog;

    dialog = new NewTaskDialog (this.app);
    dialog.transient_for = this;
    dialog.present ();
  }

  private void setup_menu () {
    Gtk.Builder builder;

    builder = new Gtk.Builder ();
    builder.add_from_resource ("/apps/tasks/resources/menus.ui");

    menu_button.menu_model = builder.get_object ("winmenu") as GLib.MenuModel;

    var lists = new GLib.SimpleAction("lists", null);
    var preferences = new GLib.SimpleAction("preferences", null);
    var about = new GLib.SimpleAction("about", null);

    lists.activate.connect (on_lists_activate);
    about.activate.connect (on_about_activate);
    preferences.activate.connect (on_preferences_activate);
    this.add_action(lists);
    this.add_action(about);
    this.add_action(preferences);
  }

  private void append_tasks (Gee.LinkedList<Task>? list)
  {
    if (list == null)
      return;

    foreach (Task t in list)
    {
      TaskRow row;

      row = new TaskRow (t);
      tasks_list.add (row);
    }
  }

  public void add_list (List l)
  {
    ListRow row;

    row = new ListRow (l);
    row.show ();
    lists_listbox.add (row);
    row.list.update_task_number ();
  }

  /* Show lists dialog */
  private void on_lists_activate ()
  {
    Tasks.ListsDialog dialog;

    dialog = new Tasks.ListsDialog (this.app);
    dialog.transient_for = this;

    dialog.present ();
  }

  /* Show preferences dialog */
  private void on_preferences_activate ()
  {
    Tasks.PreferencesDialog dialog;

    dialog = new Tasks.PreferencesDialog (this.app);
    dialog.transient_for = this;

    Settings.configure_preferences_dialog (dialog);

    dialog.present ();
  }

  // About button
  private void on_about_activate ()
  {
    const string[] authors = {
      "Georges Basile Stavracas Neto <georges.stavracas@gmail.com>",
      null
    };

    const string[] artists = {
      "Georges Basile Stavracas Neto <georges.stavracas@gmail.com>",
      null
    };

    const string[] documenters = {
      "Georges Basile Stavracas Neto <georges.stavracas@gmail.com>",
      null
    };

    var dialog = new Gtk.AboutDialog();
    dialog.authors = authors;
    dialog.artists = artists;
    dialog.documenters = documenters;

    dialog.program_name = _("Tasks");
    dialog.comments = _("Simple and clean manager for your tasks.");
    dialog.copyright = _("Copyright \xc2\xa9 2012-2014 The Tasks Project authors\n");
    dialog.version = "3.13.1";
    dialog.license_type = Gtk.License.GPL_3_0;
    dialog.wrap_license = true;
    dialog.website = "https://github.com/GeorgesStavracas/Tasks";
    dialog.website_label = _("Tasks website");

    try
    {
      dialog.logo = new Gdk.Pixbuf.from_resource("/apps/tasks/resources/icon.png");
    }
    catch (GLib.Error e)
    {
      dialog.logo = null;
    }

    dialog.transient_for = this;
    dialog.modal = true;
    dialog.destroy_with_parent = true;

    dialog.present();
  }
}

}
