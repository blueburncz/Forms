/// @func FORMS_MenuBar([_items[, _props]])
///
/// @extends FORMS_Container
///
/// @desc
///
/// @param {Array<Struct.FORMS_MenuBarItem>} [_items]
/// @param {Struct.FORMS_ContainerProps, Undefined} [_props]
function FORMS_MenuBar(_items=[], _props=undefined)
	: FORMS_Container(undefined, _props) constructor
{
	static Container_update = update;

	set_content(new FORMS_MenuBarContent());

	Width.from_props(_props, "Width", 100, FORMS_EUnit.Percent);
	Height.from_props(_props, "Height", 24, FORMS_EUnit.Pixel);

	/// @var {Array<Struct.FORMS_MenuBarItem>}
	/// @private
	__items = _items;

	/// @var {Real}
	/// @private
	__itemCurrent = -1;

	/// @private
	__contextMenu = undefined;

	static update = function (_deltaTime)
	{
		Container_update(_deltaTime);
		if (__contextMenu != undefined && !weak_ref_alive(__contextMenu))
		{
			__contextMenu = undefined;
			__itemCurrent = -1;
		}
		return self;
	};
}

/// @func FORMS_MenuBarItem(_name[, _contextMenu])
///
/// @desc
///
/// @param {String} _name
/// @param {Function, Undefined} [_contextMenu]
function FORMS_MenuBarItem(_name, _contextMenu=undefined) constructor
{
	/// @var {String}
	Name = _name;

	/// @var {Function, Undefined}
	ContextMenu = _contextMenu;
}

/// @func FORMS_MenuBarContent()
///
/// @extends FORMS_Content
///
/// @desc
function FORMS_MenuBarContent()
	: FORMS_Content() constructor
{
	static draw = function ()
	{
		var _menu = Container;
		var _items = _menu.__items;
		var _itemCurrent = _menu.__itemCurrent;
		var _itemIndex = 0;
		var _contextMenuY = Container.__realY + Container.__realHeight;

		Pen.start(8, 4);

		repeat (array_length(_items))
		{
			var _item = _items[_itemIndex];
			var _itemX = Container.__realX + Pen.X - 8;

			var _link = Pen.link(_item.Name, {
				Color: (_itemIndex == _itemCurrent) ? c_orange : c_white,
				Disabled: (_item.ContextMenu == undefined),
			});

			if ((_link == 1
				|| (_link == -1 && _menu.__contextMenu != undefined && _menu.__itemCurrent != _itemIndex))
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
	};
}
