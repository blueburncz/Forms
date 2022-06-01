function FORMS_HBox() {}

function forms_hbox_create()
{
	var _hbox = forms_widgetset_create(FORMS_HBox);
	_hbox[? "scr_update"] = forms_hbox_update;
	_hbox[? "scr_draw"] = forms_hbox_draw;
	return _hbox;
}

function forms_hbox_update(_hbox)
{
	forms_widgetset_update(_hbox);

	var _width = forms_widget_get_width(_hbox);
	var _height = forms_widget_get_height(_hbox);

	var _items = forms_widgetset_get_items(_hbox);
	var _item_count = ds_list_size(_items);
	var _items_width = 0;
	var _flex_total = 0;

	var i = 0;
	repeat (_item_count)
	{
		var _item = _items[| i++];
		if (!ds_map_exists(_item, "flex"))
		{
			_items_width += forms_widget_get_width(_item);
		}
		else
		{
			_flex_total += _item[? "flex"];
		}
	}

	var _x = 0;
	i = 0;
	repeat (_item_count)
	{
		var _item = _items[| i++];
		var _w = (ds_map_exists(_item, "flex"))
			? round((_width - _items_width) * (_item[? "flex"] / _flex_total))
			: forms_widget_get_width(_item);
		forms_widget_set_rectangle(_item, _x, 0, _w, _height);
		_x += _w;
	}
}

function forms_hbox_draw(_hbox)
{
	var _items = forms_widgetset_get_items(_hbox);
	var i = 0;
	repeat (ds_list_size(_items))
	{
		forms_draw_item(_items[| i++]);
	}
}