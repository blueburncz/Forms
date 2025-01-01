/// @enum An enumeration of all units available to use for size, padding, spacing etc.
enum FORMS_EUnit
{
	/// @member A pixel.
	Pixel,
	/// @member A percentage of size of the parent widget.
	Percent,
	/// @member Value is computed automatically (e.g. grow to fit all child widgets). Using this in unsupported places
	/// results into errors!
	Auto,
	/// @member Total number of members of this enum.
	SIZE
};

/// @func FORMS_UnitValue([_value[, _unit]])
///
/// @desc A value coupled with the type of units it uses.
///
/// @param {Real} [_value] The value. Defaults to 0.
/// @param {Real} [_unit] The type of the unit used. Use values from {@link FORMS_EUnit}. Defaults to
/// {@link FORMS_EUnit.Pixel}.
function FORMS_UnitValue(_value = 0, _unit = FORMS_EUnit.Pixel) constructor
{
	/// @var {Real} The value. Ignored if {@link FORMS_UnitValue.Unit} is {@link FORMS_EUnit.Auto}!
	Value = _value;

	/// @var {Real} The type of units used.
	/// @see FORMS_EUnit
	Unit = _unit;

	/// @func from_string(_string[, _allowAuto])
	///
	/// @desc Initializes value and unit from given string.
	///
	/// @param {String} _string The string containing the new value and unit. Unit defaults to {@link FORMS_EUnit.Pixels}
	/// if not included in the string.
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
	/// @param {Struct.FORMS_WidgetProps, undefined} _props Properties to initialize the value and unit from or
	/// `undefined` (in which case the defaults will be used).
	/// @param {String} _name The name of the value key. Unit key is constructed by appending "Unit" to this.
	/// @param {Real} [_valueDefault] The default value to use if props is `undefined` or it doesn't contain the value
	/// key. Defaults to 0.
	/// @param {Real} [_unitDefault] The default unit to use if props is `undefined` or it doesn't contain the unit key.
	/// Use values from {@link FORMS_EUnit}. Defaults to {@link FORMS_EUnit.Pixel}.
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
	/// @param {Real} _relativeTo The absolute value to which this one is relative.
	/// @param {Real, Undefined} [_autoSize] The size to use if unit is {@link FORMS_EUnit.Auto} or `undefined`.
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
