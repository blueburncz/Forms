/// @func FORMS_DrawPopupMessage(_x, _y, _message)
///
/// @desc Draws a popup message at the given position.
///
/// @param {Real} _x The x position to draw popup the message at.
/// @param {Real} _y The y position to draw popup the message at.
/// @param {String} _message The text of the popup message.
function FORMS_DrawPopupMessage(_x, _y, _message)
{
	var _w = string_width(_message) + 128;
	var _h = string_height(_message) + 32;
	_x = _x - _w - 16;
	_y = _y - _h - 16;

	FORMS_DrawShadow(_x, _y, _w, _h, FORMS_GetColor(FORMS_EStyle.Shadow), FORMS_GetColor(FORMS_EStyle.ShadowAlpha));
	FORMS_DrawRectangle(_x, _y, _w, _h, FORMS_GetColor(FORMS_EStyle.WindowBorder));
	FORMS_DrawRectangle(_x + 1, _y + 1, _w - 2, _h - 2, FORMS_GetColor(FORMS_EStyle.WindowBackground));
	draw_sprite(FORMS_SprWarning, 0, _x + 16, _y + _h / 2);
	draw_text(_x + 96, _y + 16, _message);
}

/// @func FORMS_ShowPopupMessage(_text[, _ms])
///
/// @desc Shows the popup message.
///
/// @param {String} _text The text of the popup message.
/// @param {Real} [_ms] The duration of the popup message in ms. Defaults to 2000.
function FORMS_ShowPopupMessage(_text, _ms=2000)
{
	gml_pragma("forceinline");
	FORMS_POPUP_MESSAGE = _text;
	FORMS_POPUP_TIMER = current_time;
	FORMS_POPUP_DURATION = _ms;
}
