/// @func FORMS_DrawTextBold(_x, _y, _text)
///
/// @desc Draws bold text at the given position.
///
/// @param {Real} _x The x position to draw the text at.
/// @param {Real} _y The y position to draw the text at.
/// @param {String} _text The text to draw.
///
/// @note The sets the font to bold and resets it back to normal
/// right after rendering the text.
function FORMS_DrawTextBold(_x, _y, _text)
{
	gml_pragma("forceinline");
	var _font = draw_get_font();
	draw_set_font(FORMS_FONT_BOLD);
	draw_text(_x, _y, _text);
	draw_set_font(_font);
}
