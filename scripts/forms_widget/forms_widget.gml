/// @enum
enum FORMS_EUnit
{
	/// @member
	Pixel,
	/// @member
	Percent,
	/// @member Value is computed automatically. Using this in unsupported
	/// places results into errors!
	Auto,
	/// @member Total number of members of this enum.
	SIZE
};

/// @func FORMS_WidgetUnitValue([_value[, _unit]])
///
/// @desc
///
/// @param {Real} [_value]
/// @param {Real} [_unit] Use values from {@link FORMS_EUnit.Pixel}.
function FORMS_WidgetUnitValue(_value=0, _unit=FORMS_EUnit.Pixel) constructor
{
	/// @var {Real}
	Value = _value;

	/// @var {Real}
	/// @see FORMS_EUnit
	Unit = _unit;

	/// @func from_string(_string[, _allowAuto])
	///
	/// @desc
	///
	/// @param {String} _string
	///
	/// @return {Struct.FORMS_WidgetUnitValue} Returns `self`.
	static from_string = function (_string, _allowAuto=true)
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
				if (_char == "+")
				{
				}
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
	};

	/// @func from_props(_props, _name[, _valueDefault[, _unitDefault]])
	///
	/// @desc
	///
	/// @param {Struct.FORMS_WidgetProps, undefined} _props
	/// @param {String} _name
	/// @param {Real} [_valueDefault]
	/// @param {Real} [_unitDefault]
	///
	/// @return {Struct.FORMS_WidgetUnitValue} Returns `self`.
	static from_props = function (_props, _name, _valueDefault=0, _unitDefault=FORMS_EUnit.Pixel)
	{
		if (_props == undefined)
		{
			Value = _valueDefault;
			Unit = _unitDefault;
		}
		else
		{
			var _value = _props[$ _name];
			if (is_string(_value))
			{
				from_string(_value);
			}
			else
			{
				Value = _props[$ _name] ?? _valueDefault;
				Unit = _props[$ _name + "Unit"] ?? _unitDefault;
			}
		}
		return self;
	};

	/// @func get_absolute(_relativeTo[, _autoSize])
	///
	/// @desc
	///
	/// @param {Real} _relativeTo
	/// @param {Real, Undefined} [_autoSize]
	///
	/// @return {Real}
	static get_absolute = function (_relativeTo, _autoSize=undefined)
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
	};
}

/// @func FORMS_WidgetProps()
///
/// @desc
function FORMS_WidgetProps() constructor
{
	/// @var {String, Undefined} A unique identifier of the widget.
	Id = undefined;

	/// @var {String, Undefined} The name of the widget.
	Name = undefined;

	/// @var {Real, Undefined}
	Icon = undefined;

	/// @var {Asset.GMFont, Undefined}
	IconFont = undefined;

	/// @var {Real, String, Undefined} The widget's X position relative to its
	/// parent.
	X = undefined;

	/// @var {Real, Undefined} Use values from {@link FORMS_EUnit.Pixel}.
	XUnit = undefined;

	/// @var {Real, String, Undefined} The widget's Y position relative to its
	/// parent.
	Y = undefined;

	/// @var {Real, Undefined} Use values from {@link FORMS_EUnit.Pixel}.
	YUnit = undefined;

	/// @var {Real, String, Undefined} The widget's width.
	Width = undefined;

	/// @var {Real, Undefined} Use values from {@link FORMS_EUnit.Pixel}.
	WidthUnit = undefined;

	/// @var {Real, String, Undefined} The widget's height.
	Height = undefined;

	/// @var {Real, Undefined} Use values from {@link FORMS_EUnit.Pixel}.
	HeightUnit = undefined;

	/// @var {Real, Undefined}
	Flex = undefined;
}

/// @func forms_get_prop(_props, _name)
///
/// @desc
///
/// @param {Struct, Undefined} _props
/// @param {String} _name
///
/// @return {Any}
function forms_get_prop(_props, _name)
{
	gml_pragma("forceinline");
	return ((_props != undefined) ? _props[$ _name] : undefined);
}

/// @macro
/// @private
#macro FORMS_LAYOUT_GENERATED \
	if (forms_mouse_in_rectangle(__realX, __realY, __realWidth, __realHeight)) \
	{ \
		forms_get_root().WidgetHovered = self; \
	}

/// @func FORMS_Widget([_props])
///
/// @desc
///
/// @param {Struct.FORMS_WidgetProps, Undefined} [_props]
function FORMS_Widget(_props=undefined) constructor
{
	/// @private
	static __idNext = 0;

	/// @var {String} A unique identifier of the widget.
	Id = forms_get_prop(_props, "Id") ?? $"Widget{__idNext++}";

	/// @var {Real, Undefined}
	Icon = forms_get_prop(_props, "Icon");

	/// @var {Asset.GMFont}
	IconFont = forms_get_prop(_props, "IconFont") ?? FA_FntSolid12;

	/// @var {String} The name of the widget. Defaults to an empty string.
	Name = forms_get_prop(_props, "Name") ?? "";

	/// @var {Struct.FORMS_CompoundWidget, Undefined}
	/// @readonly
	Parent = undefined;

	/// @var {Struct.FORMS_WidgetUnitValue} The widget's X position relative to
	/// its parent widget.
	X = new FORMS_WidgetUnitValue().from_props(_props, "X");

	/// @var {Real} The widget's actual X position.
	/// @private
	__realX = 0;

	/// @var {Struct.FORMS_WidgetUnitValue} The widget's Y position relative to
	/// its parent widget.
	Y = new FORMS_WidgetUnitValue().from_props(_props, "Y");

	/// @var {Real} The widget's actual Y position.
	/// @private
	__realY = 0;

	/// @var {Struct.FORMS_WidgetUnitValue} The widget's width.
	Width = new FORMS_WidgetUnitValue().from_props(_props, "Width");

	/// @var {Real} The widget's actual width.
	/// @private
	__realWidth = 0;

	/// @var {Struct.FORMS_WidgetUnitValue} The widget's height.
	Height = new FORMS_WidgetUnitValue().from_props(_props, "Height");

	/// @var {Real} The widget's actual height.
	/// @private
	__realHeight = 0;

	/// @var {Real}
	Flex = forms_get_prop(_props, "Flex") ?? 0;

	/// @var {Bool}
	/// @private
	__toDestroy = false;

	/// @func get_x()
	///
	/// @desc
	///
	/// @return {Real}
	static get_x = function ()
	{
		gml_pragma("forceinline");
		return __realX;
	};

	/// @func get_y()
	///
	/// @desc
	///
	/// @return {Real}
	static get_y = function ()
	{
		gml_pragma("forceinline");
		return __realY;
	};

	/// @func get_width()
	///
	/// @desc
	///
	/// @return {Real}
	static get_width = function ()
	{
		gml_pragma("forceinline");
		return __realWidth;
	};

	/// @func get_height()
	///
	/// @desc
	///
	/// @return {Real}
	static get_height = function ()
	{
		gml_pragma("forceinline");
		return __realHeight;
	};

	/// @func has_parent()
	///
	/// @desc
	///
	/// @return {Bool}
	static has_parent = function ()
	{
		gml_pragma("forceinline");
		return (Parent != undefined);
	};

	/// @func remove_self()
	///
	/// @desc
	///
	/// @return {Struct.FORMS_Widget} Returns `self`.
	static remove_self = function ()
	{
		forms_assert(Parent != undefined, "Widget does not have a parent!");
		Parent.remove_child(self);
		return self;
	};

	/// @func find_widget(_id)
	///
	/// @desc
	///
	/// @param {String} _id
	///
	/// @return {Struct.FORMS_Widget, Undefined}
	static find_widget = function (_id)
	{
		gml_pragma("forceinline");
		return (Id == _id) ? self : undefined;
	};

	/// @func find_parent_type(_type)
	///
	/// @desc
	///
	/// @param {Function} _type
	///
	/// @return {Struct.FORMS_CompoundWidget, Undefined}
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
	};

	/// @func find_parent_name(_name)
	///
	/// @desc
	///
	/// @param {String} _name
	///
	/// @return {Struct.FORMS_CompoundWidget, Undefined}
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
	};

	/// @func get_auto_width()
	///
	/// @desc
	///
	/// @return {Real, Undefined}
	static get_auto_width = function () { return undefined; };

	/// @func get_auto_height()
	///
	/// @desc
	///
	/// @return {Real, Undefined}
	static get_auto_height = function () { return undefined; };

	/// @func layout()
	///
	/// @desc
	///
	/// @return {Struct.FORMS_Widget} Returns `self`.
	static layout = function ()
	{
		FORMS_LAYOUT_GENERATED;
		return self;
	};

	/// @func is_mouse_over()
	///
	/// @desc
	///
	/// @return {Bool}
	static is_mouse_over = function ()
	{
		return forms_get_root().WidgetHovered == self;
	};

	/// @func update(_deltaTime)
	///
	/// @desc
	///
	/// @param {Real} _deltaTime
	///
	/// @return {Struct.FORMS_Widget} Returns `self`.
	static update = function (_deltaTime)
	{
		return self;
	};

	/// @func draw()
	///
	/// @desc
	///
	/// @return {Struct.FORMS_Widget} Returns `self`.
	static draw = function ()
	{
		return self;
	};

	/// @func destroy_later()
	///
	/// @desc
	///
	/// @return {Undefined}
	static destroy_later = function ()
	{
		if (!__toDestroy)
		{
			array_push(forms_get_root().__widgetsToDestroy, self);
			__toDestroy = true;
		}
		return undefined;
	};

	/// @func destroy()
	///
	/// @desc
	///
	/// @return {Undefined}
	static destroy = function ()
	{
		return undefined;
	};
}
