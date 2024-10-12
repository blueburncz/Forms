/// @enum An enumeration of all units available to use for size, padding,
/// spacing etc.
enum FORMS_EUnit
{
	/// @member A pixel.
	Pixel,
	/// @member A percentage of size of the parent widget.
	Percent,
	/// @member Value is computed automatically (e.g. grow to fit all child
	/// widgets). Using this in unsupported places results into errors!
	Auto,
	/// @member Total number of members of this enum.
	SIZE
};

/// @func FORMS_UnitValue([_value[, _unit]])
///
/// @desc A value coupled with the type of units it uses.
///
/// @param {Real} [_value] The value. Defaults to 0.
/// @param {Real} [_unit] The type of the unit used. Use values from
/// {@link FORMS_EUnit}. Defaults to {@link FORMS_EUnit.Pixel}.
function FORMS_UnitValue(_value = 0, _unit = FORMS_EUnit.Pixel) constructor
{
	/// @var {Real} The value. Ignored if {@link FORMS_UnitValue.Unit}
	/// is {@link FORMS_EUnit.Auto}!
	Value = _value;

	/// @var {Real} The type of units used.
	/// @see FORMS_EUnit
	Unit = _unit;

	/// @func from_string(_string[, _allowAuto])
	///
	/// @desc Initializes value and unit from given string.
	///
	/// @param {String} _string The string containing the new value and unit.
	/// Unit defaults to {@link FORSM_EUnit.Pixels} if not included in the
	/// string.
	///
	/// @return {Struct.FORMS_UnitValue} Returns `self`.
	///
	/// @example
	/// ```gml
	/// var _sizePixels = new FORMS_UnitValue().from_string("100px"); // 100 pixels
	/// var _sizePercent = new FORMS_UnitValue().from_string("100%"); // 100 percent
	/// var _sizeAuto = new FORMS_UnitValue().from_string("auto");    // "auto"
	/// ```
	static from_string = function (_string, _allowAuto = true)
	{
		if (_string == "auto")
		{
			forms_assert(_allowAuto, "'auto' not allowed!");
			Unit = FORMS_EUnit.Auto;
			return self;
		}

		var _stateSign = 0;
		var _stateInteger = 1;
		var _stateDecimal = 2;
		var _stateUnit = 3;
		var _state = _stateSign;

		var _sign = 1;
		var _before = ""
		var _number = "";
		var _unit = "";

		var _length = string_length(_string);
		var _index = 1;

		while (_index <= _length)
		{
			var _char = string_char_at(_string, _index++);

			switch (_state)
			{
				case _stateSign:
					if (_char == "+") {}
					else if (_char == "-")
					{
						_sign *= -1;
					}
					else if (string_digits(_char) == _char)
					{
						_state = _stateInteger;
						--_index;
					}
					else if (_char == ".")
					{
						_before = "0";
						_number += ".";
						_state = _stateDecimal;
					}
					else
					{
						forms_assert(false, $"Unexpected symbol '{_char}'!");
					}
					break;

				case _stateInteger:
					if (string_digits(_char) == _char)
					{
						_number += _char;
					}
					else if (_char == ".")
					{
						_number += _char;
						_state = _stateDecimal;
					}
					else
					{
						_state = _stateUnit;
						--_index;
					}
					break;

				case _stateDecimal:
					if (string_digits(_char) == _char)
					{
						_number += _char;
					}
					else
					{
						_state = _stateUnit;
						--_index;
					}
					break;

				case _stateUnit:
					_unit += _char;
					break;
			}
		}

		if (_number == ".")
		{
			throw "Invalid number '.'!";
		}

		if (_unit != ""
			&& _unit != "px"
			&& _unit != "%")
		{
			throw $"Invalid unit '{_unit}'!";
		}

		Value = _sign * real(_before + _number);
		Unit = (_unit == "" || _unit == "px")
			? FORMS_EUnit.Pixel
			: FORMS_EUnit.Percent;

		return self;
	}

	/// @func from_props(_props, _name[, _valueDefault[, _unitDefault]])
	///
	/// @desc Initializes value and unit from given props struct.
	///
	/// @param {Struct.FORMS_WidgetProps, undefined} _props Properties to
	/// initialize the value and unit from or `undefined` (in which case the
	/// defaults will be used).
	/// @param {String} _name The name of the value key. Unit key is constructed
	/// by appending "Unit" to this.
	/// @param {Real} [_valueDefault] The default value to use if props is
	/// `undefined` or it doesn't contain the value key. Defaults to 0.
	/// @param {Real} [_unitDefault] The default unit to use if props is
	/// `undefined` or it doesn't contain the unit key. Use values from
	/// {@link FORMS_EUnit}. Defaults to {@link FORMS_EUnit.Pixel}.
	///
	/// @return {Struct.FORMS_UnitValue} Returns `self`.
	///
	/// @example
	/// ```gml
	/// // 100px:
	/// var _sizePixels = new FORMS_UnitValue()
	///     .from_props({ Size: 100, SizeUnit: FORMS_EUnit.Pixel }, "Size");
	///
	/// // 100%:
	/// var _sizePercent = new FORMS_UnitValue()
	///     .from_props({ Size: 100, SizeUnit: FORMS_EUnit.Percent }, "Size");
	///
	/// // "auto":
	/// var _sizeAuto = new FORMS_UnitValue()
	///     .from_props({ SizeUnit: FORMS_EUnit.Auto }, "Size");
	///
	/// // 0px:
	/// var _sizeFromDefaults = new FORMS_UnitValue().from_props({}, "Size");
	/// ```
	static from_props = function (_props, _name, _valueDefault = 0, _unitDefault = FORMS_EUnit.Pixel)
	{
		if (_props == undefined)
		{
			Value = _valueDefault;
			Unit = _unitDefault;
		}
		else
		{
			var _value = _props[$  _name];
			if (is_string(_value))
			{
				from_string(_value);
			}
			else
			{
				Value = _props[$  _name] ?? _valueDefault;
				Unit = _props[$  _name + "Unit"] ?? _unitDefault;
			}
		}
		return self;
	}

	/// @func get_absolute(_relativeTo[, _autoSize])
	///
	/// @desc Retrieves the absolute value, in pixels.
	///
	/// @param {Real} _relativeTo The absolute value to which this one is
	/// relative.
	/// @param {Real, Undefined} [_autoSize] The size to use if unit is
	/// {@link FORMS_EUnit.Auto} or `undefined`.
	///
	/// @return {Real}
	static get_absolute = function (_relativeTo, _autoSize = undefined)
	{
		gml_pragma("forceinline");
		switch (Unit)
		{
			case FORMS_EUnit.Pixel:
				return Value;
			case FORMS_EUnit.Percent:
				return (_relativeTo * Value * 0.01);
			case FORMS_EUnit.Auto:
				forms_assert(_autoSize != undefined, "Auto size not defined!");
				return _autoSize;
			default:
				forms_assert(false, "Invalid unit!");
		}
	}
}

/// @func FORMS_WidgetProps()
///
/// @desc Properties accepted by the constructor of {@link FORMS_Widget}.
function FORMS_WidgetProps() constructor
{
	/// @var {String, Undefined} The unique identifier of the widget.
	Id = undefined;

	/// @var {String, Undefined} The name of the widget.
	Name = undefined;

	/// @var {Real, Undefined} The Font Awesome icon associated with the widget.
	/// Use values from {@link FA_ESolid}, {@link FA_ERegular} or
	/// {@link FA_EBrands}.
	Icon = undefined;

	/// @var {Asset.GMFont, Undefined} The font used for the icon. Must match
	/// with the icon style!
	IconFont = undefined;

	/// @var {Real, String, Undefined} The widget's X position relative to its
	/// parent.
	X = undefined;

	/// @var {Real, Undefined} Use values from {@link FORMS_EUnit}.
	XUnit = undefined;

	/// @var {Real, String, Undefined} The widget's Y position relative to its
	/// parent.
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

	/// @var {Real, Undefined} A value that represents how much space does the
	/// widget take when its parent is {@link FORMS_FlexBox}. Value 0 means the
	/// widget doesn't grow or shrink based on the flex box size.
	Flex = undefined;
}

/// @func forms_get_prop(_props, _name)
///
/// @desc Retrieves a value of a property from given struct.
///
/// @param {Struct, Undefined} _props A struct with properties or `undefined`.
/// @param {String} _name The name of the property.
///
/// @return {Any} Returns the value of the property of `undefined` if it's not
/// present in the given properties struct.
function forms_get_prop(_props, _name)
{
	gml_pragma("forceinline");
	return ((_props != undefined) ? _props[$  _name] : undefined);
}

/// @macro {Code} Must be used in method [layout](./FORMS_Widget.layout.html)
/// of all widgets!
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
/// @param {Struct.FORMS_WidgetProps, Undefined} [_props] Properties to create
/// the widget with or `undefined` (default).
function FORMS_Widget(_props = undefined) constructor
{
	/// @private
	static __idNext = 0;

	/// @var {String} A unique identifier of the widget. Defaults to string
	/// "Widget" + automatically incremented number.
	Id = forms_get_prop(_props, "Id") ?? $"Widget{__idNext++}";

	/// @var {Real, Undefined} The Font Awesome icon associated with the widget
	/// or `undefined` (default). Use values from {@link FA_ESolid},
	/// {@link FA_ERegular} or {@link FA_EBrands}.
	Icon = forms_get_prop(_props, "Icon");

	/// @var {Asset.GMFont} The font used for the icon. Must match with the icon
	/// style! Defaults to `FA_FntSolid12`.
	IconFont = forms_get_prop(_props, "IconFont") ?? FA_FntSolid12;

	/// @var {String} The name of the widget. Defaults to an empty string.
	Name = forms_get_prop(_props, "Name") ?? "";

	/// @var {Struct.FORMS_CompoundWidget, Undefined} The parent of this widget
	/// or `undefined`.
	/// @readonly
	Parent = undefined;

	/// @var {Struct.FORMS_UnitValue} The widget's X position relative to
	/// its parent widget.
	X = new FORMS_UnitValue().from_props(_props, "X");

	/// @var {Real} The widget's actual X position.
	/// @private
	__realX = 0;

	/// @var {Struct.FORMS_UnitValue} The widget's Y position relative to
	/// its parent widget.
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

	/// @var {Real} A value that represents how much space does the widget take
	/// when its parent is {@link FORMS_FlexBox}. Value 0 (default) means the
	/// widget doesn't grow or shrink based on the flex box size.
	Flex = forms_get_prop(_props, "Flex") ?? 0;

	/// @var {Bool}
	/// @private
	__toDestroy = false;

	/// @func get_x()
	///
	/// @desc Retrieves the actual X position of the widget computed in
	/// [layout](./FORMS_Widget.layout.html).
	///
	/// @return {Real} The actual widget's position on the X axis.
	static get_x = function ()
	{
		gml_pragma("forceinline");
		return __realX;
	}

	/// @func get_y()
	///
	/// @desc Retrieves the actual Y position of the widget computed in
	/// [layout](./FORMS_Widget.layout.html).
	///
	/// @return {Real} The actual widget's position on the Y axis.
	static get_y = function ()
	{
		gml_pragma("forceinline");
		return __realY;
	}

	/// @func get_width()
	///
	/// @desc Retrieves the actual width of the widget computed in
	/// [layout](./FORMS_Widget.layout.html).
	///
	/// @return {Real} The actual widget's width.
	static get_width = function ()
	{
		gml_pragma("forceinline");
		return __realWidth;
	}

	/// @func get_height()
	///
	/// @desc Retrieves the actual height of the widget computed in
	/// [layout](./FORMS_Widget.layout.html).
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
	/// @desc Recursively looks for a widget with given ID down in the widget
	/// hierarchy.
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
	/// @desc Recursively looks for a node of given type up in the widget
	/// hierarchy and returns the first one found.
	///
	/// @param {Function} _type A constructor that the widget must be an
	/// instance of (tested with `is_instanceof()`).
	///
	/// @return {Struct.FORMS_CompoundWidget, Undefined} The found widget or
	/// `undefined`.
	static find_parent_type = function (_type)
	{
		var _current = Parent;
		while (_current)
		{
			if (is_instanceof(Parent, _type))
			{
				return Parent;
			}
			Parent = Parent.Parent;
		}
		return undefined;
	}

	/// @func find_parent_name(_name)
	///
	/// @desc Recursively looks for a node with given name up in the widget
	/// hierarchy and returns the first one found.
	///
	/// @param {String} _name The name of the widget to find.
	///
	/// @return {Struct.FORMS_CompoundWidget, Undefined} The widget found or
	/// `undefined`.
	static find_parent_name = function (_name)
	{
		var _current = Parent;
		while (_current)
		{
			if (Parent.Name == _name)
			{
				return Parent;
			}
			Parent = Parent.Parent;
		}
		return undefined;
	}

	/// @func get_auto_width()
	///
	/// @desc Returns the width used for child widgets whose width is set to
	/// "auto".
	///
	/// @return {Real, Undefined} The width or `undefined` if this widget
	/// does not support "auto" sizes.
	static get_auto_width = function () { return undefined; }

	/// @func get_auto_height()
	///
	/// @desc Returns the height used for child widgets whose height is set to
	/// "auto".
	///
	/// @return {Real, Undefined} The height or `undefined` if this widget
	/// does not support "auto" sizes.
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
	/// @param {Real} _deltaTime Number of milliseconds passed since the last
	/// frame.
	///
	/// @return {Struct.FORMS_Widget} Returns `self`.
	static update = function (_deltaTime)
	{
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
		return undefined;
	}
}
