/// @func ce_ds_map_clone(_map)
/// @desc Creates a shallow copy of the map.
/// @param {ds_map} _map The map to clone.
/// @return {ds_map} The created map.
function ce_ds_map_clone(_map)
{
	var _clone = ds_map_create();
	ds_map_copy(_clone, _map);
	return _clone;
}

/// @func ce_ds_map_create_from_array(_key_value_array)
/// @desc Creates a new map, taking keys and values from the array.
/// @param {array} _key_value_array An array that containing keys at odd indices and
/// values at even indices.
/// @return {ds_map} The created map.
/// @example
/// Variables `_p1` and `_p2` hold maps with the exact same key-value pairs.
/// ```gml
/// var _p1 = ce_ds_map_create_from_array([
///     "first_name", "Some",
///     "last_name", "Dude",
///     "age", 24,
/// ]);
/// var _p2 = ds_map_create();
/// ds_map_add(_p2, "first_name", "Some");
/// ds_map_add(_p2, "last_name", "Dude");
/// ds_map_add(_p2, "age", 24);
/// ```
function ce_ds_map_create_from_array(_key_value_array)
{
	var _map = ds_map_create();
	var _size = array_length(_key_value_array);
	for (var i = 0; i < _size; i += 2)
	{
		_map[? _key_value_array[i]] = _key_value_array[i + 1];
	}
	return _map;
}

/// @func ce_ds_map_extend(_target, _source)
/// @desc Shallowly copies key-value pairs from source map to the target map,
/// overwriting the already existing ones.
/// @param {ds_map} _target The map to be extended.
/// @param {ds_map} _source The map to take the key-value pairs from.
function ce_ds_map_extend(_target, _source)
{
	var _size = ds_map_size(_source);
	var _key = ds_map_find_first(_source)
	for (var i = 0; i < _size; ++i)
	{
		_target[? _key] = _source[? _key];
		_key = ds_map_find_next(_source, _key);
	}
}

/// @func ce_ds_map_extend_from_array(_map, _key_value_array)
/// @desc Extends a map by key-value pairs stored in an array.
/// @param {ds_map} _map The map to extend.
/// @param {array} _key_value_array An array that contains keys
/// at odd indices and values at even indices.
function ce_ds_map_extend_from_array(_map, _key_value_array)
{
	var _size = array_length(_key_value_array);
	for (var i = 0; i < _size; i += 2)
	{
		_map[? _key_value_array[i]] = _key_value_array[i + 1];
	}
}

/// @func ce_ds_map_find_key(_map, _value)
/// @desc Finds the first key of the map that contains given value.
/// @param {ds_map} _map The map to search in.
/// @param {any} _value The value that the key should contain.
/// @return {string/real} The found key or `undefined`.
function ce_ds_map_find_key(_map, _value)
{
	var _key = ds_map_find_first(_map);
	repeat (ds_map_size(_map))
	{
		if (_map[? _key] == _value)
		{
			return _key;
		}
		_key = ds_map_find_next(_map, _key);
	}
	return undefined;
}

/// @func ce_ds_map_get(_map, _index[, _default])
/// @desc Retrieves a value at given index of a map.
/// @param {ds_map} _map The map to get the value from.
/// @param {real} _index The index.
/// @param {any} [_default] The default value. Defaults to `undefined`.
/// @return {any} Value at given index or the default value if the index does
/// not exist.
/// @example
/// ```gml
/// var _map = ds_map_create();
/// _map[? "a"] = 1;
/// _map[? "b"] = 2;
/// ce_ds_map_get(_map, "a"); // => 1
/// ce_ds_map_get(_map, "b", 1); // => 2
/// ce_ds_map_get(_map, "c", 3); // => 3
/// ce_ds_map_get(_map, "c"); // => undefined
/// ```
function ce_ds_map_get(_map, _index)
{
	if (argument_count > 2
		&& !ds_map_exists(_map, _index))
	{
		return argument[2];
	}
	return _map[? _index];
}

/// @func ce_ds_map_get_keys(_map)
/// @desc Retrieves an array of keys of a map.
/// @param {ds_map} _map The map.
/// @return {array} An array of all keys in the map.
function ce_ds_map_get_keys(_map)
{
	var _size = ds_map_size(_map);
	var _arr = array_create(_size, "");
	var _key = ds_map_find_first(_map)
	for (var i = 0; i < _size; ++i)
	{
		_arr[i] = _key;
		_key = ds_map_find_next(_map, _key);
	}
	return _arr;
}

/// @func ce_ds_map_get_values(_map)
/// @desc Retrieves an array of values of a map.
/// @param {ds_map} _map The map.
/// @return {array} An array of all values in the map.
function ce_ds_map_get_values(_map)
{
	var _size = ds_map_size(_map);
	var _arr = array_create(_size, "");
	var _key = ds_map_find_first(_map)
	for (var i = 0; i < _size; ++i)
	{
		_arr[i] = _map[? _key];
		_key = ds_map_find_next(_map, _key);
	}
	return _arr;
}