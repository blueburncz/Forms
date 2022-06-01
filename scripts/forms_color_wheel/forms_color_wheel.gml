/// @func forms_color_wheel(_pen, _size, _color)
/// @param {array} _pen
/// @param {real} _size
/// @param {int} _color
function forms_color_wheel(_pen, _size, _color)
{
	var _shader = FORMS_ShColorWheel;
	shader_set(_shader);
	shader_set_uniform_f(shader_get_uniform(_shader, "u_fTexel"), 1 / _size);
	shader_set_uniform_f(shader_get_uniform(_shader, "u_fValue"), color_get_value(_color) / 255);
	draw_sprite_stretched(FORMS_SprTexture, 0, forms_pen_get_x(_pen), forms_pen_get_y(_pen), _size, _size);
	shader_reset();
	forms_pen_move(_pen, _size);
}