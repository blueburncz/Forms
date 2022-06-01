/// @func forms_button(_pen, _text[, _props])
/// @desc Draws a button.
/// @param {FORMS_EPen} _pen
/// @param {string} _text
/// @param {struct} [_props]
/// @return {bool} Returns `true` if the button is pressed.
function forms_button(_pen, _text)
{
	var _props = (argument_count > 2) ? argument[2] : {};

	var _id = ce_struct_get(_props, "id", forms_make_id());
	var _disabled = ce_struct_get(_props, "disabled", false);
	var _tooltip = ce_struct_get(_props, "tooltip", "");

	var _x = forms_pen_get_x(_pen);
	var _y = forms_pen_get_y(_pen);
	var _strw = string_width(_text);
	var _width = ce_struct_get(_props, "width", _strw + 20);
	var _height = forms_line_height;

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

	if (_disabled)
	{
		ce_draw_sprite_nine_slice(FORMS_SprButton, 0, _x, _y, _width, _height, false);
	}
	else
	{
		var _index = (forms_has_mouse_input(_id) ? 3 : (_mouse_over ? 2 : 1));
		ce_draw_sprite_nine_slice(FORMS_SprButton, _index, _x, _y, _width, _height, false);
	}

	var _pen_inner = forms_pen_create(_x + round((_width - _strw) * 0.5), _y);
	forms_text(_pen_inner, _text, { color: _disabled ? $FF404040 : $FFFFFFFF });

	forms_pen_move(_pen, _width);

	return (_mouse_over && forms_mouse_lost_input == _id);
}