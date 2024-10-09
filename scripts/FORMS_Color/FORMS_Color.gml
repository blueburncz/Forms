/// @func FORMS_Color([_color], [_alpha])
///
/// @desc A struct for storing higher precision colors, mostly for the 
/// {@link FORMS_Pen.color} & {@link FORMS_ColorPicker} widget. If using other 
/// formats such as HSV or RGB then leave _color argument blank and set using 
/// relevant methods.
///
/// @param {Constant.color, Struct.FORMS_Color} [_color] Initial color to set 
/// the struct, can either be a ABGR/BGR color or FORMS_Color struct.
/// @param {Real} _alpha Optional alpha value for BGR colors, 0..1.
function FORMS_Color(_color = c_white, _alpha = undefined) constructor
{
	/// @var {Real} 32bit (8bit per channel) ABGR-encoded color.
	/// @private
	__color = c_white;

	/// @var {Real} Red component of the color, 0..1.
	/// @private
	__red = 0;

	/// @var {Real} Green component of the color, 0..1.
	/// @private
	__green = 0;

	/// @var {Real} Blue component of the color, 0..1.
	/// @private
	__blue = 0;

	/// @var {Real} Alpha component of the color, 0..1.
	/// @private
	__alpha = 1;

	self.set(_color, _alpha);

	/// @func __calculate_color()
	///
	/// @desc Update the ABGR "__color" variable with the current component values.
	///
	/// @private
	static __calculate_color = function ()
	{
		__color = ((__red * 255)) | ((__green * 255) << 8) | ((__blue * 255) << 16) | ((__alpha * 255) << 24);
	}

	/// @func set(_color)
	///
	/// @desc Sets the color
	///
	/// @param {Constant.Color, Struct.FORMS_Color} _color The color to use, can 
	/// be a ABGR/BGR color or {@link FORMS_Color}.
	/// @param {Real} _alpha Optional alpha value for BGR colors, 0..1.
	///
	/// @return {Struct.FORMS_Color} Returns `self`.
	static set = function (_color, _alpha = undefined)
	{
		__red = is_struct(_color) ? _color.__red : (color_get_red(_color) / 255);
		__green = is_struct(_color) ? _color.__green : (color_get_green(_color) / 255);
		__blue = is_struct(_color) ? _color.__blue : (color_get_blue(_color) / 255);
		__alpha = is_struct(_color) ? _color.__alpha : clamp(_alpha ?? (forms_color_get_alpha(_color) / 255), 0, 1);
		__calculate_color();
		return self;
	}

	/// @func set_from_rgba(_red, _green, _blue, _alpha)
	///
	/// @desc Sets the color from RGBA components.
	///
	/// @param {Real} _red Red value between 0..1.
	/// @param {Real} _green Green value between 0..1.
	/// @param {Real} _blue Blue value between 0..1.
	/// @param {Real} _alpha Alpha value between 0..1.
	///
	/// @return {Struct.FORMS_Color} Returns `self`.
	static set_from_rgba = function (_red, _green, _blue, _alpha)
	{
		__red = clamp(_red, 0, 1);
		__green = clamp(_green, 0, 1);
		__blue = clamp(_blue, 0, 1);
		__alpha = clamp(_alpha, 0, 1);
		__calculate_color();
		return self;
	}

	/// @func set_from_hsva(_hue, _saturation, _value, _alpha)
	///
	/// @desc Sets the color from HSVA components.
	///
	/// @param {Real} _hue The hue component, 0..1.
	/// @param {Real} _saturation The saturation component, 0..1.
	/// @param {Real} _value The value component, 0..1.
	/// @param {Real} _alpha The alpha component, 0..1.
	///
	/// @return {Struct.FORMS_Color} Returns `self`.
	static set_from_hsva = function (_hue, _saturation, _value, _alpha)
	{
		var _r, _g, _b;
		_hue = (_hue * 6) mod 6;
		var _i = floor(_hue);
		var _f = _hue - _i;
		var _p = _value * (1 - _saturation);
		var _q = _value * (1 - _f * _saturation);
		var _t = _value * (1 - (1 - _f) * _saturation);
		switch (_i)
		{
			case 0:
				_r = _value;
				_g = _t;
				_b = _p;
				break;
			case 1:
				_r = _q;
				_g = _value;
				_b = _p;
				break;
			case 2:
				_r = _p;
				_g = _value;
				_b = _t;
				break;
			case 3:
				_r = _p;
				_g = _q;
				_b = _value;
				break;
			case 4:
				_r = _t;
				_g = _p;
				_b = _value;
				break;
			case 5:
				_r = _value;
				_g = _p;
				_b = _q;
				break;
		}
		__red = clamp(_r, 0, 1);
		__green = clamp(_g, 0, 1);
		__blue = clamp(_b, 0, 1);
		__alpha = clamp(_alpha, 0, 1);
		__calculate_color();
		return self;
	}

	/// @func set_from_hex(_hue, _saturation, _value, _alpha)
	///
	/// @desc Sets the color from a HEX string with format RGBA or RGB, can be 
	/// preceded by "#" or "0x".
	///
	/// @param {String} _hex_str The hex encoded color string.
	///
	/// @return {Bool} Returns `true` if hex was valid.
	static set_from_hex = function (_hex_str)
	{
		static __valid_chars = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"];
		_hex_str = string_replace(string_replace(string_upper(_hex_str), "#", ""), "0X", "");
		var _l = string_length(_hex_str);
		// Validate Hex
		if ((_l != 6) && (_l != 8)) { return false; }
		for (var c = 1; c <= _l; ++c)
		{
			if (!array_contains(__valid_chars, string_char_at(_hex_str, c))) { return false; }
		}
		// Convert to color components
		__red = real("0x" + string_copy(_hex_str, 1, 2)) / 255;
		__green = real("0x" + string_copy(_hex_str, 3, 2)) / 255;
		__blue = real("0x" + string_copy(_hex_str, 5, 2)) / 255;
		__alpha = (_l == 8) ? (real("0x" + string_copy(_hex_str, 7, 2)) / 255) : 1;
		__calculate_color();
		return true;
	}

	/// @func get()
	///
	/// @desc Returns the ABGR version of the color.
	///
	/// @return Returns a ABGR color.
	static get = function () { return __color; }

	/// @func get_red()
	///
	/// @desc Returns the red value.
	///
	/// @return {Real} Returns red value between 0..255.
	static get_red = function () { return __red * 255; }

	/// @func get_green()
	///
	/// @desc Returns the green value.
	///
	/// @return {Real} Returns green value between 0..255.
	static get_green = function () { return __green * 255; }

	/// @func get_blue()
	///
	/// @desc Returns the blue value.
	///
	/// @return {Real} Returns blue value between 0..255.
	static get_blue = function () { return __blue * 255; }

	/// @func get_alpha()
	///
	/// @desc Returns the alpha value.
	///
	/// @return {Real} Returns alpha value between 0..1.
	static get_alpha = function () { return __alpha; }

	/// @func get_hsva()
	///
	/// @desc Returns the Hue, Saturation, Value & Alpha components as an array.
	///
	/// @return {Array<Real>} Returns array with format [H,S,V,A] with values 0..1.
	static get_hsva = function ()
	{
		var _max = max(__red, __green, __blue);
		var _min = min(__red, __green, __blue);
		var d = _max - _min;
		var _h;
		var _s = (_max == 0 ? 0 : d / _max);
		var _v = _max;
		switch (_max)
		{
			case _min:
				_h = 0;
				break;
			case __red:
				_h = (__green - __blue) + d * (__green < __blue ? 6 : 0);
				_h /= 6 * d;
				break;
			case __green:
				_h = (__blue - __red) + d * 2;
				_h /= 6 * d;
				break;
			case __blue:
				_h = (__red - __green) + d * 4;
				_h /= 6 * d;
				break;
		}
		return [_h, _s, _v, __alpha];
	}

	/// @func equal_to(_color, [_precise])
	///
	/// @desc Compare another color to this one and return if they are equal.
	///
	/// @param {Struct.FORMS_Color, Constant.Color} _color Color to compare to.
	/// @param {Bool} _precise Whether to compare colors more precisely (only when
	/// comparing to another {@link FORMS_Color}).
	///
	/// @return {Bool, Undefined} Returns `true` if the two colors are equal, 
	/// `undefined` if the value given is not a valid color.
	static equal_to = function (_color, _precise = true)
	{
		if (forms_is_forms_color(_color) && _precise)
		{
			return (__red == _color.__red) && (__green == _color.__green)
				&& (__blue == _color.__blue) && (__alpha == _color.__alpha);
		}
		else if (is_real(_color))
		{
			return __color == (is_struct(_color) ? _color.__color : _color);
		}
		return undefined;
	}

	/// @func __byte_to_hex_string(_byte)
	///
	/// @desc Converts a single byte to a hexadecimal string.
	///
	/// @param {Real} _byte Byte to convert.
	///
	/// @return {String} Returns hexadecimal string.
	///
	/// @private
	static __byte_to_hex_string = function (_byte)
	{
		var _high = _byte >> 4;
		var _low = _byte & 0x0F;
		return chr(_high + ((_high < 10) ? 48 : 55)) + chr(_low + ((_low < 10) ? 48 : 55));
	}

	/// @func toString()
	///
	/// @desc Converts the color into a standard RGBA hex string.
	///
	/// @return {String} Returns RGBA hex string of the color.
	static toString = function ()
	{
		return "#" + __byte_to_hex_string(color_get_red(__color)) + __byte_to_hex_string(color_get_green(__color))
			+ __byte_to_hex_string(color_get_blue(__color)) + __byte_to_hex_string(forms_color_get_alpha(__color));
	}
}

/// @func forms_is_forms_color(_val)
///
/// @desc This function checks if the supplied value is a {@link FORMS_Color}
/// struct.
///
/// @param {Any} _val The value to check.
///
/// @return {Bool} Returns `true` if value is a {@link FORMS_Color}.
function forms_is_forms_color(_val)
{
	return is_struct(_val) && is_instanceof(_val, FORMS_Color);
}

/// @func forms_color_get_alpha(_col)
///
/// @desc This functions returns the amount of alpha in the given color, with a
/// value between 0 and 255. If color has no alpha value, 0 is returned.
///
/// @param {Constant.Color} _col The color to check.
///
/// @return {Real} Alpha value between 0 and 255.
function forms_color_get_alpha(_col)
{
	return (_col >> 24) & 0xFF;
}
