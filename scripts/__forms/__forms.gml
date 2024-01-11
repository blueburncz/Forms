/// @func forms_assert(_expr, _message)
///
/// @desc
///
/// @param {Bool} _expr
/// @param {String} _message
function forms_assert(_expr, _message)
{
	gml_pragma("forceinline");
	if (!_expr)
	{
		show_error(_message, true);
	}
}

/// @func forms_draw_rectangle(_x, _y, _width, _height[, _color[, _alpha]])
///
/// @desc
///
/// @param {Real} _x
/// @param {Real} _y
/// @param {Real} _width
/// @param {Real} _height
/// @param {Constant.Color} [_color] Defaults to `c_white`.
/// @param {Real} [_alpha] Defaults to 1.
function forms_draw_rectangle(_x, _y, _width, _height, _color=c_white, _alpha=1.0)
{
	gml_pragma("forceinline");
	draw_sprite_stretched_ext(FORMS_SprRectangle, 0, _x, _y, _width, _height, _color, _alpha);
}
