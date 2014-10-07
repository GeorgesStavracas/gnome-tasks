/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * tasks-text-editor.c
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

[GtkTemplate (ui = "/apps/tasks/resources/editor.ui")]
public class TextEditor : Gtk.Frame
{
  [GtkChild]
  protected Gtk.TextView textview;

  /* Style buttons */
  [GtkChild]
  protected Gtk.ToggleButton bold_button;
  [GtkChild]
  protected Gtk.ToggleButton italic_button;
  [GtkChild]
  protected Gtk.ToggleButton underline_button;

  protected Gee.HashMap<string, Gtk.TextTag> tags;

  private bool ignore_toggle_signal;

  construct
  {
    ignore_toggle_signal = false;
    create_tags ();
    connect_signals ();
  }

  private void create_tags ()
  {
    tags = new Gee.HashMap<string, Gtk.TextTag>();

    /* Style tags */
    tags.set("bold", textview.buffer.create_tag ("bold", "weight", Pango.Weight.BOLD));
    tags.set("italic", textview.buffer.create_tag ("italic", "style", Pango.Style.ITALIC));
    tags.set("underline", textview.buffer.create_tag ("underline", "underline", Pango.Underline.SINGLE));
  }

  private void connect_signals()
  {
    bold_button.toggled.connect (this.on_button_toggled);
    italic_button.toggled.connect (this.on_button_toggled);
    underline_button.toggled.connect (this.on_button_toggled);

    textview.move_cursor.connect_after (this.on_textview_move_cursor);
    textview.buffer.end_user_action.connect (this.on_buffer_end_user_action);
  }

  private void on_textview_move_cursor (Gtk.MovementStep step, int count, bool extend)
  {
    unowned Gtk.TextBuffer buffer;
    Gtk.TextIter iter;

    /* From now on, toggle buttons must ignore the Gtk.ToggleButton::toggled signal */
    ignore_toggle_signal = true;

    buffer = textview.buffer;
    buffer.get_iter_at_offset (out iter, buffer.cursor_position);

    bold_button.active = iter.has_tag (tags["bold"]);
    italic_button.active = iter.has_tag (tags["italic"]);
    underline_button.active = iter.has_tag (tags["underline"]);

    /* Signal ignoring stops here */
    ignore_toggle_signal = false;
  }

  private void on_buffer_end_user_action ()
  {
    ignore_toggle_signal = true;
    debug ("STUB");
    ignore_toggle_signal = false;
  }

  private void on_button_toggled (Gtk.ToggleButton button)
  {
    string? action;
    bool enabled;

    /* Toggle event is ignored when fired by cursor changes */
    if (ignore_toggle_signal)
      return;

    action = null;
    enabled = false;

    /* Select the action & the toggle state */
    if (button == bold_button)
    {
      action = "bold";
      enabled = bold_button.active;
    }

    if (button == italic_button)
    {
      action = "italic";
      enabled = italic_button.active;
    }

    if (button == underline_button)
    {
      action = "underline";
      enabled = underline_button.active;
    }

    if (action == null)
      return;

    /* Apply the selected tag */
    toggle_tag (action, enabled);
  }

  private void toggle_tag (string tag, bool apply)
  {
    Gtk.TextIter start, end;
    bool selection;

    /* Text iterator */
    selection = textview.buffer.get_selection_bounds (out start, out end);

    /* FIXME: allow non-selection bolding */
    if (!selection)
      return;

    if (apply)
      textview.buffer.apply_tag (tags[tag], start, end);
    else
      textview.buffer.remove_tag (tags[tag], start, end);
  }
}

}
