/// @func FORMS_DrawColourInput(_x, _y, _width, _color, _alpha)
///
/// @desc Draws a color input at the given position.
///
/// @param {Real} _x The x position to draw the input at.
/// @param {Real} _y The y position to draw the input at.
/// @param {Real} _width The width of the input.
/// @param {Real} _color The current color.
/// @param {Real} _alpha The current alpha.
///
/// @return {Struct.FORMS_Window, Undefined} The color picker window on click or `undefined`.
function FORMS_DrawColourInput(_x, _y, _width, _color, _alpha)
{
	var _parent = FORMS_WIDGET_FILLING;
	var _mouseOver = (_parent.IsHovered()
		&& FORMS_MOUSE_X > _x
		&& FORMS_MOUSE_Y > _y
		&& FORMS_MOUSE_X < _x + _width
		&& FORMS_MOUSE_Y < _y + FORMS_INPUT_SPRITE_HEIGHT);

	draw_sprite_ext(FORMS_SprInput, 0, _x, _y, 1, 1, 0, _color, 1);
	var _w = round((_width - FORMS_INPUT_SPRITE_WIDTH * 2) * 0.5);
	draw_sprite_stretched_ext(FORMS_SprInput, 1, _x + FORMS_INPUT_SPRITE_WIDTH, _y, _w, FORMS_INPUT_SPRITE_HEIGHT, _color, 1);
	draw_sprite_stretched_ext(FORMS_SprInput, 1, _x + FORMS_INPUT_SPRITE_WIDTH + _w, _y, _w, FORMS_INPUT_SPRITE_HEIGHT, c_black, 1);
	draw_sprite_stretched_ext(FORMS_SprInput, 1, _x + FORMS_INPUT_SPRITE_WIDTH + _w, _y, _w, FORMS_INPUT_SPRITE_HEIGHT, c_white, _alpha);
	draw_sprite_ext(FORMS_SprInput, 2, _x + FORMS_INPUT_SPRITE_WIDTH + _w * 2, _y, 1, 1, 0, c_black, 1);
	draw_sprite_ext(FORMS_SprInput, 2, _x + FORMS_INPUT_SPRITE_WIDTH + _w * 2, _y, 1, 1, 0, c_white, _alpha);

	if (mouse_check_button_pressed(mb_left)
		&& _mouseOver)
	{
		var _colourPicker = new FORMS_Window();
		_colourPicker.SetPosition(
			round((window_get_width() - _colourPicker.Width) * 0.5),
			round((window_get_height() - _colourPicker.Height) * 0.5));
		var _colourPickerContainer = _colourPicker.Container;
		_colourPickerContainer.Color = _color;
		_colourPickerContainer.Alpha = _alpha;
		FORMS_WindowSetContent(_colourPicker, new FORMS_ColourPickerContent());
		FORMS_ROOT.AddItem(_colourPicker);
		return _colourPicker;
	}

	return undefined;
}
