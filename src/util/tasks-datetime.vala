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

  public TimeZone timezone {get; set;}

  public int year
  {
    get {return base_time.get_year ();}
    set {base_time = base_time.add_years (base_time.get_year () - value);}
  }

  public int month
  {
    get {return base_time.get_month ();}
    set {base_time = base_time.add_months (base_time.get_month () - value);}
  }

  public int day
  {
    get {return base_time.get_day_of_month ();}
    set {base_time = base_time.add_days (base_time.get_day_of_month () - value);}
  }

  public int hour
  {
    get {return base_time.get_hour ();}
    set {base_time = base_time.add_hours (base_time.get_hour () - value);}
  }

  public int minute
  {
    get {return base_time.get_minute ();}
    set {base_time = base_time.add_minutes (base_time.get_minute () - value);}
  }

  public int second
  {
    get {return base_time.get_second ();}
    set {base_time = base_time.add_seconds (base_time.get_second () - value);}
  }

  public bool daylight {
    get {return base_time.is_daylight_savings ();}
  }

  public DateTime (TimeZone tz = new TimeZone.local ())
  {
    base_time = new GLib.DateTime.now (tz);
  }
}

}
