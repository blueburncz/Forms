function FORMS_Canvas() {}

/// @func forms_canvas_create([type])
/// @desc Creates a new canvas.
/// @param {real} [type] The canvas type.
/// @return {real} The id of the createed canvas.
function forms_canvas_create()
{
	var _type = (argument_count > 0) ? argument[0] : FORMS_Canvas;
	var _canvas = forms_widgetset_create(_type);
	forms_canvas_set_surface(_canvas, noone);
	forms_canvas_set_background(_canvas, FORMS_C_WINDOW_BACKGROUND);
	_canvas[? "scr_draw"] = forms_canvas_draw;
	_canvas[? "scr_cleanup"] = forms_canvas_cleanup;
	return _canvas;
}

/// @func forms_canvas_cleanup(canvas)
/// @desc Frees canvas resources from memory.
/// @param {real} canvas The id of the canvas.
function forms_canvas_cleanup(canvas)
{
	var _surface = canvas[? "surface"];
	if (surface_exists(_surface))
	{
		surface_free(_surface);
	}
	forms_widgetset_cleanup(canvas);
}

/// @func forms_canvas_draw(canvas)
/// @desc Draws the canvas.
/// @param {canvas} canvas The id of the canvas.
function forms_canvas_draw(canvas)
{
	var _surface = forms_canvas_get_surface(canvas);
	if (surface_exists(_surface))
	{
		draw_surface(
			_surface,
			forms_widget_get_x(canvas),
			forms_widget_get_y(canvas));
	}
}

/// @func forms_canvas_get_background(canvas)
/// @desc Gets the background color of the canvas.
/// @param {real} canvas The id of the canvas.
/// @return {real} The background color of the canvas.
function forms_canvas_get_background(canvas)
{
	gml_pragma("forceinline");
	return canvas[? "background"];
}

/// @func forms_canvas_get_surface(canvas)
/// @desc Gets the surface of the canvas.
/// @param {real} canvas The id of the canvas.
/// @return {real} The surface of the canvas.
function forms_canvas_get_surface(canvas)
{
	gml_pragma("forceinline");
	return canvas[? "surface"];
}

/// @func forms_canvas_set_background(canvas, background)
/// @desc Sets the background color of the canvas.
/// @param {real} canvas The id of the canvas.
/// @param {real} background The new background color.
function forms_canvas_set_background(canvas, background)
{
	gml_pragma("forceinline");
	canvas[? "background"] = background;
}

/// @func forms_canvas_set_surface(canvas, surface)
/// @desc Sets the surface of the canvas.
/// @param {real} canvas The id of the canvas.
/// @param {real} surface The id of the new surface.
function forms_canvas_set_surface(canvas, surface)
{
	gml_pragma("forceinline");
	canvas[? "surface"] = surface;
}

/// @func forms_begin_fill(_canvas)
/// @desc Sets the canvas surface as the render target.
/// @param {real} _canvas The id of the canvas.
/// @return {bool} True if the surface has been set as the render target.
function forms_begin_fill(_canvas)
{
	////////////////////////////////////////////////////////////////////////////////
	// Check surface
	var _surface = forms_canvas_get_surface(_canvas);
	var _width = max(forms_widget_get_width(_canvas), 1);
	var _height = max(forms_widget_get_height(_canvas), 1);

	if (surface_exists(_surface))
	{
		if (surface_get_width(_surface) != _width
			|| surface_get_height(_surface) != _height)
		{
			surface_resize(_surface, _width, _height);
			forms_request_redraw(_canvas);
		}
	}
	else
	{
		_surface = surface_create(_width, _height);
		forms_request_redraw(_canvas);
	}
	forms_canvas_set_surface(_canvas, _surface);

	////////////////////////////////////////////////////////////////////////////////
	// Start filling
	if (forms_widget_get_redraw(_canvas)
		&& !forms_widget_filling)
	{
		forms_widget_set_redraw(_canvas, false);
		var _scroll_x = 0;
		var _scroll_y = 0;
		var _scrollbar_hor = _canvas[? "scrollbar_hor"]
		var _scrollbar_ver = _canvas[? "scrollbar_ver"];
		if (!is_undefined(_scrollbar_hor))
		{
			_scroll_x = forms_scrollbar_get_scroll(_scrollbar_hor)
				* forms_scrollbar_is_visible(_scrollbar_hor);
		}
		if (!is_undefined(_scrollbar_ver))
		{
			_scroll_y = forms_scrollbar_get_scroll(_scrollbar_ver)
				* forms_scrollbar_is_visible(_scrollbar_ver);
		}
		surface_set_target(_surface);
		draw_clear(forms_canvas_get_background(_canvas));
		forms_matrix_set(-_scroll_x, -_scroll_y);
		forms_widget_filling = _canvas;
		forms_widget_id = 0;
		return true;
	}
	return false;
}

/// @func forms_end_fill(_canvas)
/// @desc Finishes drawing into the canvas and resets the render target.
/// @param {real} _canvas The id of the canvas.
function forms_end_fill(_canvas)
{
	if (forms_widget_filling == _canvas)
	{
		var _scroll_x = 0;
		var _scroll_y = 0;
		var _scrollbar_ver = _canvas[? "scrollbar_ver"];
		var _scrollbar_hor = _canvas[? "scrollbar_hor"];
		var _draw_ver = false;
		var _draw_hor = false;

		if (!is_undefined(_scrollbar_ver))
		{
			_draw_ver = forms_scrollbar_is_visible(_scrollbar_ver);
			_scroll_y = forms_scrollbar_get_scroll(_scrollbar_ver) * _draw_ver;
		}
		if (!is_undefined(_scrollbar_hor))
		{
			_draw_hor = forms_scrollbar_is_visible(_scrollbar_hor);
			_scroll_x = forms_scrollbar_get_scroll(_scrollbar_hor) * _draw_hor;
		}

		if (!is_undefined(_scrollbar_ver))
		{
			var _height = forms_widget_get_height(_canvas) - _draw_hor * forms_widget_get_height(_scrollbar_hor);
			forms_widget_set_height(_scrollbar_ver, _height);
			_scrollbar_ver[? "size"] = _height;
			forms_scrollbar_calc_jump_and_thumb_size(_scrollbar_ver);

			if (_draw_ver)
			{
				forms_draw_item(_scrollbar_ver, _scroll_x + forms_widget_get_width(_canvas) - forms_widget_get_width(_scrollbar_ver), _scroll_y);
			}
		}

		if (!is_undefined(_scrollbar_hor))
		{
			var _width = forms_widget_get_width(_canvas) - _draw_ver * forms_widget_get_width(_scrollbar_ver);
			forms_widget_set_width(_scrollbar_hor, _width);
			_scrollbar_hor[? "size"] = _width;
			forms_scrollbar_calc_jump_and_thumb_size(_scrollbar_hor);

			if (_draw_hor)
			{
				forms_draw_item(_scrollbar_hor, _scroll_x, _scroll_y + forms_widget_get_height(_canvas) - forms_widget_get_height(_scrollbar_hor));
			}
		}

		if (_draw_ver && _draw_hor)
		{
			var _size = 14;
			var _x = _scroll_x + forms_widget_get_width(_canvas) - _size;
			var _y = _scroll_y + forms_widget_get_height(_canvas) - _size;
			ce_draw_rectangle(_x, _y, _size, _size, c_black);
		}

		forms_matrix_restore();
		surface_reset_target();
		forms_widget_filling = noone;
	}
}