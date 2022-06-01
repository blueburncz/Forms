/// @func forms_radiobutton(_pen, _label, _state[, _props])
/// @desc Draws a radiobutton.
/// @param {array} _pen A pen structure.
/// @param {string} _label
/// @param {bool} _state The current state of the radiobutton.
/// @param {struct} [_props]
/// @return {bool} Return the new state of the radiobutton.
/// @see FORMS_EPen
function forms_radiobutton(_pen, _label, _state)
{
	var _props = (argument_count > 3) ? argument[3] : {};

	var _id = ce_struct_get(_props, "id", forms_make_id());
	var _disabled = ce_struct_get(_props, "disabled", false);
	var _tooltip = ce_struct_get(_props, "tooltip", "");

	var _sprite = FORMS_SprRadiobutton;
	var _width = sprite_get_width(_sprite);
	var _height = sprite_get_height(_sprite);
	var _x = forms_pen_get_x(_pen);
	var _y = forms_pen_get_y_inline(_pen, _height);

	var _mouse_in_rectangle = forms_mouse_over_rectangle(_x, _y, _width, _height, _id);
	var _mouse_over = (!_disabled && _mouse_in_rectangle);

	if (_mouse_in_rectangle)
	{
		forms_tooltip_str = _tooltip;
	}

	if (_mouse_over && mouse_check_button_pressed(mb_left))
	{
		forms_steal_mouse_input(_id);
	}

	if (_mouse_over || forms_has_mouse_input(_id))
	{
		draw_sprite(_sprite, 0, _x, _y);
	}
	else
	{
		draw_sprite(_sprite, 1 + _disabled, _x, _y);
	}

	if (_state)
	{
		draw_sprite(_sprite, 3 + _disabled, _x, _y);
	}

	forms_pen_move(_pen, _width + 4);

	if (_label != "")
	{
		forms_text(_pen, _label, _props);
	}

	if (!_disabled && _mouse_over && forms_mouse_lost_input == _id)
	{
		return !_state;
	}

	return _state;
}

/// @func forms_draw_radiobutton_list(_pen, _labels, _current)
/// @decs Draws a list of radio buttons.
/// @param {FORMS_EPen} _pen A pen structure.
/// @param {string[]} _labels An array of button labels.
/// @param {int} _current The index of the currently selected option.
/// @return {real} The index of the new selected button.
function forms_draw_radiobutton_list(_pen, _labels, _current)
{
	var i = 0;
	repeat (array_length(_labels))
	{
		if (forms_radiobutton(_pen, _labels[i], _current == i))
		{
			_current = i;
		}
		forms_pen_newline(_pen);
		++i;
	}
	return _current;
}