/// @func forms_select(_id, _pen, _items, _current[, _props])
/// @param {string} _id
/// @param {FORMS_EPen} _pen
/// @param {struct[]} _items
/// @param {int} _current
/// @param {struct} [_props]
/// @return {bool}
function forms_select(_id, _pen, _items, _current)
{
	var _props = (argument_count > 4) ? argument[4] : {};
	var _tooltip = ce_struct_get(_props, "tooltip", "");
	var _disabled = ce_struct_get(_props, "disabled", false);

	var _sprite = FORMS_SprDropdown;

	var _text = "";
	for (var i = 0; i < array_length(_items); ++i)
	{
		var _item = _items[i];
		if (ce_struct_get(_item, "value", i) == _current)
		{
			_text = _item.option;
			break;
		}
	}

	var _width = ce_struct_get(_props, "width");
	if (_width != undefined)
	{
		var i = 1;
		var _text_new = "";
		repeat (string_length(_text))
		{
			var _char = string_char_at(_text, i++);
			if (string_width(_text_new + _char) > _width - (20 + forms_line_height))
			{
				break;
			}
			_text_new += _char;
		}
		_text = _text_new;
	}
	else
	{
		_width = string_width(_text) + 20 + forms_line_height;
	}

	var _sprite_width = sprite_get_width(_sprite);
	var _sprite_height = sprite_get_height(_sprite);
	var _height = forms_line_height;

	var _x = forms_pen_get_x(_pen);
	var _y = forms_pen_get_y(_pen);

	ce_draw_sprite_nine_slice(_sprite, _disabled, _x, _y, _width, _height, false);
	ce_draw_sprite_nine_slice(_sprite, _disabled, _x + _width - forms_line_height, _y, forms_line_height, forms_line_height, false);
	draw_sprite(_sprite, 2,
		_x + _width - forms_line_height + round((forms_line_height - _sprite_width) * 0.5),
		_y + round((forms_line_height - _sprite_height) * 0.5));

	var _pen_inner = forms_pen_create(_x + 10, _y);
	forms_text(_pen_inner, _text);

	var _mouse_in_rectangle = forms_mouse_over_rectangle(_x, _y, _width, _height, _id);
	var _mouse_over = (!_disabled && _mouse_in_rectangle);

	if (_mouse_in_rectangle)
	{
		forms_tooltip_str = _tooltip;
	}

	if (_mouse_over && mouse_check_button_pressed(mb_left))
	{
		forms_steal_mouse_input(_id);
	}

	if (_mouse_over && forms_mouse_lost_input == _id)
	{
		var _dropdown = forms_dropdown_create();
		_dropdown[? "width"] = _width;
		_dropdown[? "target"] = _id;
		_dropdown[? "options"] = _items;
		_dropdown[? "current"] = _current;
		var _position = forms_get_draw_position_absolute(_x, _y + forms_line_height);
		forms_show_dropdown(_dropdown, _position[0], _position[1]);
	}

	forms_pen_move(_pen, _width);

	return forms_consume_retval(_id);
}

function forms_dropdown() {}

function forms_dropdown_create()
{
	var _dropdown = forms_container_create();
	_dropdown[? "type"] = forms_dropdown;
	_dropdown[? "scr_update"] = forms_dropdown_update;
	_dropdown[? "scr_draw"] = forms_dropdown_draw;
	_dropdown[? "background"] = $171717;
	_dropdown[? "options"] = [];
	_dropdown[? "current"] = 0;
	_dropdown[? "target"] = "";
	forms_widget_set_depth(_dropdown, $FFFFFE);
	return _dropdown;
}

function forms_dropdown_draw(_dropdown)
{
	if (forms_begin_fill(_dropdown))
	{
		// Draw items
		var _pen = forms_pen_create(10, 2);
		forms_pen_set_marginv(_pen, 0);
	
		var _dropdown_items = _dropdown[? "options"];
		var _current = _dropdown[? "current"];
		var _item_count = array_length(_dropdown_items);
		var i = 0;

		repeat (_item_count)
		{
			var _id = forms_make_id();
			var _item = _dropdown_items[i];
			var _item_text = _item.option;
			var _item_value = ce_struct_get(_item, "value", i);
			var _item_disabled = ce_struct_get(_item, "disabled", false);

			var _mouse_in_rectangle = forms_mouse_over_rectangle(
				forms_pen_get_x(_pen), forms_pen_get_y(_pen),
				_dropdown[? "width"], forms_line_height,
				_id);

			var _mouse_over = (!_item_disabled && _mouse_in_rectangle);

			if (_mouse_over && mouse_check_button_pressed(mb_left))
			{
				forms_steal_mouse_input(_id);
			}

			if (_mouse_over || forms_has_mouse_input(_id))
			{
				ce_draw_rectangle(2, forms_pen_get_y(_pen), _dropdown[? "width"] - 4, forms_line_height, $A09389);
			}
			else if (_current == _item_value)
			{
				ce_draw_rectangle(2, forms_pen_get_y(_pen), _dropdown[? "width"] - 4, forms_line_height, $786B61);
			}
	
			if (_mouse_over && forms_mouse_lost_input == _id)
			{
				forms_set_retval(_dropdown[? "target"], _item_value);
				forms_close_dropdown();
			}

			forms_text(_pen, _item_text);
			forms_pen_newline(_pen);

			++i;
		}

		// Set dropdown size
		var _content_size = forms_pen_get_max_coordinates(_pen);
		var _dropdown_width = min(max(_content_size[0] + 10, _dropdown[? "width"]), forms_window_width);
		var _dropdown_height = min(_content_size[1] + 2, forms_window_height);
		forms_widget_set_width(_dropdown, _dropdown_width);
		forms_widget_set_height(_dropdown, _dropdown_height);
		forms_container_set_content_width(_dropdown, _dropdown_width);
		forms_container_set_content_height(_dropdown, _dropdown_height);
		forms_end_fill(_dropdown);
	}

	// Draw dropdown
	forms_canvas_draw(_dropdown);
}

/// @func forms_dropdown_update(_dropdown)
function forms_dropdown_update(_dropdown)
{
	forms_container_update(_dropdown);

	// Clamp position
	forms_widget_set_position(_dropdown,
		min(forms_widget_get_x(_dropdown), forms_window_width - forms_widget_get_width(_dropdown)),
		min(forms_widget_get_y(_dropdown), forms_window_height - forms_widget_get_height(_dropdown)));
}

/// @func forms_close_dropdown()
function forms_close_dropdown()
{
	if (__forms_dropdown != noone)
	{
		forms_widget_destroy(__forms_dropdown);
		__forms_dropdown = noone;
	}
}

/// @func forms_show_dropdown(_dropdown, _x, _y)
function forms_show_dropdown(_dropdown, _x, _y)
{
	forms_close_dropdown();
	__forms_dropdown = _dropdown;
	forms_widget_set_position(_dropdown, _x, _y);
	forms_add_item(forms_root, _dropdown);
}