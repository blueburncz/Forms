function FORMS_Container() {}

/// @func forms_container_create([_x, _y, _width, _height])
/// @desc Creates a new scrollable container.
/// @param {real} [_x] The x positon to create the container at.
/// @param {real} [_y] The y positon to create the container at.
/// @param {real} [_width] The width of the container.
/// @param {real} [_height] The width of the container.
/// @return {real} The id of the created container.
function forms_container_create()
{
	var _container = forms_canvas_create(FORMS_Container);
	if (argument_count == 4)
	{
		forms_widget_set_rectangle(_container, argument[0], argument[1], argument[2], argument[3]);
	}
	forms_container_set_content(_container, noone);
	_container[? "scr_draw"] = forms_container_draw;
	_container[? "scr_update"] = forms_container_update;
	_container[? "click_scroll"] = false;
	_container[? "click_scroll_mouse_x"] = 0;
	_container[? "click_scroll_mouse_y"] = 0;
	ds_map_add_map(_container, "scrollbar_hor", forms_hscrollbar_create(_container));
	ds_map_add_map(_container, "scrollbar_ver", forms_vscrollbar_create(_container));
	return _container;
}

/// @func forms_container_update(_container)
/// @desc Updates the container.
/// @param {real} _container The id of the container.
function forms_container_update(_container)
{
	var _scrollbar_hor = _container[? "scrollbar_hor"];
	var _scrollbar_ver = _container[? "scrollbar_ver"];
	forms_widgetset_update(_container);

	// Click scroll
	if (mouse_check_button_pressed(mb_middle)
		&& forms_widget_is_hovered(_container)
		&& !forms_widget_exists(forms_widget_active))
	{
		_container[? "click_scroll"] = true;
		_container[? "click_scroll_mouse_x"] = forms_window_mouse_x;
		_container[? "click_scroll_mouse_y"] = forms_window_mouse_y;
		forms_widget_active = _container;
	}

	if (forms_widget_active == _container
		&& _container[? "click_scroll"])
	{
		_scrollbar_hor[? "scroll"] += (forms_window_mouse_x - _container[? "click_scroll_mouse_x"])
									/ _scrollbar_hor[? "scroll_jump"] * 0.1;
		_scrollbar_ver[? "scroll"] += (forms_window_mouse_y - _container[? "click_scroll_mouse_y"])
									/ _scrollbar_ver[? "scroll_jump"] * 0.1;

		_scrollbar_hor[? "scroll"] = clamp(_scrollbar_hor[? "scroll"], 0, _scrollbar_hor[? "size"] - _scrollbar_hor[? "thumb_size"]);
		_scrollbar_ver[? "scroll"] = clamp(_scrollbar_ver[? "scroll"], 0, _scrollbar_ver[? "size"] - _scrollbar_ver[? "thumb_size"]);

		if (!mouse_check_button(mb_middle))
		{
			_container[? "click_scroll"] = false;
			forms_widget_active = noone;
		}
		forms_cursor = cr_drag;
	}
}

/// @func forms_container_draw(container)
/// @desc Draws the container.
/// @param {real} container The id of the container.
function forms_container_draw(container)
{
	// Draw items
	if (forms_begin_fill(container))
	{
		var _size = [0.1, 0.1];
		var _content = container[? "content"];
		if (_content != noone)
		{
			_size = _content(container);
		}

		forms_container_set_content_width(container, _size[0]);
		forms_container_set_content_height(container, _size[1]);
		forms_end_fill(container);
	}

	// Draw container
	forms_canvas_draw(container);
}

/// @func forms_container_get_content(container)
/// @desc Gets the content script of the container.
/// @param {real} container The id of the container.
/// @param {real} content The content script of the container or noone.
function forms_container_get_content(container)
{
	gml_pragma("forceinline");
	return container[? "content"];
}

/// @func forms_container_get_content_height(container)
/// @desc Gets the height of the container's content.
/// @param {real} container The id of the container.
/// @return {real} The height of the container's content.
function forms_container_get_content_height(container)
{
	gml_pragma("forceinline");
	return ds_map_find_value(container[? "scrollbar_ver"], "content_size");
}

/// @func forms_container_get_content_width(container)
/// @desc Gets the width of the container's content.
/// @param {real} container The id of the container.
/// @return {real} The width of the container's content.
function forms_container_get_content_width(container)
{
	gml_pragma("forceinline");
	return ds_map_find_value(container[? "scrollbar_hor"], "content_size");
}

/// @func forms_container_set_content(container, content)
/// @desc Sets the content script of the container.
/// @param {real} container The id of the container.
/// @param {real} content The new content script or noone.
function forms_container_set_content(container, content)
{
	gml_pragma("forceinline");
	container[? "content"] = content;
}

/// @func forms_container_set_content_height(container, content_height)
/// @desc Sets height of the content of the given
/// container to the given value.
/// @param {real} container The id of the container.
/// @param {real} content_height The new height of the container's content.
function forms_container_set_content_height(container, content_height)
{
	gml_pragma("forceinline");
	ds_map_set(container[? "scrollbar_ver"], "content_size", max(1, content_height));
}

/// @func forms_container_set_content_width(container, content_width)
/// @desc Sets width of the content of the given
/// container to the given value.
/// @param {real} container The id of the container.
/// @param {real} content_width The new width of the container's content.
function forms_container_set_content_width(container, content_width)
{
	gml_pragma("forceinline");
	ds_map_set(container[? "scrollbar_hor"], "content_size", max(1, content_width));
}