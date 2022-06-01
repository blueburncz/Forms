function FORMS_VBox() {}

function forms_vbox_create()
{
	var _vbox = forms_widgetset_create(FORMS_VBox);
	_vbox[? "scr_update"] = forms_vbox_update;
	_vbox[? "scr_draw"] = forms_vbox_draw;
	return _vbox;
}

function forms_vbox_update(_vbox)
{
	forms_widgetset_update(_vbox);

	var _width = forms_widget_get_width(_vbox);
	var _height = forms_widget_get_height(_vbox);

	var _items = forms_widgetset_get_items(_vbox);
	var _item_count = ds_list_size(_items);
	var _items_height = 0;
	var _flex_total = 0;

	var i = 0;
	repeat (_item_count)
	{
		var _item = _items[| i++];
		if (!ds_map_exists(_item, "flex"))
		{
			_items_height += forms_widget_get_height(_item);
		}
		else
		{
			_flex_total += _item[? "flex"];
		}
	}

	var _y = 0;
	i = 0;
	repeat (_item_count)
	{
		var _item = _items[| i++];
		var _h = (ds_map_exists(_item, "flex"))
			? round((_height - _items_height) * (_item[? "flex"] / _flex_total))
			: forms_widget_get_height(_item);
		forms_widget_set_rectangle(_item, 0, _y, _width, _h);
		_y += _h;
	}
}

function forms_vbox_draw(_vbox)
{
	var _items = forms_widgetset_get_items(_vbox);
	var i = 0;
	repeat (ds_list_size(_items))
	{
		forms_draw_item(_items[| i++]);
	}
}