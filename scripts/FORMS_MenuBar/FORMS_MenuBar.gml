/// @func FORMS_MenuBarProps()
///
/// @extends FORMS_ContainerProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_MenuBar}.
function FORMS_MenuBarProps(): FORMS_ContainerProps() constructor {}

/// @func FORMS_MenuBar([_items[, _props]])
///
/// @extends FORMS_Container
///
/// @desc A bar with dropdown menus, usually placed at the top of the
/// application window.
///
/// @param {Array<Struct.FORMS_MenuBarItem>} [_items] An array of items in the
/// menu bar.
/// @param {Struct.FORMS_MenuBarProps, Undefined} [_props] Properties to create
/// the menu bar with or `undefined` (default).
function FORMS_MenuBar(_items = [], _props = undefined): FORMS_Container(_props) constructor
{
	static Container_update = update;

	/// @var {Array<Struct.FORMS_MenuBarItem>}
	/// @private
	__items = _items;

	/// @var {Real}
	/// @private
	__itemCurrent = -1;

	/// @var {Struct.WeakRef<Struct.FORMS_Widget>, Undefined}
	/// @private
	__contextMenu = undefined;

	/// @var {Struct.FORMS_UnitValue} The widget's width. Defaults to 100%.
	Width = Width.from_props(_props, "Width", 100, FORMS_EUnit.Percent);

	/// @var {Struct.FORMS_UnitValue} The widget's height. Defaults to
	/// 24px.
	Height = Height.from_props(_props, "Height", 24, FORMS_EUnit.Pixel);

	static draw_content = function ()
	{
		var _menu = self;
		var _items = _menu.__items;
		var _itemCurrent = _menu.__itemCurrent;
		var _itemIndex = 0;
		var _contextMenuY = __realY + __realHeight;

		Pen.PaddingY = 4;
		Pen.start();

		repeat(array_length(_items))
		{
			var _item = _items[_itemIndex];
			var _itemX = __realX + Pen.X - 8;

			var _link = Pen.link(_item.Name,
			{
				Color: (_itemIndex == _itemCurrent) ? c_white : c_silver,
				Disabled: (_item.ContextMenu == undefined),
			});

			if ((_link == 1
					|| (_link == -1 && _menu.__contextMenu != undefined && _menu.__itemCurrent
						!= _itemIndex)
				)
				&& _item.ContextMenu != undefined)
			{
				if (_menu.__contextMenu != undefined)
				{
					_menu.__contextMenu.ref.destroy_later();
					_menu.__contextMenu = undefined;
				}

				var _itemContextMenu = new _item.ContextMenu();
				_itemContextMenu.X.Value = _itemX;
				_itemContextMenu.Y.Value = _contextMenuY;
				_menu.__contextMenu = weak_ref_create(_itemContextMenu);

				forms_get_root().add_child(_itemContextMenu);

				_itemCurrent = _itemIndex;
				_menu.__itemCurrent = _itemCurrent;
			}

			Pen.move(20);
			++_itemIndex;
		}

		Pen.finish();
		return self;
	}

	static update = function (_deltaTime)
	{
		Container_update(_deltaTime);
		if (__contextMenu != undefined && !weak_ref_alive(__contextMenu))
		{
			__contextMenu = undefined;
			__itemCurrent = -1;
		}
		return self;
	}
}

/// @func FORMS_MenuBarItem(_name[, _contextMenu])
///
/// @desc An item in a {@link FORMS_MenuBar}.
///
/// @param {String} _name The name of the menu item.
/// @param {Function, Undefined} [_contextMenu] A constructor of a struct that
/// inherits from {@link FORMS_ContextMenu} to be created when the menu item is
/// selected, or `undefined` (default).
function FORMS_MenuBarItem(_name, _contextMenu = undefined) constructor
{
	/// @var {String} The name of the menu item.
	Name = _name;

	/// @var {Function, Undefined} A constructor of a struct that inherits from
	/// {@link FORMS_ContextMenu} to be created when the menu item is selected,
	/// or `undefined` (default).
	ContextMenu = _contextMenu;
}
