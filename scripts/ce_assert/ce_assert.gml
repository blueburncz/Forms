/// @func ce_assert(_exp, _msg)
/// @desc Shows the error message if the expression is not a `real` (`bool`) or
/// equals to `0` (`false`) and aborts the game.
/// @param {any} _exp The expression to assert.
/// @param {string} _msg The error message.
/// @note Asserts work only when {@link CE_DEBUG} is set to `true`!
/// This is handy when you have thoroughly tested your game and you don't want to
/// show error messages in release builds.
/// @see CE_DEBUG
function ce_assert(_exp, _msg)
{
	if (CE_DEBUG)
	{
		if (!(is_real(_exp) || is_bool(_exp)) || !_exp)
		{
			show_error(_msg, true);
		}
	}
}

/// @func ce_assert_ds_exists(_id, _type, _msg)
/// @desc Checks if the data structure of given id and type exists. If it
/// does not, then aborts the game, showing the error message.
/// @param {real} id The id of the ds.
/// @param {real} type The ds type (`ds_type_map`, `ds_type_list`, ...).
/// @param {string} msg The error message.
/// @example
/// ```gml
/// var _map = ds_map_create();
/// ce_assert_ds_exists(_map, ds_type_map,
///     "This should pass, since we just created it.");
/// ds_map_destroy(_map);
/// ce_assert_ds_exists(_map, ds_type_map,
/// "This will abort the game just as expected.");
/// ```
/// @note Asserts work only when {@link CE_DEBUG} is set to `true`!
/// This is handy when you have thoroughly tested your game and you don't want to
/// show error messages in release builds.
/// @see CE_DEBUG
function ce_assert_ds_exists(_id, _type, _msg)
{
	if (CE_DEBUG)
	{
		if (!ds_exists(_id, _type))
		{
			show_error(_msg, true);
		}
	}
}

/// @func ce_assert_equal(_exp, _val, _msg)
/// @desc Shows the error message if the expression is not equal to `val`.
/// @param {any} _exp The expression to assert.
/// @param {any} _val The expected value.
/// @param {string} _msg The error message.
/// @note Asserts work only when {@link CE_DEBUG} is set to `true`!
/// This is handy when you have thoroughly tested your game and you don't want to
/// show error messages in release builds.
/// @see CE_DEBUG
function ce_assert_equal(_exp, _val, _msg)
{
	if (CE_DEBUG)
	{
		if (typeof(_exp) != typeof(_val)
			|| _exp != _val)
		{
			show_error(_msg, true);
		}
	}
}

/// @func ce_assert_is_int(_value, _msg)
/// @desc Checks whether the given value is an integer, if not, shows the error
/// message and aborts the game.
/// @param {any} _value The value to check.
/// @param {string} _msg The error message.
/// @note Asserts work only when {@link CE_DEBUG} is set to `true`!
/// This is handy when you have thoroughly tested your game and you don't want to
/// show error messages in release builds.
/// @see CE_DEBUG
function ce_assert_is_int(_value, _msg)
{
	if (CE_DEBUG)
	{
		if (!is_real(_value)
			|| floor(_value) != _value)
		{
			show_error(_msg, true);
		}
	}
}

/// @func ce_assert_not_equal(exp, val, msg)
/// @desc Shows the error message if the expression is equal to `val`.
/// @param {any} _exp The expression to assert.
/// @param {any} _val The expected value.
/// @param {string} _msg The error message.
/// @note Asserts work only when {@link CE_DEBUG} is set to `true`!
/// This is handy when you have thoroughly tested your game and you don't want to
/// show error messages in release builds.
/// @see CE_DEBUG
function ce_assert_not_equal(_exp, _val, _msg)
{
	if (CE_DEBUG)
	{
		if (typeof(_exp) == typeof(_val)
			&& _exp == _val)
		{
			show_error(_msg, true);
		}
	}
}