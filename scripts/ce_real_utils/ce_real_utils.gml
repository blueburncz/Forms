/// @func ce_parse_real(string)
/// @desc Parses a real number from a string.
/// @param {string} string The string to parse the number from.
/// @return {real/string} The parsed number or `NaN` if the string does not
/// represent a number.
function ce_parse_real(_string)
{
	var _sign = 1;
	var _number = "0";
	var _index = 1;
	var _state = 0;

	repeat (string_length(_string) + 1)
	{
		var _char = string_char_at(_string, _index++);

		switch (_state)
		{
		case 0:
			if (_char == "-")
			{
				_sign *= -1;
			}
			else if (_char == "+")
			{
				_sign *= +1;
			}
			else if (ce_char_is_digit(_char)
				|| _char == ".")
			{
				_state = 1;
				--_index;
			}
			else
			{
				return NaN;
			}
			break;

		case 1:
			if (ce_char_is_digit(_char)
				|| _char == ".")
			{
				_number += _char;
			}
			else
			{
				return NaN;
			}
			break;

		case 2:
			if (ce_char_is_digit(_char))
			{
				_number += _char;
			}
			else
			{
				return NaN;
			}
			break;
		}
	}

	return _sign * real(_number);
}

/// @func ce_real_compare(r1, r2)
/// @desc Compares two numbers.
/// @param {real} _r1 The first number.
/// @param {real} _r2 The second number.
/// @return {real} `cmpfunc_equal` if the numbers are equal or
/// `cmpfunc_less` / `cmpfunc_greater` if the first number is
/// less / greater than the second number.
/// @example
/// Sorting an array of numbers using a bubble sort algorithm and this function
/// for number comparison.
/// ```gml
/// var _numbers = [3, 1, 2];
/// var _size = array_length(_numbers);
/// for (var i = 0; i < _size - 1; ++i)
/// {
///     for (var j = 0; j < _size - i - 1; ++j)
///     {
///         if (ce_real_compare(_numbers[j], _numbers[j + 1]) == cmpfunc_greater)
///         {
///             ce_array_swap(_numbers, j, j + 1);
///         }
///     }
/// }
/// // The array is now equal to [1, 2, 3].
/// ```
function ce_real_compare(_r1, _r2)
{
	gml_pragma("forceinline");
	return ((_r1 < _r2) ? cmpfunc_less
		: ((_r1 > _r2) ? cmpfunc_greater
		: cmpfunc_equal));
}

/// @func ce_real_is_even(_real)
/// @param {real} _real The number to check.
/// @return {bool} `true` if the number is even.
function ce_real_is_even(_real)
{
	gml_pragma("forceinline");
	return (_real & $1 == 0);
}

/// @func ce_real_is_odd(_real)
/// @param {real} _real The number to check.
/// @return {bool} `true` if the number is odd.
function ce_real_is_odd(_real)
{
	gml_pragma("forceinline");
	return (_real & $1 == 1);
}

/// @func ce_real_to_string(_real[, _dec_places])
/// @desc Converts a real value to a string without generating trailing zeros
/// after a decimal point.
/// @param {real} _real The real value to convert to a string.
/// @param {real} [_dec_places] Maximum decimal places. Defaults to 16.
/// @return {string} The resulting string.
/// @example
/// ```gml
/// ce_real_to_string(16); // => 16
/// ce_real_to_string(16.870); // => 16.87
/// ```
function ce_real_to_string(_real, _dec_places=16)
{
	var _string = string_format(_real, -1, _dec_places);
	var _string_length = string_length(_string);

	do
	{
		_string = string_format(_real, -1, --_dec_places);
		--_string_length;
		if (string_byte_at(_string, _string_length) != 48)
		{
			break;
		}
	}
	until (_dec_places == 0);

	return _string;
}