/// @func forms_input(_pen, _width, _value[, _props])
/// @desc Draws an input.
/// @param {array} _pen A Pen structure.
/// @param {real} _width The width of the input.
/// @param {real/string} _value The input value.
/// @param {struct} [_props]
/// @see FORMS_EPen
/// @see FORMS_VALUE
function forms_input(_pen, _width, _value)
{
	var _is_real = is_real(_value);

	var _props = (argument_count > 3) ? argument[3] : {};
	var _secret = ce_struct_get(_props, "secret", false);
	var _icon_left = ce_struct_get(_props, "icon_left", noone);
	var _icon_right = ce_struct_get(_props, "icon_right", noone);
	var _placeholder = ce_struct_get(_props, "placeholder", "");
	var _disabled = ce_struct_get(_props, "disabled", false);
	var _round = ce_struct_get(_props, "round", false);
	var _id = forms_encode_id(forms_widget_filling, forms_widget_id++);

	if (_is_real && _round)
	{
		_value = round(_value);
	}
	var _value_original = _value;

	var _font_backup = draw_get_font();
	forms_set_font(FORMS_FntMono);

	var _padding = ceil(forms_font_width * 0.5) + 1;
	var _delegate = forms_widget_filling;
	var _x = forms_pen_get_x(_pen);
	var _y = forms_pen_get_y(_pen);
	var _active = (forms_input_active == _id);

	var _arrows_width;

	if (_is_real)
	{
		_arrows_width = sprite_get_width(FORMS_SprInputArrows);
		_width -= _arrows_width + 2;
	}

	if (_active)
	{
		_value = forms_input_string;
	}
	else
	{
		if (forms_has_retval(_id))
		{
			_value = forms_get_retval(_id);
		}
		_value = _is_real ? ce_real_to_string(_value) : string(_value);
	}

	var _string_length = string_length(_value);
	var _max_text_width = (_width - _padding * 2)
		- ((_icon_left != noone) * (FORMS_ICON_SIZE + 4))
		- ((_icon_right != noone) * (FORMS_ICON_SIZE + 4));
	var _max_char_count = floor(_max_text_width / forms_font_width);
	var _mouse_over = forms_mouse_over_rectangle(_x, _y, _width, forms_line_height, _id);

	////////////////////////////////////////////////////////////////////////////////
	//
	// Draw input
	//

	// Background
	ce_draw_sprite_nine_slice(FORMS_SprInput, _disabled, _x, _y, _width, forms_line_height, false);

	if (_icon_left != noone)
	{
		forms_draw_icon(forms_pen_create(_x + _padding, _y), _icon_left);
	}

	if (_icon_right != noone)
	{
		forms_draw_icon(forms_pen_create(_x + _width - FORMS_ICON_SIZE - 4, _y), _icon_right);
	}

	// Text
	var _text_x = _x + _padding + ((_icon_left != noone) ? (FORMS_ICON_SIZE + 4) : 0);
	var _text_y = _y + round((forms_line_height - forms_font_height) * 0.5);
	var __col_selection = $423935;

	var _mouse_over_text_area = (_mouse_over
		&& forms_mouse_x >= _text_x
		&& forms_mouse_x <= _text_x + _max_text_width);

	if (!_disabled && _mouse_over_text_area)
	{
		forms_cursor = cr_beam;
	}

	if (_active)
	{
		if (forms_input_index[1] - forms_input_index_draw_start > _max_char_count)
		{
			forms_input_index_draw_start += forms_input_index[1] - forms_input_index_draw_start - _max_char_count;
		}
		else if (forms_input_index_draw_start > forms_input_index[1])
		{
			forms_input_index_draw_start -= forms_input_index_draw_start - forms_input_index[1];
		}

		var _draw_value = string_copy(_value, forms_input_index_draw_start, _max_char_count);

		if (_secret)
		{
			_draw_value = string_repeat("*", string_length(_draw_value));
		}

		if (forms_input_index[0] != forms_input_index[1])
		{
			// Selection
			var _min_index = clamp(min(forms_input_index[0], forms_input_index[1]) - forms_input_index_draw_start, 0, _string_length);
			var _max_index = clamp(max(forms_input_index[0], forms_input_index[1]) - forms_input_index_draw_start, 0, _string_length);
			var _rect_min_x = _text_x + forms_font_width * max(_min_index, 0);
			var _rect_max_x = _text_x + forms_font_width * min(_max_index, _max_char_count);

			// Text before selection
			draw_text(_text_x, _text_y, string_copy(_draw_value, 1, _min_index));
			// Selection rectangle
			ce_draw_rectangle(_rect_min_x, _text_y, _rect_max_x - _rect_min_x, forms_font_height, __col_selection);
			// Selected text
			draw_text(_rect_min_x, _text_y, string_copy(_draw_value, _min_index + 1, _max_index - _min_index));
			// Text after selection
			draw_text(_rect_max_x, _text_y, string_delete(_draw_value, 1, _max_index));
		}
		else
		{
			draw_text(_text_x, _text_y, _draw_value);
		}

		// Beam
		var _beam_x = _text_x + forms_font_width * (forms_input_index[ (forms_input_index[0] != forms_input_index[1]) ] - forms_input_index_draw_start);
		ce_draw_rectangle(_beam_x, _text_y, 1, forms_font_height, c_white, round(dsin((current_time - forms_input_timer) * 0.3) * 0.5 + 0.5));
	}
	else
	{
		var _is_empty = (_value == "");
		var _draw_value = _is_empty
			? _placeholder
			: (_secret ? string_repeat("*", string_length(_value)) : _value);
		var _color = (_is_empty || _disabled) ? FORMS_C_DISABLED : FORMS_C_TEXT;

		forms_draw_text_part(forms_pen_create(_text_x, _y), _draw_value, _max_char_count * forms_font_width, _color);
	}

	forms_pen_move(_pen, _width);

	////////////////////////////////////////////////////////////////////////////////
	//
	// Arrows
	//
	if (_is_real)
	{
		forms_pen_move(_pen, 2);
		var _arrows_height = sprite_get_height(FORMS_SprInputArrows);
		var _arrows_height_half = _arrows_height * 0.5;
		var _arrows_x = forms_pen_get_x(_pen);
		var _arrows_y = forms_pen_get_y_inline(_pen, _arrows_height);

		if (_disabled)
		{
			draw_sprite_part(FORMS_SprInputArrows, 0, 0, 0, _arrows_width, _arrows_height_half, _arrows_x, _arrows_y);
			draw_sprite_part(FORMS_SprInputArrows, 0, 0, _arrows_height_half, _arrows_width, _arrows_height_half, _arrows_x, _arrows_y + _arrows_height_half);
		}
		else
		{
			// Up
			var _arrow_id = forms_make_id();
			var _arrow_mouse_over = forms_mouse_over_rectangle(_arrows_x, _arrows_y, _arrows_width, _arrows_height_half, _arrow_id);
			if (_arrow_mouse_over && mouse_check_button_pressed(mb_left))
			{
				forms_steal_mouse_input(_arrow_id);
			}
			if (forms_mouse_lost_input == _arrow_id)
			{
				var _step = ce_struct_get(_props, "step", 1)
					* (keyboard_check(vk_control) ? 0.1 : (keyboard_check(vk_shift) ? 10 : 1));
				forms_set_retval(_id, _value_original + _step);
			}
			var _index = (forms_has_mouse_input(_arrow_id) ? 3 : (_arrow_mouse_over ? 2 : 1));

			draw_sprite_part(FORMS_SprInputArrows, _index, 0, 0, _arrows_width, _arrows_height_half, _arrows_x, _arrows_y);

			// Down
			var _arrow_id = forms_make_id();
			var _arrow_mouse_over = forms_mouse_over_rectangle(_arrows_x, _arrows_y + _arrows_height_half, _arrows_width, _arrows_height_half, _arrow_id);
			if (_arrow_mouse_over && mouse_check_button_pressed(mb_left))
			{
				forms_steal_mouse_input(_arrow_id);
			}
			if (forms_mouse_lost_input == _arrow_id)
			{
				var _step = ce_struct_get(_props, "step", 1)
					* (keyboard_check(vk_control) ? 0.1 : (keyboard_check(vk_shift) ? 10 : 1));
				forms_set_retval(_id, _value_original - _step);
			}
			var _index = (forms_has_mouse_input(_arrow_id) ? 3 : (_arrow_mouse_over ? 2 : 1));
			draw_sprite_part(FORMS_SprInputArrows, _index, 0, _arrows_height_half, _arrows_width, _arrows_height_half, _arrows_x, _arrows_y + _arrows_height_half);
		}

		forms_pen_move(_pen, _arrows_width);
	}

	////////////////////////////////////////////////////////////////////////////////
	//
	// Input logic
	//
	var _return_value = false;
	var _pressed_left = (_mouse_over && mouse_check_button_pressed(mb_left) && forms_steal_mouse_input(_id));
	var _pressed_right = (_mouse_over && mouse_check_button_pressed(mb_right));
	var _pressed = (_pressed_left || _pressed_right);

	// Select input
	if (!_disabled && _pressed && !_active)
	{
		// Note: Deselect of an active input is implemented in forms_input_update
		forms_input_active = _id;
		forms_input_string = _value;
		forms_input_index_draw_start = 1;
		forms_input_index[0] = 1;
		forms_input_index[1] = 1;
		keyboard_string = "";
		_active = true;
	}

	if (_active)
	{
		var _pos_total = forms_get_draw_position_absolute(_x, _y);
		forms_input_bbox = [
			_pos_total[0],
			_pos_total[1],
			_pos_total[0] + _width,
			_pos_total[1] + forms_line_height
		];

		// Select text
		if (forms_has_mouse_input(_id))
		{
			var _index = clamp(round((forms_mouse_x - _text_x) / forms_font_width) + forms_input_index_draw_start, 1, _string_length + 1);
			if (_pressed_left)
			{
				forms_input_index[0] = _index;
			}
			forms_input_index[1] = _index;
		}

		if (_pressed_right)
		{
			// Open context menu
			var _context_menu = forms_context_menu_create();
			forms_menu_input(_context_menu);
			forms_show_context_menu(_context_menu);

			// TODO: Select word in input on double click
		}

		if (keyboard_check_pressed(vk_enter))
		{
			// Return value when enter is pressed
			_return_value = true;
			forms_input_active = noone;
		}
		else if (keyboard_check_pressed(vk_escape))
		{
			// Return original value
			forms_input_active = noone;
		}
	}

	forms_set_font(_font_backup);

	if (_return_value)
	{
		if (forms_widget_exists(_delegate))
		{
			forms_request_redraw(_delegate);
		}

		if (_is_real)
		{
			var _real = ce_parse_real(_value);
			_real = (is_nan(_real) ? _value_original : _real);
			if (_round)
			{
				_real = round(_real);
			}
			var _min = ce_struct_get(_props, "min", undefined);
			if (_min != undefined)
			{
				_real = max(_real, _min);
			}
			var _max = ce_struct_get(_props, "max", undefined);
			if (_max != undefined)
			{
				_real = min(_real, _max);
			}
			FORMS_VALUE = _real;
		}
		else
		{
			FORMS_VALUE = _value;
		}

		return true;
	}

	if (forms_consume_retval(_id))
	{
		forms_request_redraw(_delegate);
		if (_is_real)
		{
			var _real = ce_parse_real(FORMS_VALUE);
			_real = !is_nan(_real) ? _real : 0;
			if (_round)
			{
				_real = round(_real);
			}
			var _min = ce_struct_get(_props, "min", undefined);
			if (_min != undefined)
			{
				_real = max(_real, _min);
			}
			var _max = ce_struct_get(_props, "max", undefined);
			if (_max != undefined)
			{
				_real = min(_real, _max);
			}
			FORMS_VALUE = _real;
		}
		return true;
	}

	return false;
}

/// @func forms_input_copy()
/// @desc Copies selected part of text of currently active input
/// to the clipboard.
function forms_input_copy()
{
	if (forms_input_index[0] != forms_input_index[1])
	{
		clipboard_set_text(
			string_copy(
				forms_input_string,
				min(forms_input_index[0], forms_input_index[1]),
				abs(forms_input_index[0] - forms_input_index[1])));
	}
}

/// @func forms_input_cut()
/// @desc Cuts selected part of text in currently active input.
function forms_input_cut()
{
	if (forms_input_index[0] != forms_input_index[1])
	{
		clipboard_set_text(
			string_copy(
				forms_input_string,
				min(forms_input_index[0], forms_input_index[1]),
				abs(forms_input_index[0] - forms_input_index[1])));
		forms_input_delete_selected();
	}
}

/// @func forms_input_delete()
/// @desc Deletes selected part of text in currently active input.
function forms_input_delete()
{
	if (forms_input_index[0] != forms_input_index[1])
	{
		forms_input_delete_selected();
	}
}

/// @func forms_input_delete_selected()
/// @desc Deletes selected part of input text.
function forms_input_delete_selected()
{
	var _min_index = min(forms_input_index[0], forms_input_index[1]);
	forms_input_string = string_delete(
		forms_input_string,
		_min_index,
		abs(forms_input_index[0] - forms_input_index[1]));
	forms_input_index[0] = _min_index;
	forms_input_index[1] = _min_index;
}

/// @func forms_input_paste()
/// @desc Pastes text from the clipboard to currently active input.
function forms_input_paste()
{
	if (clipboard_has_text())
	{
		// Delete selected part
		if (forms_input_index[0] != forms_input_index[1])
		{
			forms_input_delete_selected();
		}

		// Insert string
		forms_input_string = string_insert(
			clipboard_get_text(),
			forms_input_string,
			forms_input_index[0]);
		forms_input_index[0] += string_length(clipboard_get_text());
		forms_input_index[1] = forms_input_index[0];
	}
}

/// @func forms_input_select_all()
/// @desc Selects all text in currently active input.
function forms_input_select_all()
{
	var _strlen = string_length(forms_input_string);
	forms_input_index[0] = 1;
	forms_input_index[1] = _strlen + 1;
}

/// @func forms_input_update(_input)
/// @param {real} _input The id of the input.
function forms_input_update(_input)
{
	if (mouse_check_button_pressed(mb_any)
		&& (forms_window_mouse_x < forms_input_bbox[0]
		|| forms_window_mouse_y < forms_input_bbox[1]
		|| forms_window_mouse_x > forms_input_bbox[2]
		|| forms_window_mouse_y > forms_input_bbox[3])
		&& (!forms_widget_exists(__forms_context_menu)
		|| forms_widget_hovered != __forms_context_menu))
	{
		forms_set_retval(forms_input_active, forms_input_string);
		forms_request_redraw(forms_decode_id(forms_input_active));
		forms_input_active = noone;
		return;
	}

	var _delegate = forms_decode_id(_input);
	forms_request_redraw(_delegate);

	var _input_string_length = string_length(forms_input_string);

	// Multitype
	forms_input_multitype = false;

	if (keyboard_check_pressed(vk_anykey))
	{
		forms_input_multitype = true;
		forms_input_timer = current_time;
	}

	if (current_time > forms_input_timer + 300)
	{
		forms_input_multitype = true;
	}

	// _type
	var _keyboard_string_length = string_length(keyboard_string);

	if (_keyboard_string_length > 0)
	{
		// Delete selected part
		if (forms_input_index[0] != forms_input_index[1])
		{
			forms_input_delete_selected();
		}

		// Insert string
		forms_input_string = string_insert(keyboard_string, forms_input_string, forms_input_index[0]);
		forms_input_index[0] += _keyboard_string_length;
		forms_input_index[1] = forms_input_index[0];
		keyboard_string = "";
	}

	// Backspace
	if (keyboard_check(vk_backspace) && forms_input_multitype)
	{
		if (forms_input_index[0] == forms_input_index[1])
		{
			forms_input_string = string_delete(forms_input_string, forms_input_index[0] - 1, 1);
			forms_input_index[0] = max(forms_input_index[0] - 1, 1);
			forms_input_index[1] = forms_input_index[0];
		}
		else
		{
			forms_input_delete_selected();
		}
	}
	else if (keyboard_check(vk_delete) && forms_input_multitype)
	{
		// Delete
		if (forms_input_index[0] != forms_input_index[1])
		{
			forms_input_delete_selected();
		}
		else
		{
			forms_input_string = string_delete(forms_input_string, forms_input_index[0], 1);
		}
	}

	// Save string length
	var _input_string_length = string_length(forms_input_string);

	// Control
	if (keyboard_check(vk_control))
	{
		if (keyboard_check_pressed(ord("A")))
		{
			forms_input_select_all();
		}
		else if (keyboard_check_pressed(ord("D")))
		{
			forms_input_delete();
		}
		else if (keyboard_check_pressed(ord("X")))
		{
			forms_input_cut();
		}
		else if (keyboard_check_pressed(ord("C")))
		{
			forms_input_copy();
		}
		else if (keyboard_check_pressed(ord("V")))
		{
			forms_input_paste();
			_input_string_length = string_length(forms_input_string);
		}
	}

	// Arrows
	if (keyboard_check(vk_left) && forms_input_multitype)
	{
		forms_input_index[1] = max(forms_input_index[1] - 1, 1);

		if (!keyboard_check(vk_shift))
		{
			forms_input_index[0] = forms_input_index[1];
		}
	}
	else if (keyboard_check(vk_right) && forms_input_multitype)
	{
		forms_input_index[1] = min(forms_input_index[1] + 1, _input_string_length + 1);

		if (!keyboard_check(vk_shift))
		{
			forms_input_index[0] = forms_input_index[1];
		}
	}

	// Home/end
	if (keyboard_check_pressed(vk_home))
	{
		forms_input_index[1] = 1;

		if (!keyboard_check(vk_shift))
		{
			forms_input_index[0] = forms_input_index[1];
		}
	}
	else if (keyboard_check_pressed(vk_end))
	{
		forms_input_index[1] = _input_string_length + 1;

		if (!keyboard_check(vk_shift))
		{
			forms_input_index[0] = forms_input_index[1];
		}
	}
}