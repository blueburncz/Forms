/// @func ce_byte_array_to_hex(_bytes)
/// @desc Converts an array of number between 0..255 into a string of
/// hexadecimal representations of each number.
/// @param {array} _bytes The array with numbers.
/// @return {string} The resulting string.
function ce_byte_array_to_hex(_bytes)
{
	var _str = "";
	var i = 0;
	repeat (array_length(_bytes))
	{
		_str += ce_byte_to_hex(_bytes[i++]);
	}
	return _str;
}

/// @func ce_byte_to_hex(_byte)
/// @desc Converts a number in range 0..255 into a hexadecimal representation.
/// @param {real} _byte The number to convert.
/// @return {string} The hexadecimal representation.
function ce_byte_to_hex(_byte)
{
	gml_pragma("forceinline");
	return (ce_nibble_to_hex((_byte & 0xF0) >> 4) + ce_nibble_to_hex(_byte & 0xF));
}

/// @func ce_nibble_to_hex(_nibble)
/// @desc Converts a number in range 0..15 into its hexadecimal representation.
/// @param {real} _nibble The number to convert.
/// @return {string} The hexadecimal representation.
function ce_nibble_to_hex(_nibble)
{
	gml_pragma("forceinline");
	static _nibble_to_hex = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"];
	return _nibble_to_hex[_nibble];
}

/// @func ce_hex_to_nibble(_hex)
/// @desc Converts a hex char into a nibble.
/// @param {string} _hex The character to convert.
/// @return {real/NaN} The parsed nibble on success or NaN on fail.
function ce_hex_to_nibble(_hex)
{
	var _char = string_char_at(_hex, 1);
	_char = ord(string_upper(_char));
	if (_char >= ord("0") && _char <= ord("9"))
	{
		return _char - ord("0");
	}
	else if (_char >= ord("A") && _char <= ord("F"))
	{
		return 10 + _char - ord("A");
	}
	else
	{
		return NaN;
	}
}

/// @func ce_hex_to_real(_hex)
/// @desc Converts hex string into a number.
/// @param {string} _hex The hex string.
/// @return {real/NaN} The parsed number on success or NaN on fail.
function ce_hex_to_real(_hex)
{
	var _real = 0;
	var _index = 1;
	repeat (string_length(_hex))
	{
		var _char = string_char_at(_hex, _index++);
		var _nibble = ce_hex_to_nibble(_char);
		if (is_nan(_nibble))
		{
			return NaN;
		}
		_real = (_real << 4) | _nibble;
	}
	return _real;
}