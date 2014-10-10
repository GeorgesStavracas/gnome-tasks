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
  private Gtk.Calendar calendar;
  [GtkChild]
  private Gtk.Button cancel_button;
  [GtkChild]
  private Gtk.Button create_button;

  protected unowned Tasks.Application app;

  public NewTaskDialog (Tasks.Application app)
  {
    this.app = app;
    this.set_titlebar (headerbar);

    calendar_toggle.bind_property ("active", calendar_popover, "visible", GLib.BindingFlags.BIDIRECTIONAL);
    time_toggle.bind_property ("active", time_popover, "visible", GLib.BindingFlags.BIDIRECTIONAL);

    calendar.day_selected.connect (this.on_calendar_day_selected);
    calendar.day_selected_double_click.connect (this.on_calendar_day_selected_double_click);

    cancel_button.clicked.connect (on_header_button_clicked);
    create_button.clicked.connect (on_header_button_clicked);
  }

  private void on_header_button_clicked (Gtk.Button button)
  {
    if (button == create_button);
    this.close ();
  }

  private void on_calendar_day_selected ()
  {
    
  }

  private void on_calendar_day_selected_double_click ()
  {
    calendar_popover.visible = false;
  }

  private void set_calendar_toggle_text ()
  {
  }
}

}
