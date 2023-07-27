/// @func FORMS_DrawRectangle(_x, _y, _width, _height, _color[, _alpha])
///
/// @desc Draws a rectangle of the given size and color at the given position.
///
/// @param {Real} _x The x position to draw the rectangle at.
/// @param {Real} _y The y position to draw the rectangle at.
/// @param {Real} _width The width of the rectangle.
/// @param {Real} _height The height of the rectangle.
/// @param {Real} _color The color of the rectangle.
/// @param {Real} [_alpha] The alpha of the rectangle.
function FORMS_DrawRectangle(_x, _y, _width, _height, _color, _alpha=1.0)
{
	gml_pragma("forceinline");
	draw_sprite_ext(FORMS_SprRectangle, 0,
		_x, _y,
		_width, _height,
		0, _color, _alpha);
}
