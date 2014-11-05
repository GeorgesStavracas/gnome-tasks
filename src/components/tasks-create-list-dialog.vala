/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * tasks-lists-dialog.c
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

public class CreateListDialog : GLib.Object
{
  protected unowned Tasks.Application app;

  private Gtk.Dialog dialog;
  private Gtk.Entry entry;
  private Gtk.TreeView view;
  private Gtk.ListStore store;

  public CreateListDialog (Tasks.Application app, Gtk.Window? parent)
  {
    this.app = app;

    /* dialog */
    dialog = new Gtk.Dialog.with_buttons (_("Create new list"),
                                          parent,
                                          Gtk.DialogFlags.MODAL | Gtk.DialogFlags.USE_HEADER_BAR,
                                          null);
    dialog.get_content_area ().border_width = 12;

    /* buttons */
    dialog.add_button (_("Cancel"), Gtk.ResponseType.CANCEL);

    var button = dialog.add_button (_("Create"), Gtk.ResponseType.OK);
    button.get_style_context ().add_class ("suggested-action");

    
    /* builder */
    Gtk.Builder builder = new Gtk.Builder ();
    try
    {
      builder.add_from_resource ("/apps/tasks/resources/create-list.ui");

      entry = builder.get_object ("name_entry") as Gtk.Entry;
      view = builder.get_object ("lists_treeview") as Gtk.TreeView;
      store = builder.get_object ("liststore1") as Gtk.ListStore;

      Gtk.Grid grid = builder.get_object ("create_list_grid") as Gtk.Grid;
      grid.show_all ();
      dialog.get_content_area ().add (grid);
    }
    catch (GLib.Error error)
    {}

    setup_sources ();
    setup_signals ();
  }

  private void setup_sources ()
  {
    Manager manager;

    manager = Manager.instance;
    foreach (DataSource source in manager.sources)
    {
      Gtk.TreeIter iter;

      store.append (out iter);
      store.set (iter,
                 0, source.get_icon ().get_pixbuf (),
                 1, source.get_name (),
                 2, source.get_icon ().get_pixbuf ());
    }

    /* cell renderers */
    view.insert_column_with_attributes (0, null, new Gtk.CellRendererPixbuf (), "pixbuf", 0);
    view.insert_column_with_attributes (1, null, new Gtk.CellRendererText (), "text", 1);
    view.insert_column_with_attributes (0, null, new Gtk.CellRendererPixbuf (), "pixbuf", 2);
  }

  private void setup_signals ()
  {
    entry.changed.connect (()=>
    {
      
    });
  }

  public void run ()
  {
    dialog.run ();
  }
}

}
