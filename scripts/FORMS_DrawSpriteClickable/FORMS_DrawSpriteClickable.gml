/// @func FORMS_DrawSpriteClickable(_sprite, _subimg, _x, _y[, _color])
///
/// @desc Draws a clickable sprite at the given position.
///
/// @param {Real} _sprite The sprite.
/// @param {Real} _subimg The subimage of the sprite.
/// @param {Real} _x The x position to draw the sprite at.
/// @param {Real} _y The y position to draw the sprite at.
/// @param {Real} [_color] The color to blend the sprite with.
///
/// @return {Bool} True if the sprite is clicked.
function FORMS_DrawSpriteClickable(_sprite, _subimg, _x, _y, _color=c_white)
{
	var _parent = FORMS_WIDGET_FILLING;
	var _width = sprite_get_width(_sprite);
	var _height = sprite_get_height(_sprite);
	var _mouseOver = (_parent.IsHovered()
		&& FORMS_MOUSE_X > _x
		&& FORMS_MOUSE_Y > _y
		&& FORMS_MOUSE_X < _x + _width
		&& FORMS_MOUSE_Y < _y + _height);
	draw_sprite_ext(_sprite, _subimg, _x, _y, 1, 1, 0, _color, 1);
	return (mouse_check_button_pressed(mb_left)
		&& _mouseOver);
}
