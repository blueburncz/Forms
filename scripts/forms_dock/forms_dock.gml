function FORMS_Dock() {}

/// @func forms_dock_create([_x, _y, _width, _height])
/// @desc Creates a new dock.
/// @param {real} [_x] The x positon to create the dock at.
/// @param {real} [_y] The y positon to create the dock at.
/// @param {real} [_width] The width of the dock.
/// @param {real} [_height] The width of the dock.
/// @return {real} The id of the created dock.
function forms_dock_create()
{
	var _dock = forms_widgetset_create(FORMS_Dock);
	if (argument_count == 4)
	{
		forms_widget_set_rectangle(_dock, argument[0], argument[1], argument[2], argument[3]);
	}
	_dock[? "split_size"] = 0.5;
	// Only Horizontal and Vertical applies!
	_dock[? "split_type"] = FORMS_EDirection.Horizontal;
	_dock[? "scr_update"] = forms_dock_update;
	_dock[? "scr_draw"] = forms_dock_draw;
	_dock[? "mouse_offset"] = 0;
	var _border_size = sprite_get_width(FORMS_SprDock);
	_dock[? "border_size"] = _border_size;
	_dock[? "padding"] = floor(_border_size / 2);
	return _dock;
}

/// @func forms_dock_draw(_dock)
/// @desc Draws the dock.
/// @param {real} _dock The id of the dock.
function forms_dock_draw(_dock)
{
	var _x = forms_widget_get_x(_dock);
	var _y = forms_widget_get_y(_dock);
	var _items = forms_widgetset_get_items(_dock);
	var _item_count = ds_list_size(_items);

	forms_matrix_push(_x, _y);

	switch (_item_count)
	{
	case 0:
		break;

	case 1:
		var _item = _items[| 0];
		forms_widget_set_size(_item,
			forms_widget_get_width(_dock),
			forms_widget_get_height(_dock));
		forms_draw_item(_item, 0, 0);
		break;

	case 2:
		var _width = forms_widget_get_width(_dock);
		var _height = forms_widget_get_height(_dock);
		var _split_type = _dock[? "split_type"];
		var _split_size = _dock[? "split_size"];
		var _border_size = _dock[? "border_size"];
		var _padding = _dock[? "padding"];
		var _left = _items[| 0];
		var _right = _items[| 1];
		var _middle;

		switch (_split_type)
		{
		case FORMS_EDirection.Horizontal:
			_middle = round(_width * _split_size);

			forms_widget_set_size(_left,
				_middle - _padding,
				_height);

			forms_widget_set_rectangle(_right,
				_middle + _padding,
				0,
				_width - _middle - _padding,
				_height);

			draw_sprite_stretched(FORMS_SprDock, 1, _middle - _padding, 0, _border_size, _height);
			break;

		case FORMS_EDirection.Vertical:
			_middle = round(_height * _split_size);

			forms_widget_set_size(_left,
				_width,
				_middle - _padding);

			forms_widget_set_rectangle(_right,
				0,
				_middle + _padding,
				_width,
				_height - _middle - _padding);

			draw_sprite_stretched(FORMS_SprDock, 0, 0, _middle - _padding, _width, _border_size);
			break;

		default:
			// TODO: Use ce_assert
			show_error("Invalid dock split!", true);
			break;
		}

		forms_draw_item(_left, 0, 0);
		forms_draw_item(_right);
		break;

	default:
		// TODO: Use ce_assert
		show_error("Invalid dock item count!", true);
		break;
	}

	forms_matrix_restore();
}

/// @func forms_dock_update(_dock)
/// @desc Updates the dock.
/// @param {real} _dock The id of the dock.
function forms_dock_update(_dock)
{
	forms_widgetset_update(_dock);

	// Start resizing
	if (!forms_widget_exists(forms_widget_active)
		&& forms_widget_is_hovered(_dock))
	{
		var _x = forms_widget_get_x(_dock);
		var _y = forms_widget_get_y(_dock);
		var _width = forms_widget_get_width(_dock);
		var _height = forms_widget_get_height(_dock);
		var _split_type = _dock[? "split_type"];
		var _split_size = _dock[? "split_size"];
		var _padding = _dock[? "padding"];
		var _middle;

		if (_split_type == FORMS_EDirection.Horizontal)
		{
			_middle = round(_width * _split_size);

			// Horizontally
			if (forms_mouse_x >= _middle - _padding
				&& forms_mouse_x < _middle + _padding)
			{
				forms_cursor = cr_size_we;
				if (mouse_check_button_pressed(mb_left))
				{
					forms_widget_active = _dock;
					_dock[? "mouse_offset"] = _middle - forms_mouse_x;
				}
			}
		}
		else
		{
			_middle = round(_height * _split_size);

			// Vertically
			if (forms_mouse_y >= _middle - _padding
				&& forms_mouse_y < _middle + _padding)
			{
				forms_cursor = cr_size_ns;
				if (mouse_check_button_pressed(mb_left))
				{
					forms_widget_active = _dock;
					_dock[? "mouse_offset"] = _middle - forms_mouse_y;
				}
			}
		}
	}

	// Resize
	if (forms_widget_active == _dock)
	{
		if (mouse_check_button(mb_left))
		{
			if (_dock[? "split_type"] == FORMS_EDirection.Horizontal)
			{
				_dock[? "split_size"] = (forms_mouse_x + _dock[? "mouse_offset"]) / forms_widget_get_width(_dock);
				forms_cursor = cr_size_we;
			}
			else
			{
				_dock[? "split_size"] = (forms_mouse_y + _dock[? "mouse_offset"]) / forms_widget_get_height(_dock);
				forms_cursor = cr_size_ns;
			}
			_dock[? "split_size"] = clamp(_dock[? "split_size"], 0.1, 0.9);
		}
		else
		{
			forms_widget_active = noone;
		}
	}
}