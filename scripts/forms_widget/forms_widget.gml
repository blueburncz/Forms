/// @func FORMS_WidgetProps()
///
/// @desc Properties accepted by the constructor of {@link FORMS_Widget}.
function FORMS_WidgetProps() constructor
{
	/// @var {String, Undefined} The unique identifier of the widget.
	Id = undefined;

	/// @var {String, Undefined} The name of the widget.
	Name = undefined;

	/// @var {Real, Undefined} The Font Awesome icon associated with the widget. Use values from {@link FA_ESolid},
	/// {@link FA_ERegular} or {@link FA_EBrands}.
	Icon = undefined;

	/// @var {Asset.GMFont, Undefined} The font used for the icon. Must match with the icon style!
	IconFont = undefined;

	/// @var {Real, String, Undefined} The widget's X position relative to its parent.
	X = undefined;

	/// @var {Real, Undefined} Use values from {@link FORMS_EUnit}.
	XUnit = undefined;

	/// @var {Real, String, Undefined} The widget's Y position relative to its parent.
	Y = undefined;

	/// @var {Real, Undefined} Use values from {@link FORMS_EUnit}.
	YUnit = undefined;

	/// @var {Real, String, Undefined} The widget's width.
	Width = undefined;

	/// @var {Real, Undefined} Use values from {@link FORMS_EUnit}.
	WidthUnit = undefined;

	/// @var {Real, String, Undefined} The widget's height.
	Height = undefined;

	/// @var {Real, Undefined} Use values from {@link FORMS_EUnit}.
	HeightUnit = undefined;

	/// @var {Real, Undefined} A value that represents how much space does the widget take when its parent is
	/// {@link FORMS_FlexBox}. Value 0 means the widget doesn't grow or shrink based on the flex box size.
	Flex = undefined;

	/// @var {Array<Struct.FORMS_KeyboardShortcut>, Undefined} TODO: Add docs
	KeyboardShortcuts = undefined;
}

/// @func forms_get_prop(_props, _name)
///
/// @desc Retrieves a value of a property from given struct.
///
/// @param {Struct, Undefined} _props A struct with properties or `undefined`.
/// @param {String} _name The name of the property.
///
/// @return {Any} Returns the value of the property of `undefined` if it's not present in the given properties struct.
function forms_get_prop(_props, _name)
{
	gml_pragma("forceinline");
	return ((_props != undefined) ? _props[$  _name] : undefined);
}

/// @macro {Code} Must be used in method [layout](./FORMS_Widget.layout.html) of all widgets!
///
/// @example
/// ```gml
/// function MyWidget() : FORMS_Widget() constructor
/// {
///     static Widget_layout = layout; // Backup inherited method
///
///     static layout = function ()
///     {
///         FORMS_LAYOUT_GENERATED;
///         // Your custom layout code here...
///         return self;
///     };
/// }
/// ```
/* beautify ignore:start */
#macro FORMS_LAYOUT_GENERATED \
	if (forms_mouse_in_rectangle(__realX, __realY, __realWidth, __realHeight)) \
	{ \
		forms_get_root().WidgetHovered = self; \
	}
/* beautify ignore:end */

/// @func FORMS_Widget([_props])
///
/// @desc Base struct for all Forms widgets.
///
/// @param {Struct.FORMS_WidgetProps, Undefined} [_props] Properties to create the widget with or `undefined` (default).
function FORMS_Widget(_props = undefined) constructor
{
	/// @private
	static __idNext = 0;

	/// @var {String} A unique identifier of the widget. Defaults to string "Widget" + automatically incremented number.
	Id = forms_get_prop(_props, "Id") ?? $"Widget{__idNext++}";

	/// @var {Real, Undefined} The Font Awesome icon associated with the widget or `undefined` (default). Use values
	/// from {@link FA_ESolid}, {@link FA_ERegular} or {@link FA_EBrands}.
	Icon = forms_get_prop(_props, "Icon");

	/// @var {Asset.GMFont} The font used for the icon. Must match with the icon style! Defaults to `FA_FntSolid12`.
	IconFont = forms_get_prop(_props, "IconFont") ?? FA_FntSolid12;

	/// @var {String} The name of the widget. Defaults to an empty string.
	Name = forms_get_prop(_props, "Name") ?? "";

	/// @var {Struct.FORMS_CompoundWidget, Undefined} The parent of this widget or `undefined`.
	/// @readonly
	Parent = undefined;

	/// @var {Struct.FORMS_UnitValue} The widget's X position relative to its parent widget.
	X = new FORMS_UnitValue().from_props(_props, "X");

	/// @var {Real} The widget's actual X position.
	/// @private
	__realX = 0;

	/// @var {Struct.FORMS_UnitValue} The widget's Y position relative to its parent widget.
	Y = new FORMS_UnitValue().from_props(_props, "Y");

	/// @var {Real} The widget's actual Y position.
	/// @private
	__realY = 0;

	/// @var {Struct.FORMS_UnitValue} The widget's width.
	Width = new FORMS_UnitValue().from_props(_props, "Width");

	/// @var {Real} The widget's actual width.
	/// @private
	__realWidth = 0;

	/// @var {Struct.FORMS_UnitValue} The widget's height.
	Height = new FORMS_UnitValue().from_props(_props, "Height");

	/// @var {Real} The widget's actual height.
	/// @private
	__realHeight = 0;

	/// @var {Real} A value that represents how much space does the widget take when its parent is {@link FORMS_FlexBox}.
	/// Value 0 (default) means the widget doesn't grow or shrink based on the flex box size.
	Flex = forms_get_prop(_props, "Flex") ?? 0;

	/// @var {Bool}
	/// @private
	__toDestroy = false;

	/// @var {Bool}
	/// @private
	__destroyed = false;

	/// @var {Array<Struct.FORMS_KeyboardShortcut>} TODO: Add docs
	KeyboardShortcuts = forms_get_prop(_props, "KeyboardShortcuts") ?? [];

	/// @func exists()
	///
	/// @desc Checks whether the widget exists.
	///
	/// @return {Bool} Returns `true` if the widget exists.
	static exists = function ()
	{
		gml_pragma("forceinline");
		return (!__toDestroy && !__destroyed);
	}

	/// @func get_x()
	///
	/// @desc Retrieves the actual X position of the widget computed in [layout](./FORMS_Widget.layout.html).
	///
	/// @return {Real} The actual widget's position on the X axis.
	static get_x = function ()
	{
		gml_pragma("forceinline");
		return __realX;
	}

	/// @func get_y()
	///
	/// @desc Retrieves the actual Y position of the widget computed in [layout](./FORMS_Widget.layout.html).
	///
	/// @return {Real} The actual widget's position on the Y axis.
	static get_y = function ()
	{
		gml_pragma("forceinline");
		return __realY;
	}

	/// @func get_width()
	///
	/// @desc Retrieves the actual width of the widget computed in [layout](./FORMS_Widget.layout.html).
	///
	/// @return {Real} The actual widget's width.
	static get_width = function ()
	{
		gml_pragma("forceinline");
		return __realWidth;
	}

	/// @func get_height()
	///
	/// @desc Retrieves the actual height of the widget computed in [layout](./FORMS_Widget.layout.html).
	///
	/// @return {Real} The actual widget's height.
	static get_height = function ()
	{
		gml_pragma("forceinline");
		return __realHeight;
	}

	/// @func has_parent()
	///
	/// @desc Checks whether the widget has a parent.
	///
	/// @return {Bool} Returns `true` if the widget has a parent.
	static has_parent = function ()
	{
		gml_pragma("forceinline");
		return (Parent != undefined);
	}

	/// @func remove_child(_child)
	///
	/// @desc Removes a child from this widget.
	///
	/// @param {Struct.FORMS_Widget} _child The child widget to remove.
	///
	/// @return {Struct.FORMS_Widget} Returns `self`.
	static remove_child = function (_child) { return self; }

	/// @func remove_self()
	///
	/// @desc Removes the widgets from its parent, which must not be `undefined`!
	///
	/// @return {Struct.FORMS_Widget} Returns `self`.
	static remove_self = function ()
	{
		forms_assert(Parent != undefined, "Widget does not have a parent!");
		Parent.remove_child(self);
		return self;
	}

	/// @func find_widget(_id)
	///
	/// @desc Recursively looks for a widget with given ID down in the widget hierarchy.
	///
	/// @param {String} _id The ID of the widget to find.
	///
	/// @return {Struct.FORMS_Widget, Undefined} The found widget or `undefined`.
	static find_widget = function (_id)
	{
		gml_pragma("forceinline");
		return (Id == _id) ? self : undefined;
	}

	/// @func find_parent_type(_type)
	///
	/// @desc Recursively looks for a node of given type up in the widget hierarchy and returns the first one found.
	///
	/// @param {Function} _type A constructor that the widget must be an instance of (tested with `is_instanceof()`).
	///
	/// @return {Struct.FORMS_CompoundWidget, Undefined} The found widget or `undefined`.
	static find_parent_type = function (_type)
	{
		var _current = Parent;
		while (_current)
		{
			if (is_instanceof(_current, _type))
			{
				return _current;
			}
			_current = _current.Parent;
		}
		return undefined;
	}

	/// @func find_parent_name(_name)
	///
	/// @desc Recursively looks for a node with given name up in the widget hierarchy and returns the first one found.
	///
	/// @param {String} _name The name of the widget to find.
	///
	/// @return {Struct.FORMS_CompoundWidget, Undefined} The widget found or `undefined`.
	static find_parent_name = function (_name)
	{
		var _current = Parent;
		while (_current)
		{
			if (_current.Name == _name)
			{
				return _current;
			}
			_current = _current.Parent;
		}
		return undefined;
	}

	/// @func find_parent_id(_id)
	///
	/// @desc Recursively looks for a node with given ID up in the widget hierarchy and returns the first one found.
	///
	/// @param {String} _id The ID of the widget to find.
	///
	/// @return {Struct.FORMS_CompoundWidget, Undefined} The widget found or `undefined`.
	static find_parent_id = function (_id)
	{
		var _current = Parent;
		while (_current)
		{
			if (_current.Id == _id)
			{
				return _current;
			}
			_current = _current.Parent;
		}
		return undefined;
	}

	/// @func get_auto_width()
	///
	/// @desc Returns the width used for child widgets whose width is set to "auto".
	///
	/// @return {Real, Undefined} The width or `undefined` if this widget does not support "auto" sizes.
	static get_auto_width = function () { return undefined; }

	/// @func get_auto_height()
	///
	/// @desc Returns the height used for child widgets whose height is set to "auto".
	///
	/// @return {Real, Undefined} The height or `undefined` if this widget does not support "auto" sizes.
	static get_auto_height = function () { return undefined; }

	/// @func layout()
	///
	/// @desc Updates layout of the widget and its children.
	///
	/// @return {Struct.FORMS_Widget} Returns `self`.
	static layout = function ()
	{
		FORMS_LAYOUT_GENERATED;
		return self;
	}

	/// @func is_mouse_over()
	///
	/// @desc Checks whether the mouse cursor is over the widget.
	///
	/// @return {Bool} Returns `true` if the mouse cursor is over the widget.
	static is_mouse_over = function ()
	{
		return forms_get_root().WidgetHovered == self;
	}

	/// @func update(_deltaTime)
	///
	/// @desc Updates the widget and its children.
	///
	/// @param {Real} _deltaTime Number of milliseconds passed since the last frame.
	///
	/// @return {Struct.FORMS_Widget} Returns `self`.
	static update = function (_deltaTime)
	{
		var _index = 0;
		repeat(array_length(KeyboardShortcuts))
		{
			var _ks = KeyboardShortcuts[_index++];
			if (_ks.Callback != undefined && _ks.check_pressed())
			{
				_ks.Callback();
			}
		}
		return self;
	}

	/// @func draw()
	///
	/// @desc Draws the widget and its children.
	///
	/// @return {Struct.FORMS_Widget} Returns `self`.
	static draw = function ()
	{
		return self;
	}

	/// @func destroy_later()
	///
	/// @desc Causes the widget to be destroyed at the end of the frame.
	///
	/// @return {Undefined} Always returns `undefined`.
	static destroy_later = function ()
	{
		if (!__toDestroy)
		{
			array_push(forms_get_root().__widgetsToDestroy, self);
			__toDestroy = true;
		}
		return undefined;
	}

	/// @func destroy()
	///
	/// @desc Destroys the widget.
	///
	/// @return {Undefined} Always returns `undefined`.
	static destroy = function ()
	{
		forms_assert(!__destroyed, "Method destroy cannot be called multiple times!");
		__destroyed = true;

		if (Parent != undefined)
		{
			remove_self();
		}

		return undefined;
	}
}
