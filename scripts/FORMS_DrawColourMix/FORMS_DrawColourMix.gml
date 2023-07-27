/// @func FORMS_DrawColourMix(_x, _y, _color)
///
/// @desc Draws a color mix at the given position.
///
/// @param {Real} _x The x position to draw the color mix at.
/// @param {Real} _y The y position to draw the color mix at.
/// @param {Real} _color The color to mix.
///
/// @return {Real} The new mixed color.
function FORMS_DrawColourMix(_x, _y, _color)
{
	var _container = FORMS_WIDGET_FILLING;
	var _containerWidth = _container.Width;
	var _red = colour_get_red(_color);
	var _green = colour_get_green(_color);
	var _blue = colour_get_blue(_color);

	// Check whether the sliders can be edited
	var _edit = (_container.IsHovered()
		&& !FORMS_MOUSE_DISABLE
		&& FORMS_INPUT_ACTIVE == undefined);

	// Red
	var _sliderWidth = _containerWidth - _x * 2;
	FORMS_DrawRectangle(_x, _y, _sliderWidth, FORMS_LINE_HEIGHT, FORMS_GetColor(FORMS_EStyle.Input));
	FORMS_DrawRectangle(_x, _y, _sliderWidth * (_red / 255), FORMS_LINE_HEIGHT, make_colour_rgb(_red, 0, 0));
	if (_edit)
	{
		if (FORMS_MOUSE_X >= _x - 2
			&& FORMS_MOUSE_Y > _y
			&& FORMS_MOUSE_X <= _x + _sliderWidth + 2
			&& FORMS_MOUSE_Y < _y + FORMS_LINE_HEIGHT)
		{
			if (mouse_check_button(mb_left))
			{
				_red = round(clamp((FORMS_MOUSE_X - _x) / (_containerWidth - _x * 2), 0, 1) * 255);
			}
			FORMS_COLOR_PREVIEW = make_colour_rgb(_red, _green, _blue);
		}
	}
	_y += FORMS_LINE_HEIGHT + 4;

	// Green
	FORMS_DrawRectangle(_x, _y, _sliderWidth, FORMS_LINE_HEIGHT, FORMS_GetColor(FORMS_EStyle.Input));
	FORMS_DrawRectangle(_x, _y, _sliderWidth * (_green / 255), FORMS_LINE_HEIGHT, make_colour_rgb(0, _green, 0));
	if (_edit)
	{
		if (FORMS_MOUSE_X >= _x - 2
			&& FORMS_MOUSE_Y > _y
			&& FORMS_MOUSE_X <= _x + _sliderWidth + 2
			&& FORMS_MOUSE_Y < _y + FORMS_LINE_HEIGHT)
		{
			if (mouse_check_button(mb_left))
			{
				_green = round(clamp((FORMS_MOUSE_X - _x) / (_containerWidth - _x * 2), 0, 1) * 255);
			}
			FORMS_COLOR_PREVIEW = make_colour_rgb(_red, _green, _blue);
		}
	}
	_y += FORMS_LINE_HEIGHT + 4;

	// Blue
	FORMS_DrawRectangle(_x, _y, _sliderWidth, FORMS_LINE_HEIGHT, FORMS_GetColor(FORMS_EStyle.Input));
	FORMS_DrawRectangle(_x, _y, _sliderWidth * (_blue / 255), FORMS_LINE_HEIGHT, make_colour_rgb(0, 0, _blue));
	if (_edit)
	{
		if (FORMS_MOUSE_X >= _x - 2
			&& FORMS_MOUSE_Y > _y
			&& FORMS_MOUSE_X <= _x + _sliderWidth + 2
			&& FORMS_MOUSE_Y < _y + FORMS_LINE_HEIGHT)
		{
			if (mouse_check_button(mb_left))
			{
				_blue = round(clamp((FORMS_MOUSE_X - _x) / (_containerWidth - _x * 2), 0, 1) * 255);
			}
			FORMS_COLOR_PREVIEW = make_colour_rgb(_red, _green, _blue);
		}
	}
	_y += FORMS_LINE_HEIGHT + 4;

	// Inputs
	var _input;
	var _inputWidth = round((_sliderWidth - 16) / 3);

	_input = FORMS_DrawInput(_x, _y, _inputWidth, _red);
	if (!is_undefined(_input))
	{
		_red = clamp(round(_input), 0, 255);
	}

	_input = FORMS_DrawInput(_x + _inputWidth + 8, _y, _inputWidth, _green);
	if (!is_undefined(_input))
	{
		_green = clamp(round(_input), 0, 255);
	}

	_input = FORMS_DrawInput(_x + _inputWidth * 2 + 16, _y, _inputWidth, _blue);
	if (!is_undefined(_input))
	{
		_blue = clamp(round(_input), 0, 255);
	}

	return make_colour_rgb(_red, _green, _blue);
}

/// @func FORMS_ColourMixGetHeight()
///
/// @desc Gets the height of a color mixer.
///
/// @return {Real} The height of a color mixer.
function FORMS_ColourMixGetHeight()
{
	gml_pragma("forceinline");
	return (FORMS_LINE_HEIGHT * 4 + 12);
}
