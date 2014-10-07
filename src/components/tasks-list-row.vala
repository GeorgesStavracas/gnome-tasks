/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * tasks-list-row.c
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

[GtkTemplate (ui = "/apps/tasks/resources/list_row.ui")]
public class ListRow : Gtk.ListBoxRow
{
  [GtkChild]
  private Gtk.Label _name;
  [GtkChild]
  private Gtk.Frame _color;
  [GtkChild]
  private Gtk.Frame _counter_frame;

  /* Properties */
  public unowned List list_;
  public unowned List list
  {
    public get{return this.list_;}
    private set
    {
      this.list_ = value;
      this.name = value.name;
    }
  }
  public new string name
  {
    get {return _name.label;}
    private set {_name.label = value;}
  }

  public ListRow (List l)
  {
  	this.list = l;
  }
}

}
