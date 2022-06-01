function forms_context_menu() {}

/// @func forms_context_menu_create()
/// @desc Creates a new context menu.
/// @return {real} The id of the created menu.
function forms_context_menu_create()
{
	var _menu = forms_container_create();
	_menu[? "type"] = forms_context_menu;
	_menu[? "scr_update"] = forms_context_menu_update;
	_menu[? "scr_draw"] = forms_context_menu_draw;
	_menu[? "disable_icons"] = false;
	_menu[? "background"] = $282828;
	forms_widget_set_depth(_menu, $FFFFFF);
	return _menu;
}

/// @func forms_context_menu_draw(_context_menu)
/// @desc Draws the context menu.
/// @param {real} _context_menu The id of the context menu.
function forms_context_menu_draw(_context_menu)
{
	if (forms_begin_fill(_context_menu))
	{
		var _disable_icons = _context_menu[? "disable_icons"];

		if (!_disable_icons)
		{
			var _height = forms_widget_get_height(_context_menu);
			ce_draw_rectangle(0, 0, FORMS_ICON_SIZE + 4, _height, $343333);
			ce_draw_rectangle(FORMS_ICON_SIZE + 4, 0, 1, _height, $3e3e3e);
		}

		// Draw items
		var _pen = forms_pen_create();
		forms_pen_set_marginv(_pen, 0);
	
		var _context_menu_items = forms_widgetset_get_items(_context_menu);
		var _item_count = ds_list_size(_context_menu_items);
		var i = 0;

		repeat (_item_count)
		{
			var _item = _context_menu_items[| i++];

			if (!_disable_icons)
			{
				var _item_icon = _item[? "icon"];
				forms_pen_move(_pen, 2);
				if (_item_icon != noone)
				{
					forms_icon(_pen, _item_icon);
				}
				else
				{
					forms_pen_move(_pen, FORMS_ICON_SIZE);
				}
				forms_pen_move(_pen, 3);
			}

			var _id = forms_make_id();
			var _item_name = _item[? "name"];
			var _item_action = _item[? "scr_action"];
			var _item_shortcut = _item[? "shortcut"];

			var _mouse_in_rectangle = forms_mouse_over_rectangle(
				forms_pen_get_x(_pen), forms_pen_get_y(_pen),
				_context_menu[? "width"], forms_line_height,
				_id);

			var _mouse_over = (_item_action != noone && _mouse_in_rectangle);

			if (_mouse_over && mouse_check_button_pressed(mb_left))
			{
				forms_steal_mouse_input(_id);
			}

			if (_mouse_in_rectangle)
			{
				var _item_tooltip = ce_ds_map_get(_item, "tooltip", "");
				forms_tooltip_str = _item_tooltip;
			}

			if (_mouse_over || forms_has_mouse_input(_id))
			{
				ce_draw_rectangle(forms_pen_get_x(_pen), forms_pen_get_y(_pen), _context_menu[? "width"], forms_line_height, $584D47);
			}
	
			if (_mouse_over && forms_mouse_lost_input == _id)
			{
				if (_item_action != noone)
				{
					_item_action();
					forms_widget_destroy(_context_menu);
					__forms_context_menu = noone;
				}
			}

			if (_item[? "type"] == FORMS_ContextMenuDelimiter)
			{
				ce_draw_rectangle(forms_pen_get_x(_pen), forms_pen_get_y(_pen), 1000, 1, $3E3E3E);
				forms_pen_move(_pen, 0, 1);
				forms_pen_set_x(_pen, 0);
			}
			else
			{
				forms_pen_move(_pen, 6);
				forms_text(_pen, _item_name, { color: (_item_action == noone) ? $FF969696 : $FFFFFFFF });
				forms_pen_newline(_pen);
			}
		}

		_pen = forms_pen_create(forms_pen_get_max_coordinates(_pen)[0] + 8);
		forms_pen_set_marginv(_pen, 0);
		i = 0;

		// Draw keyboard shortcuts
		repeat (_item_count)
		{
			var _item = _context_menu_items[| i++];
			var _item_shortcut = _item[? "shortcut"];
			var _item_action = _item[? "scr_action"];

			if (_item_shortcut != noone)
			{
				forms_text(_pen, forms_keyboard_shortcut_to_string(_item_shortcut), {
					color: (_item_action == noone) ? $FF969696 : $FFFFFFFF
				});
			}

			if (_item[? "type"] == FORMS_ContextMenuDelimiter)
			{
				forms_pen_move(_pen, 0, 1);
			}
			else
			{
				forms_pen_newline(_pen);
			}
		}

		// Set context menu size
		var _content_size = forms_pen_get_max_coordinates(_pen);
		var _context_menu_width = min(_content_size[0] + 10, forms_window_width);
		var _context_menu_height = min(_content_size[1], forms_window_height);
		forms_widget_set_width(_context_menu, _context_menu_width);
		forms_widget_set_height(_context_menu, _context_menu_height);
		forms_container_set_content_width(_context_menu, _context_menu_width);
		forms_container_set_content_height(_context_menu, _context_menu_height);
		forms_end_fill(_context_menu);
	}

	// Draw context menu
	var _surface = forms_canvas_get_surface(_context_menu);
	if (surface_exists(_surface))
	{
		var _x = forms_widget_get_x(_context_menu);
		var _y = forms_widget_get_y(_context_menu);
		var _width = surface_get_width(_surface);
		var _height = surface_get_height(_surface);
		if (_width > 1 && _height > 1)
		{
			forms_draw_shadow(_x, _y, _width, _height);
			ce_draw_rectangle(_x - 1, _y - 1, _width + 2, _height + 2, $3E3E3E, 1);
		}
	}
	forms_canvas_draw(_context_menu);
}

/// @func forms_context_menu_update(_context_menu)
/// @desc Updates the context menu.
/// @param {real} _context_menu The id of the context menu.
function forms_context_menu_update(_context_menu)
{
	forms_container_update(_context_menu);

	// Clamp position
	forms_widget_set_position(_context_menu,
		min(forms_widget_get_x(_context_menu), forms_window_width - forms_widget_get_width(_context_menu)),
		min(forms_widget_get_y(_context_menu), forms_window_height - forms_widget_get_height(_context_menu)));
}

/// @func forms_can_show_context_menu()
/// @desc Gets whether the context menu can be opened.
/// @return {bool} True if the context menu can be opened.
function forms_can_show_context_menu()
{
	gml_pragma("forceinline");
	return (forms_window_mouse_x == forms_mouse_press_x
		&& forms_window_mouse_y == forms_mouse_press_y);
}

function forms_close_context_menu()
{
	if (__forms_context_menu != noone)
	{
		forms_widget_destroy(__forms_context_menu);
		__forms_context_menu = noone;
	}
}

/// @func forms_show_context_menu(_context_menu[, _x, _y])
/// @desc Shows the context menu.
/// @param {real} _context_menu The id of the context menu to show.
/// @param {real} [_x] The x position to show the context menu at.
/// @param {real} [_y] The y position to show the context menu at.
/// @note If the position coordinates are not specified, then the current
/// window mouse position is used.
function forms_show_context_menu(_context_menu)
{
	forms_close_context_menu();
	__forms_context_menu = _context_menu;
	if (argument_count > 1)
	{
		forms_widget_set_position(__forms_context_menu, argument[1], argument[2]);
	}
	else
	{
		forms_widget_set_position(__forms_context_menu, forms_window_mouse_x, forms_window_mouse_y);
	}
	forms_add_item(forms_root, __forms_context_menu);
}

/// @func forms_menu_input(_context_menu)
/// @desc Adds options for an input menu to the context menu.
/// @param {real} _context_menu The id of the context menu.
function forms_menu_input(_context_menu)
{
	forms_add_item(_context_menu, forms_context_menu_item_create("Cut", forms_input_cut, FORMS_EIcon.Cut, forms_ks_input_cut));
	forms_add_item(_context_menu, forms_context_menu_item_create("Copy", forms_input_copy, FORMS_EIcon.Copy, forms_ks_input_copy));
	forms_add_item(_context_menu, forms_context_menu_item_create("Paste", forms_input_paste, FORMS_EIcon.Paste, forms_ks_input_paste));
	forms_add_item(_context_menu, forms_context_menu_item_create("Delete", forms_input_delete, FORMS_EIcon.Times, forms_ks_input_delete));
	forms_add_item(_context_menu, forms_context_menu_item_create("Select All", forms_input_select_all, noone, forms_ks_input_select_all));
}