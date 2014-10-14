/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * tasks-list.c
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
public delegate bool ListFilterFunc (Task task);


public class List : Tasks.BaseObject
{
  public ListFilterFunc filter = default_filter;

  /**
   * This signal is emmited when the source releases
   * any updates.
   */
  public signal void tasks_counted (int n);

  public List (int id = -1, string name = "", DataSource? source = null)
  {
    this.id = id;
    this.name = name;
    this.source = source;
  }

  public void update_task_number ()
  {
    Manager manager;
    int counter;

    manager = Manager.instance;
    counter = 0;

    /* When the source is null,
     * we count for every souce available */
    if (source == null)
    {
      foreach (DataSource src in manager.sources)
        counter += src.count_tasks (this);
    }
    else
    {
      counter = source.count_tasks (this);
    }

    tasks_counted (counter);
  }

  protected bool default_filter (Task task)
  {
    return (task.list_id == this.id) && (!task.done);
  }
}

}
