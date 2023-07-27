/// @func FORMS_KeyboardShortcut(_action)
///
/// @param {Function} _action A function or `undefined`.
function FORMS_KeyboardShortcut(_action) constructor
{
	/// @var {Function}
	OnAction = _action;

	/// @var {Array<Real>}
	/// @private
	Keys = [];

	/// @func AddKey(_key)
	///
	/// @desc Adds key to the keyboard shortcut.
	///
	/// @param {Real} _key The key.
	static AddKey = function (_key)
	{
		gml_pragma("forceinline");
		array_push(Keys, _key);
	};

	/// @func Update()
	///
	/// @desc Updates the keyboard shortcut.
	static Update = function ()
	{
		if (OnAction == undefined
			|| FORMS_INPUT_ACTIVE != undefined)
		{
			return;
		}

		var _size = array_length(Keys);
		if (_size != ds_list_size(FORMS_KEY_LOG))
		{
			return;
		}

		for (var i = _size - 1; i >= 0; --i)
		{
			if (FORMS_KEY_LOG[| i] != Keys[i])
			{
				return;
			}
		}

		ds_list_delete(FORMS_KEY_LOG, _size - 1);
		OnAction();
	}

	/// @func ToString()
	///
	/// @desc Converts the keyboard shortcut into a human readable string.
	///
	/// @return {String} The keyboard shortcut converted into a human readable
	/// string.
	static ToString = function ()
	{
		var _string = "";
		var _size = array_length(Keys);
		for (var i = 0; i < _size - 1; ++i)
		{
			_string += FORMS_KeyToString(Keys[i]) + "+";
		}
		if (_size >= 1)
		{
			_string += FORMS_KeyToString(Keys[_size - 1]);
		}
		return _string;
	};
}
