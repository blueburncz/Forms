function forms_widgetset() {}

/// @func forms_widgetset_create([type])
/// @desc Creates a new widget set.
/// @param {real} type The widget set type.
/// @return {real} The id of the created widget set.
function forms_widgetset_create()
{
	var _widgetset;
	if (argument_count == 1)
	{
		_widgetset = forms_widget_create(argument[0]);
	}
	else
	{
		_widgetset = forms_widget_create(forms_widgetset);
	}
	_widgetset[? "scr_update"] = forms_widgetset_update;
	_widgetset[? "scr_cleanup"] = forms_widgetset_cleanup;
	ds_map_add_list(_widgetset, "items", ds_list_create());
	return _widgetset;
}

/// @func forms_widgetset_cleanup(widgetset)
/// @desc Frees resources used by the widget set from memory.
/// @param {real} widgetset The id of the widget set.
function forms_widgetset_cleanup(widgetset)
{
	var _items = forms_widgetset_get_items(widgetset);
	while (ds_list_size(_items) > 0)
	{
		var _item = _items[| 0];
		var _scr_cleanup = _item[? "scr_cleanup"];
		if (_scr_cleanup != noone)
		{
			_scr_cleanup(_item);
		}
	}
	forms_widget_cleanup(widgetset);
}

/// @func forms_widgetset_update(widgetset)
/// @desc Updates the widget set.
/// @param {real} widgetset The id of the widget set.
function forms_widgetset_update(widgetset)
{
	forms_widget_update(widgetset);

	////////////////////////////////////////////////////////////////////////////////
	// Update items
	var _items = forms_widgetset_get_items(widgetset);
	for (var i = ds_list_size(_items) - 1; i >= 0; --i)
	{
		var _item = _items[| i];
		if (!forms_widget_exists(_item))
		{
			ds_list_delete(_items, i);
		}
	}
}

/// @func forms_widgetset_get_items(widgetset)
/// @desc Gets the list of items of the widget set.
/// @param {real} widgetset The id of the widget set.
/// @return {real/undefiend} The list of items of the widget set or
/// undefined, if the widget is not a widget set.
function forms_widgetset_get_items(widgetset)
{
	gml_pragma("forceinline");
	return widgetset[? "items"];
}

/// @func forms_draw_item(_item[, _x, _y])
/// @desc Draws the item.
/// @param {real} _item The id of the item.
/// @param {real} [_x] The x position to draw the item at.
/// @param {real} [_y] The y position to draw the item at.
function forms_draw_item(_item)
{
	// Set position if passed
	if (argument_count == 3)
	{
		forms_widget_set_position(_item, argument[1], argument[2]);
	}

	// Update
	var _scr_update = _item[? "scr_update"];
	if (_scr_update != noone)
	{
		_scr_update(_item);
	}

	// Draw
	var _scr_draw = _item[? "scr_draw"];
	if (_scr_draw != noone)
	{
		_scr_draw(_item);
	}
	forms_widget_set_redraw(_item, false);
}