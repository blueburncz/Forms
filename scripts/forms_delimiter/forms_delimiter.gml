/// @func forms_delimiter(_pen)
/// @desc Draws a toolbar delimiter.
/// @param {FORMS_EPen} _pen
function forms_delimiter(_pen)
{
	gml_pragma("forceinline");
	var _width = FORMS_ICON_SIZE;
	ce_draw_rectangle(
		forms_pen_get_x(_pen) + _width * 0.5,
		forms_pen_get_y(_pen),
		1, forms_line_height, $404040);
	forms_pen_move(_pen, _width + 2);
}