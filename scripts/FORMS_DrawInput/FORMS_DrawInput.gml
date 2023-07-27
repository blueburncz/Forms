/// @func FORMS_DrawInput(_x, _y, _width, _value[, _disabled[, _defaultValue]])
///
/// @desc Draws an input at the given position.
///
/// @param {Real} _x The x position to draw the input at.
/// @param {Real} _y The y position to draw the input at.
/// @param {Real} _width The width of the input.
/// @param {Real, String} _value The value in the input.
/// @param {Bool} [_disabled] True to disable editing the input value.
/// @param {Real, String} [_defaultValue] The value to draw when the value is an
/// empty string.
///
/// @return {Real, String} The new input value when done editing or
/// `undefined` while editing.
function FORMS_DrawInput(_x, _y, _width)
{
	var _padding = ceil(FORMS_FONT_WIDTH * 0.5) + 1;
	var _id = FORMS_EncodeID(FORMS_WIDGET_FILLING, FORMS_WIDGET_ID_NEXT++);
	var _parent = FORMS_WIDGET_FILLING;
	var _xStart = _x;
	var _active = (FORMS_CONTROL_STATE == FORMS_EControlState.Input
		&& FORMS_INPUT_ACTIVE == _id);

	var _value;
	if (_active)
		_value = FORMS_INPUT_STRING;
	else
		_value = string(argument[3]);
	var _type = is_real(argument[3]);
	var _stringLength = string_length(_value);
	var _mouseOver = (_parent.IsHovered()
		&& FORMS_MOUSE_X > _x
		&& FORMS_MOUSE_Y > _y
		&& FORMS_MOUSE_X < _x + _width
		&& FORMS_MOUSE_Y < _y + FORMS_INPUT_SPRITE_HEIGHT);
	var _maxCharCount = floor((_width - _padding * 2 ) / FORMS_FONT_WIDTH);

	var _disabled = false;
	if (argument_count > 4)
		_disabled = argument[4];

	////////////////////////////////////////////////////////////////////////////
	//
	// Draw input
	//

	// Background
	draw_sprite_ext(FORMS_INPUT_SPRITE, 0, _x, _y, 1, 1, 0, FORMS_GetColor(FORMS_EStyle.Input), 1);
	draw_sprite_stretched_ext(FORMS_INPUT_SPRITE, 1, _x + FORMS_INPUT_SPRITE_WIDTH, _y,
		_width - FORMS_INPUT_SPRITE_WIDTH * 2, FORMS_INPUT_SPRITE_HEIGHT, FORMS_GetColor(FORMS_EStyle.Input), 1);
	draw_sprite_ext(FORMS_INPUT_SPRITE, 2, _x + _width - FORMS_INPUT_SPRITE_WIDTH, _y, 1, 1, 0, FORMS_GetColor(FORMS_EStyle.Input), 1);

	// Text
	var _textX = _x + _padding;
	var _textY = _y + round((FORMS_INPUT_SPRITE_HEIGHT - FORMS_FONT_HEIGHT) * 0.5);
	_maxCharCount = floor((_width - _padding * 2) / FORMS_FONT_WIDTH);
	var _colSelection = FORMS_GetColor(FORMS_EStyle.Active);

	if (!_disabled && _mouseOver)
	{
		FORMS_CURSOR = cr_beam;
	}

	if (_active)
	{
		if (FORMS_INPUT_INDEX_TO - FORMS_INPUT_INDEX_DRAW_START > _maxCharCount)
			FORMS_INPUT_INDEX_DRAW_START += FORMS_INPUT_INDEX_TO - FORMS_INPUT_INDEX_DRAW_START - _maxCharCount;
		else if (FORMS_INPUT_INDEX_DRAW_START > FORMS_INPUT_INDEX_TO)
			FORMS_INPUT_INDEX_DRAW_START -= FORMS_INPUT_INDEX_DRAW_START - FORMS_INPUT_INDEX_TO;

		var _drawValue = string_copy(_value, FORMS_INPUT_INDEX_DRAW_START, _maxCharCount);

		if (FORMS_INPUT_INDEX_FROM == FORMS_INPUT_INDEX_TO)
		{
			// Beam
			var _beamX = _textX + FORMS_FONT_WIDTH * (FORMS_INPUT_INDEX_FROM - FORMS_INPUT_INDEX_DRAW_START);
			draw_text(_textX, _textY, _drawValue);
			FORMS_DrawRectangle(_beamX, _textY, 1, FORMS_FONT_HEIGHT, _colSelection);
		}
		else
		{
			// Selection
			var _minIndex = clamp(min(FORMS_INPUT_INDEX_FROM, FORMS_INPUT_INDEX_TO) - FORMS_INPUT_INDEX_DRAW_START, 0, _stringLength);
			var _maxIndex = clamp(max(FORMS_INPUT_INDEX_FROM, FORMS_INPUT_INDEX_TO) - FORMS_INPUT_INDEX_DRAW_START, 0, _stringLength);
			var _rectMinX = _textX + FORMS_FONT_WIDTH * max(_minIndex, 0);
			var _rectMaxX = _textX + FORMS_FONT_WIDTH * min(_maxIndex, _maxCharCount);

			// Text before selection
			draw_text(_textX, _textY, string_copy(_drawValue, 1, _minIndex));
			// Selection rectangle
			FORMS_DrawRectangle(_rectMinX, _textY, _rectMaxX - _rectMinX, FORMS_FONT_HEIGHT, _colSelection);
			// Selected text
			draw_text_colour(_rectMinX, _textY, string_copy(_drawValue, _minIndex + 1, _maxIndex - _minIndex),
				FORMS_GetColor(FORMS_EStyle.TextSelected), FORMS_GetColor(FORMS_EStyle.TextSelected), FORMS_GetColor(FORMS_EStyle.TextSelected), FORMS_GetColor(FORMS_EStyle.TextSelected), 1);
			// Text after selection
			draw_text(_rectMaxX, _textY, string_delete(_drawValue, 1, _maxIndex));
		}

		// Draw highlight
		draw_sprite_ext(FORMS_INPUT_SPRITE, 3, _x, _y, 1, 1, 0, FORMS_GetColor(FORMS_EStyle.Active), 1);
		draw_sprite_stretched_ext(FORMS_INPUT_SPRITE, 4, _x + FORMS_INPUT_SPRITE_WIDTH, _y,
			_width - FORMS_INPUT_SPRITE_WIDTH * 2, FORMS_INPUT_SPRITE_HEIGHT, FORMS_GetColor(FORMS_EStyle.Active), 1);
		draw_sprite_ext(FORMS_INPUT_SPRITE, 5, _x + _width - FORMS_INPUT_SPRITE_WIDTH, _y, 1, 1, 0, FORMS_GetColor(FORMS_EStyle.Active), 1);
	}
	else
	{
		var _drawValue = _value;
		if (argument_count > 5 && _value == "")
			_drawValue = argument[5];

		var _color;
		if (_disabled)
			_color = FORMS_GetColor(FORMS_EStyle.Disabled);
		else
			_color = FORMS_GetColor(FORMS_EStyle.Text);

		FORMS_DrawTextPart(_textX, _textY, _drawValue, _maxCharCount * FORMS_FONT_WIDTH, _color);
	}

	////////////////////////////////////////////////////////////////////////////
	//
	// Input logic
	//
	if (mouse_check_button_pressed(mb_left)
		|| mouse_check_button_pressed(mb_right))
	{
		// Select input
		if (_mouseOver && !_disabled)
		{
			if (FORMS_INPUT_ACTIVE == undefined)
			{
				_active = true;
				FORMS_CONTROL_STATE = FORMS_EControlState.Input;
				FORMS_INPUT_ACTIVE = _id;
				FORMS_INPUT_PARENT = _parent;
				FORMS_INPUT_STRING = _value;
				FORMS_INPUT_INDEX_DRAW_START = 1;
				FORMS_INPUT_INDEX_FROM = 1;
				FORMS_INPUT_INDEX_TO = 1;
				keyboard_string = "";
			}
		}
		else if (_active
			&& (!FORMS_WidgetExists(FORMS_CONTEXT_MENU)
			|| (FORMS_CONTEXT_MENU != undefined
			&& !FORMS_CONTEXT_MENU.IsAncestor(FORMS_WIDGET_HOVERED))))
		{
			// Return value when clicked outside of the input
			FORMS_CONTROL_STATE = FORMS_EControlState.Default;
			FORMS_INPUT_ACTIVE = undefined;
			if (FORMS_WidgetExists(_parent))
				FORMS_RequestRedraw(_parent);
			if (_type)
				return real(_value);
			return _value;
		}
	}

	if (_active)
	{
		// Select text
		if (mouse_check_button(mb_left) /*&& _mouseOver*/)
		{
			var _index = clamp(round((FORMS_MOUSE_X - _xStart - _padding) / FORMS_FONT_WIDTH) + FORMS_INPUT_INDEX_DRAW_START, 1, _stringLength + 1);
			if (mouse_check_button_pressed(mb_left))
			{
				FORMS_INPUT_INDEX_FROM = _index;
			}
			FORMS_INPUT_INDEX_TO = _index;
		}
		else if (mouse_check_button_pressed(mb_right) && _mouseOver)
		{
			// Open context menu
			var _contextMenu = new FORMS_ContextMenu();
			PEd_GUIMenuInput(_contextMenu);
			FORMS_ShowContextMenu(_contextMenu);

			// TODO: Select word in input on double click
		}

		if (keyboard_check_pressed(vk_enter))
		{
			// Return value when enter is pressed
			FORMS_CONTROL_STATE = FORMS_EControlState.Default;
			FORMS_INPUT_ACTIVE = undefined;
			if (FORMS_WidgetExists(_parent))
				FORMS_RequestRedraw(_parent);
			if (_type)
				return real(_value);
			return _value;
		}
		else if (keyboard_check_pressed(vk_escape))
		{
			// Return original value
			FORMS_CONTROL_STATE = FORMS_EControlState.Default;
			FORMS_INPUT_ACTIVE = undefined;
			return argument[3];
		}
	}

	return undefined;
}

/// @func FORMS_InputCopy()
///
/// @desc Copies selected part of text of currently active input
/// to the clipboard.
function FORMS_InputCopy()
{
	if (FORMS_INPUT_INDEX_FROM != FORMS_INPUT_INDEX_TO)
	{
		clipboard_set_text(string_copy(FORMS_INPUT_STRING,
			min(FORMS_INPUT_INDEX_FROM, FORMS_INPUT_INDEX_TO),
			abs(FORMS_INPUT_INDEX_FROM - FORMS_INPUT_INDEX_TO)));
	}
}

/// @func FORMS_InputCut()
///
/// @desc Cuts selected part of text in currently active input.
function FORMS_InputCut()
{
	if (FORMS_INPUT_INDEX_FROM != FORMS_INPUT_INDEX_TO)
	{
		clipboard_set_text(string_copy(FORMS_INPUT_STRING,
			min(FORMS_INPUT_INDEX_FROM, FORMS_INPUT_INDEX_TO),
			abs(FORMS_INPUT_INDEX_FROM - FORMS_INPUT_INDEX_TO)));
		FORMS_InputDeleteSelectedPart();
	}
}

/// @func FORMS_InputDelete()
///
/// @desc Deletes selected part of text in currently active input.
function FORMS_InputDelete()
{
	if (FORMS_INPUT_INDEX_FROM != FORMS_INPUT_INDEX_TO)
	{
		FORMS_InputDeleteSelectedPart();
	}
}

/// @func FORMS_InputDeleteSelectedPart()
///
/// @desc Deletes selected part of input text.
function FORMS_InputDeleteSelectedPart()
{
	var _minIndex = min(FORMS_INPUT_INDEX_FROM, FORMS_INPUT_INDEX_TO);
	FORMS_INPUT_STRING = string_delete(FORMS_INPUT_STRING,
		_minIndex,
		abs(FORMS_INPUT_INDEX_FROM - FORMS_INPUT_INDEX_TO));
	FORMS_INPUT_INDEX_FROM = _minIndex;
	FORMS_INPUT_INDEX_TO = _minIndex;
}

/// @func FORMS_InputPaste()
///
/// @desc Pastes text from the clipboard to currently active input.
function FORMS_InputPaste()
{
	if (clipboard_has_text())
	{
		// Delete selected part
		if (FORMS_INPUT_INDEX_FROM != FORMS_INPUT_INDEX_TO)
		{
			FORMS_InputDeleteSelectedPart();
		}

		// Insert string
		FORMS_INPUT_STRING = string_insert(clipboard_get_text(),
			FORMS_INPUT_STRING,
			FORMS_INPUT_INDEX_FROM);
		FORMS_INPUT_INDEX_FROM += string_length(clipboard_get_text());
		FORMS_INPUT_INDEX_TO = FORMS_INPUT_INDEX_FROM;
	}
}

/// @func FORMS_InputSelectAll()
///
/// @desc Selects all text in currently active input.
function FORMS_InputSelectAll()
{
	var _strlen = string_length(FORMS_INPUT_STRING);
	FORMS_INPUT_INDEX_FROM = 1;
	FORMS_INPUT_INDEX_TO = _strlen + 1;
}
