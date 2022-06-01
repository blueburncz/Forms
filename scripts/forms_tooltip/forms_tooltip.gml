/// @func forms_draw_tooltip(_x, _y, _text)
/// @desc Draws a tooltip at the given position.
/// @param {real} _x The x position to draw the tooltip at.
/// @param {real} _y The y position to draw the tooltip at.
/// @param {string} _text The text of the tooltip.
function forms_draw_tooltip(_x, _y, _text)
{
	var _width = string_width(_text) + 16;
	var _height = string_height(_text) + 8;

	_x = round(min(_x, window_get_width() - _width - 1));
	_y = round(min(_y, window_get_height() - _height - 1));

	ce_draw_sprite_nine_slice(FORMS_SprTooltip, 0, _x, _y, _width, _height, false);
	draw_text_color(_x + 8, _y + 4, _text, c_black, c_black, c_black, c_black, 1);
}