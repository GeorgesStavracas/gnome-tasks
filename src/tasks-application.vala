/* -*- Mode: Vala; indent-tabs-mode: t; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * tasks-application.c
 * Copyright (C) 2013 Georges Basile Stavracas Neto <georges.stavracas@gmail.com>
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

public class Tasks.Application : Gtk.Application 
{

	private Tasks.Window window;
	
	public Application () {
	    Object (application_id: "apps.tasks",
              flags: GLib.ApplicationFlags.FLAGS_NONE);
	}
	
	protected override void activate ()
		{		
        // Create the window of this application and show it
				if (window == null)
						window = new Tasks.Window(this);

				window.present();
		}
	
	protected override void startup()
	{
		base.startup();

		var provider = new Gtk.CssProvider ();

		try
		{
			//var file = File.new_for_uri("resource:///apps/tasks/ui/style.css");
			var file = File.new_for_path("/mnt/Data/Projetos/Faculdade/IC/Aplicativo/src/resources/style.css");

	    // apply css to the screen
			Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default(), 
																							  provider,
	                                              Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
	    provider.load_from_file(file);
		}

		catch (Error e)
		{
		    stderr.printf ("loading css: %s\n", e.message);
		}

		// Load plugins from disk
		load_plugins();

		var menu = new GLib.Menu ();
		menu.append (_("About"), "win.about");
		menu.append (_("Quit"), "app.quit");

		var tmp = new GLib.Menu();
		tmp.append(_("Preferences"), "win.preferences");
		tmp.append_section(null, menu);

		this.app_menu = tmp;

		var quit_action = new SimpleAction ("quit", null);
		this.add_action (quit_action);

		quit_action.activate.connect (()=>{
		  Gtk.main_quit();
	  });
	}
	
	private void load_plugins()
	{
		Tasks.PluginManager manager;

		manager = Tasks.PluginManager.instance;

		manager.add_plugin_search_path (Config.PLUGINDIR, null);
	}
}


