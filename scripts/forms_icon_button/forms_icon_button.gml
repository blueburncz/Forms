/// @func forms_icon_button(_pen, _icon[, _props])
/// @desc Draws an icon button.
/// @param {array} _pen A Pen structure.
/// @param {FORMS_EIcon} _icon The icon to draw.
/// @param {struct} [_props]
/// @return {bool} True if the button was clicked.
/// @see FORMS_EPen
function forms_icon_button(_pen, _icon)
{
	var _props = (argument_count > 2) ? argument[2] : {};

	var _id = ce_struct_get(_props, "id", forms_make_id());
	var _disabled = ce_struct_get(_props, "disabled", false);
	var _active = !_disabled && ce_struct_get(_props, "active", false);
	var _tooltip = ce_struct_get(_props, "tooltip", "");

	var _x = forms_pen_get_x(_pen);
	var _y = forms_pen_get_y(_pen);
	var _width = 4 + FORMS_ICON_SIZE + 4;
	var _height = forms_line_height;

	var _mouse_in_rectangle = forms_mouse_over_rectangle(_x, _y, _width, _height);
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
		var _index = ((_active || forms_has_mouse_input(_id)) ? 3 : (_mouse_over ? 2 : 1));
		ce_draw_sprite_nine_slice(FORMS_SprButton, _index, _x, _y, _width, _height, false);
	}

	forms_icon(forms_pen_create(_x + 4, _y), _icon, { color: _disabled ? $FF404040 : $FFFFFFFF });

	forms_pen_move(_pen, _width);

	return (_mouse_over && forms_mouse_lost_input == _id);
}