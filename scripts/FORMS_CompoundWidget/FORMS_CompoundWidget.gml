/// @func FORMS_CompoundWidget()
///
/// @extends FORMS_Widget
function FORMS_CompoundWidget()
	: FORMS_Widget() constructor
{
	static Type = FORMS_EWidgetType.Compound;

	/// @var {ds_list<Struct.FORMS_Widget>}
	/// @readonly
	Items = ds_list_create();

	/// @func AddItem(_item)
	///
	/// @desc Adds item to the compound widget while preserving depth order.
	///
	/// @param {Struct.FORMS_Widget} _item The item to be added.
	///
	/// @return {Real} The index where the item has been placed at.
	static AddItem = function (_item)
	{
		var _index = ds_list_size(Items);
		while (_index > 0)
		{
			if (Items[| _index - 1].Depth > _item.Depth)
			{
				--_index;
			}
			else
			{
				break;
			}
		}
		ds_list_insert(Items, _index, _item);
		_item.Parent = self;
		return _index;
	};

	static OnUpdate = function ()
	{
		FORMS_CompoundWidgetUpdate(self);
	};

	static OnCleanUp = function ()
	{
		FORMS_CompoundWidgetCleanUp(self);
	};
}

/// @func FORMS_CompoundWidgetCleanUp(_compoundWidget)
///
/// @desc Frees resources used by the compound widget from memory.
///
/// @param {Struct.FORMS_CompoundWidget} _compoundWidget The compound widget.
function FORMS_CompoundWidgetCleanUp(_compoundWidget)
{
	var _items = FORMS_GetItems(_compoundWidget);
	while (ds_list_size(_items) > 0)
	{
		var _item = _items[| 0];
		_item.OnCleanUp();
	}
	FORMS_WidgetCleanUp(_compoundWidget);
}

/// @func FORMS_CompoundWidgetUpdate(_compoundWidget)
///
/// @desc Updates the compound widget.
///
/// @param {Struct.FORMS_CompoundWidget} _compoundWidget The compound widget.
function FORMS_CompoundWidgetUpdate(_compoundWidget)
{
	FORMS_WidgetUpdate(_compoundWidget);

	////////////////////////////////////////////////////////////////////////////
	// Remove deleted items
	var _items = FORMS_GetItems(_compoundWidget);
	for (var i = ds_list_size(_items) - 1; i >= 0; --i)
	{
		var _item = _items[| i];
		if (!FORMS_WidgetExists(_item))
		{
			ds_list_delete(_items, i);
		}
	}
}

/// @func FORMS_DrawItem(_item[, _x, _y])
///
/// @desc Draws the item.
///
/// @param {Struct.FORMS_Widget} _item The item.
/// @param {Real} [_x] The x position to draw the item at.
/// @param {Real} [_y] The y position to draw the item at.
function FORMS_DrawItem(_item, _x=undefined, _y=undefined)
{
	gml_pragma("forceinline");
	if (_x != undefined && _y != undefined)
	{
		_item.SetPosition(_x, _y);
	}
	_item.OnUpdate();
	_item.OnDraw();
	_item.Redraw = false;
}

/// @func FORMS_MatrixPush(_x, _y)
///
/// @desc Stores the current matrix into the matrix stack
/// and then pushes the coordinate system by the
/// given values.
///
/// @param {Real} _x The value to push the coordinate system by on the x axis.
/// @param {Real} _y The value to push the coordinate system by on the y axis.
function FORMS_MatrixPush(_x, _y)
{
	gml_pragma("forceinline");
	var _matWorld = matrix_get(matrix_world);
	ds_stack_push(FORMS_MATRIX_STACK, _matWorld);
	matrix_set(matrix_world,
		matrix_multiply(_matWorld, matrix_build(_x, _y, 0, 0, 0, 0, 1, 1, 1)));
}

/// @func FORMS_MatrixRestore()
///
/// @desc Restores coordinate system by popping matrix from
/// the top of the matrix stack.
function FORMS_MatrixRestore()
{
	gml_pragma("forceinline");
	matrix_set(matrix_world, ds_stack_pop(FORMS_MATRIX_STACK));
}

/// @func FORMS_MatrixSet(_x, _y)
///
/// @desc Stores the current matrix into the matrix stack
/// and sets the origin of the coordinate system to
/// the given values.
///
/// @param {Real} _x The origin on the x axis.
/// @param {Real} _y The origin on the y axis.
function FORMS_MatrixSet(_x, _y)
{
	gml_pragma("forceinline");
	ds_stack_push(FORMS_MATRIX_STACK, matrix_get(matrix_world));
	matrix_set(matrix_world, matrix_build(_x, _y, 0, 0, 0, 0, 1, 1, 1));
}

/// @func FORMS_MoveItemToTop(_item)
///
/// @desc Moves the item to the top while preserving depth order.
///
/// @param {Struct.FORMS_Widget} _item The item to move.
function FORMS_MoveItemToTop(_item)
{
	var _parent = _item.Parent;

	if (!FORMS_WidgetExists(_parent))
	{
		return;
	}

	var _items = FORMS_GetItems(_parent);
	var _n = ds_list_size(_items);
	var _index = ds_list_find_index(_items, _item);

	if (_index >= 0)
	{
		var i = _index + 1;
		var _itemDepth = _item.Depth;

		while (i < _n && _items[| i].Depth <= _itemDepth)
		{
			++i;
		}

		ds_list_insert(_items, i, _item);
		ds_list_delete(_items, _index);
	}
}

/// @func FORMS_GetItems(_widget)
///
/// @desc Gets the list of items of the widget.
///
/// @param {Struct.FORMS_Widget} _widget The widget.
///
/// @return {Id.DsList<Struct.FORMS_Widget>, Undefined} The list of items of the
/// widget or `undefined`, if the widget is not {@link FORMS_CompoundWidget}.
function FORMS_GetItems(_widget)
{
	gml_pragma("forceinline");
	return variable_struct_exists(_widget, "Items")
		? _widget.Items
		: undefined;
}


/// @func FORMS_FindWidget(_items, _mouseX, _mouseY)
///
/// @desc Recursively finds widget on the given position in the list of widgets.
///
/// @param {Id.DsList<Struct.FORMS_Widget>} _items The list of widgets.
/// @param {Real} _mouseX The x position to find a widget at.
/// @param {Real} _mouseY The y position to find a widget at.
///
/// @return {Struct.FORMS_Widget, Undefined} The widget found or `undefined`.
function FORMS_FindWidget(_items, _mouseX, _mouseY)
{
	for (var i = ds_list_size(_items) - 1; i >= 0; --i)
	{
		var _item = _items[| i];
		var _x = _item.X;
		var _y = _item.Y;

		if (_mouseX > _x
			&& _mouseY > _y
			&& _mouseX < _x + _item.Width
			&& _mouseY < _y + _item.Height)
		{
			_item.Redraw = true;

			// Skip hidden scrollbars
			if (_item.Type == FORMS_EWidgetType.Scrollbar
				&& !_item.IsVisible())
			{
				continue;
			}

			// Check if scrollbars are hovered
			var _scrollX = 0;
			var _scrollY = 0;
			var _scrollbarHor = FORMS_GetScrollbarHor(_item);
			var _scrollbarVer = FORMS_GetScrollbarVer(_item);
			var _scrollbars = ds_list_create();

			if (!is_undefined(_scrollbarHor))
			{
				ds_list_add(_scrollbars, _scrollbarHor);
				_scrollX = _scrollbarHor.GetScroll() * _scrollbarHor.IsVisible();
			}
			if (!is_undefined(_scrollbarVer))
			{
				ds_list_add(_scrollbars, _scrollbarVer);
				_scrollY = _scrollbarVer.GetScroll() * _scrollbarVer.IsVisible();
			}

			if (is_nan(_scrollX)) _scrollX = 0;
			if (is_nan(_scrollY)) _scrollY = 0;

			var _hovered = undefined;
			if (!ds_list_empty(_scrollbars))
			{
				_hovered = FORMS_FindWidget(_scrollbars, _mouseX - _x + _scrollX, _mouseY - _y + _scrollY);
			}
			ds_list_destroy(_scrollbars);
			if (FORMS_WidgetExists(_hovered))
			{
				return _hovered;
			}

			// Find hovered item
			var _subItems = FORMS_GetItems(_item);
			if (!is_undefined(_subItems))
			{
				_hovered = FORMS_FindWidget(_subItems, _mouseX - _x + _scrollX, _mouseY - _y + _scrollY);
				if (FORMS_WidgetExists(_hovered))
				{
					return _hovered;
				}
			}

			return _item;
		}
	}
	return undefined;
}
