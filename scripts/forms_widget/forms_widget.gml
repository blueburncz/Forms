/// @func FORMS_Widget()
///
/// @desc Base struct for widgets.
function FORMS_Widget() constructor
{
	/// @var {FORMS_EWidgetType} The type of the widget.
	/// @readonly
	/// @see FORMS_EWidgetType
	static Type = FORMS_EWidgetType.Blank;

	/// @private
	static IdNext = 0;

	/// @var {Real} The id of the widget.
	/// @readonly
	Id = IdNext++;

	/// @var {Struct.FORMS_CompoundWidget} The widget's parent or `undefined`.
	/// @readonly
	Parent = undefined;

	/// @var {Real} The widget's position on the X axis.
	X = 0;

	/// @var {Real} The widget's position on the Y axis.
	Y = 0;

	/// @var {Real} The widget's width.
	Width = 1;

	/// @var {Real} The widget's height.
	Height = 1;

	/// @var {Real} The widget's depth. User for sorting widgets within its parent.
	Depth = 0;

	/// @var {Bool} If `true` then the widget's content needs to be redrawed.
	Redraw = true;

	/// @var {String} The widget's tooltip displayed on mouse over or `undefined`.
	Tooltip = undefined;

	/// @var {Struct.FORMS_KeyboardShortcut[]} Keyboard shortcuts usable when
	/// the widget
	/// is active.
	/// @readonly
	KeyboardShortcuts = [];

	/// @var {Bool} If `true` then the widget will be destroyed at the end of the
	/// frame and it should not be used anymore.
	/// @private
	Destroyed = false;

	/// @func AddKeyboardShortcut(_keyboardShortcut)
	///
	/// @desc Adds keyboard shortcut to the widget.
	///
	/// @param {Struct.FORMS_KeyboardShortcut} _keyboardShortcut The keyboard
	/// shortcut.
	static AddKeyboardShortcut = function (_keyboardShortcut)
	{
		gml_pragma("forceinline");
		array_push(KeyboardShortcuts, _keyboardShortcut);
	};

	/// @func IsAncestor(_item)
	///
	/// @desc Finds out whether the widget is an ancestor of an item.
	///
	/// @param {Struct.FORMS_Widget} _item The item.
	///
	/// @return {Bool} True if the widget is an ancestor the item.
	static IsAncestor = function (_item)
	{
		if (!FORMS_WidgetExists(_item))
		{
			return false;
		}
		var _parent = _item.Parent;
		if (!FORMS_WidgetExists(_parent))
		{
			return false;
		}
		if (_parent == self)
		{
			return true;
		}
		return IsAncestor(_parent);
	};

	/// @func IsActive()
	///
	/// @desc Gets whether the widget is active.
	///
	/// @return {Bool} True if the widget is active.
	static IsActive = function ()
	{
		gml_pragma("forceinline");
		return (FORMS_WIDGET_ACTIVE == self);
	};

	/// @func IsHovered()
	///
	/// @desc Gets whether the widget is hovered.
	///
	/// @return {Bool} True if the widget is hovered.
	static IsHovered = function ()
	{
		gml_pragma("forceinline");
		return (FORMS_WIDGET_HOVERED == self
			&& (!FORMS_WidgetExists(FORMS_WIDGET_ACTIVE)
			|| FORMS_WIDGET_ACTIVE == self));
	};

	/// @func IsSelected()
	///
	/// @desc Gets whether the widget is selected.
	///
	/// @return {Bool} True if the widget is selected.
	static IsSelected = function ()
	{
		gml_pragma("forceinline");
		return (FORMS_WIDGET_SELECTED == self);
	};

	/// @func GetPositionAbsolute()
	///
	/// @desc Retreives the widget's absolute position on the screen.
	///
	/// @return {Array<Real>} An array `[x, y]` with the the widget's absolute
	/// position on the screen.
	static GetPositionAbsolute = function ()
	{
		var _x = 0;
		var _y = 0;
		var _widget = self;
		while (_widget != undefined)
		{
			_x += _widget.X;
			_y += _widget.Y;
			_widget = _widget.Parent;
		}
		return [_x, _y];
	};

	/// @func SetPosition(_x, _y)
	///
	/// @desc Sets the x and y position of the widget relative to its parent.
	///
	/// @param {Real} _x The new x position.
	/// @param {Real} _y The new y position.
	///
	/// @return {Struct.FORMS_Widget} Returns `self`.
	static SetPosition = function (_x, _y)
	{
		gml_pragma("forceinline");
		X = _x;
		Y = _y;
		return self;
	};

	/// @func SetWidth(_width)
	///
	/// @desc Sets the width of the widget.
	///
	/// @param {Real} _width The new width.
	///
	/// @return {Struct.FORMS_Widget} Returns `self`.
	static SetWidth = function (_width)
	{
		gml_pragma("forceinline");
		Width = max(_width, 1);
		return self;
	};

	/// @func SetHeight(_height)
	///
	/// @desc Sets the height of the widget.
	///
	/// @param {Real} _height The new height.
	///
	/// @return {Struct.FORMS_Widget} Returns `self`.
	static SetHeight = function (_height)
	{
		gml_pragma("forceinline");
		Height = max(_height, 1);
		return self;
	};

	/// @func SetSize(_width, _height)
	///
	/// @desc Sets the width and height of the widget.
	///
	/// @param {Real} _width The new width.
	/// @param {Real} _height The new height.
	///
	/// @return {Struct.FORMS_Widget} Returns `self`.
	static SetSize = function (_width, _height)
	{
		gml_pragma("forceinline");
		SetWidth(_width);
		SetHeight(_height);
		return self;
	};

	/// @func SetRectangle(_widget, _x, _y, _width, _height)
	///
	/// @desc Sets the x and y position of the widget relative to its parent and
	/// its size.
	///
	/// @param {Real} _x The new x position.
	/// @param {Real} _y The new y position.
	/// @param {Real} _width The new width.
	/// @param {Real} _height The new height.
	///
	/// @return {Struct.FORMS_Widget} Returns `self`.
	static SetRectangle = function (_x, _y, _width, _height)
	{
		gml_pragma("forceinline");
		SetPosition(_x, _y);
		SetWidth(_width);
		SetHeight(_height);
		return self;
	};

	static OnUpdate = function ()
	{
		FORMS_WidgetUpdate(self);
	};

	static OnDraw = function () {};

	static OnCleanUp = function ()
	{
		FORMS_WidgetCleanUp(self);
	};
}

/// @func FORMS_DestroyWidget(_widget)
///
/// @desc Destroys the widget.
///
/// @param {Struct.FORMS_Widget} _widget The widget.
function FORMS_DestroyWidget(_widget)
{
	gml_pragma("forceinline");
	if (FORMS_WidgetExists(_widget))
	{
		ds_stack_push(FORMS_DESTROY_STACK, _widget);
	}
}

/// @func FORMS_RequestRedraw(_widget)
///
/// @desc Pushes a redraw request of the given widget to the parent.
///
/// @param {Struct.FORMS_Widget} _widget The widget to redraw.
function FORMS_RequestRedraw(_widget)
{
	while (FORMS_WidgetExists(_widget))
	{
		_widget.Redraw = true;
		_widget = _widget.Parent;
	}
}

/// @func FORMS_RequestRedrawAll(_widget)
///
/// @desc Requests redraw of all child widget.
///
/// @param {Struct.FORMS_Widget} _widget The widget.
function FORMS_RequestRedrawAll(_widget)
{
	_widget.Redraw = true;
	var _items = FORMS_GetItems(_widget);
	if (!is_undefined(_items))
	{
		for (var i = ds_list_size(_items) - 1; i >= 0; --i)
		{
			FORMS_RequestRedrawAll(_items[| i]);
		}
	}
}

/// @func FORMS_WidgetCleanUp(_widget)
///
/// @desc Frees resources used by the widget from memory.
///
/// @param {Struct.FORMS_Widget} _widget The widget.
function FORMS_WidgetCleanUp(_widget)
{
	if (FORMS_WidgetExists(_widget))
	{
		// Remove from parent
		var _parent = _widget.Parent;
		if (FORMS_WidgetExists(_parent))
		{
			var _items = FORMS_GetItems(_parent);
			var _pos = ds_list_find_index(_items, _widget);
			if (_pos >= 0)
			{
				ds_list_delete(_items, _pos);
			}
		}
		_widget.Destroyed = true;
	}
}

/// @func FORMS_WidgetExists(_widget)
///
/// @desc Finds out whether the widget exists.
///
/// @param {Struct.FORMS_Widget} _widget The widget.
///
/// @return {Bool} True if the widget does exist.
function FORMS_WidgetExists(_widget)
{
	try
	{
		// FIXME: Somewhat hacky...
		return (variable_struct_exists(_widget, "Type")
			&& _widget.Type >= 0
			&& _widget.Type < FORMS_EWidgetType.SIZE
			&& variable_struct_exists(_widget, "Destroyed")
			&& !_widget.Destroyed);
	}
	catch (_err)
	{
		return false;
	}
}

/// @func FORMS_WidgetUpdate(_widget)
///
/// @desc Updates the widget.
///
/// @param {Struct.FORMS_Widget} _widget The widget.
function FORMS_WidgetUpdate(_widget)
{
	//_widget.SetSize(_widget.Width, _widget.Height);

	// Set tooltip on mouse over
	if (_widget.IsHovered())
	{
		FORMS_TOOLTIP = _widget.Tooltip;

		// Select widget
		if (mouse_check_button_pressed(mb_any))
		{
			var _exists = FORMS_WidgetExists(FORMS_WIDGET_SELECTED);
			if ((_exists && FORMS_WIDGET_SELECTED != _widget)
				|| !_exists)
			{
				FORMS_RequestRedrawAll(FORMS_ROOT);
			}
			FORMS_WIDGET_SELECTED = _widget;
		}
	}
}


/// @func FORMS_PushMouseCoordinates(_widget)
///
/// @desc Pushes mouse coordinates to be relative to the widget.
///
/// @param {Struct.FORMS_Widget} _widget The widget.
function FORMS_PushMouseCoordinates(_widget)
{
	var _x = _widget.X;
	var _y = _widget.Y;
	var _scrollX = 0;
	var _scrollY = 0;
	var _scrollbarHor = FORMS_GetScrollbarHor(_widget);
	var _scrollbarVer = FORMS_GetScrollbarVer(_widget);

	if (!is_undefined(_scrollbarHor))
	{
		_scrollX = _scrollbarHor.GetScroll() * _scrollbarHor.IsVisible();
	}
	if (!is_undefined(_scrollbarVer))
	{
		_scrollY = _scrollbarVer.GetScroll() * _scrollbarVer.IsVisible();
	}
	if (is_nan(_scrollX)) _scrollX = 0;
	if (is_nan(_scrollY)) _scrollY = 0;

	FORMS_MOUSE_X += -_x + _scrollX;
	FORMS_MOUSE_Y += -_y + _scrollY;

	var _parent = _widget.Parent;
	if (FORMS_WidgetExists(_parent))
	{
		FORMS_PushMouseCoordinates(_parent);
	}
}
