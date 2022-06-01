/// @func forms_vscrollbar_create(delegate)
/// @desc Creates a new horizontal scrollbar.
/// @param {real} delegate The id of the scrollbars delegate.
/// @return {real} The id of the created scrollbar.
function forms_vscrollbar_create(delegate)
{
	var _scrollbar_ver = forms_scrollbar_create(delegate);
	forms_widget_set_width(_scrollbar_ver, 14);
	_scrollbar_ver[? "scr_update"] = forms_vscrollbar_update;
	_scrollbar_ver[? "scr_draw"] = forms_vscrollbar_draw;
	return _scrollbar_ver;
}

/// @func forms_vscrollbar_draw(scrollbar_ver)
/// @desc Draws the vertical scrollbar.
/// @param {real} scrollbar_ver The id of the vertical scrollbar.
function forms_vscrollbar_draw(scrollbar_ver)
{
	if (forms_scrollbar_is_visible(scrollbar_ver))
	{
		var _x = forms_widget_get_x(scrollbar_ver);
		var _y = forms_widget_get_y(scrollbar_ver);
		var _width = forms_widget_get_width(scrollbar_ver);
		var _height = forms_widget_get_height(scrollbar_ver);
		var _scroll = scrollbar_ver[? "scroll"];
		var _thumb_size = scrollbar_ver[? "thumb_size"];
		var _sprite_size = 10;

		var _thumb_x = _x + 2;
		var _thumb_y = _y + 2 + _scroll;
		var _thumb_end = _thumb_y + _thumb_size;

		var _subimage = (forms_widget_active == scrollbar_ver) ? 2
			: ((forms_widget_hovered == scrollbar_ver && forms_mouse_y > _thumb_y && forms_mouse_y < _thumb_end) ? 1
			: 0);

		ce_draw_sprite_nine_slice(FORMS_SprScrollbarBackground, _subimage, _x, _y, _width, _height, false);
		ce_draw_sprite_nine_slice(FORMS_SprScrollbarV, _subimage, _thumb_x, _thumb_y, _sprite_size, _thumb_size, false);
	}
}

/// @func forms_vscrollbar_update(scrollbar_ver)
/// @desc Updates the vertical scrollbar.
/// @param {real} scrollbar_ver The id of the vertical scrollbar.
function forms_vscrollbar_update(scrollbar_ver)
{
	var _scrollbar_size = forms_widget_get_height(scrollbar_ver) - 4;

	scrollbar_ver[? "size"] = _scrollbar_size;

	if (!keyboard_check(vk_control))
	{
		forms_scrollbar_update(scrollbar_ver);
	}
	else
	{
		forms_widget_update(scrollbar_ver);
	}

	// Start scrolling with mouse click
	// TODO: Fix scrollbars so that the commented code works
	if (forms_widget_hovered == scrollbar_ver
		&& mouse_check_button_pressed(mb_left))
	{
		var _y = scrollbar_ver[? "scroll"];

		if (forms_widget_hovered == scrollbar_ver
			&& forms_mouse_y > _y
			&& forms_mouse_y < _y + scrollbar_ver[? "thumb_size"])
		{
			//scrollbar_ver[? "mouse_offset"] = _y - forms_mouse_y;
			scrollbar_ver[? "mouse_offset"] = forms_window_mouse_y;
			forms_widget_active = scrollbar_ver;
		}
	}

	// Stop scrolling
	if (mouse_check_button_released(mb_left)
		&& forms_widget_active == scrollbar_ver)
	{
		forms_widget_active = noone;
	}

	// Handle scrolling
	if (forms_scrollbar_is_visible(scrollbar_ver))
	{
		var _scroll = scrollbar_ver[? "scroll"];
		if (forms_widget_active == scrollbar_ver)
		{
			//_scroll = forms_mouse_y + scrollbar_ver[? "mouse_offset"];
			_scroll += forms_window_mouse_y - scrollbar_ver[? "mouse_offset"];
			scrollbar_ver[? "mouse_offset"] = forms_window_mouse_y;
		}
		_scroll = clamp(_scroll, 0, _scrollbar_size - scrollbar_ver[? "thumb_size"]);
		scrollbar_ver[? "scroll"] = _scroll;
	}
}