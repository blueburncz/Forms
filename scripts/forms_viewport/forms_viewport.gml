function FORMS_Viewport() {}

/// @func forms_viewport_create(_title[, _surface])
/// @desc Creates a new viewport.
/// @param {string} _title The viewport title.
/// @param {surface} [_surface] The viewport surface. A new one will be created
/// if not defined.
/// @return {real} The id of the created viewport.
function forms_viewport_create(_title)
{
	var _viewport = forms_widgetset_create(FORMS_Viewport);
	_viewport[? "scr_draw"] = forms_viewport_draw;
	_viewport[? "draw_overlay"] = undefined;
	_viewport[? "viewport_surface"] = (argument_count > 1) ? argument[1] : noone;
	_viewport[? "viewport_scale"] = 1;
	_viewport[? "viewport_x"] = 0;
	_viewport[? "viewport_y"] = 0;
	_viewport[? "viewport_width"] = 1;
	_viewport[? "viewport_height"] = 1;

	var _titlebar = forms_titlebar_create(_title, FORMS_EIcon.VideoCamera);
	_viewport[? "titlebar"] = _titlebar;
	forms_add_item(_viewport, _titlebar);

	return _viewport;
}

/// @func forms_viewport_get_titlebar(_viewport)
/// @desc Gets the title bar of the viewport.
/// @param {real} _viewport The id of the viewport.
/// @return {real} The title bar of the viewport.
function forms_viewport_get_titlebar(_viewport)
{
	gml_pragma("forceinline");
	return _viewport[? "titlebar"];
}

/// @func forms_viewport_draw(_viewport)
/// @desc Draws the viewport.
/// @param {real} _viewport The id of the viewport.
function forms_viewport_draw(_viewport)
{
	var _x = forms_widget_get_x(_viewport);
	var _y = forms_widget_get_y(_viewport);
	var _width = forms_widget_get_width(_viewport);
	var _height = forms_widget_get_height(_viewport);
	var _aa = _viewport[? "viewport_scale"];

	// Draw title bar
	var _titlebar = forms_viewport_get_titlebar(_viewport);
	forms_widget_set_width(_titlebar, _width);
	forms_draw_item(_titlebar);
	var _titlebar_height = clamp(forms_line_height, 1, _height - 1);
	forms_widget_set_height(_titlebar, _titlebar_height);

	// Draw border
	_y += _titlebar_height;
	_height = max(_height - _titlebar_height, 2);

	var _color_border = FORMS_C_WINDOW_BORDER;
	ce_draw_rectangle(_x, _y, _width, _height, _color_border);

	_x += 1;
	_width = max(_width - 2, 1);
	_height -= 1;

	// Save viewport position
	var _pos = matrix_transform_vertex(matrix_get(matrix_world), _x, _y, 0);
	var _viewport_x = _pos[0];
	var _viewport_y = _pos[1];
	_viewport[? "viewport_x"] = _viewport_x;
	_viewport[? "viewport_y"] = _viewport_y;
	_viewport[? "viewport_width"] = _width;
	_viewport[? "viewport_height"] = _height;

	// Draw viewport
	var _viewport_width = _width * _aa;
	var _viewport_height = _height * _aa;
	var _viewport_surface = ce_surface_check(_viewport[? "viewport_surface"], _viewport_width, _viewport_height);

	gpu_push_state();
	gpu_set_colorwriteenable(1, 1, 1, 0);
	gpu_set_tex_filter(true);
	draw_surface_stretched(_viewport_surface, _x, _y, _width, _height);
	gpu_pop_state();

	_viewport[? "viewport_surface"] = _viewport_surface;

	// Draw overlay
	forms_matrix_push(_x, _y);
	var _overlay = _viewport[? "draw_overlay"];
	if (_overlay != undefined)
	{
		_overlay(_viewport);
	}
	forms_matrix_restore();
}