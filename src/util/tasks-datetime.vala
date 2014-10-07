/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * tasks-datetime.c
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

public class DateTime : GLib.Object
{
  private GLib.DateTime base_time;

  public GLib.TimeZone timezone {get; set;}

  public long year {get; set;}
  public uint month {get; set;}
  public uint day {get; set;}

  public uint hour {get; set;}
  public uint minute {get; set;}
  public uint second {get; set;}

  public bool daylight {get; set; default=false;}

  public DateTime ()
  {
    base_time = new GLib.DateTime.now_local();
  }
}

}
