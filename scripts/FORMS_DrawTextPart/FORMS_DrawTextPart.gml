/// @func FORMS_DrawTextPart(_x, _y, _text, _maxWidth[, _color])
///
/// @desc Draws part of the text at the given position.
///
/// @param {Real} _x The x position to draw the text at.
/// @param {Real} _y The y position to draw the text at.
/// @param {String} _text The text to draw.
/// @param {Real} _maxWidth The maximum width of the text in pixels. If the text
/// is longer than this, then it is clipped and
/// followed by "...".
/// @param {Real} [_color] The color of the text. If not provided,
/// {@link FORMS_GetColor(FORMS_EStyle.Text)} is used.
function FORMS_DrawTextPart(_x, _y, _text, _maxWidth, _color=FORMS_GetColor(FORMS_EStyle.Text))
{
	var _maxCharCount = floor(_maxWidth/ FORMS_FONT_WIDTH);
	if (string_length(_text) > _maxCharCount)
	{
		var _textNew = string_copy(_text, 1, _maxCharCount);
		if (!FORMS_MOUSE_DISABLE
			&& FORMS_MOUSE_X > _x
			&& FORMS_MOUSE_Y > _y
			&& FORMS_MOUSE_X < _x + string_width(_textNew)
			&& FORMS_MOUSE_Y < _y + string_height(_textNew))
		{
			FORMS_TOOLTIP = _text;
		}
		_text = _textNew;
	}
	draw_text_colour(_x, _y, _text, _color, _color, _color, _color, 1);
}
