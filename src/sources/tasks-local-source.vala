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
        return;
      }
    }

    /* Test database file */
    if (! file.query_exists () ||
        ! (file.query_file_type (0) == GLib.FileType.REGULAR))
    {
      create_database ();
    }
    else
    {
      /* Open database */
      int error_code;

      error_code = Sqlite.Database.open_v2 (database_path + database_file, out database);

      if (error_code != Sqlite.OK)
      {
        warning (_("Database couldn't be opened:")+" (%d) %s", database.errcode (), database.errmsg ());
        database = null;
      }
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

  public Gtk.Image get_icon ()
  {
    Gtk.Image icon;
    icon = new Gtk.Image.from_icon_name ("computer-symbolic", Gtk.IconSize.MENU);
    icon.show ();
    icon.set_tooltip_text (this.get_name ());
    return icon;
  }

  public int count_tasks (List? l = null)
  {
    string count_query = "SELECT COUNT(*) FROM 'Tasks'";
    string error;
    int rc, n_tasks;
    Sqlite.Statement stmt;

    if (l != null)
      count_query +=  " WHERE list=%d".printf (l.id);

    rc = database.prepare_v2 (count_query, -1, out stmt, null);
    if (rc == Sqlite.OK)
    {
      critical (_("Cannot connect to database. Aborting."));
      return 0;
    }

    /* It is certain that it has only 1 row with 1 column */
    rc = stmt.step ();
    n_tasks = stmt.column_int (0);

    return n_tasks;
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
    Gee.LinkedList<List> lists;
    int rc;
    Sqlite.Statement stmt;
    string query = "SELECT * FROM 'List'";

    lists = new Gee.LinkedList<List> ();

    /* Select all lists available */
    rc = database.prepare_v2 (query, -1, out stmt);
    if (rc != Sqlite.OK)
    {
      critical (_("Cannot connect to database."));
      return lists;
    }

    /* Fetch data*/
    do
    {
      List l;
      int id;
      string name;

      rc = stmt.step ();
      switch (rc)
      {
        case Sqlite.DONE:
          break;

        case Sqlite.ROW:
          id = stmt.column_int (0);
          name = stmt.column_text (1);

          /* Create and append list */
          l = new List (id, name, this);
          lists.add (l);
          break;

        default:
          message ("Error %s", database.errmsg ());
          break;
      }

    } while (rc == Sqlite.OK);

    return lists;
  }

  public void create_list (List l)
  {
    string validator = "SELECT COUNT(*) FROM 'List' WHERE name='%s'";
    string query = "INSERT INTO 'List' (name) VALUES (%s)";
    string error;
    int rc, n_lists, last_id;
    Sqlite.Statement stmt;

    /* First, check if there isn't another list with the same name */
    validator = validator.printf (l.name);

    rc = database.prepare_v2 (validator, -1, out stmt, null);
    if (rc == Sqlite.OK)
    {
      critical (_("Cannot connect to database. Aborting."));
      return;
    }

    /* It is certain that it has only 1 row with 1 column */
    rc = stmt.step ();
    n_lists = stmt.column_int (0);

    if (n_lists > 0)
    {
      critical ("%d lists with this name.", n_lists);
      return;
    }

    /* Now that the validation is done, we can insert the list */
    query = query.printf (l.name);

    rc = database.exec (query, null, out error);

    if (rc != Sqlite.OK)
      return;

    /* Update list ID field */
    last_id = (int) database.last_insert_rowid ();
    l.id = last_id;
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
    string query = """INSERT INTO 'Task'
        (name,parent,list,priority,description,due_date,completed)
        VALUES
        ('%s',%d,%d,%d,'%s','%s',0)""";
    string error;
    int rc, last_id;
    Sqlite.Statement stmt;

    /* Insert the task */
    query = query.printf (t.name,
                          t.parent != null ? t.parent.id : -1,
                          t.list_id,
                          t.priority,
                          t.description,
                          t.due.to_string ());


    rc = database.exec (query, null, out error);

    if (rc != Sqlite.OK)
      return;

    /* Update list ID field */
    last_id = (int) database.last_insert_rowid ();
    t.id = last_id;
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
