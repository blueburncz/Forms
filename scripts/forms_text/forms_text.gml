/// @func forms_text(_pen, _text[, _props])
/// @desc Draws a text.
/// @param {FORMS_EPen} _pen
/// @param {string} _text
/// @param {struct} [_props]
function forms_text(_pen, _text)
{
	var _props = (argument_count > 2) ? argument[2] : {};

	var _tooltip = ce_struct_get(_props, "tooltip", "");
	var _argb = ce_struct_get(_props, "color", ce_color_alpha_to_argb(FORMS_C_TEXT, 1));
	var _argb_shadow = ce_struct_get(_props, "shadow", 0);
	var _font = ce_struct_get(_props, "font", FORMS_FntNormal);
	var _wrap = ce_struct_get(_props, "wrap", 0);

	var _color = ce_color_from_argb(_argb);
	var _alpha = ce_color_argb_to_alpha(_argb);

	var _font_old = draw_get_font();
	forms_set_font(_font);

	var _x = forms_pen_get_x(_pen);
	var _y = forms_pen_get_y_inline(_pen, forms_font_height);

	if (_wrap <= 0)
	{
		var _width = string_width(_text);
		var _height = string_height(_text);
		if (_argb_shadow > 0)
		{
			var _color_shadow = ce_color_from_argb(_argb_shadow);
			var _alpha_shadow = ce_color_argb_to_alpha(_argb_shadow);
			draw_text_color(_x + 1, _y + 1, _text, _color_shadow, _color_shadow, _color_shadow, _color_shadow, _alpha_shadow);
		}
		draw_text_color(_x, _y, _text, _color, _color, _color, _color, _alpha);
		forms_pen_move(_pen, _width);
	}
	else
	{
		var _width = string_width_ext(_text, forms_line_height, _wrap);
		var _height = string_height_ext(_text, forms_line_height, _wrap);
		if (_argb_shadow > 0)
		{
			var _color_shadow = ce_color_from_argb(_argb_shadow);
			var _alpha_shadow = ce_color_argb_to_alpha(_argb_shadow);
			draw_text_ext_color(_x + 1, _y + 1, _text, forms_line_height, _wrap, _color_shadow, _color_shadow, _color_shadow, _color_shadow, _alpha_shadow);
		}
		draw_text_ext_color(_x, _y, _text, forms_line_height, _wrap, _color, _color, _color, _color, _alpha);
		forms_pen_move(_pen, _width, _height - forms_line_height);
	}

	forms_set_font(_font_old);

	if (_tooltip != "" && forms_mouse_over_rectangle(_x, _y, _width, _height))
	{
		forms_tooltip_str = _tooltip;
	}
}

/// @func forms_draw_text(pen, text[, color[, alpha]])
/// @param {array} pen A pen structure.
/// @param {string} text A text to draw.
/// @param {real} [color] The color of the text. Defaults to `FORMS_C_TEXT`.
/// @param {real} [alpha] The alpha of the text. Defaults to 1.
/// @see FORMS_EPen
function forms_draw_text(_pen, _text)
{
	var _color = (argument_count > 2) ? argument[2] : FORMS_C_TEXT;
	var _alpha = (argument_count > 3) ? argument[3] : 1;

	draw_text_color(forms_pen_get_x(_pen), forms_pen_get_y_inline(_pen, forms_font_height),
		_text, _color, _color, _color, _color, _alpha);

	forms_pen_move(_pen, string_width(_text));
}

/// @func forms_draw_text_bold(pen, text[, color[, alpha]])
/// @desc Draws a bold text.
/// @param {array} pen A Pen structure.
/// @param {string} text The text to draw.
/// @param {real} [color] The color of the text. Defaults to `FORMS_C_TEXT`.
/// @param {real} [alpha] The alpha of the text. Defaults to 1.
/// @note This sets the font to bold and resets it back to normal after rendering
/// the text!
/// @see FORMS_EPen
function forms_draw_text_bold(pen, text)
{
	gml_pragma("forceinline");
	var _fnt = draw_get_font();
	draw_set_font(FORMS_FntBold);
	forms_draw_text(pen, text,
		(argument_count > 2) ? argument[2] : FORMS_C_TEXT,
		(argument_count > 3) ? argument[3] : 1);
	draw_set_font(_fnt);
}

/// @func forms_draw_text_part(_pen, _text, _max_width[, _color[, _ellipsis]])
/// @desc Draws the part of the text which fits the `max_width`.
/// @param {array} _pen A pen structure.
/// @param {string} _text The text to draw.
/// @param {real} _max_width The maximum width of the text in pixels. If the text
/// is longer than this value, then it is clipped.
/// @param {real} [_color] The color of the text. Defaults to `FORMS_C_TEXT`.
/// @param {bool} [_ellipsis] If `true`, then a clipped text will be followed by
/// "...". Defaults to `false`.
/// @see FORMS_EPen
function forms_draw_text_part(_pen, _text, _max_width)
{
	var _color = (argument_count > 3) ? argument[3] : FORMS_C_TEXT;
	var _ellipsis = (argument_count > 4) ? argument[4] : false;

	var _width = 0;
	var _shortened = false;
	var _index = 1;

	repeat (string_length(_text))
	{
		var _char_width = string_width(string_char_at(_text, _index));
		if (_width + _char_width <= _max_width)
		{
			_width += _char_width;
			++_index;
		}
		else
		{
			_shortened = true;
			break;
		}
	}

	var _display_text = (_shortened && _ellipsis)
		? (string_copy(_text, 1, _index - 4) + "...")
		: string_copy(_text, 1, _index - 1);

	forms_draw_text(_pen, _display_text, _color);
}

/// @func forms_draw_text_shadow(x, y, text, color_text, color_shadow)
/// @desc Draws text with shadow at the given position.
/// @param {real} _x The x position to draw the text at.
/// @param {real} _y The y position to draw the text at.
/// @param {string} _text The text to draw.
/// @param {real} _color_text The color of the text.
/// @param {real} _color_shadow The color of the shadow.
function forms_draw_text_shadow(_x, _y, _text, _color_text, _color_shadow)
{
	gml_pragma("forceinline");
	draw_text_color(_x + 1, _y + 1, _text, _color_shadow, _color_shadow, _color_shadow, _color_shadow, 1);
	draw_text_color(_x, _y, _text, _color_text, _color_text, _color_text, _color_text, 1);
}