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

  public int compare (Tasks.DateTime d2)
  {
    if (d2.year != this.year)
      return d2.year - this.year;

    if (d2.month != this.month)
      return d2.month - this.month;

    if (d2.day != this.day)
      return d2.day - this.day;

    if (d2.hour != this.hour)
      return d2.hour - this.hour;

    if (d2.minute != this.minute)
      return d2.minute - this.minute;

    if (d2.second != this.second)
      return d2.second - this.second;

    return 0;
  }

  public void parse (string datetime)
  {
		// String MUST be 'YYYY-MM-DD HH:mm'
		if(datetime.index_of("-") < 0) return;
		if(datetime.index_of(":") < 0) return;
		if(datetime.index_of(" ") < 0) return;

		string[] parts = datetime.split(" ");
		string[] date = parts[0].split("-");
		string[] time = parts[1].split(":");

		this.year = int.parse(date[0]);
		this.month = int.parse(date[1]);
		this.day = int.parse(date[2]);

		this.hour = int.parse(time[0]);
		this.minute = int.parse(time[1]);
  }

  public string to_string (string format = "%Y-%m-%d %H:%M")
  {
    return base_time.format (format);
  }
}

}
