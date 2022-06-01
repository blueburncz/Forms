/// @func forms_hscrollbar_create(delegate)
/// @desc Creates a new horizontal scrollbar.
/// @param {real} delegate The id of the scrollbars delegate.
/// @return {real} The id of the created scrollbar.
function forms_hscrollbar_create(delegate)
{
	var _scrollbar_hor = forms_scrollbar_create(delegate);
	forms_widget_set_height(_scrollbar_hor, 14);
	_scrollbar_hor[? "scr_update"] = forms_hscrollbar_update;
	_scrollbar_hor[? "scr_draw"] = forms_hscrollbar_draw;
	return _scrollbar_hor;
}

/// @func forms_hscrollbar_draw(scrollbar_hor)
/// @desc Draws the horizontal scrollbar.
/// @param {real} scrollbar_hor The id of the horizontal scrollbar.
function forms_hscrollbar_draw(scrollbar_hor)
{
	if (forms_scrollbar_is_visible(scrollbar_hor))
	{
		var _x = forms_widget_get_x(scrollbar_hor);
		var _y = forms_widget_get_y(scrollbar_hor);
		var _width = forms_widget_get_width(scrollbar_hor);
		var _height = forms_widget_get_height(scrollbar_hor);
		var _scroll = scrollbar_hor[? "scroll"];
		var _thumb_size = scrollbar_hor[? "thumb_size"];
		var _sprite_size = 10;

		var _thumb_x = _x + 2 + _scroll;
		var _thumb_y = _y + 2;
		var _thumb_end = _thumb_x + _thumb_size;

		var _subimage = (forms_widget_active == scrollbar_hor) ? 2
			: ((forms_widget_hovered == scrollbar_hor && forms_mouse_x > _thumb_x && forms_mouse_x < _thumb_end) ? 1
			: 0);

		ce_draw_sprite_nine_slice(FORMS_SprScrollbarBackground, _subimage, _x, _y, _width, _height, false);
		ce_draw_sprite_nine_slice(FORMS_SprScrollbarH, _subimage, _thumb_x, _thumb_y, _thumb_size, _sprite_size, false);
	}
}

/// @func forms_hscrollbar_update(scrollbar_hor)
/// @desc Updates the horizontal scrollbar.
/// @param {real} scrollbar_hor The id of the horizontal scrollbar.
function forms_hscrollbar_update(scrollbar_hor)
{
	var _scrollbar_size = forms_widget_get_width(scrollbar_hor) - 4;

	scrollbar_hor[? "size"] = _scrollbar_size;

	if (keyboard_check(vk_control))
	{
		forms_scrollbar_update(scrollbar_hor);
	}
	else
	{
		forms_widget_update(scrollbar_hor);
	}

	// Start scrolling with mouse click
	// TODO: Fix scrollbars so that the commented code works
	if (forms_widget_hovered == scrollbar_hor
		&& mouse_check_button_pressed(mb_left))
	{
		var _x = scrollbar_hor[? "scroll"];

		if (forms_widget_hovered == scrollbar_hor
			&& forms_mouse_x > _x
			&& forms_mouse_x < _x + scrollbar_hor[? "thumb_size"])
		{
			//scrollbar_hor[? "mouse_offset"] = _x - forms_mouse_x;
			scrollbar_hor[? "mouse_offset"] = forms_window_mouse_x;
			forms_widget_active = scrollbar_hor;
		}
	}

	// Stop scrolling
	if (mouse_check_button_released(mb_left)
		&& forms_widget_active == scrollbar_hor)
	{
		forms_widget_active = noone;
	}

	// Handle scrolling
	if (forms_scrollbar_is_visible(scrollbar_hor))
	{
		var _scroll = scrollbar_hor[? "scroll"];
		if (forms_widget_active == scrollbar_hor)
		{
			//_scroll = forms_mouse_x + scrollbar_hor[? "mouse_offset"];
			_scroll += forms_window_mouse_x - scrollbar_hor[? "mouse_offset"];
			scrollbar_hor[? "mouse_offset"] = forms_window_mouse_x;
		}
		_scroll = clamp(_scroll, 0, _scrollbar_size - scrollbar_hor[? "thumb_size"]);
		scrollbar_hor[? "scroll"] = _scroll;
	}
}