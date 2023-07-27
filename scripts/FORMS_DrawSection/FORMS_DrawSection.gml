/// @func FORMS_DrawSection(_name, _x, _y, _expanded)
///
/// @desc Draws a section at the given position.
///
/// @param {String} _name The name of the section.
/// @param {Real} _x The x position to draw the section at.
/// @param {Real} _y The y position to draw the section at.
/// @param {Bool} _expanded True if the section is expanded.
///
/// @return {Bool} True if the section is clicked.
function FORMS_DrawSection(_name, _x, _y, _expanded)
{
	var _container = FORMS_WIDGET_FILLING;
	var _containerWidth = _container.Width;
	var _text = string(_name);
	var _state = _expanded;

	// Background
	FORMS_DrawRectangle(0, _y, _containerWidth, FORMS_LINE_HEIGHT, FORMS_GetColor(FORMS_EStyle.Section));

	// Text
	var _font = draw_get_font();
	draw_set_font(FORMS_FONT_BOLD);
	draw_text(FORMS_LINE_HEIGHT, _y + round((FORMS_LINE_HEIGHT - FORMS_FONT_HEIGHT) * 0.5), _text);
	draw_set_font(_font);

	// Icon
	draw_sprite(FORMS_SprRoll, _state, 8, _y);

	// Mouse over
	if (_container.IsHovered()
		&& FORMS_MOUSE_Y > _y
		&& FORMS_MOUSE_Y < _y + FORMS_LINE_HEIGHT)
	{
		// Click
		if (mouse_check_button_pressed(mb_left))
		{
			FORMS_RequestRedraw(_container);
			return true;
		}
	}
	return false;
}
