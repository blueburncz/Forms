/// @func ce_color_alpha_to_argb(_color, _alpha)
/// @desc Converts the color and aplha into a ARGB color.
/// @param {real} _color The color.
/// @param {real} _alpha The alpha.
/// @return {real} The ARGB color.
function ce_color_alpha_to_argb(_color, _alpha)
{
	gml_pragma("forceinline");
	return ce_color_rgb_to_bgr(_color) | ((_alpha * 255) << 24);
}

/// @func ce_color_argb_to_alpha(_argb)
/// @desc Converts ARGB color to alpha.
/// @param {real} _argb The ARGB color.
/// @return {real} The alpha.
function ce_color_argb_to_alpha(_argb)
{
	gml_pragma("forceinline");
	return (((_argb & $FF000000) >> 24) / 255);
}

/// @func ce_color_from_argb(_argb)
/// @desc Converts ARGB color to BGR color.
/// @param {real} _argb The ARGB color.
/// @return {real} The BGR color.
function ce_color_from_argb(_argb)
{
	gml_pragma("forceinline");
	return ce_color_rgb_to_bgr(_argb & $FFFFFF);
}

/// @func ce_color_invert(_color)
/// @desc Inverts the color.
/// @param {real} _color The color to invert.
/// @return {real} The inverted color.
function ce_color_invert(_color)
{
	gml_pragma("forceinline");
	return make_color_rgb(
		255 - color_get_red(_color),
		255 - color_get_green(_color),
		255 - color_get_blue(_color));
}

/// @func ce_color_rgb_to_bgr(_color)
/// @desc Converts between RGB and BGR color format.
/// @param {real} _color The BGR or RGB color.
/// @return {real} The resulting color.
function ce_color_rgb_to_bgr(_color)
{
	gml_pragma("forceinline");
	return ((_color & $FF0000) >> 16)
		| (_color & $FF00)
		| ((_color & $FF) << 16);
}