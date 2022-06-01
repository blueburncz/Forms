function FORMS_Scrollbar() {}

/// @func forms_scrollbar_create(delegate)
/// @desc Creates a new scrollbar.
/// @param {real} delegate The id of the scrollbars delegate.
/// @return {real} The id of the created scrollbar.
function forms_scrollbar_create(delegate)
{
	var _scrollbar = forms_widget_create(FORMS_Scrollbar);
	forms_widget_set_delegate(_scrollbar, delegate);
	forms_widget_set_depth(_scrollbar, 16777216);
	_scrollbar[? "sprite"] = noone;
	_scrollbar[? "sprite_size"] = 1;
	_scrollbar[? "content_size"] = 0.1;
	_scrollbar[? "scr_update"] = forms_scrollbar_update;
	_scrollbar[? "size"] = 1;
	_scrollbar[? "scroll"] = 0;
	_scrollbar[? "scroll_jump"] = 1;
	_scrollbar[? "mouse_offset"] = 0;
	_scrollbar[? "min_thumb_size"] = 12;
	_scrollbar[? "thumb_size"] = _scrollbar[? "min_thumb_size"];
	return _scrollbar;
}

/// @func forms_scrollbar_calc_jump_and_thumb_size(scrollbar)
/// @desc Calculates the jump value and thumb size of the scrollbar.
/// @param {real} scrollbar The id of the scrollbar.
function forms_scrollbar_calc_jump_and_thumb_size(scrollbar)
{
	var _size = scrollbar[? "size"];
	var _content_size = scrollbar[? "content_size"];
	var _min_thumb_size = scrollbar[? "min_thumb_size"];

	var _viewable_ratio = _size / _content_size;
	var _scrollbar_area = _size;
	var _thumb_size = max(_min_thumb_size, _scrollbar_area * _viewable_ratio);
	scrollbar[? "thumb_size"] = _thumb_size;

	var _scroll_track_space = _content_size - _size;
	var _scroll_thumb_space = _size - _thumb_size;
	scrollbar[? "scroll_jump"] = _scroll_track_space / _scroll_thumb_space;
}

/// @func forms_scrollbar_get_scroll(scrollbar)
/// @desc Gets the scroll of the given scrollbar.
/// @param {real} scrollbar The id of the scrollbar.
/// @return {real} The content scroll.
function forms_scrollbar_get_scroll(scrollbar)
{
	gml_pragma("forceinline");
	return round(scrollbar[? "scroll"] * scrollbar[? "scroll_jump"]);
}

/// @func forms_scrollbar_is_visible(_scrollbar)
/// @desc Finds out whether the scrollbar is visible.
/// @param {real} _scrollbar The id of the scrollbar.
/// @return {bool} True if the scrollbar is visible.
function forms_scrollbar_is_visible(_scrollbar)
{
	var _delegate = forms_widget_get_delegate(_scrollbar);
	if (_delegate[? "scrollbar_hor"] == _scrollbar)
	{
		if (_scrollbar[? "content_size"] > forms_widget_get_width(_delegate))
		{
			return true;
		}
	}
	if (_delegate[? "scrollbar_ver"] == _scrollbar)
	{
		if (_scrollbar[? "content_size"] > forms_widget_get_height(_delegate))
		{
			return true;
		}
	}
	return false;
}

/// @func forms_scrollbar_set_scroll(scrollbar, scroll)
/// @desc Sets scrollbar's scroll to the given value.
/// @param {real} scrollbar The id of the scrollbar.
/// @param {real} scroll The new scroll value.
function forms_scrollbar_set_scroll(scrollbar, scroll)
{
	gml_pragma("forceinline");
	scrollbar[? "scroll"] = scroll / scrollbar[? "scroll_jump"];
}

/// @func forms_scrollbar_update(scrollbar)
/// @desc Updates the scrollbar.
/// @param {real} _scrollbar The id of the scrollbar.
function forms_scrollbar_update(_scrollbar)
{
	forms_widget_update(_scrollbar);
	forms_scrollbar_calc_jump_and_thumb_size(_scrollbar);

	var _delegate = forms_widget_get_delegate(_scrollbar);

	if (forms_widget_is_hovered(_scrollbar)
		|| (forms_widget_exists(_delegate)
		&& (forms_widget_is_hovered(_delegate)
		|| forms_widget_delegates_recursive(_delegate, forms_widget_hovered))))
	{
		var _wheel = (mouse_wheel_down() - mouse_wheel_up()) * 2 * forms_font_height / _scrollbar[? "scroll_jump"];
		if (_wheel != 0)
		{
			var _scroll_new = clamp(_scrollbar[? "scroll"] + _wheel, 0, _scrollbar[? "size"] - _scrollbar[? "thumb_size"]);
			if (_scroll_new != _scrollbar[? "scroll"])
			{
				_scrollbar[? "scroll"] = _scroll_new;
				forms_request_redraw(_scrollbar);
				forms_close_context_menu();
				forms_close_dropdown();
			}
		}
	}
}