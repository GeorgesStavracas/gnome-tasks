/* -*- Mode: Vala; indent-tabs-mode: t; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * tasks-data-source.c
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

/**
 * An interface to define data sources. The whole management is up to the implementing source.
 */
public interface DataSource : GLib.Object
{
	public abstract string get_name ();
  public abstract string get_source_name ();

  public abstract void init ();
  public abstract void deinit ();

  public abstract int count_tasks (List? l = null);
  public abstract int count_tasks_for_tag (Tag? tag = null);
  public abstract Gee.LinkedList<Task> get_tasks (List? l = null);
  public abstract Gee.LinkedList<List> get_lists ();

  public abstract void create_list (List l);
  public abstract void update_list (List l);
  public abstract void remove_list (List l);

  public abstract void create_tag (Tag t);
  public abstract void update_tag (Tag t);
  public abstract void remove_tag (Tag t);

  public abstract void create_task (Task t);
  public abstract void update_task (Task t);
  public abstract void remove_task (Task t);
}

}
