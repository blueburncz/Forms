/// @func forms_keyboard_shortcut_create(action)
/// @desc Creates a new keyboard shortcut.
/// @param {real} action The script that will be executed with the keyboard shortcut.
/// @return {real} The id of the created keyboard shortcut.
function forms_keyboard_shortcut_create(action)
{
	var _shortcut = ds_map_create();
	ds_map_add_list(_shortcut, "keys", ds_list_create());
	_shortcut[? "scr_action"] = action;
	return _shortcut;
}

/// @func forms_keyboard_shortcut_add_key(keyboard_shortcut, key)
/// @desc Adds key to the keyboard shortcut.
/// @param {real} keyboard_shortcut The id of the keyboard shortcut.
/// @param {real} key The key.
function forms_keyboard_shortcut_add_key(keyboard_shortcut, key)
{
	gml_pragma("forceinline");
	ds_list_add(keyboard_shortcut[? "keys"], key);
}

/// @func forms_keyboard_shortcut_to_string(keyboard_shortcut)
/// @desc Converts the keyboard shortcut into a human readable string.
/// @param {real} keyboard_shortcut The id of the keyboard shortcut.
/// @return {string} The keyboard shortcut converted into a human readable string.
function forms_keyboard_shortcut_to_string(keyboard_shortcut)
{
	var _keys = keyboard_shortcut[? "keys"];
	var _string = "";
	var _size = ds_list_size(_keys);
	for (var i = 0; i < _size - 1; ++i)
	{
		_string += forms_key_to_string(_keys[| i]) + "+";
	}
	if (_size >= 1)
	{
		_string += forms_key_to_string(_keys[| _size - 1]);
	}
	return string_upper(_string);
}

/// @func forms_keyboard_shortcut_update(keyboard_shortcut)
/// @desc Updates the keyboard shortcut.
/// @param {real} keyboard_shortcut The keyboard shortcut.
function forms_keyboard_shortcut_update(keyboard_shortcut)
{
	var _action = keyboard_shortcut[? "scr_action"];
	if (_action == noone
		|| forms_input_active != noone)
	{
		exit;
	}

	var _keys = keyboard_shortcut[? "keys"];
	var _size = ds_list_size(_keys);

	if (_size != ds_list_size(forms_key_log))
	{
		exit;
	}

	for (var i = _size - 1; i >= 0; --i)
	{
		if (forms_key_log[| i] != _keys[| i])
		{
			exit;
		}
	}

	ds_list_delete(forms_key_log, _size - 1);
	_action();
}