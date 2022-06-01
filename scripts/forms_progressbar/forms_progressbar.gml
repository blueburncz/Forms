/// @func forms_progressbar(_pen, _progress, _progress_max[, _props])
/// @param {array} _pen
/// @param {real} _progress
/// @param {real} _progress_max
/// @param {struct} [_props]
function forms_progressbar(_pen, _progress, _progress_max)
{
	var _props = (argument_count > 3) ? argument[3] : {};
	var _width = ce_struct_get(_props, "width");
	var _height = sprite_get_height(FORMS_SprProgressBar);
	var _x = forms_pen_get_x(_pen);
	var _y = forms_pen_get_y_inline(_pen, _height);
	var _progress_linear = clamp(_progress / _progress_max, 0, 1);
	var _text = ce_struct_get(_props, "text", "");
	if (_text != "")
	{
		_text += " ";
	}
	_text += string(floor(_progress_linear * 100)) + "%";
	var _text_width = string_width(_text);

	if (_width == undefined)
	{
		_width = string_width(_text) + 8;
	}

	ce_draw_rectangle(_x, _y, _width, _height, $181818);
	draw_sprite_ext(FORMS_SprProgressBar, 0, _x, _y, floor(_progress_linear * _width), 1, 0, c_white, 1);
	forms_draw_text_shadow(
		_x + floor((_width - _text_width) * 0.5),
		_y + floor((_height - string_height(_text)) * 0.5),
		_text,
		c_white,
		c_black);

	forms_pen_move(_pen, _width);
}