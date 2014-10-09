/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * tasks-settings.c
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

public class Settings : GLib.Object
{
  /* Singleton pattern instance */
  private static Settings instance_ = null;
  public static Settings instance
  {
    get
    {
      if (instance_ == null)
        instance_ = new Settings();
      return instance_;
    }
  }
  
  /* Tasks.Window */
  private Tasks.Window window_; 
  public Tasks.Window window {
    set
    {
      window_ = value;

      settings.bind ("tasks-paned-position", value.tasks_paned, "position", GLib.SettingsBindFlags.DEFAULT);
      
      value.configure_event.connect( (event) =>
      {
        int[] size = new int[2];
        int[] position = new int[2];

        value.get_size (out size[0], out size[1]);
        value.get_position (out position[0], out position[1]);

        settings.set ("window-size", "(ii)", size[0], size[1]);
        settings.set ("window-position", "(ii)", position[0], position[1]);
        settings.set ("window-maximized", "b", value.is_maximized);

        return false;
      });
      
    }
  }
  
  /* Settings */
	private GLib.Settings settings {public get; private set;}

  private Settings ()
  {
  	/* Load settings */
		settings = new GLib.Settings ("apps.tasks");
  }
  
  public static void configure_window (Tasks.Window window)
  {
    int x, y, w, h;
    bool maximized;

    var settings = Settings.instance.settings;

    settings.get("window-maximized", "b", out maximized);

    if (!maximized)
    {
      window.unmaximize ();

      /* Window size */
      settings.get("window-size", "(ii)", out w, out h);
      window.resize (w, h);

      /* Window position */
      settings.get("window-position", "(ii)", out x, out y);
      window.move(x, y);
    }
    else
    {
      window.maximize ();
    }

    instance.window = window;
  }
}

}
