/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * tasks-window.c
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

[GtkTemplate (ui = "/apps/tasks/resources/window.ui")]
public class Window : Gtk.ApplicationWindow
{
  [GtkChild]
  private Gtk.HeaderBar headerbar;
  [GtkChild]
  public Gtk.Stack stack1;

  private int current_view;

  public Window (Tasks.Application app) {
  	Object(application: app);
  }

  private void setup_gmenu() {
		var preferences = new GLib.SimpleAction("preferences", null);
  	var about = new GLib.SimpleAction("about", null);
  	
    	/* Connect the 'activate' signal to the
	   * signal handler (aka. callback).
	   */
	  about.activate.connect (on_about_activate);
	  preferences.activate.connect (on_preferences_activate);
	  this.add_action(about);
	  this.add_action(preferences);
  }

  /* Show preferences dialog */
  private void on_preferences_activate ()
  {
    /*
		Tasks.PreferencesDialog dialog;

		dialog = new Tasks.PreferencesDialog ();

		dialog.transient_for = this;
	  dialog.modal = true;
	  dialog.destroy_with_parent = true;

		dialog.present ();
		*/
  }

  // About button
  private void on_about_activate ()
  {
    const string[] authors = {
      "Georges Basile Stavracas Neto <georges.stavracas@gmail.com>",
      null
    };
    
    const string[] artists = {
    	"Georges Basile Stavracas Neto <georges.stavracas@gmail.com>",
      null
    };
	
	  const string[] documenters = {
		  "Georges Basile Stavracas Neto <georges.stavracas@gmail.com>",
      null
	  };

	  var dialog = new Gtk.AboutDialog();
	  dialog.authors = authors;
	  dialog.artists = artists;
	  dialog.documenters = documenters;

	  dialog.program_name = _("Tasks");
	  dialog.comments = _("Manage your creativity, the modular way.");
	  dialog.copyright = _("Copyright \xc2\xa9 2012-2014 The Tasks Project authors\n");
	  dialog.version = "0.0.1";
	  dialog.license_type = Gtk.License.GPL_3_0;
	  dialog.wrap_license = true;
	  dialog.website = "https://github.com/GeorgesStavracas/Tasks";
	  dialog.website_label = _("Tasks website");

		try
		{
			dialog.logo = new Gdk.Pixbuf.from_resource("/apps/Tasks/resources/icon.png");
		}
		catch (GLib.Error e)
		{
			dialog.logo = null;
		}

	  dialog.transient_for = this;
	  dialog.modal = true;
	  dialog.destroy_with_parent = true;
	
	  dialog.present();
  }
}

}
