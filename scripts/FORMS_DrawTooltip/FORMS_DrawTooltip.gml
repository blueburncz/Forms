/// @func FORMS_DrawTooltip(_x, _y, _text)
///
/// @desc Draws a tooltip at the given position.
///
/// @param {Real} _x The x position to draw the tooltip at.
/// @param {Real} _y The y position to draw the tooltip at.
/// @param {String} _text The text of the tooltip.
function FORMS_DrawTooltip(_x, _y, _text)
{
	var _width = string_width(_text) + 16;
	var _height = string_height(_text) + 8;

	_x = min(_x, window_get_width() - _width - 1);
	_y = min(_y, window_get_height() - _height - 1);

	FORMS_DrawRectangle(_x, _y, _width, _height, FORMS_GetColor(FORMS_EStyle.WindowBorder));
	FORMS_DrawRectangle(_x + 1, _y + 1, _width - 2, _height - 2, FORMS_GetColor(FORMS_EStyle.WindowBackground));
	draw_text(_x + 8, _y + 4, _text);
}
