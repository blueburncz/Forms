/// @func forms_slider(_pen, _value, _min, _max)
/// @param {FORMS_EPen} _pen
/// @param {real} _value
/// @param {real} _min
/// @param {real} _max
/// @param {struct} [_props]
/// @return {real}
function forms_slider(_pen, _value, _min, _max)
{
	
	var _range = _max - _min;
	var _props = (argument_count > 4) ? argument[4] : {};
	var _id = ce_struct_get(_props, "id", forms_make_id());
	var _disabled = ce_struct_get(_props, "disabled", false);
	var _sprite = FORMS_SprSlider;
	var _sprite_width = sprite_get_width(_sprite);
	var _sprite_height = sprite_get_height(_sprite);
	var _sprite_arrow = FORMS_SprSliderArrow;
	var _sprite_arrow_width = sprite_get_width(_sprite_arrow);
	var _sprite_arrow_height = sprite_get_height(_sprite_arrow);
	var _x = forms_pen_get_x(_pen);
	var _y = forms_pen_get_y_inline(_pen, _sprite_height);
	var _width = ce_struct_get(_props, "width", 128);
	var _argb = ce_struct_get(_props, "color", $FF029D5B);
	var _color, _alpha;

	// Control
	var _mouse_in_rectangle = forms_mouse_over_rectangle(_x, _y, _width, _sprite_height, _id);
	var _mouse_over = (!_disabled && _mouse_in_rectangle);

	if (_mouse_over && mouse_check_button_pressed(mb_left))
	{
		forms_steal_mouse_input(_id);
	}

	if (forms_has_mouse_input(_id))
	{
		var __x = clamp((forms_mouse_x - _x) / _width, 0, 1);
		_value = lerp(_min, _max, __x);
		if (ce_struct_get(_props, "round", false))
		{
			_value = round(_value);
		}
		_color = ce_color_from_argb(_argb);
		_alpha = ce_color_argb_to_alpha(_argb);
	}
	else
	{
		var _argb = $FF333740;
		_color = ce_color_from_argb(_argb);
		_alpha = ce_color_argb_to_alpha(_argb);
	}

	// Background
	draw_sprite_stretched(_sprite, 0, _x, _y, _width, _sprite_height);

	// Fill
	var _third = round(_sprite_width / 3);
	var _w = (_value - _min) / _range;
	draw_sprite_part_ext(_sprite, 1, 0, 0, _third, _sprite_height, _x, _y, 1, 1, _color, _alpha);
	var __w = round(_w * _width - (_third * 2));
	draw_sprite_part_ext(_sprite, 1, _third, 0, _third, _sprite_height, _x + _third, _y, __w / _third, 1, _color, _alpha);
	draw_sprite_part_ext(_sprite, 1, _third * 2, 0, _third, _sprite_height, _x + _third + __w, _y, 1, 1, _color, _alpha);

	// Arrow
	var _arrow_x = _x + floor((_w * _width) - (_sprite_arrow_width * 0.5));
	var _arrow_y = _y + _sprite_height - 3;
	var _arrow_color = $59514E;

	if (!_disabled && forms_mouse_over_rectangle(_arrow_x, _arrow_y, _sprite_arrow_width, _sprite_arrow_height, _id))
	{
		if (mouse_check_button_pressed(mb_left))
		{
			forms_steal_mouse_input(_id);
		}
		if (!forms_has_mouse_input(_id))
		{
			_arrow_color = c_white;
		}
	}

	draw_sprite_ext(_sprite_arrow, 0, _arrow_x, _arrow_y, 1, 1, 0, _arrow_color, 1);

	forms_pen_move(_pen, _width);

	return _value;
}