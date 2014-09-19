/* -*- Mode: Vala; indent-tabs-mode: s; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * tasks-plugin-manager.c
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

public class PluginManager : GLib.Object
{
	/* Peas */
  public Peas.Engine engine {private set; public get;}
  public Peas.ExtensionSet extension_set {private set; public get;}

	/* Settings */
	private GLib.Settings settings {public get; private set;}

	/* Singleton section */
  private static PluginManager instance_ = null;
	public static PluginManager instance
	{
		public get
		{
			if (instance_ == null)
				instance_ = new PluginManager ();
			return instance_;
		}
	}

	private PluginManager ()
	{
		/* Setup plugin engine */
		engine = Peas.Engine.get_default ();
		engine.enable_loader ("python3");

		//engine.add_search_path ("/mnt/Data/Projetos/Faculdade/IC/build/plugins", null);
		engine.add_search_path ("./plugins", null);

		//engine.load_plugin.connect_after (on_plugin_loaded);

		/* Load settings */
		settings = new GLib.Settings ("apps.tasks.plugins");

		/* Bind settings & active plugins */
		settings.bind ("active-plugins", engine, "loaded-plugins", GLib.SettingsBindFlags.DEFAULT);

		/* Setup extension set */
		extension_set = new Peas.ExtensionSet (engine, typeof (Peas.Activatable), null);

		/* Chain deactivation signal */
		//extension_set.extension_removed.connect (on_extension_removed);
	}

	public void reload_plugins ()
	{
		engine.rescan_plugins ();
	}

	public void add_plugin_search_path (string path, string? data)
	{
		engine.add_search_path (path, data);
		engine.rescan_plugins ();
	}
}

}
