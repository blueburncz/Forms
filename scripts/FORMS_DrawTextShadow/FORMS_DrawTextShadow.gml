/// @func FORMS_DrawTextShadow(_x, _y, _text, _colourText, _colourShadow)
///
/// @desc Draws text with shadow at the given position.
///
/// @param {Real} _x The x position to draw the text at.
/// @param {Real} _y The y position to draw the text at.
/// @param {String} _text The text to draw.
/// @param {Real} _colourText The color of the text.
/// @param {Real} _colourShadow The color of the shadow.
function FORMS_DrawTextShadow(_x, _y, _text, _colourText, _colourShadow)
{
	gml_pragma("forceinline");
	draw_text_colour(_x + 1, _y + 1, _text, _colourShadow, _colourShadow, _colourShadow, _colourShadow, 1);
	draw_text_colour(_x, _y, _text, _colourText, _colourText, _colourText, _colourText, 1);
}
