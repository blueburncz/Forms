function forms_menu_bar() {}

/// @func forms_menu_bar_create()
/// @desc Creates a new menu bar.
/// @return {real} The id of the created menu bar.
function forms_menu_bar_create()
{
	var _menubar = forms_canvas_create(forms_menu_bar);
	forms_widget_set_height(_menubar, forms_line_height);
	_menubar[? "scr_update"] = forms_menu_bar_update;
	_menubar[? "scr_draw"] = forms_menu_bar_draw;
	_menubar[? "current"] = noone;
	return _menubar;
}

/// @func forms_menu_bar_update(_menubar)
/// @desc Updates the menu bar.
/// @param {real} _menubar The id of the menu bar.
function forms_menu_bar_update(_menubar)
{
	forms_widgetset_update(_menubar);

	if (_menubar[? "current"] != noone
		&& __forms_context_menu == noone)
	{
		_menubar[? "current"] = noone;
		forms_request_redraw(_menubar);
	}
}

/// @func forms_menu_bar_add_item(_menubar, menubar_item)
/// @desc Adds the item to the menu bar.
/// @param {real} _menubar The id of the menu bar.
/// @param {real} menubar_item The id of the menu bar item.
function forms_menu_bar_add_item(_menubar, menubar_item)
{
	gml_pragma("forceinline");
	menubar_item[? "index"] = forms_add_item(_menubar, menubar_item);
}

/// @func forms_menu_bar_draw(_menubar)
/// @desc Draws the menu bar.
/// @param {real} menubar The id of the menu bar.
function forms_menu_bar_draw(_menubar)
{
	if (forms_begin_fill(_menubar))
	{
		ce_draw_rectangle(0, 0, forms_widget_get_width(_menubar), 1, $3e3e3e);

		var _x = 2;
		var _y = 2;
		var _items = forms_widgetset_get_items(_menubar);
		var _size = ds_list_size(_items);

		for (var i = 0; i < _size; ++i)
		{
			var _item = _items[| i];
			forms_draw_item(_item, _x, _y);
			_x += forms_widget_get_width(_item);
		}

		//ce_draw_rectangle(0, forms_widget_get_height(_menubar) - 1, forms_widget_get_width(_menubar), 1, $181818);

		forms_end_fill(_menubar);
	}

	forms_canvas_draw(_menubar);
}