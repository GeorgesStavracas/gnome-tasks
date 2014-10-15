/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * tasks-functions.c
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

public static int sort_task_rows (Gtk.ListBoxRow row1, Gtk.ListBoxRow row2)
{
  TaskRow task_row1, task_row2;
  int date;

  if (! (row1 is TaskRow) || ! (row2 is TaskRow))
    return 0;

  task_row1 = row1 as TaskRow;
  task_row2 = row2 as TaskRow;
  date = task_row1.task.due.compare (task_row2.task.due);

  if (date == 0)
  {
    if (task_row1.task.name < task_row2.task.name)
      return -1;

    if (task_row1.task.name > task_row2.task.name)
      return 1;
  }
  else
  {
    return date;
  }

  return 0;
}

}
