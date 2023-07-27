/// @func FORMS_MenuBarItem(_name[, _scrContextMenu])
///
/// @extends FORMS_Widget
///
/// @param {String} _name The name of the item.
/// @param {Function, Undefined} [_scrContextMenu] The script that opens a context menu
/// for this item or `undefined`.
function FORMS_MenuBarItem(_name, _scrContextMenu=undefined)
	: FORMS_Widget() constructor
{
	static Type = FORMS_EWidgetType.MenuBarItem;

	/// @var {String}
	Name = _name;

	/// @var {Function, Undefined}
	OnContextMenu = _scrContextMenu;

	/// @var {Real}
	/// @readonly
	/// @private
	Index = -1;

	static OnUpdate = function ()
	{
		FORMS_MenuBarItemUpdate(self);
	};

	static OnDraw = function ()
	{
		FORMS_MenuBarItemDraw(self);
	};

	SetHeight(FORMS_LINE_HEIGHT);
}

/// @func FORMS_MenuBarItemDraw(_menuBarItem)
///
/// @desc Draws the menu bar item.
///
/// @param {Struct.FORMS_MenuBarItem} _menuBarItem The menu bar item.
function FORMS_MenuBarItemDraw(_menuBarItem)
{
	var _item = _menuBarItem;
	var _x = _item.X;
	var _y = _item.Y;
	var _height = _item.Height;
	var _name = _item.Name;
	var _padding = 4;
	var _width = _item.Width;
	if (_width == 1)
	{
		_width = string_width(_name) + _padding * 2;
		_item.SetWidth(_width);
	}

	// Draw background
	var _parent = _item.Parent;
	if (_parent.Current == _item.Index)
	{
		FORMS_DrawRectangle(_x, _y, _width, _height, FORMS_GetColor(FORMS_EStyle.Active), 1);
	}
	else if (_item.IsHovered())
	{
		FORMS_DrawRectangle(_x, _y, _width, _height, FORMS_GetColor(FORMS_EStyle.Highlight), 1);
	}

	// Text
	draw_text(_x + _padding, _y + round((_height - FORMS_FONT_HEIGHT) * 0.5), _name);
}

/// @func FORMS_MenuBarItemUpdate(_menuBarItem)
///
/// @desc Updates the menu bar item.
///
/// @param {Struct.FORMS_MenuBarItem} _menuBarItem The menu bar item.
function FORMS_MenuBarItemUpdate(_menuBarItem)
{
	var _item = _menuBarItem;
	FORMS_WidgetUpdate(_item);

	var _index = _item.Index;
	var _scrContextMenu = _item.OnContextMenu;
	if (_scrContextMenu != undefined
		&& _item.IsHovered())
	{
		var _parent = _item.Parent;
		var _current = _parent.Current;

		if (mouse_check_button_pressed(mb_left))
		{
			if (_current == -1)
			{
				// Enable opening the context menus for the menu bar
				_parent.Current = _index;
			}
			else
			{
				// Close context menu
				_parent.Current = -1;
				FORMS_DestroyWidget(FORMS_CONTEXT_MENU);
			}
		}

		// Open the context menu for this item
		if (_parent.Current != -1)
		{
			_parent.Current = _index;
			if (_current != _index)
			{
				var _contextMenu = new FORMS_ContextMenu();
				_scrContextMenu(_contextMenu);
				FORMS_ShowContextMenu(_contextMenu,
					_item.X,
					_parent.Y + _parent.Height + 1);
			}
		}
	}
}
