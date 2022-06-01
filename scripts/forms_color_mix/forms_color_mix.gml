enum __FORMS_EColorMix
{
	Red,
	Green,
	Blue,
	Hue,
	Sat,
	Val
};

function __reset_hue_start(_argb)
{
	forms_widget_filling[? "__hue_start"] = ce_wrap_angle(((color_get_hue(ce_color_from_argb(_argb)) / 255) * 360) - (forms_widget_filling[? "__hue_index"] * 10));
}

function __forms_rgba_channel(_pen, _channels, _index)
{
	var _changed = false;

	var _slider_sprite = FORMS_SprColorSliderH;
	var _slider_width = sprite_get_width(_slider_sprite);
	var _slider_height = sprite_get_height(_slider_sprite);

	var _slider_id = forms_make_id();
	var _slider_x = forms_pen_get_x(_pen);
	var _slider_y = forms_pen_get_y_inline(_pen, _slider_height);

	var _slider_color_left, _slider_color_right;

	if (_index == 3)
	{
		// Mix alpha
		var _rgb = make_color_rgb(_channels[0], _channels[1], _channels[2]);
		_slider_color_left = ce_color_alpha_to_argb(_rgb, 0);
		_slider_color_right = ce_color_alpha_to_argb(_rgb, 1);
	}
	else
	{
		// Mix color
		_slider_color_left = ce_color_alpha_to_argb(
			make_color_rgb(
				(_index == 0) ? 0 : _channels[0],
				(_index == 1) ? 0 : _channels[1],
				(_index == 2) ? 0 : _channels[2]),
			1);
		_slider_color_right = ce_color_alpha_to_argb(
			make_color_rgb(
				(_index == 0) ? 255 : _channels[0],
				(_index == 1) ? 255 : _channels[1],
				(_index == 2) ? 255 : _channels[2]),
			1);
	}

	draw_sprite(_slider_sprite, 0, _slider_x, _slider_y);
	forms_draw_rectangle_color(
		_slider_x + 1,
		_slider_y + 1,
		_slider_width - 2,
		_slider_height - 2,
		_slider_color_left, _slider_color_right,
		_slider_color_right, _slider_color_left);

	if (forms_mouse_over_rectangle(_slider_x, _slider_y, _slider_width, _slider_height, _slider_id)
		&& mouse_check_button_pressed(mb_left))
	{
		forms_steal_mouse_input(_slider_id);
	}

	var _arrow_id = forms_make_id();
	var _arrow_sprite = FORMS_SprColorSliderArrowH;
	var _arrow_width = sprite_get_width(_arrow_sprite);
	var _arrow_height = sprite_get_height(_arrow_sprite);
	var _arrow_x = _slider_x + round((_slider_width * (_channels[_index] / 255)) - _arrow_width * 0.5);
	var _arrow_y = _slider_y - _arrow_height + 3;

	draw_sprite_ext(_arrow_sprite, 0, _arrow_x, _arrow_y, 1, 1, 0, forms_has_mouse_input(_arrow_id) ? $8f837A : c_white , 1);

	if (forms_mouse_over_rectangle(_arrow_x, _arrow_y, _arrow_width, _arrow_height, _arrow_id)
		&& mouse_check_button_pressed(mb_left))
	{
		forms_steal_mouse_input(_arrow_id);
	}

	if (forms_has_mouse_input(_slider_id)
		|| forms_has_mouse_input(_arrow_id))
	{
		_channels[@ _index] = clamp(round(((forms_mouse_x - _slider_x) / _slider_width) * 255), 0, 255);
		_changed = true;
	}

	// Input
	forms_pen_move(_pen, _slider_width + 18);
	if (forms_input(_pen, 36 + 2 + 13, _channels[_index], { min: 0, max: 255, round: true }))
	{
		_channels[@ _index] = FORMS_VALUE;
		_changed = true;
	}

	if (_changed)
	{
		FORMS_VALUE = ce_color_alpha_to_argb(make_color_rgb(_channels[0], _channels[1], _channels[2]), _channels[3] / 255);
		__reset_hue_start(FORMS_VALUE);
	}

	return _changed;
}

function __forms_hsva_channel(_pen, _channels, _index)
{
	var _changed = false;

	var _slider_sprite = FORMS_SprHsvSlider;
	var _slider_width = sprite_get_width(_slider_sprite);
	var _slider_height = sprite_get_height(_slider_sprite);

	var _slider_id = forms_make_id();
	var _slider_x = forms_pen_get_x(_pen);
	var _slider_y = forms_pen_get_y_inline(_pen, _slider_height);

	draw_sprite(_slider_sprite, 0, _slider_x, _slider_y);

	// Iterations
	var _iter_count = 11;
	var _step = 100 / 10;
	var _iter_x = _slider_x + 1;
	var _iter_y = _slider_y + 1;
	var _iter_width = (_slider_width - 2) / _iter_count;
	var _iter_height = _slider_height - 2;
	var _max = _slider_width - 1 - _iter_width;
	var i = 0;

	var _hue_index = ce_ds_map_get(forms_widget_filling, "__hue_index", floor(_iter_count / 2));
	var _hue_start = forms_widget_filling[? "__hue_start"];
	var _h = _channels[0];

	if (_index == 0)
	{
		if (!ds_map_exists(forms_widget_filling, "__hue_start"))
		{
			forms_widget_filling[? "__hue_start"] = _h - _hue_index * _step;
		}
		_hue_start = forms_widget_filling[? "__hue_start"];
		_h = _hue_start;
	}

	repeat (_iter_count)
	{
		ce_draw_rectangle(_iter_x, _iter_y, _iter_width, _iter_height,
			make_color_hsv(
				(ce_wrap_angle(_h) / 360) * 255,
				(((_index == 1) ? i * _step : _channels[1]) / 100) * 255,
				(((_index == 2) ? i * _step : _channels[2]) / 100) * 255));
		_iter_x += _iter_width;
		++i;

		if (_index == 0)
		{
			_h += _step;
		}
	}

	if (forms_mouse_over_rectangle(_slider_x, _slider_y, _slider_width, _slider_height, _slider_id)
		&& mouse_check_button_pressed(mb_left))
	{
		forms_steal_mouse_input(_slider_id);
	}

	if (forms_has_mouse_input(_slider_id))
	{
		switch (_index)
		{
			case 0:
				// Hue
				_hue_index = clamp(round((ce_snap((forms_mouse_x - _slider_x), _iter_width) / _max) * _iter_count), 0, _iter_count - 1);
				_channels[@ _index] = _hue_start + _hue_index * _step;
				_channels[@ _index] = clamp(_channels[@ _index], _hue_start, _hue_start + 100);
				_channels[@ _index] = ce_wrap_angle(_channels[@ _index]);
				forms_widget_filling[? "__reset_hue"] = false;
				break;
			case 1:
			case 2:
				// Sat, val
				_channels[@ _index] = ((forms_mouse_x - _slider_x) / _max) * 100;
				_channels[@ _index] = clamp(_channels[_index], 0, 100);
				_channels[@ _index] = ce_snap(_channels[_index], 10);
				break;
		}
		_changed = true;
	}

	// Select
	var _select_id = forms_make_id();
	var _select_sprite = FORMS_SprHsvSliderSelect;
	var _select_width = sprite_get_width(_select_sprite);
	var _select_height = sprite_get_height(_select_sprite);
	var _select_x = _slider_x - 1;
	var _select_y = _slider_y - 1;

	if (_index == 0)
	{
		_select_x = _slider_x - 1 + round(_hue_index * _iter_width);
	}
	else
	{
		_select_x = _slider_x - 1 + round((ce_snap(_channels[_index], 10) / 100) * _max);
	}

	draw_sprite(_select_sprite, 0, _select_x, _select_y);

	// Input
	forms_pen_move(_pen, _slider_width + 18);
	if (forms_input(_pen, 36 + 2 + 13, _channels[_index], { min: 0, max: 100, round: true }))
	{
		_channels[@ _index] = FORMS_VALUE;
		_changed = true;
	}

	forms_widget_filling[? "__hue_index"] = _hue_index;

	if (_changed)
	{
		FORMS_VALUE = ce_color_alpha_to_argb(
			make_color_hsv(
				(_channels[0] / 360) * 255,
				(_channels[1] / 100) * 255,
				(_channels[2] / 100) * 255),
			_channels[3]);

		if (_index != 0)
		{
			__reset_hue_start(FORMS_VALUE);
		}
	}

	return _changed;
}

/// @func forms_draw_color_mix(_pen, _argb[, _argb_original])
/// @desc Draws a color mix.
/// @param {array} _pen A Pen structure.
/// @param {real} _argb The color to mix.
/// @param {real} [_argb_original] The original color.
/// @return {real} True if the color has changed. The new color can be read from
/// `FORMS_VALUE`.
/// @see FORMS_EPen
/// @see FORMS_VALUE
function forms_draw_color_mix(_pen, _argb)
{
	var _delegate = forms_widget_get_delegate(forms_widget_filling);
	var _mix_current = ce_ds_map_get(forms_widget_filling, "_color_mix_current", __FORMS_EColorMix.Val);
	var _custom_color_current = ce_ds_map_get(forms_widget_filling, "_custom_color_current", 0);

	var _argb_old = _argb;
	var _argb_original = (argument_count > 2) ? argument[2] : $FFFFFFFF;

	var _color = ce_color_from_argb(_argb);
	var _alpha = ce_color_argb_to_alpha(_argb);
	var _red = color_get_red(_color);
	var _green = color_get_green(_color);
	var _blue = color_get_blue(_color);
	var _hue = color_get_hue(_color);
	var _sat = color_get_saturation(_color);
	var _val = color_get_value(_color);

	// Select color title
	forms_text(_pen, "Select Color:");
	forms_pen_newline(_pen);

	////////////////////////////////////////////////////////////////////////////
	//
	// Big color box
	//
	var _box_id = forms_make_id();
	var _box_x = forms_pen_get_x(_pen);
	var _box_y = forms_pen_get_y(_pen);
	var _box_width = 187;
	var _box_height = 225;

	if (_mix_current == __FORMS_EColorMix.Hue
		|| _mix_current == __FORMS_EColorMix.Sat
		|| _mix_current == __FORMS_EColorMix.Val)
	{
		var _h, _s, _v;

		switch (_mix_current)
		{
			case __FORMS_EColorMix.Hue:
				_h = _hue / 255;
				_s = -1;
				_v = -2;
				break;
			case __FORMS_EColorMix.Sat:
				_h = -1;
				_s = _sat / 255;
				_v = -2;
				break;
			case __FORMS_EColorMix.Val:
				_h = -1;
				_s = -2;
				_v = _val / 255;
				break;
		}

		shader_set(FORMS_ShHSVBox);
		shader_set_uniform_f(shader_get_uniform(FORMS_ShHSVBox, "u_fHue"), _h);
		shader_set_uniform_f(shader_get_uniform(FORMS_ShHSVBox, "u_fSat"), _s);
		shader_set_uniform_f(shader_get_uniform(FORMS_ShHSVBox, "u_fVal"), _v);
		draw_sprite_stretched(FORMS_SprTexture, 0, _box_x, _box_y, _box_width, _box_height);
		shader_reset();
	}

	var _crosshair_x = 0;
	var _crosshair_y = 0;

	switch (_mix_current)
	{
		case __FORMS_EColorMix.Red:
			forms_draw_rectangle_color(_box_x, _box_y, _box_width, _box_height,
				ce_color_alpha_to_argb(make_color_rgb(_red, 255, 0), 1),
				ce_color_alpha_to_argb(make_color_rgb(_red, 255, 255), 1),
				ce_color_alpha_to_argb(make_color_rgb(_red, 0, 255), 1),
				ce_color_alpha_to_argb(make_color_rgb(_red, 0, 0), 1));
			_crosshair_x = _blue / 255;
			_crosshair_y = 1 - (_green / 255);
			break;
		case __FORMS_EColorMix.Green:
			forms_draw_rectangle_color(_box_x, _box_y, _box_width, _box_height,
				ce_color_alpha_to_argb(make_color_rgb(255, _green, 0), 1),
				ce_color_alpha_to_argb(make_color_rgb(255, _green, 255), 1),
				ce_color_alpha_to_argb(make_color_rgb(0, _green, 255), 1),
				ce_color_alpha_to_argb(make_color_rgb(0, _green, 0), 1));
			_crosshair_x = _blue / 255;
			_crosshair_y = 1 - (_red / 255);
			break;
		case __FORMS_EColorMix.Blue:
			forms_draw_rectangle_color(_box_x, _box_y, _box_width, _box_height,
				ce_color_alpha_to_argb(make_color_rgb(0, 255, _blue), 1),
				ce_color_alpha_to_argb(make_color_rgb(255, 255, _blue), 1),
				ce_color_alpha_to_argb(make_color_rgb(255, 0, _blue), 1),
				ce_color_alpha_to_argb(make_color_rgb(0, 0, _blue), 1));
			_crosshair_x = _red / 255;
			_crosshair_y = 1 - (_green / 255);
			break;
		case __FORMS_EColorMix.Hue:
			_crosshair_x = _sat / 255;
			_crosshair_y = 1 - (_val / 255);
			break;
		case __FORMS_EColorMix.Sat:
			_crosshair_x = _hue / 255;
			_crosshair_y = 1 - (_val / 255);
			break;
		case __FORMS_EColorMix.Val:
			_crosshair_x = _hue / 255;
			_crosshair_y = 1 - (_sat / 255);
			break;
	}

	draw_sprite(FORMS_SprColorCrosshair, 0,
		round(_box_x + _box_width * _crosshair_x),
		round(_box_y + _box_height * _crosshair_y));

	if (forms_mouse_over_rectangle(_box_x, _box_y, _box_width, _box_height, _box_id)
		&& mouse_check_button_pressed(mb_left))
	{
		forms_steal_mouse_input(_box_id);
	}

	if (forms_has_mouse_input(_box_id))
	{
		switch (_mix_current)
		{
			case __FORMS_EColorMix.Red:
				_blue = clamp(((forms_mouse_x - _box_x) / _box_width) * 255, 0, 255);
				_green = clamp((1 - ((forms_mouse_y - _box_y) / _box_height)) * 255, 0, 255);
				_argb = ce_color_alpha_to_argb(make_color_rgb(_red, _green, _blue), _alpha);
				break;
			case __FORMS_EColorMix.Green:
				_blue = clamp(((forms_mouse_x - _box_x) / _box_width) * 255, 0, 255);
				_red = clamp((1 - ((forms_mouse_y - _box_y) / _box_height)) * 255, 0, 255);
				_argb = ce_color_alpha_to_argb(make_color_rgb(_red, _green, _blue), _alpha);
				break;
			case __FORMS_EColorMix.Blue:
				_red = clamp(((forms_mouse_x - _box_x) / _box_width) * 255, 0, 255);
				_green = clamp((1 - ((forms_mouse_y - _box_y) / _box_height)) * 255, 0, 255);
				_argb = ce_color_alpha_to_argb(make_color_rgb(_red, _green, _blue), _alpha);
				break;
			case __FORMS_EColorMix.Hue:
				_sat = clamp(((forms_mouse_x - _box_x) / _box_width) * 255, 0, 255);
				_val = clamp((1 - ((forms_mouse_y - _box_y) / _box_height)) * 255, 0, 255);
				_argb = ce_color_alpha_to_argb(make_color_hsv(_hue, _sat, _val), _alpha);
				break;
			case __FORMS_EColorMix.Sat:
				_hue = clamp(((forms_mouse_x - _box_x) / _box_width) * 255, 0, 255);
				_val = clamp((1 - ((forms_mouse_y - _box_y) / _box_height)) * 255, 0, 255);
				_argb = ce_color_alpha_to_argb(make_color_hsv(_hue, _sat, _val), _alpha);
				break;
			case __FORMS_EColorMix.Val:
				_hue = clamp(((forms_mouse_x - _box_x) / _box_width) * 255, 0, 255);
				_sat = clamp((1 - ((forms_mouse_y - _box_y) / _box_height)) * 255, 0, 255);
				_argb = ce_color_alpha_to_argb(make_color_hsv(_hue, _sat, _val), _alpha);
				break;
		}
	}

	forms_pen_move(_pen, _box_width + 11);

	////////////////////////////////////////////////////////////////////////////
	//
	// Big vertical slider
	//
	var _big_slider_sprite = FORMS_SprColorSliderV;
	var _big_slider_id = forms_make_id();
	var _big_slider_x = forms_pen_get_x(_pen);
	var _big_slider_y = forms_pen_get_y(_pen);
	var _big_slider_width = sprite_get_width(_big_slider_sprite);
	var _big_slider_height = sprite_get_height(_big_slider_sprite);

	var _big_arrow_id = forms_make_id();
	var _big_arrow_y = 0;

	if (forms_mouse_over_rectangle(_big_slider_x, _big_slider_y, _big_slider_width, _big_slider_height, _big_slider_id)
		&& mouse_check_button_pressed(mb_left))
	{
		forms_steal_mouse_input(_big_slider_id);
	}

	draw_sprite(_big_slider_sprite, 0, _big_slider_x, _big_slider_y);

	if (_mix_current != __FORMS_EColorMix.Hue)
	{
		var _big_slider_color_top, _big_slider_color_bottom;

		switch (_mix_current)
		{
			case __FORMS_EColorMix.Red:
				if (forms_has_mouse_input(_big_slider_id)
					|| forms_has_mouse_input(_big_arrow_id))
				{
					_red = clamp((1 - (forms_mouse_y - _big_slider_y) / _big_slider_height) * 255, 0, 255);
					_argb = ce_color_alpha_to_argb(make_color_rgb(_red, _green, _blue), _alpha);
				}
				_big_arrow_y = 1 - (_red / 255);
				_big_slider_color_top = make_color_rgb(255, _green, _blue);
				_big_slider_color_bottom = make_color_rgb(0, _green, _blue);
				break;
			case __FORMS_EColorMix.Green:
				if (forms_has_mouse_input(_big_slider_id)
					|| forms_has_mouse_input(_big_arrow_id))
				{
					_green = clamp((1 - (forms_mouse_y - _big_slider_y) / _big_slider_height) * 255, 0, 255);
					_argb = ce_color_alpha_to_argb(make_color_rgb(_red, _green, _blue), _alpha);
				}
				_big_arrow_y = 1 - (_green / 255);
				_big_slider_color_top = make_color_rgb(_red, 255, _blue);
				_big_slider_color_bottom = make_color_rgb(_red, 0, _blue);
				break;
			case __FORMS_EColorMix.Blue:
				if (forms_has_mouse_input(_big_slider_id)
					|| forms_has_mouse_input(_big_arrow_id))
				{
					_blue = clamp((1 - (forms_mouse_y - _big_slider_y) / _big_slider_height) * 255, 0, 255);
					_argb = ce_color_alpha_to_argb(make_color_rgb(_red, _green, _blue), _alpha);
				}
				_big_arrow_y = 1 - (_blue / 255);
				_big_slider_color_top = make_color_rgb(_red, _green, 255);
				_big_slider_color_bottom = make_color_rgb(_red, _green, 0);
				break;
			case __FORMS_EColorMix.Sat:
				if (forms_has_mouse_input(_big_slider_id)
					|| forms_has_mouse_input(_big_arrow_id))
				{
					_sat = clamp((1 - (forms_mouse_y - _big_slider_y) / _big_slider_height) * 255, 0, 255);
					_argb = ce_color_alpha_to_argb(make_color_hsv(_hue, _sat, _val), _alpha);
				}
				_big_arrow_y = 1 - (_sat / 255);
				_big_slider_color_top = make_color_hsv(_hue, 255, _val);
				_big_slider_color_bottom = make_color_hsv(_hue, 0, _val);
				break;
			case __FORMS_EColorMix.Val:
				if (forms_has_mouse_input(_big_slider_id)
					|| forms_has_mouse_input(_big_arrow_id))
				{
					_val = clamp((1 - (forms_mouse_y - _big_slider_y) / _big_slider_height) * 255, 0, 255);
					_argb = ce_color_alpha_to_argb(make_color_hsv(_hue, _sat, _val), _alpha);
				}
				_big_arrow_y = 1 - (_val / 255);
				_big_slider_color_top = make_color_hsv(_hue, _sat, 255);
				_big_slider_color_bottom = make_color_hsv(_hue, _sat, 0);
				break;
		}

		draw_rectangle_color(
			_big_slider_x + 1,
			_big_slider_y + 1,
			_big_slider_x + _big_slider_width - 2,
			_big_slider_y + _big_slider_height - 2,
			_big_slider_color_top, _big_slider_color_top,
			_big_slider_color_bottom, _big_slider_color_bottom,
			false);
	}
	else
	{
		if (forms_has_mouse_input(_big_slider_id)
			|| forms_has_mouse_input(_big_arrow_id))
		{
			_hue = clamp((1 - ((forms_mouse_y - _big_slider_y) / _big_slider_height)) * 255, 0, 255);
			_argb = ce_color_alpha_to_argb(make_color_hsv(_hue, _sat, _val), _alpha);
		}

		_big_arrow_y = 1 - (_hue / 255);

		shader_set(FORMS_ShHSVBox);
		shader_set_uniform_f(shader_get_uniform(FORMS_ShHSVBox, "u_fHue"), -2);
		shader_set_uniform_f(shader_get_uniform(FORMS_ShHSVBox, "u_fSat"), 1);
		shader_set_uniform_f(shader_get_uniform(FORMS_ShHSVBox, "u_fVal"), 1);
		draw_sprite_stretched(FORMS_SprTexture, 0,
			_big_slider_x + 1,
			_big_slider_y + 1,
			_big_slider_width - 2,
			_big_slider_height - 2);
		shader_reset();
	}

	var _big_arrow_sprite = FORMS_SprColorSliderArrowV;
	var _big_arrow_width = sprite_get_width(_big_arrow_sprite);
	var _big_arrow_height = sprite_get_height(_big_arrow_sprite);
	var _big_arrow_x = _big_slider_x - 2;
	_big_arrow_y = round(_big_slider_y + (_big_slider_height * _big_arrow_y) - _big_arrow_height * 0.5);

	if (forms_mouse_over_rectangle(_big_arrow_x, _big_arrow_y, _big_arrow_width, _big_arrow_height, _big_arrow_id)
		&& mouse_check_button_pressed(mb_left))
	{
		forms_steal_mouse_input(_big_arrow_id);
	}

	draw_sprite_ext(_big_arrow_sprite, 0, _big_arrow_x, _big_arrow_y,
		1, 1, 0, forms_has_mouse_input(_big_arrow_id) ? $A09389 : c_white, 1);

	forms_pen_move(_pen, _big_slider_width + 16);

	////////////////////////////////////////////////////////////////////////////
	//
	// Radiobuttons and sliders
	//
	var _radios_x = forms_pen_get_x(_pen);
	var _radios_y = forms_pen_get_y(_pen);

	var _slider_sprite = FORMS_SprColorSliderH;
	var _slider_width = sprite_get_width(_slider_sprite);
	var _slider_height = sprite_get_height(_slider_sprite);

	////////////////////////////////////////////////////////////////////////////
	// Red
	forms_pen_set_x(_pen, _radios_x);
	if (forms_radiobutton(_pen, "Red", _mix_current == __FORMS_EColorMix.Red))
	{
		_mix_current = __FORMS_EColorMix.Red;
	}
	forms_pen_set_x(_pen, _radios_x + 89);
	if (__forms_rgba_channel(_pen, [_red, _green, _blue, _alpha * 255], 0))
	{
		_argb = FORMS_VALUE;
	}
	forms_pen_newline(_pen);

	////////////////////////////////////////////////////////////////////////////
	// Green
	forms_pen_set_x(_pen, _radios_x);
	if (forms_radiobutton(_pen, "Green", _mix_current == __FORMS_EColorMix.Green))
	{
		_mix_current = __FORMS_EColorMix.Green;
	}
	forms_pen_set_x(_pen, _radios_x + 89);
	if (__forms_rgba_channel(_pen, [_red, _green, _blue, _alpha * 255], 1))
	{
		_argb = FORMS_VALUE;
	}
	forms_pen_newline(_pen);

	////////////////////////////////////////////////////////////////////////////
	// Blue
	forms_pen_set_x(_pen, _radios_x);
	if (forms_radiobutton(_pen, "Blue", _mix_current == __FORMS_EColorMix.Blue))
	{
		_mix_current = __FORMS_EColorMix.Blue;
	}
	forms_pen_set_x(_pen, _radios_x + 89);
	if (__forms_rgba_channel(_pen, [_red, _green, _blue, _alpha * 255], 2))
	{
		_argb = FORMS_VALUE;
	}
	forms_pen_newline(_pen);
	forms_pen_move(_pen, 0, 15);

	////////////////////////////////////////////////////////////////////////////
	// Alpha
	forms_pen_set_x(_pen, _radios_x + 23);
	forms_text(_pen, "Alpha");
	forms_pen_set_x(_pen, _radios_x + 89);
	if (__forms_rgba_channel(_pen, [_red, _green, _blue, _alpha * 255], 3))
	{
		_argb = FORMS_VALUE;
	}
	forms_pen_newline(_pen);
	forms_pen_move(_pen, 0, 15);

	if (_argb != _argb_old)
	{
		_color = ce_color_from_argb(_argb);
		_alpha = ce_color_argb_to_alpha(_argb);
		_red = color_get_red(_color);
		_green = color_get_green(_color);
		_blue = color_get_blue(_color);
		_hue = color_get_hue(_color);
		_sat = color_get_saturation(_color);
		_val = color_get_value(_color);
		__reset_hue_start(_argb);
	}

	////////////////////////////////////////////////////////////////////////////
	// Hue
	forms_pen_set_x(_pen, _radios_x);
	if (forms_radiobutton(_pen, "Hue", _mix_current == __FORMS_EColorMix.Hue))
	{
		_mix_current = __FORMS_EColorMix.Hue;
	}
	forms_pen_set_x(_pen, _radios_x + 89);
	if (__forms_hsva_channel(_pen, [(_hue / 255) * 360, (_sat / 255) * 100, (_val / 255) * 100, _alpha], 0))
	{
		_argb = FORMS_VALUE;
	}
	forms_pen_newline(_pen);

	////////////////////////////////////////////////////////////////////////////
	// Sat
	forms_pen_set_x(_pen, _radios_x);
	if (forms_radiobutton(_pen, "Sat", _mix_current == __FORMS_EColorMix.Sat))
	{
		_mix_current = __FORMS_EColorMix.Sat;
	}
	forms_pen_set_x(_pen, _radios_x + 89);
	if (__forms_hsva_channel(_pen, [(_hue / 255) * 360, (_sat / 255) * 100, (_val / 255) * 100, _alpha], 1))
	{
		_argb = FORMS_VALUE;
	}
	forms_pen_newline(_pen);

	////////////////////////////////////////////////////////////////////////////
	// Val
	forms_pen_set_x(_pen, _radios_x);
	if (forms_radiobutton(_pen, "Val", _mix_current == __FORMS_EColorMix.Val))
	{
		_mix_current = __FORMS_EColorMix.Val;
	}
	forms_pen_set_x(_pen, _radios_x + 89);
	if (__forms_hsva_channel(_pen, [(_hue / 255) * 360, (_sat / 255) * 100, (_val / 255) * 100, _alpha], 2))
	{
		_argb = FORMS_VALUE;
	}
	forms_pen_newline(_pen);

	////////////////////////////////////////////////////////////////////////////
	//
	// Bottom
	//

	// Basic colors
	var _basic_colors = [
		$FFFF0000,
		$FFFFFF00,
		$FF00FF00,
		$FF00FFFF,
		$FF0000FF,
		$FFFF00FF,
		$FFFFFFFF,
		$FF000000,
		$FF603912,
		$FF630460,
	];

	forms_pen_move(_pen, 0, -10);
	forms_text(_pen, "Basic Colors:");
	forms_pen_newline(_pen);
	forms_pen_move(_pen, 0, -10);

	var i = 0;
	repeat (array_length(_basic_colors))
	{
		var _c = _basic_colors[i];
		if (forms_color_minibox(_pen, _c))
		{
			_argb = _c;
			__reset_hue_start(_argb);
		}
		forms_pen_move(_pen, 3);
		++i;
	}

	// Color compare
	forms_pen_move(_pen, 9);

	var _color_compare_sprite = FORMS_SprColorCompare;
	var _color_compare_x = forms_pen_get_x(_pen);
	var _color_compare_y = forms_pen_get_y(_pen) + 3;
	var _color_compare_width = sprite_get_width(_color_compare_sprite);
	var _color_compare_height = sprite_get_height(_color_compare_sprite);

	draw_sprite(_color_compare_sprite, 0, _color_compare_x, _color_compare_y);
	draw_sprite_ext(_color_compare_sprite, 1, _color_compare_x, _color_compare_y, 1, 1, 0,
		ce_color_from_argb(_argb_original), ce_color_argb_to_alpha(_argb_original));
	draw_sprite_ext(_color_compare_sprite, 2, _color_compare_x, _color_compare_y, 1, 1, 0,
		ce_color_from_argb(_argb), ce_color_argb_to_alpha(_argb));

	forms_pen_move(_pen, _color_compare_width + 10);

	// Hex
	var _text_hex_x = forms_pen_get_x(_pen);

	forms_text(_pen, "Hex ");

	if (forms_input(_pen, 64, ce_byte_array_to_hex([_red, _green, _blue])))
	{
		var _real = ce_hex_to_real(FORMS_VALUE);
		if (!is_nan(_real))
		{
			_argb = ce_color_alpha_to_argb(ce_color_rgb_to_bgr(_real), _alpha);
		}
	}

	forms_pen_newline(_pen);
	forms_pen_move(_pen, 0, -15);

	// Grays
	var _grays = [
		$FFFFFFFF,
		$FFE6E6E6,
		$FFCCCCCC,
		$FFB3B3B3,
		$FF999999,
		$FF808080,
		$FF676767,
		$FF4D4D4D,
		$FF343434,
		$FF1A1A1A,
	];

	var i = 0;
	repeat (array_length(_grays))
	{
		var _c = _grays[i];
		if (forms_color_minibox(_pen, _c))
		{
			_argb = _c;
			__reset_hue_start(_argb);
		}
		forms_pen_move(_pen, 3);
		++i;
	}

	// New color text
	forms_pen_set_x(_pen, _text_hex_x);
	forms_pen_move(_pen, 0, 2);
	forms_text(_pen, "New Color");
	forms_pen_newline(_pen);

	// Custom colors
	forms_pen_move(_pen, 0, -15);
	forms_text(_pen, "Custom Colors:");
	forms_pen_newline(_pen);
	forms_pen_move(_pen, 0, -10);

	var i = 0;
	repeat (array_length(forms_custom_colors))
	{
		var _c = forms_custom_colors[i];
		if (forms_color_minibox(_pen, _c, { selected: (i == _custom_color_current) }))
		{
			_argb = _c;
			_custom_color_current = i;
		}
		forms_pen_move(_pen, 3);
		++i;
	}
	forms_pen_move(_pen, 10);

	if (forms_button(_pen, "Store Color", { width: 112 }))
	{
		forms_custom_colors[@ _custom_color_current] = _argb;
		_custom_color_current = ce_wrap(++_custom_color_current, 0, array_length(forms_custom_colors) - 1);
	}
	forms_pen_move(_pen, 22);

	if (forms_button(_pen, "Cancel", { width: 90 }))
	{
		_argb = _argb_original;
		//forms_widget_destroy(_delegate);
	}
	forms_pen_move(_pen, 5);

	if (forms_button(_pen, "OK", { width: 90 }))
	{
		forms_widget_destroy(_delegate);
	}

	////////////////////////////////////////////////////////////////////////////
	//
	// Temp
	//
	forms_pen_newline(_pen);

	////////////////////////////////////////////////////////////////////////////
	//
	// Save
	//
	forms_widget_filling[? "_color_mix_current"] = _mix_current;
	forms_widget_filling[? "_custom_color_current"] = _custom_color_current;

	////////////////////////////////////////////////////////////////////////////
	//
	// Return value
	//
	if (_argb != _argb_old)
	{
		FORMS_VALUE = _argb;
		return true;
	}

	return false;
}