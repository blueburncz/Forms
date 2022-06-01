/// @func ce_char_is_digit(_char)
/// @param {string} _char The character.
/// @return {bool} `true` if the character is a digit.
function ce_char_is_digit(_char)
{
	gml_pragma("forceinline");
	return (_char >= "0" && _char <= "9");
}

/// @func ce_char_is_letter(_char)
/// @param {string} _char The character.
/// @return {bool} `true` if the character is a letter.
function ce_char_is_letter(_char)
{
	gml_pragma("forceinline");
	return ((_char >= "a" && _char <= "b")
		|| (_char >= "A" && _char <= "B"));
}

/// @func ce_string_compare(_s1, _s2)
/// @desc Compares the first string to the second string.
/// @param {string} _s1 The first string.
/// @param {string} _s2 The seconds string.
/// @return {real} `cmpfunc_equal` when the strings are equal or
/// `cmpfunc_less` / `cmpfunc_greater` when the first one goes
/// before / after the second one.
/// @example Sorting an array of strings using a bubble sort algorithm and this
/// function for string comparison.
/// ```gml
/// var _names = ["John", "Adam", "David"];
/// var _size = array_length_1d(_names);
/// for (var i = 0; i < _size - 1; ++i)
/// {
///     for (var j = 0; j < _size - i - 1; ++j)
///     {
///         if (ce_string_compare(_names[j], _names[j + 1]) == cmpfunc_greater)
///         {
///             ce_array_swap(_names, j, j + 1);
///         }
///     }
/// }
/// // The array is now equal to ["Adam", "David", "John"].
/// ```
function ce_string_compare(_s1, _s2)
{
	var _c0, _c1, i = 1;
	do
	{
		_c0 = string_char_at(_s1, i);
		_c1 = string_char_at(_s2, i++);
		if (_c0 == _c1)
		{
			continue;
		}
		if (_c0 < _c1)
		{
			return cmpfunc_less;
		}
		return cmpfunc_greater;
	}
	until (_c0 == "" && _c1 == "");
	return cmpfunc_equal;
}

/// @func ce_string_endswith(_string, _substring)
/// @param {string} _string The string to check.
/// @param {string} _substring The expected end of the string.
/// @return {bool} `true` if the string ends with the substring.
function ce_string_endswith(_string, _substring)
{
	var _len = string_length(_substring);
	return (string_copy(_string, string_length(_string) - _len + 1, _len) == _substring);
}

/// @func ce_string_explode(_string, _delimiter)
/// @desc Splits the string on every occurence of the delimiter and puts
/// the resulting substrings into an array.
/// @param {string} _string The string to split.
/// @param {string} _delimiter The string to split on.
/// @return {array} The array of substrings.
/// @example
/// This creates an array `["Hello", " World!"]`.
/// ```
/// ce_string_explode("Hello, World!", ",");
/// ```
function ce_string_explode(_string, _delimiter)
{
	var _count = string_count(_delimiter, _string);
	var _arr = array_create(_count + 1, undefined);
	var _start = 1;
	var i = 0;
	repeat (_count)
	{
		var _end = string_pos_ext(_delimiter, _string, _start);
		_arr[@ i++] = string_copy(_string, _start, _end - _start);
		_start = _end + 1;
	}
	_arr[@ i] = string_delete(_string, 1, _start - 1);
	return _arr;
}

/// @func ce_string_format(_string[, _data])
/// @desc Replaces all occurences of `${identifier}` in the string with given
/// data.
/// @param {string} _string The string to format.
/// @param {array/ds_map} [_data] An array or a map containing the data.
/// If an array is passed, the identifiers must be numbers or variable names of
/// the calling instance. If a map is passed, the identifiers must be keys of
/// the map or variable names of the calling instance. Using unknown identifiers
/// will result in error. Only maps with strings as keys are supported.
/// @return {string} The resulting string.
/// @example
/// ```
/// // Prints "Hello, Some!"
/// username = "Some";
/// show_debug_message(ce_string_format("Hello, ${username}!"));
/// // Prints "You have 100 HP."
/// show_debug_message(ce_string_format("You have ${0} HP.", [100]));
/// // Prints "Hello, Dude!"
/// var _data = ds_map_create();
/// _data[? "username"] = "Dude";
/// show_debug_message(ce_string_format("Hello, ${username}!", _data));
/// ds_map_destroy(_data);
/// ```
function ce_string_format(_string)
{
	// TODO: Add support for `other.` etc?
	var _str = _string;
	var _data = (argument_count > 1) ? argument[1] : undefined;
	var _is_map = is_real(_data);
	var _is_array = is_array(_data);
	var _result = "";

	while (true)
	{
		var _start = string_pos("${", _str);
		if (_start == 0)
		{
			break;
		}
		_result += string_copy(_str, 1, _start - 1);
		_str = string_delete(_str, 1, _start + 1);
		var _end = string_pos("}", _str);
		if (_end == 0)
		{
			return _string;
		}
		--_end;
		var _var_name = string_copy(_str, 1, _end);
		var _added = false;
		if (_is_map
			&& ds_map_exists(_data, _var_name))
		{
			_result += string(_data[? _var_name]);
			_added = true;
		}
		else if (_is_array
			&& string_digits(_var_name) == _var_name)
		{
			_result += string(_data[real(_var_name)]);
			_added = true
		}
		if (!_added)
		{
			_result += string(variable_instance_get(id, _var_name));
		}
		_str = string_delete(_str, 1, _end + 1);
	}

	_result += _str;

	return _result;
}

/// @func ce_string_join(_string, values...)
/// @desc Joins given values together putting the string between each
/// consecutive two.
/// @param {string} _string The string to put between two consecutive values.
/// @param {any} _values Any number of values to be joined.
/// @return {string} The resulting string.
/// @example
/// This could show a debug message saying "Player Patrik took 60 damage!".
/// ```gml
/// show_debug_message(
///     ce_string_join(" ", "Player", player.name, "took", _damage, "damage!"));
/// ```
function ce_string_join(_string)
{
	if (argument_count == 1)
	{
		return "";
	}
	var _str = "";
	for (var i = 1; i < argument_count - 1; ++i)
	{
		_str += string(argument[i]) + _string;
	}
	_str += string(argument[i]);
	return _str;
}

/// @func ce_string_join_array(_string, _array)
/// @desc Joins values in the array putting the string between each two
/// consecutive values.
/// @param {string} _string The string to put between two consecutive values.
/// @param {array} _array An array of values that you want to join.
/// @return {string} The resulting string.
/// @example
/// This will show a message saying "Numbers: 1, 2, 3, 4".
/// ```gml
/// show_message("Numbers: " + ce_string_join_array(", ", [1, 2, 3, 4]));
/// ```
function ce_string_join_array(_string, _array)
{
	var _size = array_length(_array);
	if (_size == 0)
	{
		return "";
	}
	var _str = "";
	for (var i = 0; i < _size - 1; ++i)
	{
		_str += string(_array[i]) + _string;
	}
	_str += string(_array[i]);
	return _str;
}

/// @func ce_string_join_list(_string, _list)
/// @desc Joins values in the list putting the string between each two
/// consecutive values.
/// @param {string} _string The string to put between two consecutive values.
/// @param {ds_list} _list The the list of values that you want to join.
/// @return {string} The resulting string.
/// @example
/// This will show a message saying "Numbers: 1, 2, 3, 4".
/// ```gml
/// var _numbers = ds_list_create();
/// ds_list_add(_numbers, 1, 2, 3, 4);
/// show_message("Numbers: " + ce_string_join_list(", ", _numbers));
/// ```
function ce_string_join_list(_string, _list)
{
	var _size = ds_list_size(_list);
	if (_size == 0)
	{
		return "";
	}
	var _str = "";
	for (var i = 0; i < _size - 1; ++i)
	{
		_str += string(_list[| i]) + _string;
	}
	_str += string(_list[| i]);
	return _str;
}

/// @func ce_string_remove_part(_string, _start_str, _end_str)
/// @desc Removes part beginning with `_start_st`r and ending with `_end_str`
/// from the string.
/// @param {string} _string The string to remove the part from.
/// @param {string} _start_str The start of the part to remove.
/// @param {string} _end_str The end of the part to remove.
/// @return {string} The string with the given part removed.
function ce_string_remove_part(_string, _start_str, _end_str)
{
	var _start = string_pos(_start_str, _string);
	var _end = string_pos(_end_str, _string);
	return string_delete(_string, _start, _end - _start + string_length(_end_str));
}

/// @func ce_string_startswith(_string, _substring)
/// @param {string} _string The string.
/// @param {string} _substring The expected start of the string.
/// @return {bool} `true` if the string starts with the substring.
function ce_string_startswith(_string, _substring)
{
	return (string_copy(_string, 1, string_length(_substring)) == _substring);
}

/// @func ce_string_trim(_string)
/// @desc Removes leading and trailing whitespace from the string.
/// @param {string} _string The string to remove the whitespace from.
/// @return {string} The resulting string.
function ce_string_trim(_string)
{
	gml_pragma("forceinline");
	return ce_string_triml(ce_string_trimr(_string));
}

/// @func ce_string_triml(_string)
/// @desc Removes leading whitespace from the string.
/// @param {string} _string The string to remove the whitespace from.
/// @return {string} The resulting string.
function ce_string_triml(_string)
{
	var ch;
	var i = 0;
	do
	{
		ch = string_char_at(_string, 1 + (i++));
	}
	until (ch != " " && ch != "\t" && ch != "\n");
	return string_delete(_string, 1, i - 1);
}

/// @func ce_string_trimr(_string)
/// @desc Removes trailing whitespace from the string.
/// @param {string} _string The string to remove the whitespace from.
/// @return {string} The resulting string.
function ce_string_trimr(_string)
{
	var ch;
	var i = string_length(_string);
	do
	{
		ch = string_char_at(_string, i--);
	}
	until (ch != " " && ch != "\t" && ch != "\n");
	_string = string_delete(_string, i + 2, string_length(_string) - i);
	return _string;
}