/// @func FORMS_DrawListItem(_name, _x, _y, _active, _disabled[, _highlight])
///
/// @desc Draws a list item on the given position.
///
/// @param {String} _name The item name.
/// @param {Real} _x The x position to draw the item at.
/// @param {Real} _y The y position to draw the item at.
/// @param {Bool} _active True if the item is currently selected.
/// @param {Bool} _disabled True to disable clicking on the item.
/// @param {Bool} [_highlight] True to highlight the item.
///
/// @return {Real} If the item is clicked, then 1 is returned.
/// If the mouse cursor is currently over the item, then -1 is returned.
/// In all other cases returns 0.
function FORMS_DrawListItem(_name, _x, _y, _active, _disabled, _highlight=false)
{
	var _container = FORMS_WIDGET_FILLING;
	var _containerWidth = _container.Width;
	var _text = string(_name);

	// Check mouse over
	var _mouseOver = (_container.IsHovered()
		&& FORMS_MOUSE_Y > _y
		&& FORMS_MOUSE_Y < _y + FORMS_LINE_HEIGHT);

	// Draw
	var _textColour = FORMS_GetColor(FORMS_EStyle.Text);
	var _backgroundColour = undefined;

	if (_active)
	{
		_textColour = FORMS_GetColor(FORMS_EStyle.TextSelected);
		_backgroundColour = FORMS_GetColor(FORMS_EStyle.Active);
	}
	else if (!_disabled)
	{
		if (_highlight
			|| _mouseOver)
		{
			_backgroundColour = FORMS_GetColor(FORMS_EStyle.Highlight);
		}
	}
	else
	{
		_textColour = FORMS_GetColor(FORMS_EStyle.Disabled);
	}

	if (_backgroundColour != undefined)
	{
		FORMS_DrawRectangle(0, _y, _containerWidth, FORMS_LINE_HEIGHT, _backgroundColour);
	}
	if (_textColour != FORMS_GetColor(FORMS_EStyle.Text))
	{
		draw_text_colour(_x, _y + round((FORMS_LINE_HEIGHT - FORMS_FONT_HEIGHT) * 0.5), _text,
			_textColour, _textColour, _textColour, _textColour, 1);
	}
	else
	{
		draw_text(_x, _y + round((FORMS_LINE_HEIGHT - FORMS_FONT_HEIGHT) * 0.5), _text);
	}

	// Click
	if (!_disabled
		&& _mouseOver)
	{
		if (mouse_check_button_pressed(mb_left))
		{
			return 1;
		}
		return -1;
	}
	return 0;
}
