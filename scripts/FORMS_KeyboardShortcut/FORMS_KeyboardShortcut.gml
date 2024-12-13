/// @macro {Constant.VirtualKey} Keycode for the command key on macOS.
#macro FORMS_VK_CMD 92

/// @func FORMS_KeyboardShortcut([_keys[, _mouseButtons]])
///
/// @desc A collection of keyboard keys and mouse buttons that together represent a single keyboard shortcut.
///
/// @param {Array<Constant.VirtualKey>, Undefined} [_keys] An array of keys that trigger the shortcut or `undefined`
/// (default).
/// @param {Array<Constant.MouseButton>, Undefined} [_mouseButtons] An array of mouse buttons that trigger the shortcut
/// or `undefined` (default).
function FORMS_KeyboardShortcut(_keys = undefined, _mouseButtons = undefined) constructor
{
	/// @var {Array<Constant.VirtualKey>} An array of keys that trigger the shortcut.
	/// @readonly
	/// @see FORMS_KeyboardShortcut.add_key
	Keys = [];

	/// @var {Array<Constant.MouseButton>} An array of mouse buttons that trigger the shortcut.
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
	/// @desc Retrieves the number of keys and mouse buttons assigned to the keyboard shortcut.
	///
	/// @return {Real} Returns the number of keys and mouse buttons assigned to the keyboard shortcut. 
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
	/// @return {Bool} Returns `true` if given key is assigned to the keyboard shortcut.
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
	/// @desc Checks whether given mouse button is assigned to the keyboard shortcut.
	///
	/// @param {Constant.MouseButton} _button The mouse button to check.
	///
	/// @return {Bool} Returns `true` if given mouse button is assigned to the keyboard shortcut.
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

	/// @func check()
	///
	/// @desc Tests whether all keys bound to the shortcut are checked.
	///
	/// @return {Bool} Returns `true` if all keys bound to the shortcut are checked.
	static check = function ()
	{
		var _keysLength = array_length(Keys);
		var _mouseButtonsLength = array_length(MouseButtons);

		if (_keysLength == 0 && _mouseButtonsLength == 0)
		{
			return false;
		}

		for (var i = 0; i < _keysLength; ++i)
		{
			if (!keyboard_check(Keys[i]))
			{
				return false;
			}
		}

		for (var i = 0; i < _mouseButtonsLength; ++i)
		{
			if (!mouse_check_button(MouseButtons[i]))
			{
				return false;
			}
		}

		return true;
	}

	/// @func check_pressed()
	///
	/// @desc Tests whether all keys bound to the shortcut are pressed.
	///
	/// @return {Bool} Returns `true` if all keys bound to the shortcut are pressed.
	static check_pressed = function ()
	{
		var _keysLength = array_length(Keys);
		var _mouseButtonsLength = array_length(MouseButtons);

		if (_keysLength == 0 && _mouseButtonsLength == 0)
		{
			return false;
		}

		for (var i = _keysLength - ((_mouseButtonsLength > 0) ? 1 : 2); i >= 0; --i)
		{
			if (!keyboard_check(Keys[i]))
			{
				return false;
			}
		}

		if (_keysLength > 0 && _mouseButtonsLength == 0)
		{
			if (!keyboard_check_pressed(array_last(Keys)))
			{
				return false;
			}
		}

		for (var i = 0; i < _mouseButtonsLength - 1; ++i)
		{
			if (!mouse_check_button(MouseButtons[i]))
			{
				return false;
			}
		}

		if (_mouseButtonsLength > 0)
		{
			if (!mouse_check_button_pressed(array_last(MouseButtons)))
			{
				return false;
			}
		}

		return true;
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

/// @func forms_key_is_control_key(_key)
///
/// @desc Does a primitive check whether given keycode is a control key.
///
/// @param {Constant.VirtualKey} _key The key to check.
///
/// @return {Bool} Returns `true` if given key is a control key or `false` if it likely represents a printable character.
function forms_key_is_control_key(_key)
{
	switch (_key)
	{
		case vk_left:
		case vk_right:
		case vk_up:
		case vk_down:
		case vk_enter:
		case vk_escape:
			//case vk_space:
		case vk_shift:
		case vk_control:
		case vk_alt:
		case vk_backspace:
		case vk_tab:
		case vk_home:
		case vk_end:
		case vk_delete:
		case vk_insert:
		case vk_pageup:
		case vk_pagedown:
		case vk_pause:
		case vk_printscreen:
		case vk_f1:
		case vk_f2:
		case vk_f3:
		case vk_f4:
		case vk_f5:
		case vk_f6:
		case vk_f7:
		case vk_f8:
		case vk_f9:
		case vk_f10:
		case vk_f11:
		case vk_f12:
			//case vk_numpad0:
			//case vk_numpad1:
			//case vk_numpad2:
			//case vk_numpad3:
			//case vk_numpad4:
			//case vk_numpad5:
			//case vk_numpad6:
			//case vk_numpad7:
			//case vk_numpad8:
			//case vk_numpad9:
			//case vk_multiply:
			//case vk_divide:
			//case vk_add:
			//case vk_subtract:
			//case vk_decimal:
		case vk_lshift:
		case vk_lcontrol:
		case vk_lalt:
		case vk_rshift:
		case vk_rcontrol:
		case vk_ralt:
			return true;

		default:
			return false;
	}
}
