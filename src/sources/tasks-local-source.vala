/* -*- Mode: Vala; indent-tabs-mode: t; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * tasks-local-source.c
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
public class LocalSource : GLib.Object, Tasks.DataSource
{
  /**
	 * The database file path. By default, Environment.user_config_dir ().
	 *
	 * See {@link Environment}
	 */
	public string database_path {public get; private set; default = Environment.get_user_config_dir () + "/gnome-tasks/";}

	/**
	 * The database file name.
	 */
	public string database_file {public get; private set; default = "local.db";}

	/**
	 * The database itself.
	 */
	private Sqlite.Database database;

  public LocalSource ()
  {}

  public void init ()
  {
    GLib.File dir;
		GLib.File file;

		dir = GLib.File.new_for_path (database_path);
		file = GLib.File.new_for_path (database_path + database_file);

		/* Test directory */
		if (! dir.query_exists () ||
				! (dir.query_file_type (0) == GLib.FileType.DIRECTORY))
		{
			try
			{
				/* Create directory */
				dir.make_directory_with_parents ();
			}
			catch (GLib.Error er)
			{
				warning (_("Could not create database directory"));
			}
		}

		/* Test database file */
		if (! file.query_exists () ||
			  ! (file.query_file_type (0) == GLib.FileType.REGULAR))
	  {
			create_database ();
	  }
  }

  public void deinit () {}

  /**
	 * Creates an empty database where it doesn't exists.
	 */
	private async void create_database ()
	{
		ThreadFunc<void*> run = () =>
		{
			try
			{
				int error_code;
				string schema, tag_out, error_message;
				uint8[] schema_content;
				GLib.File schema_file;

				/* Retrieve Database creation script */
				schema_file = GLib.File.new_for_uri ("resource:///apps/tasks/resources/sql/schema.sql");
				schema_file.load_contents (null, out schema_content, out tag_out);
				schema = (string) schema_content;

				/* Create database file */
				error_code = Sqlite.Database.open_v2 (database_path + database_file, out database);

				if (error_code != Sqlite.OK)
				{
					warning ("Database couldn't be opened: (%d) %s", database.errcode (), database.errmsg ());
					database = null;
					return null;
				}

				/* Create Sqlite SCHEMA */
				error_code = database.exec (schema, null, out error_message);

				if (error_code != Sqlite.OK)
				{
					warning ("Database couldn't be opened: (%d) %s", database.errcode (), database.errmsg ());
					database = null;
					return null;
				}
			}
			catch (GLib.Error er)
			{
				warning (_("Could not create database file"));
			}

			return null;
		};

		/* Create thread */
		try
		{
		  Thread<void*> thread = new Thread<void*>.try (null, run);
			thread.join ();
		}
		catch (GLib.Error error)
		{
			warning (_("Could not create database file. Error running thread."));
		}

		yield;
	}

	public string get_name ()
	{
	  return _("Local");
	}

  public string get_source_name ()
  {
    return _("Local source");
  }

  public int count_tasks (List? l = null)
  {
    message ("count_tasks STUB");
    return 0;
  }

  public int count_tasks_for_tag (Tag? tag = null)
  {
    message ("count_tasks_for_tag STUB");
    return 0;
  }

  public Gee.LinkedList<Task> get_tasks (List? l = null)
  {
    message ("get_tasks STUB");
    return new Gee.LinkedList<Task> ();
  }

  public Gee.LinkedList<List> get_lists ()
  {
    message ("get_lists STUB");
    return new Gee.LinkedList<List> ();
  }

	public void create_list (List l)
	{
	  message ("create_list STUB");
	}

	public void update_list (List l)
	{
	  message ("update_list STUB");
	}

	public void remove_list (List l)
	{
	  message ("remove_list STUB");
	}

	public void create_tag (Tag t)
	{
	  message ("create_tag STUB");
	}

	public void update_tag (Tag t)
	{
	  message ("update_tag STUB");
	}

	public void remove_tag (Tag t)
	{
	  message ("remove_tag STUB");
	}

  public void create_task (Task t)
  {
    message ("create_task STUB");
  }

  public void update_task (Task t)
  {
    message ("update_task STUB");
  }

  public void remove_task (Task t)
  {
    message ("remove_task STUB");
  }
}

}
