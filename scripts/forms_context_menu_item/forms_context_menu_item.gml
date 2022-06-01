function FORMS_ContextMenuItem() {}

/// @func forms_context_menu_item_create(name, action[, icon[, shortcut[, tooltip]])
/// @desc Creates a new context menu item with given name.
/// @param {string} name The of the context menu item.
/// @param {real} action The script that will be executed on click, or noone.
/// @param {FORMS_EIcon} [icon] An icon. Defaults to `noone`.
/// @param {real} [shortcut] The id of the keyboard shortcut for this item.
/// @param {string} [tooltip] The tooltip text that will show up on mouse over.
/// If you don't specify the action then this is not used.
/// @return {real} The id of the created context menu item.
function forms_context_menu_item_create(name, action, _icon=noone, _shortcut=noone, _tooltip="")
{
	var context_menu_item = forms_widget_create(FORMS_ContextMenuItem);
	context_menu_item[? "name"] = name;
	context_menu_item[? "icon"] = _icon;
	context_menu_item[? "scr_action"] = action;
	context_menu_item[? "scr_update"] = forms_context_menu_item_update;
	context_menu_item[? "scr_draw"] = forms_context_menu_item_draw;
	forms_widget_set_height(context_menu_item, forms_line_height);
	context_menu_item[? "shortcut"] = _shortcut;
	if (_tooltip != "" && context_menu_item[? "scr_action"] != noone)
	{
		forms_widget_set_tooltip(context_menu_item, _tooltip);
	}
	return context_menu_item;
}

/// @func forms_context_menu_item_draw(context_menu_item)
/// @desc Dras the context menu item.
/// @param {real} context_menu_item The id of the context menu item.
function forms_context_menu_item_draw(context_menu_item)
{
	var _x = forms_widget_get_x(context_menu_item);
	var _y = forms_widget_get_y(context_menu_item);
	var _width = forms_widget_get_width(context_menu_item);
	var _height = forms_widget_get_height(context_menu_item);
	var _name = context_menu_item[? "name"];
	var _icon = context_menu_item[? "icon"];
	var _delegate = forms_widget_get_delegate(context_menu_item);
	var _disable_icons = _delegate[? "disable_icons"];
	var _scr_action = context_menu_item[? "scr_action"];
	var _text_color = FORMS_C_DISABLED;
	var _delegate_width = forms_widget_get_width(_delegate);

	var _shortcut = context_menu_item[? "shortcut"];
	var _shortcut_width = 0;

	// Draw highlight
	var _highlight_x = _x + ((FORMS_ICON_SIZE + 5) * !_disable_icons);

	if (_scr_action != noone)
	{
		_text_color = FORMS_C_TEXT;
		if (forms_widget_is_hovered(context_menu_item))
		{
			ce_draw_rectangle(_highlight_x, _y, _delegate_width, _height, $584D47);
		}
	}

	// Draw icon
	if (!_disable_icons && _icon != noone)
	{
		forms_icon(forms_pen_create(_x + 2, _y), _icon);
	}

	// Draw item name
	forms_draw_text(forms_pen_create(_highlight_x + 8, _y), _name, _text_color);

	// Draw keyboard shortcut
	if (_shortcut != noone)
	{
		var _shortcut_text = forms_keyboard_shortcut_to_string(_shortcut);
		_shortcut_width = string_width(_shortcut_text) + 8;
		draw_text_color(
			_x + _delegate_width - _shortcut_width,
			_y + round((_height - forms_font_height) * 0.5),
			_shortcut_text,
			_text_color, _text_color, _text_color, _text_color, 1);
		_shortcut_width += forms_font_width * 2;
	}

	forms_widget_set_width(context_menu_item, max(_x + string_width(_name) + _shortcut_width + 32, _delegate_width));
}

/// @func forms_context_menu_item_update(context_menu_item)
/// @desc Updates the context menu item.
/// @param {real} context_menu_item The id of the context menu item.
function forms_context_menu_item_update(context_menu_item)
{
	forms_widget_update(context_menu_item);

	if (mouse_check_button_pressed(mb_left)
		&& forms_widget_is_hovered(context_menu_item))
	{
		var _scr_action = context_menu_item[? "scr_action"];
		if (_scr_action != noone)
		{
			_scr_action();
			forms_widget_destroy(forms_widget_get_delegate(context_menu_item));
			__forms_context_menu = noone;
		}
	}
}