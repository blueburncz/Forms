function FORMS_Window() {}

/// @func forms_window_create(_title)
/// @desc Creates a new window.
/// @param {string} _title The window title.
/// @return {real} The id of the created window.
function forms_window_create(_title)
{
	var _window = forms_widgetset_create(FORMS_Window);
	var _titlebar = forms_container_create();
	var _container = forms_container_create();
	_window[? "titlebar"] = _titlebar;
	_titlebar[? "title"] = _title;
	_titlebar[? "height"] = forms_line_height;
	_titlebar[? "content"] = forms_cnt_titlebar_window;
	forms_canvas_set_background(_titlebar, FORMS_C_WINDOW_BORDER);
	_window[? "container"] = _container;
	forms_add_item(_window, _titlebar);
	forms_add_item(_window, _container);
	_window[? "scr_update"] = forms_window_update;
	_window[? "scr_draw"] = forms_window_draw;
	_window[? "closeable"] = true;
	_window[? "resizable"] = true;
	_window[? "resize"] = FORMS_EDirection.None;
	_window[? "drag"] = false;
	_window[? "mouse_offset_x"] = 0;
	_window[? "mouse_offset_y"] = 0;
	_window[? "border"] = 3;
	forms_widget_set_size(_window, 300, 200);
	forms_widget_set_depth(_window, $FFFFFD);
	//_window[? "scr_on_redraw"] = forms_window_on_redraw;
	return _window;
}

/// @func forms_window_draw(_window)
/// @desc Draws the window.
/// @param {real} _window The id of the window.
function forms_window_draw(_window)
{
	var _window_w = forms_widget_get_width(_window);
	var _window_h = forms_widget_get_height(_window);
	var _border = _window[? "border"];
	var _titlebar = forms_window_get_titlebar(_window);
	var _container = forms_window_get_container(_window);

	forms_matrix_push(forms_widget_get_x(_window), forms_widget_get_y(_window));

	// Shadow and border
	forms_draw_shadow(0, 0, _window_w, _window_h);
	var _selected_shape = forms_get_selected_widget();
	var _color_border = FORMS_C_WINDOW_BORDER;
	ce_draw_rectangle(0, 0, _window_w, _window_h, _color_border);

	// Title
	forms_widget_set_width(_titlebar, _window_w - _border * 2);
	forms_draw_item(_titlebar, _border, 0);
	var _titlebar_height = forms_container_get_content_height(_titlebar);
	forms_widget_set_height(_titlebar, _titlebar_height);

	// Content
	forms_widget_set_size(_container,
		_window_w - _border * 2,
		max(_window_h - _titlebar_height - _border, 1));
	forms_draw_item(_container, _border, _titlebar_height);

	forms_matrix_restore();

	forms_widget_set_height(_window, max(forms_widget_get_height(_window), _titlebar_height + _border));
}

/// @func forms_window_get_container(window)
/// @desc Gets the container of the window.
/// @param {real} window The id of the window.
/// @return {real} The container of the window.
function forms_window_get_container(window)
{
	gml_pragma("forceinline");
	return window[? "container"];
}

/// @func forms_window_get_content(window)
/// @desc Gets the content script of the window.
/// @param {real} window The id of the window.
/// @return {real} The content script of the window.
function forms_window_get_content(window)
{
	var _container = window[? "container"];
	return _container[? "content"];
}

/// @func forms_window_get_titlebar(window)
/// @desc Gets the title bar of the window.
/// @param {real} window The id of the window.
/// @return {real} The title bar of the window.
function forms_window_get_titlebar(window)
{
	gml_pragma("forceinline");
	return window[? "titlebar"];
}

/// @func forms_window_on_redraw(window)
/// @desc Request redraw of the window.
/// @param {real} window The id of the window.
function forms_window_on_redraw(window)
{
	forms_request_redraw_all(window[? "container"]);
	forms_request_redraw_all(window[? "titlebar"]);
}

/// @func forms_window_set_content(window, content)
/// @desc Sets content of the window.
/// @param {real} window The id of the window.
/// @param {real} content The new content script of the window.
function forms_window_set_content(window, content)
{
	var _container = window[? "container"];
	_container[? "content"] = content;
}

/// @func forms_window_update(_window)
/// @desc Updates the window.
/// @param {real} _window The id of the window.
function forms_window_update(_window)
{
	var _width = forms_widget_get_width(_window);
	var _height = forms_widget_get_height(_window);
	var _border = _window[? "border"];
	var _titlebar = forms_window_get_titlebar(_window);
	var _resize = _window[? "resize"];

	forms_widgetset_update(_window);

	if (mouse_check_button_pressed(mb_any)
		&& (forms_widget_is_hovered(_window)
		|| forms_widget_delegates_recursive(_window, forms_widget_hovered)))
	{
		forms_move_item_to_top(_window);

		////////////////////////////////////////////////////////////////////////////
		// FIXME Stupid hack :(
		forms_widget_selected = _window;
		forms_request_redraw_all(forms_root);
		////////////////////////////////////////////////////////////////////////////
	}

	var _titlebar_hovered_for_resize = (forms_widget_is_hovered(_titlebar)
		&& forms_mouse_y < _border);

	if (forms_widget_is_hovered(_titlebar)
		&& !_titlebar_hovered_for_resize)
	{
		// Start dragging
		if (mouse_check_button_pressed(mb_left)
			&& forms_mouse_x < _width - forms_line_height - _border)
		{
			_window[? "drag"] = true;
			_window[? "mouse_offset_x"] = forms_widget_get_x(_window) - forms_window_mouse_x;
			_window[? "mouse_offset_y"] = forms_widget_get_y(_window) - forms_window_mouse_y;
			forms_widget_active = _window;
		}
	}
	else if (_resize == FORMS_EDirection.None
		&& _window[? "resizable"]
		&& (forms_widget_is_hovered(_window)
		|| _titlebar_hovered_for_resize))
	{
		// Start resizing
		if (forms_mouse_x <= _border)
		{
			_resize |= FORMS_EDirection.Left;
		}
		else if (forms_mouse_x >= _width - _border)
		{
			_resize |= FORMS_EDirection.Right;
		}

		if (forms_mouse_y <= _border)
		{
			_resize |= FORMS_EDirection.Up;
		}
		else if (forms_mouse_y >= _height - _border)
		{
			_resize |= FORMS_EDirection.Down;
		}

		if (mouse_check_button_pressed(mb_left))
		{
			if (_resize & FORMS_EDirection.Left)
			{
				_window[? "mouse_offset_x"] = forms_window_mouse_x - forms_widget_get_x(_window);
			}
			else if (_resize & FORMS_EDirection.Right)
			{
				_window[? "mouse_offset_x"] = forms_widget_get_x(_window) + forms_widget_get_width(_window) - forms_window_mouse_x;
			}

			if (_resize & FORMS_EDirection.Up)
			{
				_window[? "mouse_offset_y"] = forms_window_mouse_y - forms_widget_get_y(_window);
			}
			else if (_resize & FORMS_EDirection.Down)
			{
				_window[? "mouse_offset_y"] = forms_widget_get_y(_window) + forms_widget_get_height(_window) - forms_window_mouse_y;
			}

			_window[? "resize"] = _resize;
			forms_widget_active = _window;
		}
	}

	if (_window[? "drag"])
	{
		////////////////////////////////////////////////////////////////////////////
		// Dragging
		forms_widget_set_position(_window,
			clamp(forms_window_mouse_x, 0, forms_window_width) + _window[? "mouse_offset_x"],
			clamp(forms_window_mouse_y, 0, forms_window_height) + _window[? "mouse_offset_y"]);
		if (!mouse_check_button(mb_left))
		{
			_window[? "drag"] = false;
			forms_widget_active = noone;
		}
	}

	if (_resize != FORMS_EDirection.None)
	{
		////////////////////////////////////////////////////////////////////////////
		// Resizing

		// Set cursor
		if ((_resize & FORMS_EDirection.Left
			&& _resize & FORMS_EDirection.Up)
			|| (_resize & FORMS_EDirection.Right
			&& _resize & FORMS_EDirection.Down))
		{
			forms_cursor = cr_size_nwse;
		}
		else if ((_resize & FORMS_EDirection.Left
			&& _resize & FORMS_EDirection.Down)
			|| (_resize & FORMS_EDirection.Right
			&& _resize & FORMS_EDirection.Up))
		{
			forms_cursor = cr_size_nesw;
		}
		else if (_resize & FORMS_EDirection.Horizontal)
		{
			forms_cursor = cr_size_we;
		}
		else if (_resize & FORMS_EDirection.Vertical)
		{
			forms_cursor = cr_size_ns;
		}

		// Set size
		if (forms_widget_active == _window)
		{
			var _min_width = 128 + _border * 2;
			if (_resize & FORMS_EDirection.Right)
			{
				forms_widget_set_width(_window, max(forms_mouse_x + _window[? "mouse_offset_x"], _min_width));
			}
			else if (_resize & FORMS_EDirection.Left)
			{
				var _width_old = forms_widget_get_width(_window);
				var _width_new = max(_width_old - forms_mouse_x + _window[? "mouse_offset_x"], _min_width);
				forms_widget_set_width(_window, _width_new);
				forms_widget_set_x(_window, forms_widget_get_x(_window) - (_width_new - _width_old));
			}

			var _min_height = forms_widget_get_height(_titlebar) + _border * 2;
			if (_resize & FORMS_EDirection.Down)
			{
				forms_widget_set_height(_window, max(forms_mouse_y + _window[? "mouse_offset_y"], _min_height));
			}
			else if (_resize & FORMS_EDirection.Up)
			{
				var _height_old = forms_widget_get_height(_window);
				var _height_new = max(_height_old - forms_mouse_y + _window[? "mouse_offset_y"], _min_height)
				forms_widget_set_height(_window, _height_new);
				forms_widget_set_y(_window, forms_widget_get_y(_window) - (_height_new - _height_old));
			}

			if (!mouse_check_button(mb_left))
			{
				_window[? "resize"] = FORMS_EDirection.None;
				forms_widget_active = noone;
			}
		}
	}
}

/// @func forms_show_window(_window)
/// @desc Adds a window to a GUI root and sets it as active.
/// @param {real} _window The id of the window to show.
function forms_show_window(_window)
{
	forms_add_item(forms_root, _window);
	if (forms_widget_selected != noone)
	{
		forms_request_redraw(forms_widget_selected);
	}
	forms_widget_selected = _window;
}

/// @function forms_window_fit_content(_window)
/// @param {real} _window
function forms_window_fit_content(_window)
{
	forms_disable_click = true;
	gpu_push_state();
	gpu_set_colorwriteenable(false, false, false, false);
	var _content = forms_window_get_content(_window);
	var _filling = forms_widget_filling;
	var _container = forms_window_get_container(_window);
	forms_widget_filling = _container;
	var _content_size = _content(_container);
	forms_widget_filling = _filling;
	gpu_pop_state();
	forms_disable_click = false;

	var _border = _window[? "border"];
	var _width = _content_size[0] + _border * 2;
	var _height = _content_size[1]
		+ forms_widget_get_height(forms_window_get_titlebar(_window))
		+ _border;

	forms_widget_set_rectangle(
		_window,
		round((window_get_width() - _width) * 0.5),
		round((window_get_height() - _height) * 0.5),
		_width,
		_height);
}