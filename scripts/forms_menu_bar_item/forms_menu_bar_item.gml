function FORMS_MenuBarItem() {}

/// @func forms_menu_bar_item_create(name, scr_context_menu)
/// @desc Creates a new menu bar item.
/// @param {string} name The name of the item.
/// @param {real} scr_context_menu The script that opens a context menu for this item or noone.
/// @return {real} The id of the created menu bar item.
function forms_menu_bar_item_create(name, scr_context_menu)
{
	var menubar_item = forms_widget_create(FORMS_MenuBarItem);
	menubar_item[? "name"] = name;
	menubar_item[? "scr_context_menu"] = scr_context_menu;
	menubar_item[? "scr_update"] = forms_menu_bar_item_update;
	menubar_item[? "scr_draw"] = forms_menu_bar_item_draw;
	menubar_item[? "index"] = noone;
	forms_widget_set_height(menubar_item, forms_line_height);
	return menubar_item;
}

/// @func forms_menu_bar_item_draw(menubar_item)
/// @desc Draws the menu bar item.
/// @param {real} menubar_item The id of the menu bar item.
function forms_menu_bar_item_draw(menubar_item)
{
	var _x = forms_widget_get_x(menubar_item);
	var _y = forms_widget_get_y(menubar_item);
	var _height = forms_widget_get_height(menubar_item);
	var _name = menubar_item[? "name"];
	var _padding = 12;
	var _width = forms_widget_get_width(menubar_item);
	if (_width == 1)
	{
		_width = string_width(_name) + _padding * 2;
		forms_widget_set_width(menubar_item, _width);
	}


	// Draw background
	var _delegate = forms_widget_get_delegate(menubar_item);
	if (_delegate[? "current"] == menubar_item[? "index"]
		|| forms_widget_is_hovered(menubar_item))
	{
		ce_draw_sprite_nine_slice(FORMS_SprMenuItem, 0, _x, _y, _width, _height, false);
	}

	// Text
	draw_text(_x + _padding, _y + round((_height - forms_font_height) * 0.5), _name);
}

/// @func forms_menu_bar_item_update(menubar_item)
/// @desc Updates the menu bar item.
/// @param {real} menubar_item The id of the menu bar item.
function forms_menu_bar_item_update(menubar_item)
{
	forms_widget_update(menubar_item);

	var _index = menubar_item[? "index"];
	var _scr_context_menu = menubar_item[? "scr_context_menu"];
	if (_scr_context_menu != noone
		&& forms_widget_is_hovered(menubar_item))
	{
		var _delegate = forms_widget_get_delegate(menubar_item);
		var _current = _delegate[? "current"];

		if (mouse_check_button_pressed(mb_left))
		{
			if (_current == noone)
			{
				// Enable opening the context menus for the menu bar
				_delegate[? "current"] = _index;
			}
			else
			{
				// Close context menu
				_delegate[? "current"] = noone;
				forms_widget_destroy(__forms_context_menu);
			}
		}

		// Open the context menu for this item
		if (_delegate[? "current"] != noone)
		{
			_delegate[? "current"] = _index;
			if (_current != _index)
			{
				var _context_menu = forms_context_menu_create();
				_context_menu[? "disable_icons"] = true;
				_scr_context_menu(_context_menu);
				forms_show_context_menu(
					_context_menu,
					forms_widget_get_x(menubar_item) + 1,
					forms_widget_get_y(_delegate) + forms_widget_get_height(menubar_item) + 3);
			}
		}
	}
}