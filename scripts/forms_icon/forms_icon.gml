/// @func forms_icon(_pen, _icon[, _props])
/// @desc Draws an icon.
/// @param {array} _pen A pen structure.
/// @param {FORMS_EIcon} _icon The icon to draw.
/// @param {struct} [_props]
/// @see FORMS_EPen
function forms_icon(_pen, _icon)
{
	var _props = (argument_count > 2) ? argument[2] : {};

	var _size = ce_struct_get(_props, "size", FORMS_ICON_SIZE);
	var _argb = ce_struct_get(_props, "color", $FFFFFFFF);
	var _color = ce_color_from_argb(_argb);
	var _alpha = ce_color_argb_to_alpha(_argb);

	var _x = forms_pen_get_x(_pen);
	var _y = forms_pen_get_y_inline(_pen, _size);

	draw_sprite_stretched_ext(FORMS_SprIcons, _icon, _x, _y, _size + 5, _size + 5, _color, _alpha);
	forms_pen_move(_pen, _size);

	if (forms_mouse_over_rectangle(_x, _y, _size, _size))
	{
		var _tooltip = ce_struct_get(_props, "tooltip", "");
		if (_tooltip != "")
		{
			forms_tooltip_str = _tooltip;
		}
	}
}

/// @func forms_draw_icon(_pen, _icon[, _size[, _color[, _alpha]]])
/// @desc Draws an icon.
/// @param {array} _pen A pen structure.
/// @param {FORMS_EIcon} _icon The icon to draw.
/// @param {real} [_size] The size of the icon. Defaults to `FORMS_ICON_SIZE`.
/// @param {real} [_color] The color of the icon. Defaults to `FORMS_C_TEXT`.
/// @param {real} [_alpha] The alpha of the icon. Defaults to 1.
/// @return {bool} True if mouse cursor is over the icon.
/// @see FORMS_EPen
function forms_draw_icon(_pen, _icon)
{
	var _size = (argument_count > 2) ? argument[2] : undefined;
	if (_size == undefined)
	{
		_size = FORMS_ICON_SIZE;
	}
	var _color = (argument_count > 3) ? argument[3] : FORMS_C_TEXT;
	var _alpha = (argument_count > 4) ? argument[4] : 1;

	var _x = forms_pen_get_x(_pen);
	var _y = forms_pen_get_y_inline(_pen, _size);

	draw_sprite_stretched_ext(FORMS_SprIcons, _icon, _x, _y, _size + 5, _size + 5, _color, _alpha);
	forms_pen_move(_pen, _size);

	return forms_mouse_over_rectangle(_x, _y, _size, _size);
}