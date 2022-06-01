/// @func forms_titlebar_create(_title[, _icon])
/// @param {string} title The name of the panel.
/// @param {FORMS_EIcon/undefined} [icon] The panel icon. Defaults to undefined.
/// @return {real}
function forms_titlebar_create(_title)
{
	var _titlebar = forms_container_create();
	_titlebar[? "title"] = _title;
	_titlebar[? "icon"] = (argument_count > 1) ? argument[1] : undefined;
	_titlebar[? "content"] = forms_cnt_titlebar;
	forms_canvas_set_background(_titlebar, $282828);
	return _titlebar;
}

/// @func forms_cnt_titlebar(_container)
/// @desc Draws the content of a Title Bar to the container.
/// @param {real} _container The id of the container.
/// @return {array} The content size.
function forms_cnt_titlebar(_container)
{
	var _container_width = forms_widget_get_width(_container);

	var _title = _container[? "title"];
	var _icon = _container[? "icon"];
	var _pen = forms_pen_create(10, 0);
	forms_pen_set_marginh(_pen, 4);

	var _width = 10 + FORMS_ICON_SIZE + 5 + string_width(_title) + 10;

	ce_draw_sprite_nine_slice(FORMS_SprTab, 0, 0, 0, _width, forms_line_height, false);
	ce_draw_sprite_nine_slice(FORMS_SprTab, 1, 0, 0, _width, forms_line_height, false, $5B9D03);
	draw_line_color(_width - 1, forms_line_height - 1, _width - 1 + 100, forms_line_height - 1, $5B9D03, $282828);

	if (_icon != undefined)
	{
		forms_draw_icon(_pen, _icon);
	}
	forms_draw_text(_pen, _title);

	return [_container_width, forms_line_height];
}

/// @func forms_cnt_titlebar_window(_container)
/// @desc Draws the content of a Window Title Bar to the container.
/// @param {real} _container The id of the container.
/// @return {array} The content size.
function forms_cnt_titlebar_window(_container)
{
	var _container_width = forms_widget_get_width(_container);
	var _delegate = forms_widget_get_delegate(_container);

	var _title = _container[? "title"];
	var _pen = forms_pen_create(0, 0);

	forms_text(_pen, _title);

	if (_delegate[? "closeable"])
	{
		forms_pen_set_x(_pen, _container_width - FORMS_ICON_SIZE - 8);

		if (forms_icon_button(_pen, FORMS_EIcon.Close))
		{
			forms_widget_destroy(_delegate);
		}
	}

	return [_container_width, forms_line_height];
}