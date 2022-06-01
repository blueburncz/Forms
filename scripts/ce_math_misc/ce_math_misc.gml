/// @func ce_hammersley_2d(_i, _n)
/// @desc Gets i-th point from sequence of uniformly distributed points on a
/// unit square.
/// @param {real} _i The point index in sequence.
/// @param {real} _n The total size of the sequence.
/// @source http://holger.dammertz.org/stuff/notes__hammersley_on_hemisphere.html
function ce_hammersley_2d(_i, _n)
{
	var b = (_n << 16) | (_n >> 16);
	b = ((b & 0x55555555) << 1) | ((b & 0xAAAAAAAA) >> 1);
	b = ((b & 0x33333333) << 2) | ((b & 0xCCCCCCCC) >> 2);
	b = ((b & 0x0F0F0F0F) << 4) | ((b & 0xF0F0F0F0) >> 4);
	b = ((b & 0x00FF00FF) << 8) | ((b & 0xFF00FF00) >> 8);
	return [
		_i / _n,
		b * 2.3283064365386963 * 0.0000000001
	];
}

/// @func ce_point_in_rect(_point_x, _point_y, _rect_x, _rect_y, _rect_width, _rect_height)
/// @param {real} _point_x The x position of the point.
/// @param {real} _point_y The y position of the point.
/// @param {real} _rect_x The x position of the rectangle's top left corner.
/// @param {real} _rect_y The y position of the rectangle's top left corner.
/// @param {real} _rect_width The width of the rectangle.
/// @param {real} _rect_height The height of the rectangle.
/// @return {bool} `true` if the point is in the rectangle.
function ce_point_in_rect(_point_x, _point_y, _rect_x, _rect_y, _rect_width, _rect_height)
{
	gml_pragma("forceinline");
	return (_point_x > _rect_x
		&& _point_y > _rect_y
		&& _point_x < _rect_x + _rect_width
		&& _point_y < _rect_y + _rect_height);
}

/// @func ce_scale_keep_aspect(_target_w, _target_h, _width, _height)
/// @param {real} _target_w The target width.
/// @param {real} _target_h The target height.
/// @param {real} _width The original width.
/// @param {real} _height The original height.
/// @return {real} The scale.
function ce_scale_keep_aspect(_target_w, _target_h, _width, _height)
{
	var _prev_aspect = _target_w / _target_h;
	var _img_aspect = _width / _height;
	if (_prev_aspect > _img_aspect)
	{
		return _target_h / _height;
	}
	return _target_w / _width;
}

/// @func ce_smoothstep(_e0, _e1, _x)
/// @desc Performs smooth Hermite interpolation between 0 and 1 when
/// e0 < x < e1.
/// @param {real} _e0 The lower edge of the Hermite function.
/// @param {real} _e1 The upper edge of the Hermite function.
/// @param {real} _x The source value for interpolation.
/// @return {real} The resulting interpolated value.
/// @source https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/smoothstep.xhtml
function ce_smoothstep(_e0, _e1, _x)
{
	var _t = clamp((_x - _e0) / (_e1 - _e0), 0, 1);
	return (_t * _t * (3 - 2 * _t));
}

/// @func ce_snap(_value, _step)
/// @desc Floors value to multiples of step using formula
/// `floor(value / step) * step`.
/// @param {real} _value The value.
/// @param {real} _step The step.
/// @return {real} The resulting value.
/// @example
/// ```gml
/// ce_snap(3.8, 2); // => 2
/// ce_snap(4.2, 2); // => 4
/// ```
function ce_snap(_value, _step)
{
	gml_pragma("forceinline");
	return floor(_value / _step) * _step;
}

/// @func ce_wrap(_number, _min, _max)
/// @desc Wraps number between values min and max.
/// @param {real} _number The number to wrap.
/// @param {real} _min The minimal value.
/// @param {real} _max The maximal value.
/// @return {real} The wrapped number.
function ce_wrap(_number, _min, _max)
{
	gml_pragma("forceinline");
	if (_number > _max)
	{
		return _number % _max;
	}
	if (_number < _min)
	{
		return _number % _max + _max;
	}
	return _number;
}

/// @func ce_wrap_angle(_angle)
/// @desc Wraps angle between values 0..360.
/// @param {real} angle The angle to wrap.
/// @return {real} The wrapped angle.
function ce_wrap_angle(_angle)
{
	gml_pragma("forceinline");
	return (_angle + ceil(-_angle / 360) * 360);
}