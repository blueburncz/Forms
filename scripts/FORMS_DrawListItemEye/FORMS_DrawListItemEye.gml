/// @func FORMS_DrawListItemEye(_name, _x, _y, _active, _disabled[, _highlight])
///
/// @desc Draws a list item with an eye on the given position.
///
/// @param {String} _name The item name.
/// @param {Real} _x The x position to draw the item at.
/// @param {Real} _y The y position to draw the item at.
/// @param {Bool} _active True if the item is currently selected.
/// @param {Bool} _disabled True to disable clicking on the item.
/// @param {Bool} [_highlight] True to highlight the item.
///
/// @return {Real} If the item is clicked, then 1 is returned.
/// If the eye is clicked, then 2 is returned.
/// In all other cases returns 0.
function FORMS_DrawListItemEye(_name, _x, _y, _active, _disabled, _highlight=false)
{
	var _container = FORMS_WIDGET_FILLING;
	var _text = string(_name);

	// Check mouse over
	var _mouseOver = (_container.IsHovered()
		&& FORMS_MOUSE_Y > _y
		&& FORMS_MOUSE_Y < _y + FORMS_LINE_HEIGHT);

	// Draw
	FORMS_DrawListItem(_text, _x + FORMS_LINE_HEIGHT, _y, _active, _disabled, _highlight);
	draw_sprite_ext(FORMS_SprMisc, 1, _x, _y, 1, 1, 0, merge_colour(c_white, FORMS_GetColor(FORMS_EStyle.Disabled), _disabled), 1);

	// Click
	if (mouse_check_button_pressed(mb_left)
		&& _mouseOver)
	{
		if (FORMS_MOUSE_X < _x + FORMS_LINE_HEIGHT)
		{
			return 2;
		}
		if (!_disabled)
		{
			return 1;
		}
	}
	return 0;
}
