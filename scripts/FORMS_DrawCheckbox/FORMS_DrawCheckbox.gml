/// @func FORMS_DrawCheckbox(_x, _y, _state)
///
/// @desc Draws a checkbox at the given position.
///
/// @param {Real} _x The x position to draw the checkbox at.
/// @param {Real} _y The y position to draw the checkbox at.
/// @param {Bool} _state The current state of the checkbox.
///
/// @return {Bool} Return the new state of the checkbox.
function FORMS_DrawCheckbox(_x, _y, _state)
{
	var _parent = FORMS_WIDGET_FILLING;
	var _sprite = FORMS_SprCheckbox;
	var _width = sprite_get_width(_sprite);
	var _height = sprite_get_height(_sprite);
	_y += round((FORMS_LINE_HEIGHT - _height) * 0.5);
	var _mouseOver = (_parent.IsHovered()
		&& FORMS_MOUSE_X > _x
		&& FORMS_MOUSE_Y > _y
		&& FORMS_MOUSE_X < _x + _width
		&& FORMS_MOUSE_Y < _y + _height);
	draw_sprite_ext(_sprite, 0, _x, _y, 1, 1, 0, FORMS_GetColor(FORMS_EStyle.Input), 1);
	if (_state)
	{
		draw_sprite_ext(_sprite, 1, _x, _y, 1, 1, 0, FORMS_GetColor(FORMS_EStyle.Text), 1);
	}
	if (mouse_check_button_pressed(mb_left)
		&& _mouseOver)
	{
		return !_state;
	}
	return _state;
}
