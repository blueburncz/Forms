/// @func FORMS_ContextMenu()
///
/// @extends FORMS_Container
function FORMS_ContextMenu()
	: FORMS_Container() constructor
{
	Type = FORMS_EWidgetType.ContextMenu;

	Depth = 2147483647;

	static OnUpdate = function ()
	{
		FORMS_ContextMenuUpdate(self);
	}

	static OnDraw = function ()
	{
		FORMS_ContextMenuDraw(self);
	};
}

/// @func FORMS_CanShowContextMenu()
///
/// @desc Gets whether the context menu can be opened.
///
/// @return {Bool} True if the context menu can be opened.
function FORMS_CanShowContextMenu()
{
	gml_pragma("forceinline");
	return (window_mouse_get_x() == FORMS_MOUSE_PRESS_X
		&& window_mouse_get_y() == FORMS_MOUSE_PRESS_Y
		&& !keyboard_check(vk_alt));
}

/// @func FORMS_ContextMenuDraw(_contextMenu)
///
/// @desc Draws the context menu.
///
/// @param {Struct.FORMS_ContextMenu} _contextMenu The context menu.
function FORMS_ContextMenuDraw(_contextMenu)
{
	if (_contextMenu.BeginFill())
	{
		var _contextMenuItems = FORMS_GetItems(_contextMenu);
		var _x = 0;
		var _y = 4;
		var _width = 1;

		// Draw items
		var _size = ds_list_size(_contextMenuItems);
		for (var i = 0; i < _size; ++i)
		{
			var _item = _contextMenuItems[| i];
			FORMS_DrawItem(_item, 0, _y);
			_width = max(_width, _item.Width);
			_y += _item.Height;
		}

		// Set context menu size
		var _contextMenuWidth = clamp(_width, 200, window_get_width());
		var _contextMenuHeight = min(_y + 4, window_get_height());
		_contextMenu.SetWidth(_contextMenuWidth);
		_contextMenu.SetHeight(_contextMenuHeight);
		_contextMenu.SetContentWidth(_contextMenuWidth);
		_contextMenu.SetContentHeight(_contextMenuHeight);
		_contextMenu.EndFill();
	}

	// Draw context menu
	var _surface = _contextMenu.Surface;
	if (surface_exists(_surface))
	{
		var _x = _contextMenu.X;
		var _y = _contextMenu.Y;
		var _width = surface_get_width(_surface);
		var _height = surface_get_height(_surface);
		if (_width > 1
			&& _height > 1)
		{
			//FORMS_DrawShadow(_x, _y, _width, _height, FORMS_GetColor(FORMS_EStyle.Shadow), FORMS_GetColor(FORMS_EStyle.ShadowAlpha));
			FORMS_DrawRectangle(_x - 1, _y - 1, _width + 2, _height + 2, FORMS_GetColor(FORMS_EStyle.WindowBorder), 1);
		}
	}
	FORMS_CanvasDraw(_contextMenu);
}

/// @func FORMS_ContextMenuUpdate(_contextMenu)
///
/// @desc Updates the context menu.
///
/// @param {Struct.FORMS_ContextMenu} _contextMenu The context menu.
function FORMS_ContextMenuUpdate(_contextMenu)
{
	FORMS_ContainerUpdate(_contextMenu);

	// Clamp position
	_contextMenu.SetPosition(
		min(_contextMenu.X, window_get_width() - _contextMenu.Width),
		min(_contextMenu.Y, window_get_height() - _contextMenu.Height));
}

/// @func FORMS_ShowContextMenu(_contextMenu[, _x, _y])
///
/// @desc Shows the context menu.
///
/// @param {Struct.FORMS_ContextMenu} _contextMenu The context menu to show.
/// @param {Real} [_x] The x position to show the context menu at.
/// @param {Real} [_y] The y position to show the context menu at.
///
/// @note If the position coordinates are not specified, then the current
/// window mouse position is used.
function FORMS_ShowContextMenu(_contextMenu, _x=window_mouse_get_x(), _y=window_mouse_get_y())
{
	if (FORMS_CONTEXT_MENU)
	{
		FORMS_DestroyWidget(FORMS_CONTEXT_MENU);
	}
	FORMS_CONTEXT_MENU = _contextMenu;
	FORMS_CONTEXT_MENU.SetPosition(_x, _y);
	FORMS_ROOT.AddItem(FORMS_CONTEXT_MENU);
}
