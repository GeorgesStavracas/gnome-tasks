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

[GtkTemplate (ui = "/apps/tasks/resources/lists-dialog.ui")]
public class ListsDialog : Gtk.Dialog
{
  [GtkChild]
  private Gtk.Button add_button;
  [GtkChild]
  private Gtk.Button remove_button;
  [GtkChild]
  private Gtk.Button edit_button;
  [GtkChild]
  private Gtk.HeaderBar headerbar;
  [GtkChild]
  private Gtk.ListBox lists_listbox;

  protected unowned Tasks.Application app;

  public ListsDialog (Tasks.Application app)
  {
    this.app = app;
    this.set_titlebar (headerbar);

    setup_lists ();

    lists_listbox.row_selected.connect (this.list_selected);
    add_button.clicked.connect (this.create_button_clicked);
  }

  private void setup_lists ()
  {
    Manager manager;

    manager = Manager.instance;
    foreach (DataSource source in manager.sources)
    {
      foreach (List l in source.get_lists ())
      {
        ListRow row = new ListRow (l);
        row._counter_frame.hide ();
        lists_listbox.insert (row, -1);
      }
    }
  }

  private void list_selected (Gtk.ListBoxRow? row)
  {
    remove_button.sensitive = (row != null);
    edit_button.sensitive = (row != null);
  }

  private void create_button_clicked ()
  {
    CreateListDialog dialog;

    dialog = new CreateListDialog (app, this);
    dialog.run ();
  }
}

}
