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
  private Gtk.Entry title_entry;

  private unowned Task _task;
  public unowned Task task
  {
    set {
      
      _task = value;
      title_entry.text = value.name;
    }

    get {
      return _task;
    }
  }

  construct
  {
    title_entry.get_style_context ().remove_class ("entry");
    connect_signals ();
  }

  private void connect_signals ()
  {
    title_entry.focus_in_event.connect (()=>
    {
      title_entry.get_style_context ().add_class ("entry");
      return false;
    });

    title_entry.focus_out_event.connect (()=>
    {
      title_entry.get_style_context ().remove_class ("entry");
      return false;
    });
  }
}

}
