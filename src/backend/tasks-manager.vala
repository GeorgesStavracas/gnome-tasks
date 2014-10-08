/* -*- Mode: Vala; indent-tabs-mode: s; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * tasks-manager.c
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

public class Manager : GLib.Object
{
  public signal void sync_start ();
  public signal void sync_end ();
  public signal void register_list (List l);
  public signal void source_registered (DataSource source);

  public Gee.LinkedList<DataSource> sources {get; private set;}

	/* Singleton section */
  private static Manager instance_ = null;
  public static Manager instance
  {
    public get
    {
      if (instance_ == null)
        instance_ = new Manager ();
      return instance_;
    }
  }

  private Manager ()
  {
    sources = new Gee.LinkedList<DataSource> ();

    /* Local source is the default embedded source */
    this.register_source (new LocalSource ());
  }

	public void register_source (DataSource source)
	{
    sources.add (source);
    source_registered (source);
    source.init ();
  }

	public void register_default_lists ()
	{
    List all, done, overdue;

	  all = new List (-1, _("All"));
	  all.filter = (t) => {
	    return true;
	  };

	  done = new List (-1, _("Done"));
	  done.filter = (t) => {
	    return t.done;
	  };

	  overdue = new List (-1, _("Overdue"));
	  done.filter = (t) => {
	    /* TODO: return true to overdone tasks */;
	    return false;
	  };

	  register_list (all);
	  register_list (overdue);
	  register_list (done);
	}
}

}
