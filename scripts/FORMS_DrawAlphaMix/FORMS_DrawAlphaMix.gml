/// @func FORMS_DrawAlphaMix(_x, _y, _alpha)
///
/// @desc Draws an alpha mix at the given position.
///
/// @param {Real} _x The x position to draw the alpha mix at.
/// @param {Real} _y The y position to draw the alpha mix at.
/// @param {Real} _alpha The alpha value to mix.
///
/// @return {Real} The new mixed alpha.
function FORMS_DrawAlphaMix(_x, _y, _alpha)
{
	var _container = FORMS_WIDGET_FILLING;
	var _containerWidth = _container.Width;

	// Check whether the sliders can be edited
	var _edit = (mouse_check_button(mb_left)
		&& _container.IsHovered()
		&& !FORMS_MOUSE_DISABLE
		&& FORMS_INPUT_ACTIVE == undefined);

	// Alpha
	var _sliderWidth = _containerWidth - _x * 2;
	FORMS_DrawRectangle(_x, _y, _sliderWidth, FORMS_LINE_HEIGHT, FORMS_GetColor(FORMS_EStyle.Input));
	FORMS_DrawRectangle(_x, _y, _sliderWidth * _alpha, FORMS_LINE_HEIGHT, merge_colour(c_black, c_white, _alpha));

	if (_edit)
	{
		if (FORMS_MOUSE_X >= _x - 2
			&& FORMS_MOUSE_Y > _y
			&& FORMS_MOUSE_X <= _x + _sliderWidth + 2
			&& FORMS_MOUSE_Y < _y + FORMS_LINE_HEIGHT)
		{
			_alpha = max(0, min((FORMS_MOUSE_X - _x) / (_containerWidth - _x * 2), 1));
		}
	}
	_y += FORMS_LINE_HEIGHT + 4;

	// Inputs
	iw = round(_containerWidth - _x * 2);
	var _input = FORMS_DrawInput(_x, _y, iw, _alpha, false);
	if (!is_undefined(_input))
	{
		_alpha = max(0, min(_input, 1));
	}

	// Return alpha
	return _alpha;
}

/// @func FORMS_AlphaMixGetHeight()
///
/// @desc Gets the height of an alpha mixer.
///
/// @return {Real} The height of an alpha mixer.
function FORMS_AlphaMixGetHeight()
{
	gml_pragma("forceinline");
	return (FORMS_LINE_HEIGHT * 2 + 4);
}
