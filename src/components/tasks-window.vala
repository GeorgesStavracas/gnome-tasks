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
  public Gtk.Overlay overlay;
  [GtkChild]
  public Gtk.Paned tasks_paned;
  [GtkChild]
  public Gtk.ListBox tasks_list;
  [GtkChild]
  public Gtk.ListBox lists_listbox;
  [GtkChild]
  public Gtk.Button back_button;
  [GtkChild]
  public Gtk.Button new_task_button;
  [GtkChild]
  public Gtk.Stack stack1;

  protected unowned Tasks.Application app;

  public Window (Tasks.Application app) {
  	Object(application: app);
  	this.app = app;

  	overlay.show_all ();

    setup_example_tasks ();
    setup_signals ();
  	setup_menu ();

  	Manager.instance.register_default_lists ();
  }

  private void setup_signals ()
  {
    Manager manager;

    manager = Manager.instance;
    manager.register_list.connect (this.add_list);

    tasks_list.row_activated.connect (this.set_task);
    back_button.clicked.connect (this.on_back_button_clicked);
    new_task_button.clicked.connect (this.on_new_task_button_clicked);
  }

  private void setup_example_tasks ()
  {
    TaskRow row;

    row = new TaskRow ();
    tasks_list.add (row);
  }

  private void set_task (Gtk.ListBoxRow? obj)
  {
    new_task_button.visible = false;
    back_button.visible = true;
    stack1.visible_child_name = "details";
  }

  private void on_back_button_clicked ()
  {
    new_task_button.visible = true;
    back_button.visible = false;
    stack1.visible_child_name = "tasks";
  }

  private void on_new_task_button_clicked ()
  {
    NewTaskDialog dialog;

    dialog = new NewTaskDialog (this.app);
    dialog.transient_for = this;
		dialog.present ();
  }

  private void setup_menu () {
		var preferences = new GLib.SimpleAction("preferences", null);
  	var about = new GLib.SimpleAction("about", null);

	  about.activate.connect (on_about_activate);
	  preferences.activate.connect (on_preferences_activate);
	  this.add_action(about);
	  this.add_action(preferences);
  }

  public void add_list (List l)
  {
    ListRow row;

    row = new ListRow (l);
    row.show ();
    lists_listbox.add (row);
  }

  /* Show preferences dialog */
  private void on_preferences_activate ()
  {
		Tasks.PreferencesDialog dialog;

		dialog = new Tasks.PreferencesDialog (this.app);
		dialog.transient_for = this;

    Settings.configure_preferences_dialog (dialog);

		dialog.present ();
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
	  dialog.comments = _("Simple and clean manager for your tasks.");
	  dialog.copyright = _("Copyright \xc2\xa9 2012-2014 The Tasks Project authors\n");
	  dialog.version = "3.13.1";
	  dialog.license_type = Gtk.License.GPL_3_0;
	  dialog.wrap_license = true;
	  dialog.website = "https://github.com/GeorgesStavracas/Tasks";
	  dialog.website_label = _("Tasks website");

		try
		{
			dialog.logo = new Gdk.Pixbuf.from_resource("/apps/tasks/resources/icon.png");
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
