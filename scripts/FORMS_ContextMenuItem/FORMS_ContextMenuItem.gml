/// @func FORMS_ContextMenuItem(_name[, _action[, _shortcut[, _tooltip]]])
///
/// @extends FORMS_Widget
///
/// @param {String} _name The of the context menu item.
/// @param {Function, Undefined} [_action] The function that will be executed on click or
/// `undefined`.
/// @param {Struct.FORMS_KeyboardShortcut, Undefined} [_shortcut] The keyboard shortcut for this item.
/// @param {String, Undefined} [_tooltip] The tooltip text that will show up on mouse over.
/// If you don't specify the action then this is not used.
function FORMS_ContextMenuItem(_name, _action=undefined, _shortcut=undefined, _tooltip=undefined)
	: FORMS_Widget() constructor
{
	static Type = FORMS_EWidgetType.ContextMenuItem;

	Name = _name;

	OnAction = _action;

	Shortcut = _shortcut;

	Tooltip = _tooltip;

	Height = FORMS_LINE_HEIGHT;

	static OnUpdate = function ()
	{
		FORMS_ContextMenuItemUpdate(self);
	};

	static OnDraw = function ()
	{
		FORMS_ContextMenuItemDraw(self);
	};
}

/// @func FORMS_ContextMenuItemDraw(_contextMenuItem)
///
/// @desc Draws the context menu item.
///
/// @param {Real} _contextMenuItem The context menu item.
function FORMS_ContextMenuItemDraw(_contextMenuItem)
{
	var _item = _contextMenuItem;
	var _x = _item.X;
	var _y = _item.Y;
	var _height = _item.Height;
	var _name = _item.Name;
	var _parent = _item.Parent;
	var _scrAction = _item.OnAction;
	var _textColour = FORMS_GetColor(FORMS_EStyle.Disabled);
	var _parentWidth = _parent.Width;

	var _shortcut = _item.Shortcut;
	var _shortcutWidth = 0;

	// Draw highlight
	if (_scrAction != undefined)
	{
		_textColour = FORMS_GetColor(FORMS_EStyle.Text);
		if (_item.IsHovered())
		{
			FORMS_DrawRectangle(_x, _y, _parentWidth, _height, FORMS_GetColor(FORMS_EStyle.Active), 1);
		}
	}

	// Draw item name
	draw_text_colour(_x + 8, _y + round((_height - FORMS_FONT_HEIGHT) * 0.5), _name,
		_textColour, _textColour, _textColour, _textColour, 1);

	// Draw keyboard shortcut
	if (_shortcut != undefined)
	{
		var _shortcutText = _shortcut.ToString();
		_shortcutWidth = string_width(_shortcutText) + 8;
		draw_text_colour(_x + _parentWidth - _shortcutWidth,
			_y + round((_height - FORMS_FONT_HEIGHT) * 0.5),
			_shortcutText,
			_textColour, _textColour, _textColour, _textColour, 1);
		_shortcutWidth += FORMS_FONT_WIDTH * 2;
	}

	_item.SetWidth(max(_x + string_width(_name) + _shortcutWidth, _parentWidth));
}

/// @func FORMS_ContextMenuItemUpdate(_contextMenuItem)
///
/// @desc Updates the context menu item.
///
/// @param {Real} _contextMenuItem The context menu item.
function FORMS_ContextMenuItemUpdate(_contextMenuItem)
{
	var _item = _contextMenuItem;
	FORMS_WidgetUpdate(_item);

	if (mouse_check_button_pressed(mb_left)
		&& _item.IsHovered())
	{
		var _scrAction = _item.OnAction;
		if (_scrAction != undefined)
		{
			_scrAction();
			FORMS_DestroyWidget(_item.Parent);
			FORMS_CONTEXT_MENU = undefined;
		}
	}
}
