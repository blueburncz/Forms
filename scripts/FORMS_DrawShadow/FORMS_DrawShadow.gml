/// @func FORMS_DrawShadow(_x, _y, _width, _height, _color, _alpha)
///
/// @desc Draws shadow of given size at given position.
///
/// @param {Real} _x The x position of the shadow.
/// @param {Real} _y The y position of the shadow.
/// @param {Real} _width The width of the shadow.
/// @param {Real} _height The height of the shadow.
/// @param {Real} _color The shadow color.
/// @param {Real} _alpha The shadow alpha.
function FORMS_DrawShadow(_x, _y, _width, _height, _color, _alpha)
{
	var _spr = FORMS_SprShadow;
	var _sprW = sprite_get_width(_spr);
	var _offset = _sprW * 0.5;
	_x += _offset;
	_y += _offset;
	var _w = _width - _sprW;
	var _h = _height - _sprW;
	var _col = _color;
	var _a = _alpha;

	draw_sprite_ext(_spr, 0, _x - _sprW, _y - _sprW, 1, 1, 0, _col, _a);
	draw_sprite_stretched_ext(_spr, 1, _x, _y - _sprW, _w, _sprW, _col, _a);
	draw_sprite_ext(_spr, 0, _x + _w + _sprW, _y - _sprW, -1, 1, 0, _col, _a);
	draw_sprite_stretched_ext(_spr, 2, _x - _sprW, _y, _sprW, _h, _col, _a);
	draw_sprite_ext(_spr, 2, _x + _w + _sprW, _y, -1, _h / _sprW, 0, _col, _a);
	draw_sprite_ext(_spr, 0, _x - _sprW, _y + _h + _sprW, 1, -1, 0, _col, _a);
	draw_sprite_ext(_spr, 1, _x, _y + _h + _sprW, _w / _sprW, -1, 0, _col, _a);
	draw_sprite_ext(_spr, 0, _x + _w + _sprW, _y + _h + _sprW, -1, -1, 0, _col, _a);
}
