globalvar
	forms_window_width,
	forms_window_height,
	forms_window_mouse_x,
	forms_window_mouse_y,
	forms_disable_click,
	forms_cursor,
	forms_widgets,
	forms_widget_id,
	forms_widget_hovered,
	forms_widget_active,
	forms_widget_filling,
	forms_widget_selected,
	forms_mouse_input,
	forms_mouse_input_widget,
	forms_mouse_lost_input,
	forms_mouse_x,
	forms_mouse_y,
	forms_tooltip_str,
	forms_matrix_stack,
	forms_destroy_stack,
	forms_color_show,
	forms_input_sprite,
	forms_input_sprite_width,
	forms_input_sprite_height,
	forms_input_string,
	forms_input_index,
	forms_input_index_draw_start,
	forms_input_multitype ,
	forms_input_timer,
	forms_input_active,
	forms_input_bbox,
	__forms_dropdown,
	__forms_context_menu,
	forms_mouse_press_x,
	forms_mouse_press_y,
	forms_key_log,
	forms_ks_input_cut,
	forms_ks_input_copy,
	forms_ks_input_paste,
	forms_ks_input_delete,
	forms_ks_input_select_all,
	__forms_retval_named,
	__forms_retval,
	forms_root,
	forms_color_picker,
	forms_color_picker_target,
	forms_custom_colors,
	forms_font,
	forms_font_height,
	forms_font_width,
	forms_line_height,
	;

/// @func forms_init()
/// @desc Initializes GUI.
/// @return {real} The id of the GUI root widget.
function forms_init()
{
	display_set_gui_maximise();
	forms_window_width = window_get_width();
	forms_window_height = window_get_height();
	forms_window_mouse_x = window_mouse_get_x();
	forms_window_mouse_y = window_mouse_get_y();
	forms_disable_click = false;

	var _fnt = draw_get_font();
	forms_set_font(FORMS_FntNormal);
	draw_set_font(_fnt);

	forms_cursor = cr_default;
	forms_widgets = ds_list_create();
	forms_widget_id = 0;
	forms_widget_hovered = noone;
	forms_widget_active = noone;
	forms_widget_filling = noone;
	forms_widget_selected = noone;

	/// @var {string} An id of a draw-only widget that currently takes all mouse input.
	forms_mouse_input = "";

	/// @var {real} An id of a widget that contains the draw-only widget that takes all
	/// mouse input.
	forms_mouse_input_widget = noone;

	/// @var {string} An id of a draw-only widget that just lost mouse input.
	forms_mouse_lost_input = "";

	forms_mouse_x = 0;
	forms_mouse_y = 0;
	forms_tooltip_str = "";
	forms_matrix_stack = ds_stack_create();
	forms_destroy_stack = ds_stack_create();
	forms_color_show = -1;

	// Input
	forms_input_sprite = FORMS_SprInput;
	forms_input_sprite_width = sprite_get_width(forms_input_sprite);
	forms_input_sprite_height = sprite_get_height(forms_input_sprite);
	forms_input_string = "";
	forms_input_index = [1, 1];
	forms_input_index_draw_start = 1;
	forms_input_multitype = 0;
	forms_input_timer = current_time;
	forms_input_active = noone;
	forms_input_bbox = [0, 0, 0, 0];

	// Dropdown
	__forms_dropdown = noone;

	// Context menu
	__forms_context_menu = noone;
	forms_mouse_press_x = noone;
	forms_mouse_press_y = noone;

	// Keyboard shortcuts
	forms_key_log = ds_list_create();

	// Inputs
	forms_ks_input_cut = forms_keyboard_shortcut_create(forms_input_cut);
	forms_keyboard_shortcut_add_key(forms_ks_input_cut, vk_control);
	forms_keyboard_shortcut_add_key(forms_ks_input_cut, ord("X"));

	forms_ks_input_copy = forms_keyboard_shortcut_create(forms_input_copy);
	forms_keyboard_shortcut_add_key(forms_ks_input_copy, vk_control);
	forms_keyboard_shortcut_add_key(forms_ks_input_copy, ord("C"));

	forms_ks_input_paste = forms_keyboard_shortcut_create(forms_input_paste);
	forms_keyboard_shortcut_add_key(forms_ks_input_paste, vk_control);
	forms_keyboard_shortcut_add_key(forms_ks_input_paste, ord("V"));

	forms_ks_input_delete = forms_keyboard_shortcut_create(forms_input_delete);
	forms_keyboard_shortcut_add_key(forms_ks_input_delete, vk_control);
	forms_keyboard_shortcut_add_key(forms_ks_input_delete, ord("D"));

	forms_ks_input_select_all = forms_keyboard_shortcut_create(forms_input_select_all);
	forms_keyboard_shortcut_add_key(forms_ks_input_select_all, vk_control);
	forms_keyboard_shortcut_add_key(forms_ks_input_select_all, ord("A"));

	// Named return values
	__forms_retval_named = ds_map_create();

	// Return value from widgets
	__forms_retval = undefined;

	#macro FORMS_VALUE __forms_retval

	// Root
	forms_root = forms_widgetset_create();

	// Color picker
	forms_color_picker = noone;
	forms_color_picker_target = undefined;

	forms_custom_colors = [
		$FF000000,
		$FF000000,
		$FF000000,
		$FF000000,
		$FF000000,
		$FF000000,
		$FF000000,
		$FF000000,
		$FF000000,
		$FF000000,
	];

	return forms_root;
}

/// @func forms_set_retval(_name, _value)
/// @param {string} _name
/// @param {any} _value
function forms_set_retval(_name, _value)
{
	gml_pragma("forceinline");
	__forms_retval_named[? _name] = _value;
	forms_request_redraw_all(forms_root);
}

/// @func forms_has_retval(_name)
/// @param {string} _name
/// @return {bool}
function forms_has_retval(_name)
{
	gml_pragma("forceinline");
	return ds_map_exists(__forms_retval_named, _name);
}

/// @func forms_get_retval(_name)
/// @param {string} _name
/// @return {any}
function forms_get_retval(_name)
{
	gml_pragma("forceinline");
	return __forms_retval_named[? _name];
}

/// @func forms_consume_retval(_name)
/// @param {string} _name
/// @return {bool}
function forms_consume_retval(_name)
{
	gml_pragma("forceinline");
	if (ds_map_exists(__forms_retval_named, _name))
	{
		FORMS_VALUE = __forms_retval_named[? _name];
		ds_map_delete(__forms_retval_named, _name);
		forms_request_redraw_all(forms_root);
		return true;
	}
	return false;
}

/// @func forms_add_item(widgetset, item)
/// @desc Adds item to the widget set while preserving depth order.
/// @param {real} widgetset The id of the widget set.
/// @param {real} item The id of the item to be added.
/// @return {real} The index where the item has been placed at.
function forms_add_item(widgetset, item)
{
	var _items = forms_widgetset_get_items(widgetset);
	var _index = ds_list_size(_items);
	while (_index > 0)
	{
		if (forms_widget_get_depth(_items[| _index - 1]) > forms_widget_get_depth(item))
		{
			--_index;
		}
		else
		{
			break;
		}
	}
	ce_ds_list_insert_map(_items, _index, item);
	forms_widget_set_delegate(item, widgetset);
	return _index;
}

/// @func forms_add_keyboard_shortcut(_widget, _keyboard_shortcut)
/// @desc Adds keyboard shortcut to the widget.
/// @param {real} _widget The id of the widget to add the keyboard shortcut to.
/// @param {real} _keyboard_shortcut The id of the keyboard shortcut.
function forms_add_keyboard_shortcut(_widget, _keyboard_shortcut)
{
	if (is_undefined(_widget[? "keyboard_shortcuts"]))
	{
		ds_map_add_list(_widget, "keyboard_shortcuts", ds_list_create());
	}
	ce_ds_list_add_map(_widget[? "keyboard_shortcuts"], _keyboard_shortcut);
}

/// @func forms_alpha_mix_get_height()
/// @desc Gets the height of an alpha mixer.
/// @return {real} The height of an alpha mixer.
function forms_alpha_mix_get_height()
{
	gml_pragma("forceinline");
	return (forms_line_height * 2 + 4);
}

/// @func forms_cleanup()
/// @desc Frees resources used by GUI from memory.
function forms_cleanup()
{
	forms_widget_cleanup(forms_root);
	ds_stack_destroy(forms_matrix_stack);
	ds_stack_destroy(forms_destroy_stack);
	ds_list_destroy(forms_key_log);
	ds_map_destroy(__forms_retval_named);
	ds_map_destroy(forms_ks_input_cut);
	ds_map_destroy(forms_ks_input_copy);
	ds_map_destroy(forms_ks_input_paste);
	ds_map_destroy(forms_ks_input_delete);
	ds_map_destroy(forms_ks_input_select_all);
}

/// @func forms_color_mix_get_height()
/// @desc Gets the height of a color mixer.
/// @return {real} The height of a color mixer.
function forms_color_mix_get_height()
{
	gml_pragma("forceinline");
	return (forms_line_height * 4 + 12);
}

/// @func forms_decode_id(_id)
/// @desc Gets the dynamic widget delegate from its id.
/// @param {real} _id The id of the dynamic widget.
/// @return {real} The id of the delegate.
function forms_decode_id(_id)
{
	gml_pragma("forceinline");
	return ((_id div 100000) - 1);
}

/// @func forms_destroy()
/// @desc Destroys GUI.
function forms_destroy()
{
	for (var i = 0; i < ds_list_size(forms_widgets); ++i)
	{
		var _widget = forms_widgets[| i];
		var _scr_cleanup = _widget[? "scr_cleanup"];
		if (_scr_cleanup != noone)
		{
			_scr_cleanup(_widget);
		}
	}
	ds_list_destroy(forms_widgets);
}

/// @func forms_draw()
/// @desc Draws GUI.
function forms_draw()
{
	var _fnt = draw_get_font();
	var _color = draw_get_color();
	gpu_push_state();
	gpu_set_tex_filter(true);
	gpu_set_tex_mip_enable(mip_off);

	forms_tooltip_str = "";
	forms_color_show = -1;

	draw_clear(FORMS_C_BACKGROUND);
	forms_set_font(FORMS_FntNormal);
	draw_set_color(c_white);

	// Draw items
	var _items = forms_widgetset_get_items(forms_root);
	var _item_count = ds_list_size(_items);
	var _notif_y = forms_window_height;

	for (var i = 0; i < _item_count; ++i)
	{
		var _item = _items[| i];
		if (forms_widget_exists(_item))
		{
			if (i == _item_count - 1)
			{
				if (_item[? "block_input"])
				{
					ce_draw_rectangle(0, 0, forms_window_width, forms_window_height, c_black, 0.25);
				}
			}
			if (_item[? "type"] == FORMS_Notification)
			{
				_notif_y -= forms_widget_get_height(_item) + 8;
				forms_widget_set_x(_item, forms_window_width - forms_widget_get_width(_item) - 8);
				forms_widget_set_y(_item, _notif_y);
			}
			forms_draw_item(_item);
		}
		else
		{
			ds_list_delete(_items, --i);
		}
	}

	// Tooltip
	if (forms_tooltip_str != "")
	{
		forms_draw_tooltip(forms_window_mouse_x + 16, forms_window_mouse_y + 16, forms_tooltip_str);
	}

	// Set cursor
	if (forms_window_mouse_x > 3
		&& forms_window_mouse_y > 3
		&& forms_window_mouse_x < window_get_width() - 3
		&& forms_window_mouse_y < window_get_height() - 3)
	{
		window_set_cursor(forms_cursor);
	}
	forms_cursor = cr_default;

	// Handle destroy requests
	while (!ds_stack_empty(forms_destroy_stack))
	{
		var _widget = ds_stack_pop(forms_destroy_stack);
		if (forms_widget_exists(_widget))
		{
			_widget[? "scr_cleanup"](_widget);
			if (forms_widget_active == _widget)
			{
				forms_widget_active = noone;
			}
		}
	}

	gpu_pop_state();
	draw_set_color(_color);
	draw_set_font(_fnt);

	if (mouse_check_button_released(mb_left))
	{
		forms_mouse_lost_input = forms_mouse_input;
		forms_mouse_input = "";
		forms_mouse_input_widget = noone;
	}
	else
	{
		forms_mouse_lost_input = "";
	}

	//if (forms_input_active != noone)
	//{
	//	draw_rectangle(
	//		forms_input_bbox[0],
	//		forms_input_bbox[1],
	//		forms_input_bbox[2],
	//		forms_input_bbox[3],
	//		true);
	//}
}

/// @func forms_encode_id(delegate, number)
/// @desc Gets the id of the dynamic widget.
/// @param {real} delegate The id of the delegate.
/// @param {real} number The unique number of the dynamic widget.
/// @return {real} The id of the dynamic widget.
function forms_encode_id(delegate, number)
{
	gml_pragma("forceinline");
	return ((delegate + 1) * 100000 + number);
}

/// @func forms_find_widget(_items, _mouse_x, _mouse_y)
/// @desc Recursively finds widget on the given position in the list of shapes.
/// @param {real} _items The list of shapes.
/// @param {real} _mouse_x The x position to find a widget at.
/// @param {real} _mouse_y The y position to find a widget at.
/// @return {real} The id of the found widget or noone.
function forms_find_widget(_items, _mouse_x, _mouse_y)
{
	for (var i = ds_list_size(_items) - 1; i >= 0; --i)
	{
		var _item = _items[| i];
		var _x = forms_widget_get_x(_item);
		var _y = forms_widget_get_y(_item);

		if (_mouse_x > _x
			&& _mouse_y > _y
			&& _mouse_x < _x + forms_widget_get_width(_item)
			&& _mouse_y < _y + forms_widget_get_height(_item))
		{
			forms_widget_set_redraw(_item, true);

			// Skip hidden scrollbars
			if (forms_widget_get_type(_item) == FORMS_Scrollbar
				&& !forms_scrollbar_is_visible(_item))
			{
				continue;
			}

			// Check if scrollbars are hovered
			var _scroll_x = 0;
			var _scroll_y = 0;
			var _scrollbar_hor = _item[? "scrollbar_hor"]
			var _scrollbar_ver = _item[? "scrollbar_ver"];
			var _scrollbars = ds_list_create();

			if (!is_undefined(_scrollbar_hor))
			{
				ds_list_add(_scrollbars, _scrollbar_hor);
				_scroll_x = forms_scrollbar_get_scroll(_scrollbar_hor) * forms_scrollbar_is_visible(_scrollbar_hor);
			}
			if (!is_undefined(_scrollbar_ver))
			{
				ds_list_add(_scrollbars, _scrollbar_ver);
				_scroll_y = forms_scrollbar_get_scroll(_scrollbar_ver) * forms_scrollbar_is_visible(_scrollbar_ver);
			}

			var _hovered = noone;
			if (!ds_list_empty(_scrollbars))
			{
				_hovered = forms_find_widget(_scrollbars, _mouse_x - _x + _scroll_x, _mouse_y - _y + _scroll_y);
			}
			ds_list_destroy(_scrollbars);
			if (forms_widget_exists(_hovered))
			{
				return _hovered;
			}

			// Find hovered item
			var _sub_items = forms_widgetset_get_items(_item);
			if (!is_undefined(_sub_items))
			{
				var _hovered = forms_find_widget(_sub_items, _mouse_x - _x + _scroll_x, _mouse_y - _y + _scroll_y);
				if (forms_widget_exists(_hovered))
				{
					return _hovered;
				}
			}
			return _item;
		}
	}
	return noone;
}

/// @func forms_get_active_widget()
/// @desc Gets the id of the currently active widget.
/// @return {real} The id of the currently active widget or noone.
function forms_get_active_widget()
{
	gml_pragma("forceinline");
	return forms_widget_active;
}

/// @func forms_get_font()
/// @return {real}
function forms_get_font()
{
	gml_pragma("forceinline");
	return forms_font;
}

/// @func forms_get_hovered_widget()
/// @desc Gets the id of the currently hovered widget.
/// @return {real} The id of the currently hovered widget or noone.
function forms_get_hovered_widget()
{
	gml_pragma("forceinline");
	return forms_widget_hovered;
}

/// @func forms_get_selected_widget()
/// @desc Gets the id of the currently selected widget.
/// @return {real} The id of the currently selected widget or noone.
function forms_get_selected_widget()
{
	gml_pragma("forceinline");
	return forms_widget_selected;
}

function forms_make_id()
{
	gml_pragma("forceinline");
	return (forms_widget_filling[? "id"] + ".draw" + string(forms_widget_id++));
}

/// @func forms_steal_mouse_input(_id)
/// @param {string} _id
/// @return {bool}
function forms_steal_mouse_input(_id)
{
	if (forms_mouse_input == _id)
	{
		return true;
	}
	if (forms_mouse_input == "")
	{
		forms_mouse_input = _id;
		forms_mouse_input_widget = forms_widget_filling;
		return true;
	}
	return false;
}

/// @func forms_has_mouse_input(_id)
/// @param {string} _id
/// @return {bool}
function forms_has_mouse_input(_id)
{
	gml_pragma("forceinline");
	return (forms_mouse_input == _id);
}

/// @func forms_key_to_string(_key)
/// @param {real} _key
/// @return {string}
function forms_key_to_string(_key)
{
	if (_key >= vk_f1 && _key <= vk_f12)
	{
		return ("F" + string(_key - vk_f1));
	}

	if (_key >= vk_numpad0 && _key <= vk_numpad9)
	{
		return ("Num" + string(_key - vk_numpad0));
	}

	switch (_key)
	{
	case vk_escape: return "Esc";
	case vk_delete: return "Delete";
	case vk_backspace: return "Backspace";
	case vk_tab: return "Tab";
	case vk_shift: return "Shift";
	case vk_control: return "Ctrl";
	case vk_lcontrol: return "LeftCtrl";
	case vk_rcontrol: return "RightCtrl";
	case vk_alt: return "Alt";
	case vk_lalt: return "LeftAlt";
	case vk_ralt: return "RightAlt";
	case vk_printscreen: return "PrintScrn";
	case vk_pause: return "Pause";
	case vk_pageup: return "PageUp";
	case vk_pagedown: return "PageDown";
	case vk_insert: return "Insert";
	case vk_home: return "Home";
	case vk_enter: return "Enter";
	case vk_end: return "End";
	case vk_space: return "Spacebar";
	case vk_left: return "Left";
	case vk_right: return "Right";
	case vk_up: return "Up";
	case vk_down: return "Down";
	case vk_multiply: return "Multiply";
	case vk_divide: return "Divide";
	case vk_add: return "Plus";
	case vk_subtract: return "Minus";
	case vk_decimal: return "Decimal";
	}

	return chr(_key);
}

/// @func forms_log_key(_key)
/// @desc Adds the key to the key log.
/// @param {real} _key The key to be added to the key log.
function forms_log_key(_key)
{
	switch (_key)
	{
	case vk_lshift:
	case vk_rshift:
		_key = vk_shift;
		break;

	case vk_lalt:
	case vk_ralt:
		_key = vk_alt;
		break;

	case vk_lcontrol:
	case vk_rcontrol:
		_key = vk_control;
		break;
	}

	ds_list_add(forms_key_log, _key);
}

/// @func forms_matrix_push(_x, _y)
/// @desc Stores the current matrix into the matrix stack
/// and then pushes the coordinate system by the
/// given values.
/// @param {real} _x The value to push the coordinate system by on the x axis.
/// @param {real} _y The value to push the coordinate system by on the y axis.
function forms_matrix_push(_x, _y)
{
	var _mat_world = matrix_get(matrix_world);
	ds_stack_push(forms_matrix_stack, _mat_world);
	matrix_set(matrix_world,
		matrix_multiply(_mat_world, matrix_build(_x, _y, 0, 0, 0, 0, 1, 1, 1)));
}

/// @func forms_matrix_restore()
/// @desc Restores coordinate system by popping matrix from
/// the top of the matrix stack.
function forms_matrix_restore()
{
	gml_pragma("forceinline");
	matrix_set(matrix_world, ds_stack_pop(forms_matrix_stack));
}

/// @func forms_matrix_set(_x, _y)
/// @desc Stores the current matrix into the matrix stack
/// and sets the origin of the coordinate system to
/// the given values.
/// @param {real} _x The origin on the x axis.
/// @param {real} _y The origin on the y axis.
function forms_matrix_set(_x, _y)
{
	var _mat_world = matrix_get(matrix_world);
	ds_stack_push(forms_matrix_stack, _mat_world);
	matrix_set(matrix_world, matrix_build(_x, _y, 0, 0, 0, 0, 1, 1, 1));
}

/// @func forms_mouse_over_rectangle(_x, _y, _width, _height[, _id])
/// @param {real} _x
/// @param {real} _y
/// @param {real} _width
/// @param {real} _height
/// @param {string/real} [_id]
/// @return {bool}
function forms_mouse_over_rectangle(_x, _y, _width, _height)
{
	gml_pragma("forceinline");

	if (argument_count > 4
		&& forms_mouse_input != ""
		&& forms_mouse_input != argument[4])
	{
		return false;
	}

	return (!forms_disable_click
		&& forms_widget_is_hovered(forms_widget_filling)
		&& forms_mouse_x > _x
		&& forms_mouse_y > _y
		&& forms_mouse_x < _x + _width
		&& forms_mouse_y < _y + _height);
}

/// @func forms_mouse_over_circle(_x, _y, _radius)
/// @param {real} _x
/// @param {real} _y
/// @param {real} _radius
/// @return {bool}
function forms_mouse_over_circle(_x, _y, _radius)
{
	gml_pragma("forceinline");
	return (!forms_disable_click
		&& forms_widget_is_hovered(forms_widget_filling)
		&& forms_mouse_input == ""
		&& point_distance(forms_mouse_x, forms_mouse_y, _x, _y) <= _radius);
}

/// @func forms_move_item_to_top(_item)
/// @desc Moves the item to the top while preserving depth order.
/// @param {real} _item The id of the item to move.
function forms_move_item_to_top(_item)
{
	var _delegate = forms_widget_get_delegate(_item);

	if (!forms_widget_exists(_delegate))
	{
		exit;
	}

	var _items = forms_widgetset_get_items(_delegate);
	var _n = ds_list_size(_items);
	var _index = ds_list_find_index(_items, _item);

	if (_index >= 0)
	{
		var i = _index + 1;
		var _item_depth = forms_widget_get_depth(_item);

		while (i < _n && forms_widget_get_depth(_items[| i]) <= _item_depth)
		{
			++i;
		}

		ce_ds_list_insert_map(_items, i, _item);
		ds_list_delete(_items, _index);
	}
}

/// @func forms_push_mouse_coordinates(_widget)
/// @desc Pushes mouse coordinates to be relative to the widget.
/// @param {real} _widget The id of the widget.
function forms_push_mouse_coordinates(_widget)
{
	var _x = forms_widget_get_x(_widget);
	var _y = forms_widget_get_y(_widget);
	var _scroll_x = 0;
	var _scroll_y = 0;
	var _scrollbar_hor = _widget[? "scrollbar_hor"]
	var _scrollbar_ver = _widget[? "scrollbar_ver"];

	if (!is_undefined(_scrollbar_hor))
	{
		_scroll_x = forms_scrollbar_get_scroll(_scrollbar_hor) * forms_scrollbar_is_visible(_scrollbar_hor);
	}
	if (!is_undefined(_scrollbar_ver))
	{
		_scroll_y = forms_scrollbar_get_scroll(_scrollbar_ver) * forms_scrollbar_is_visible(_scrollbar_ver);
	}

	forms_mouse_x += -_x + _scroll_x;
	forms_mouse_y += -_y + _scroll_y;

	var _delegate = forms_widget_get_delegate(_widget);
	if (forms_widget_exists(_delegate))
	{
		forms_push_mouse_coordinates(_delegate);
	}
}

/// @func forms_request_redraw(_widget)
/// @desc Pushes a redraw request of the given widget to the delegate.
/// @param {real} widget The id of the widget to redraw.
function forms_request_redraw(_widget)
{
	while (forms_widget_exists(_widget))
	{
		forms_widget_set_redraw(_widget, true);
		_widget = forms_widget_get_delegate(_widget);
	}
}

/// @func forms_request_redraw_all(_widget)
/// @desc Requests redraw of all child shapes.
/// @param {real} _widget The id of the widget.
function forms_request_redraw_all(_widget)
{
	forms_widget_set_redraw(_widget, true);
	var _items = forms_widgetset_get_items(_widget);
	if (!is_undefined(_items))
	{
		for (var i = ds_list_size(_items) - 1; i >= 0; --i)
		{
			forms_request_redraw_all(_items[| i]);
		}
	}
}

/// @func forms_set_font(_font)
/// @param {real} _font
function forms_set_font(_font)
{
	gml_pragma("forceinline");
	draw_set_font(_font);
	forms_font = _font;
	forms_font_height = string_height("M");
	forms_font_width = string_width("M");
	forms_line_height = 24; //forms_font_height + 6;
}

/// @func forms_update()
/// @desc Updates GUI.
function forms_update()
{
	forms_tooltip_str = "";
	forms_window_width = window_get_width();
	forms_window_height = window_get_height();
	forms_window_mouse_x = window_mouse_get_x();
	forms_window_mouse_y = window_mouse_get_y();
	forms_mouse_x = forms_window_mouse_x;
	forms_mouse_y = forms_window_mouse_y;
	forms_widget_set_size(forms_root, forms_window_width, forms_window_height);

	// Find hovered widget
	var _last_hovered_shape = forms_widget_hovered;
	if (!forms_widget_exists(_last_hovered_shape))
	{
		_last_hovered_shape = noone;
	}
	forms_widget_hovered = forms_find_widget(forms_widgetset_get_items(forms_root), forms_mouse_x, forms_mouse_y);

	// Block input
	var _items = forms_widgetset_get_items(forms_root);
	var _item_count = ds_list_size(_items);
	if (_item_count > 0)
	{
		var _item_last = ds_list_find_value(_items, _item_count - 1);
		if (_item_last[? "block_input"])
		{
			if (forms_widget_hovered != _item_last
				&& !forms_widget_delegates_recursive(_item_last, forms_widget_hovered))
			{
				forms_widget_hovered = noone;
			}
		}
	}

	if (forms_widget_exists(forms_mouse_input_widget))
	{
		forms_request_redraw(forms_mouse_input_widget);
	}

	// Redraw last hovered widget
	if (forms_widget_exists(_last_hovered_shape)
		&& forms_widget_hovered != _last_hovered_shape)
	{
		forms_request_redraw(_last_hovered_shape);
	}

	// Reset active widget if it does not exist
	if (!forms_widget_exists(forms_widget_active))
	{
		forms_widget_active = noone;
	}

	// Reset selected widget if it does not exist
	if (!forms_widget_exists(forms_widget_selected))
	{
		forms_widget_selected = noone;
	}

	// Redraw active widget and push mouse coordinates
	if (forms_widget_exists(forms_mouse_input_widget))
	{
		forms_push_mouse_coordinates(forms_mouse_input_widget);
	}
	else if (forms_widget_exists(forms_widget_active))
	{
		forms_request_redraw(forms_widget_active);
		forms_push_mouse_coordinates(forms_widget_active);
	}
	else if (forms_widget_exists(forms_widget_hovered))
	{
		forms_push_mouse_coordinates(forms_widget_hovered);
	}

	////////////////////////////////////////////////////////////////////////////////
	// Handle keyboard shortcuts
	if (keyboard_check_pressed(vk_anykey))
	{
		forms_log_key(keyboard_key);
	}

	if (mouse_check_button_pressed(mb_any))
	{
		forms_log_key(mouse_button);
	}

	//var _text = "";
	for (var i = ds_list_size(forms_key_log) - 1; i >= 0; --i)
	{
		var _is_mouse_button = (forms_key_log[| i] == mb_left
			|| forms_key_log[| i] == mb_right
			|| forms_key_log[| i] == mb_middle);
		if ((!_is_mouse_button && !keyboard_check(forms_key_log[| i]))
			|| (_is_mouse_button && !mouse_check_button(forms_key_log[| i])))
		{
			ds_list_delete(forms_key_log, i);
			continue;
		}
		//_text = string(forms_key_log[| i]) + ", " + _text;
	}
	//show_debug_message(_text);

	// Global
	var _shortcuts = forms_root[? "keyboard_shortcuts"];
	if (!is_undefined(_shortcuts))
	{
		for (var i = ds_list_size(_shortcuts) - 1; i >= 0; --i)
		{
			forms_keyboard_shortcut_update(_shortcuts[| i]);
		}
	}

	// Selected widget
	if (forms_widget_exists(forms_widget_selected))
	{
		var _shortcuts = forms_widget_selected[? "keyboard_shortcuts"];
		if (!is_undefined(_shortcuts))
		{
			for (var i = ds_list_size(_shortcuts) - 1; i >= 0; --i)
			{
				forms_keyboard_shortcut_update(_shortcuts[| i]);
			}
		}
	}

	// Update input
	if (forms_input_active != noone)
	{
		forms_input_update(forms_input_active);
	}

	// Close dropdown
	if (mouse_check_button_pressed(mb_left)
		&& __forms_dropdown != noone
		&& !forms_widget_is_hovered(__forms_dropdown))
	{
		forms_close_dropdown();
	}

	// Close context menu
	if (mouse_check_button_pressed(mb_left)
		&& __forms_context_menu != noone
		&& !forms_widget_is_hovered(__forms_context_menu))
	{
		forms_close_context_menu();
	}

	// Save mouse press position
	if (mouse_check_button_pressed(mb_right))
	{
		forms_mouse_press_x = forms_window_mouse_x;
		forms_mouse_press_y = forms_window_mouse_y;
	}
}