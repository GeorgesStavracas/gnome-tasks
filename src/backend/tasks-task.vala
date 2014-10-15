/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * tasks-task.c
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

public class Task : Tasks.BaseObject
{
  public int list_id {get; set;}
  public string? description {get; set; default="";}
  public bool done {get; set; default=false;}
  public unowned Tasks.Task? parent {get; set; default=null;}
  public Tasks.DateTime due {get; set;}

  public Task (int id = -1, string name = "", DataSource? source = null)
  {
    this.id = id;
    this.name = name;
    this.source = source;
    this.due = new Tasks.DateTime ();
  }
}

}
