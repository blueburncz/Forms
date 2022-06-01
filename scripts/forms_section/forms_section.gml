/// @func forms_section(_pen, _text, _width)
/// @param {array} _pen
/// @param {string} _text
/// @param {real} _width
function forms_section(_pen, _text, _width)
{
	var _x = forms_pen_get_x(_pen);
	var _y = forms_pen_get_y(_pen);

	ce_draw_sprite_nine_slice(FORMS_SprSection, 0, _x, _y, _width, forms_line_height, false);
	forms_text(forms_pen_create(_x + 10, _y), _text);

	forms_pen_move(_pen, _width);
}