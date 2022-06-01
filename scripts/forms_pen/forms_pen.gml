enum FORMS_EPen
{
	X,
	Y,
	MarginH,
	MarginV,
	LineHeight,
	StartX,
	StartY,
	MaxX,
	MaxY,
	SIZE
};

/// @func forms_pen_create([x[, y]])
/// @param {real} [x]
/// @param {real} [y]
/// @return {array}
function forms_pen_create()
{
	var _x = (argument_count > 0) ? argument[0] : 0;
	var _y = (argument_count > 1) ? argument[1] : 0;
	var _pen = array_create(FORMS_EPen.SIZE, 0);
	_pen[@ FORMS_EPen.X] = _x;
	_pen[@ FORMS_EPen.Y] = _y;
	_pen[@ FORMS_EPen.MarginH] = 0;
	_pen[@ FORMS_EPen.MarginV] = 4;
	_pen[@ FORMS_EPen.LineHeight] = forms_line_height;
	_pen[@ FORMS_EPen.StartX] = _x;
	_pen[@ FORMS_EPen.StartY] = _y;
	_pen[@ FORMS_EPen.MaxX] = _x;
	_pen[@ FORMS_EPen.MaxY] = _y;
	return _pen;
}

/// @func forms_pen_clone(_pen)
/// @param {array} _pen
/// @return {array}
function forms_pen_clone(_pen)
{
	var _clone = array_create(FORMS_EPen.SIZE, 0);
	array_copy(_clone, 0, _pen, 0, FORMS_EPen.SIZE);
	return _clone;
}

/// @func forms_pen_get_margin(pen)
/// @param {array} pen
/// @return {array}
function forms_pen_get_margin(pen)
{
	gml_pragma("forceinline");
	return [pen[FORMS_EPen.MarginH], pen[FORMS_EPen.MarginV]];
}

/// @func forms_pen_get_marginh(pen)
/// @param {array} pen
/// @return {real}
function forms_pen_get_marginh(pen)
{
	gml_pragma("forceinline");
	return pen[FORMS_EPen.MarginH];
}

/// @func forms_pen_get_marginv(pen)
/// @param {array} pen
/// @return {real}
function forms_pen_get_marginv(pen)
{
	gml_pragma("forceinline");
	return pen[FORMS_EPen.MarginV];
}

/// @func forms_pen_get_x(pen)
/// @param {array} pen
/// @return {real}
function forms_pen_get_x(pen)
{
	gml_pragma("forceinline");
	return round(pen[FORMS_EPen.X]);
}

/// @func forms_pen_get_x_center(pen, width_outer, width_inner)
/// @param {array} pen
/// @param {real} real
/// @param {real} real
/// @return {real}
function forms_pen_get_x_center(pen, width_outer, width_inner)
{
	gml_pragma("forceinline");
	return round(pen[FORMS_EPen.X] + (width_outer - width_inner) * 0.5);
}

/// @func forms_pen_get_y(pen)
/// @param {array} pen
/// @return {real}
function forms_pen_get_y(pen)
{
	gml_pragma("forceinline");
	return round(pen[FORMS_EPen.Y]);
}

/// @func forms_pen_get_y_inline(pen, height)
/// @param {array} pen
/// @param {real} height
/// @return {real}
function forms_pen_get_y_inline(pen, height)
{
	gml_pragma("forceinline");
	return round(pen[FORMS_EPen.Y] + (pen[FORMS_EPen.LineHeight] - height) * 0.5);
}

/// @func forms_pen_get_max_coordinates(_pen)
/// @param {array} _pen
/// @return {real[]}
function forms_pen_get_max_coordinates(_pen)
{
	gml_pragma("forceinline");
	return [
		_pen[FORMS_EPen.MaxX],
		_pen[FORMS_EPen.MaxY],
	];
}

/// @func forms_pen_move(_pen, _x[, _y])
/// @param {array} _pen
/// @param {real} _x
/// @param {real} [_y]
function forms_pen_move(_pen, _x)
{
	if (_x != 0)
	{
		_pen[@ FORMS_EPen.X] += _x + _pen[FORMS_EPen.MarginH];
		_pen[@ FORMS_EPen.MaxX] = max(_pen[FORMS_EPen.MaxX], _pen[FORMS_EPen.X]);
	}
	if (argument_count > 2)
	{
		_pen[@ FORMS_EPen.Y] += argument[2] + _pen[FORMS_EPen.MarginV];
		_pen[@ FORMS_EPen.MaxY] = max(_pen[FORMS_EPen.MaxY], _pen[FORMS_EPen.Y]);
	}
}

/// @func forms_pen_newline(pen)
/// @param {FORMS_EPen} pen
/// @param {int} [count]
function forms_pen_newline(pen)
{
	gml_pragma("forceinline");
	pen[@ FORMS_EPen.Y] += (pen[FORMS_EPen.LineHeight] + pen[FORMS_EPen.MarginV])
		* ((argument_count > 1) ? argument[1] : 1);
	pen[@ FORMS_EPen.X] = pen[FORMS_EPen.StartX];
	pen[@ FORMS_EPen.MaxX] = max(pen[FORMS_EPen.MaxX], pen[FORMS_EPen.X]);
	pen[@ FORMS_EPen.MaxY] = max(pen[FORMS_EPen.MaxY], pen[FORMS_EPen.Y]);
}

/// @func forms_pen_set_margin(_pen, _h[, _v])
/// @param {array} _pen
/// @param {real} _h
/// @param {real} [_v]
function forms_pen_set_margin(_pen, _h)
{
	gml_pragma("forceinline");
	_pen[@ FORMS_EPen.MarginH] = _h;
	_pen[@ FORMS_EPen.MarginV] = (argument_count > 2) ? argument[2] : argument[1];
}

/// @func forms_pen_set_marginh(pen, margin)
/// @param {array} pen
/// @param {real} margin
function forms_pen_set_marginh(pen, margin)
{
	gml_pragma("forceinline");
	pen[@ FORMS_EPen.MarginH] = margin;
}

/// @func forms_pen_set_marginv(pen, margin)
/// @param {array} pen
/// @param {real} margin
function forms_pen_set_marginv(pen, margin)
{
	gml_pragma("forceinline");
	pen[@ FORMS_EPen.MarginV] = margin;
}

/// @func forms_pen_set_x(_pen, _x)
/// @param {array} _pen
/// @param {real} _x
function forms_pen_set_x(_pen, _x)
{
	gml_pragma("forceinline");
	_pen[@ FORMS_EPen.X] = _x;
	_pen[@ FORMS_EPen.MaxX] = max(_pen[FORMS_EPen.MaxX], _x);
}

/// @func forms_pen_set_y(_pen, _y)
/// @param {array} _pen
/// @param {real} _y
function forms_pen_set_y(_pen, _y)
{
	gml_pragma("forceinline");
	_pen[@ FORMS_EPen.Y] = _y;
	_pen[@ FORMS_EPen.MaxY] = max(_pen[FORMS_EPen.MaxY], _y);
}