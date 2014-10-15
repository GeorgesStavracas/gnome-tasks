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

[GtkTemplate (ui = "/apps/tasks/resources/task-row.ui")]
public class TaskRow : Gtk.ListBoxRow
{
  [GtkChild]
  private Gtk.CheckButton _completed;
  [GtkChild]
  private Gtk.Label _end;
  [GtkChild]
  private Gtk.Label _title;
  [GtkChild]
  private Gtk.Label _subtitle;

  private unowned Task task_;
  public Task task
  {
    get
    {
      return task_;
    }

    private set
    {
      task_ = value;

      _title.label = value.name;
    }
  }

  public TaskRow (Task? task = null) {
    if (task != null)
      this.task = task;
  }
}

}
