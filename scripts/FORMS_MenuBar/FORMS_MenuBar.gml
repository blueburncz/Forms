/// @func FORMS_MenuBar()
///
/// @extends FORMS_Canvas
function FORMS_MenuBar()
	: FORMS_Canvas() constructor
{
	static Type = FORMS_EWidgetType.MenuBar;

	/// @var {Real} The index of the currently selected menu or -1.
	/// @private
	Current = -1;

	static Canvas_AddItem = AddItem;

	/// @func AddItem(_menuBarItem)
	///
	/// @desc Adds the item to the menu bar.
	///
	/// @param {Struct.FORMS_MenuBarItem} _menuBarItem The menu bar item.
	static AddItem = function (_menuBarItem)
	{
		gml_pragma("forceinline");
		_menuBarItem.Index = Canvas_AddItem(_menuBarItem);
	};

	static OnUpdate = function ()
	{
		FORMS_MenuBarUpdate(self);
	};

	static OnDraw = function ()
	{
		FORMS_MenuBarDraw(self);
	};

	SetHeight(FORMS_LINE_HEIGHT);
}

/// @func FORMS_MenuBarDraw(_menuBar)
///
/// @desc Draws the menu bar.
///
/// @param {Struct.FORMS_MenuBar} _menuBar The menu bar.
function FORMS_MenuBarDraw(_menuBar)
{
	var _menu = _menuBar;
	if (_menu.BeginFill())
	{
		var _x = 0;
		var _y = 0;
		var _items = FORMS_GetItems(_menu);
		var _size = ds_list_size(_items);

		for (var i = 0; i < _size; ++i)
		{
			var _item = _items[| i];
			FORMS_DrawItem(_item, _x, _y);
			_x += _item.Width;
		}

		_menu.EndFill();
	}

	FORMS_CanvasDraw(_menu);
}

/// @func FORMS_MenuBarUpdate(_menuBar)
///
/// @desc Updates the menu bar.
///
/// @param {Struct.FORMS_MenuBar} _menuBar The menu bar.
function FORMS_MenuBarUpdate(_menuBar)
{
	var _menu = _menuBar;
	FORMS_CompoundWidgetUpdate(_menu);

	if (_menu.Current != -1
		&& FORMS_CONTEXT_MENU == undefined)
	{
		_menu.Current = -1;
		FORMS_RequestRedraw(_menu);
	}
}
