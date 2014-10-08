/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * tasks-list-row.c
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

[GtkTemplate (ui = "/apps/tasks/resources/task-view.ui")]
public class TaskView : Gtk.Grid
{
  [GtkChild]
  protected Gtk.EventBox title_eventbox;
  [GtkChild]
  protected Gtk.Stack stack1;

  public TaskView ()
  {
  	connect_signals ();
  }

  private void connect_signals ()
  {
    title_eventbox.button_press_event.connect(on_eventbox_button_press);
  }

  private bool on_eventbox_button_press (Gdk.EventButton button)
  {
    message("press event");
    if (stack1.visible_child_name == "title-label")
      stack1.visible_child_name = "title-entry";
    else
      stack1.visible_child_name = "title-label";

    return false;
  }
}

}
