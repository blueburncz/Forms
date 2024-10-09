/// @func FORMS_KeyboardShortcut([_keys[, _mouseButtons]])
///
/// @desc A collection of keyboard keys and mouse buttons that together
/// represent a single keyboard shortcut.
///
/// @param {Array<Constant.VirtualKey>, Undefined} [_keys] An array of keys that
/// trigger the shorcut or `undefined` (default).
/// @param {Array<Constant.MouseButton>, Undefined} [_mouseButtons] An array of
/// mouse buttons that trigger the shortcut or `undefined` (default).
function FORMS_KeyboardShortcut(_keys = undefined, _mouseButtons = undefined) constructor
{
	/// @var {Array<Constant.VirtualKey>} An array of keys that trigger the
	/// shortcut.
	/// @readonly
	/// @see FORMS_KeyboardShortcut.add_key
	Keys = [];

	/// @var {Array<Constant.MouseButton>} An array of mouse buttons that
	/// trigger the shortcut.
	/// @readonly
	/// @see FORMS_KeyboardShortcut.add_mouse_button
	MouseButtons = [];

	if (_keys != undefined)
	{
		for (var i = array_length(_keys) - 1; i >= 0; --i)
		{
			add_key(_keys[i]);
		}
	}

	if (_mouseButtons != undefined)
	{
		for (var i = array_length(_mouseButtons) - 1; i >= 0; --i)
		{
			add_mouse_button(_mouseButtons[i]);
		}
	}

	/// @func get_size()
	///
	/// @desc Retrieves the number of keys and mouse buttons assigned to the
	/// keyboard shortcut.
	///
	/// @return {Real} Returns the number of keys and mouse buttons assigned to
	/// the keyboard shortcut. 
	static get_size = function ()
	{
		gml_pragma("forceinline");
		return (array_length(Keys) + array_length(MouseButtons));
	}

	/// @func __get_key_index(_key)
	///
	/// @desc
	///
	/// @param {Constant.VirtualKey} _key
	///
	/// @return {Real}
	///
	/// @private
	static __get_key_index = function (_key)
	{
		for (var i = array_length(Keys) - 1; i >= 0; --i)
		{
			if (Keys[i] == _key)
			{
				return i;
			}
		}
		return -1;
	}

	/// @func __get_mouse_button_index(_button)
	///
	/// @desc
	///
	/// @param {Constant.MouseButton} _button
	///
	/// @return {Real}
	///
	/// @private
	static __get_mouse_button_index = function (_button)
	{
		for (var i = array_length(MouseButtons) - 1; i >= 0; --i)
		{
			if (MouseButtons[i] == _button)
			{
				return i;
			}
		}
		return -1;
	}

	/// @func has_key(_key)
	///
	/// @desc Checks whether given key is assigned to the keyboard shortcut.
	///
	/// @param {Constant.VirtualKey} _key The keyboard key to check.
	///
	/// @return {Bool} Returns `true` if given key is assigned to the keyboard
	/// shortcut.
	static has_key = function (_key)
	{
		gml_pragma("forceinline");
		return (__get_key_index(_key) != -1);
	}

	/// @func add_key(_key)
	///
	/// @desc Adds a keyboard key to the keyboard shortcut.
	///
	/// @param {Constant.VirtualKey} _key The keyboard key to add.
	///
	/// @return {Struct.FORMS_KeyboardShortcut} Returns `self`.
	static add_key = function (_key)
	{
		if (!has_key(_key))
		{
			array_push(Keys, _key);
			array_sort(Keys, true);
		}
		return self;
	}

	/// @func has_mouse_button(_button)
	///
	/// @desc Checks whether given mouse button is assigned to the keyboard
	/// shortcut.
	///
	/// @param {Constant.MouseButton} _button The mouse button to check.
	///
	/// @return {Bool} Returns `true` if given mouse button is assigned to the
	/// keyboard shortuct.
	static has_mouse_button = function (_button)
	{
		gml_pragma("forceinline");
		return (__get_mouse_button_index(_button) != -1);
	}

	/// @func add_mouse_button(_button)
	///
	/// @desc Adds a mouse button to the keyboard shortcut.
	///
	/// @param {Constant.MouseButton} _button The mouse button to add.
	///
	/// @return {Struct.FORMS_KeyboardShortcut} Returns `self`.
	static add_mouse_button = function (_button)
	{
		if (!has_mouse_button(_button))
		{
			array_push(MouseButtons, _button);
			array_sort(MouseButtons, true);
		}
		return self;
	}

	static check = function ()
	{
		// TODO: Implement FORMS_KeyboardShortcut.check
		return false;
	}

	static check_pressed = function ()
	{
		// TODO: Implement FORMS_KeyboardShortcut.check_pressed
		return false;
	}

	/// @func to_string()
	///
	/// @desc Converts the keyboard shortcut into a string.
	///
	/// @return {String} The keyboard shortcut represented as a string.
	static to_string = function ()
	{
		var _string = "";
		var _isFirst = true;

		var i = 0;
		repeat(array_length(Keys))
		{
			if (!_isFirst)
			{
				_string += "+";
			}
			else
			{
				_isFirst = false;
			}
			_string += forms_key_to_string(Keys[i++]);
		}

		i = 0;
		repeat(array_length(MouseButtons))
		{
			if (!_isFirst)
			{
				_string += "+";
			}
			else
			{
				_isFirst = false;
			}
			_string += forms_mouse_button_to_string(MouseButtons[i++]);
		}

		return _string;
	}
}

/// @func forms_key_to_string(_key)
///
/// @desc Converts a keyboard key to a string.
///
/// @param {Constant.VirtualKey} _key The keyboard key to convert.
///
/// @return {String} The keyboard key represented as a string.
function forms_key_to_string(_key)
{
	if (_key >= vk_f1 && _key <= vk_f12)
	{
		return ("F" + string(_key - vk_f1 + 1));
	}

	if (_key >= vk_numpad0 && _key <= vk_numpad9)
	{
		return ("Num" + string(_key - vk_numpad0));
	}

	switch (_key)
	{
		case vk_escape:
			return "Esc";

		case vk_delete:
			return "Delete";

		case vk_backspace:
			return "Backspace";

		case vk_tab:
			return "Tab";

		case vk_shift:
			return "Shift";

		case vk_control:
			return "Ctrl";

		case vk_lcontrol:
			return "LeftCtrl";

		case vk_rcontrol:
			return "RightCtrl";

		case vk_alt:
			return "Alt";

		case vk_lalt:
			return "LeftAlt";

		case vk_ralt:
			return "RightAlt";

		case vk_printscreen:
			return "PrintScrn";

		case vk_pause:
			return "Pause";

		case vk_pageup:
			return "PageUp";

		case vk_pagedown:
			return "PageDown";

		case vk_insert:
			return "Insert";

		case vk_home:
			return "Home";

		case vk_enter:
			return "Enter";

		case vk_end:
			return "End";

		case vk_space:
			return "Spacebar";

		case vk_left:
			return "Left";

		case vk_right:
			return "Right";

		case vk_up:
			return "Up";

		case vk_down:
			return "Down";

		case vk_multiply:
			return "Multiply";

		case vk_divide:
			return "Divide";

		case vk_add:
			return "Plus";

		case vk_subtract:
			return "Minus";

		case vk_decimal:
			return "Decimal";
	}

	return chr(_key);
}

/// @func forms_mouse_button_to_string(_button)
///
/// @desc Converts a mouse button to a string.
///
/// @param {Constant.MouseButton} _button The mouse button to convert.
///
/// @return {String} The mouse button represented as a string.
function forms_mouse_button_to_string(_button)
{
	switch (_button)
	{
		case mb_left:
			return "LMB";

		case mb_right:
			return "RMB";

		case mb_middle:
			return "MMB";

		case mb_side1:
			return "SMB1";

		case mb_side2:
			return "SMB2";

		default:
			return "";
	}
}
