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
    dialog.set_response_sensitive (Gtk.ResponseType.OK, false);

    /* builder */
    Gtk.Builder builder = new Gtk.Builder ();
    try
    {
      builder.add_from_resource ("/apps/tasks/resources/create-list.ui");

      entry = builder.get_object ("name_entry") as Gtk.Entry;
      view = builder.get_object ("lists_treeview") as Gtk.TreeView;

      store = new Gtk.ListStore (4,
                                 typeof (Gdk.Pixbuf),  /* icon */
                                 typeof (string),      /* name */
                                 typeof (Gdk.Pixbuf),  /* is_default */
                                 typeof (DataSource)); /* source (invisible) */

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
    Gtk.TreeIter iter;
    Gtk.TreeViewColumn col;

    manager = Manager.instance;

    foreach (DataSource source in manager.sources)
    {
      store.append (out iter);
      store.set (iter,
                 0, source.get_icon ().pixbuf,
                 1, source.get_name (),
                 2, null,
                 3, source);
    }

    /* bind model & store */
    view.model = store;

    /* cell renderers */
    col = new Gtk.TreeViewColumn.with_attributes (null, new Gtk.CellRendererPixbuf (), "pixbuf", 0);
    col.set_min_width (32);
    view.append_column (col);

    view.insert_column_with_attributes (-1, null, new Gtk.CellRendererText (), "text", 1);
    view.insert_column_with_attributes (-1, null, new Gtk.CellRendererPixbuf (), "pixbuf", 2);
  }

  private void setup_signals ()
  {
    entry.changed.connect (validate);
    view.cursor_changed.connect (validate);

    dialog.response.connect ((res)=>
    {
      /* create the list */
      if (res == Gtk.ResponseType.OK)
      {
        List l;
        DataSource source;
        Value val;
        Gtk.TreePath path;
        Gtk.TreeIter iter;
        Gtk.TreeViewColumn focus_column;

        /* retrieve the selected source */
        view.get_cursor (out path, out focus_column);

        store.get_iter (out iter, path);
        store.get_value (iter, 3, out val);
        source = val as DataSource;

        l = new List (-1, entry.text, source);
        source.create_list (l);
      }

      dialog.close ();
    });
  }

  public void run ()
  {
    dialog.run ();
  }

  private void validate ()
  {
    Gtk.TreePath path;
    Gtk.TreeViewColumn focus_column;
    bool valid;

    view.get_cursor (out path, out focus_column);

    valid = (entry.text != "" && path != null);
    dialog.set_response_sensitive (Gtk.ResponseType.OK, valid);
  }
}

}
