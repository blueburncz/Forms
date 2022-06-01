/// @macro {string/real} The current index in the iteration.
#macro CE_ITER_INDEX global.__ce_iter_index_prev

/// @macro {any} The current value in the iteration.
#macro CE_ITER_VALUE global.__ce_iter_value

/// @macro {code} Breaks the current iteration (equivalent of `break`).
#macro CE_ITER_BREAK { _ce_iter_restore_context(); break; }

/// @macro {code} Goes to the next step in the iteration (equivalent of `continue`).
#macro CE_ITER_CONTINUE continue

/// @var {real} A stack used for iteration context switches.
/// @private
global.__ce_iter_stack = ds_stack_create();

/// @var {array/real} The currently iterated structure. Can be an array or an
/// id of a data structure.
/// @private
global.__ce_iter_struct = undefined;

/// @var {real} The type of the currently iterated structure. Equals -1 when
/// iterating an array.
/// @private
global.__ce_iter_type = undefined;

/// @var {real} Number of left iterations in the currently iterated structure.
/// @private
global.__ce_iter_counter = undefined;

/// @var {string/real} The current iteration index.
/// @private
global.__ce_iter_index = undefined;

/// @var {string/real} The previous iteration index.
/// @private
global.__ce_iter_index_prev = undefined;

/// @var {any} The current iteration value.
/// @private
global.__ce_iter_value = undefined;

/// @func _ce_iter_restore_context()
/// @private
function _ce_iter_restore_context()
{
	if (ds_stack_size(global.__ce_iter_stack) > 0)
	{
		var _context = ds_stack_pop(global.__ce_iter_stack);
		global.__ce_iter_struct = _context[0];
		global.__ce_iter_type = _context[1];
		global.__ce_iter_counter = _context[2];
		global.__ce_iter_index = _context[3];
		global.__ce_iter_index_prev = _context[4];
	}
}

/// @func ce_iter(struct[, ds_type])
/// @desc Iterates over the data structure. Should be used only as the conditional
/// in the `while` clause! Nested iterators are supported.
/// @param {array/real} struct The array or the id of the data structure.
/// @param {real} [type] The type of the data structure. Currently `ds_type_list`
/// and `ds_type_map` are supported. This parameter is obligatory when `struct` is
/// not an array.
/// @return {bool} `true` if the iteration continues.
/// @example
/// Following code iterates through the array, skipping index 1 and breaking
/// at index 2, so it prints only '0:1' and '2:3' to the console.
/// ```gml
/// var _arr = [1, 2, 3, 4];
/// while (ce_iter(_arr))
/// {
///     if (CE_ITER_INDEX == 1)
///     {
///         CE_ITER_CONTINUE;
///     }
///     show_debug_message(
///         ce_string_format("${0}: ${1}", [CE_ITER_INDEX, CE_ITER_VALUE]));
///     if (CE_ITER_INDEX == 2)
///     {
///         CE_ITER_BREAK;
///     }
/// }
/// ```
/// @note All structures have to be created first and stored into a variable
/// before iterating them!
function ce_iter(_struct)
{
	var _type;

	if (argument_count > 1)
	{
		_type = argument[1];
	}
	else
	{
		ce_assert(is_array(_struct),
			"Data structure type must be specified for non arrays!");
		_type = -1;
	}

	// Iteration target has changed.
	if (global.__ce_iter_type != _type
		|| global.__ce_iter_struct != _struct)
	{
		// Store current context into the stack.
		if (global.__ce_iter_struct != undefined)
		{
			ds_stack_push(global.__ce_iter_stack, [
				global.__ce_iter_struct,
				global.__ce_iter_type,
				global.__ce_iter_counter,
				global.__ce_iter_index,
				global.__ce_iter_index_prev,
			]);
		}

		// Create new contex.
		global.__ce_iter_struct = _struct;
		global.__ce_iter_type = _type;

		var _size;
		var _index;

		switch (_type)
		{
		case -1:
			_size = array_length(_struct);
			_index = 0;
			break;

		case ds_type_list:
			_size = ds_list_size(_struct);
			_index = 0;
			break;

		case ds_type_map:
			_size = ds_map_size(_struct);
			_index = ds_map_find_first(_struct);
			break;
		}

		global.__ce_iter_counter = _size;
		global.__ce_iter_index = _index;
	}

	// Continue iteration.
	if (global.__ce_iter_counter > 0)
	{
		--global.__ce_iter_counter;

		global.__ce_iter_index_prev = global.__ce_iter_index;

		switch (global.__ce_iter_type)
		{
		case -1:
			global.__ce_iter_value = global.__ce_iter_struct[global.__ce_iter_index++];
			break;

		case ds_type_list:
			global.__ce_iter_value = global.__ce_iter_struct[| global.__ce_iter_index++];
			break;

		case ds_type_map:
			global.__ce_iter_value = global.__ce_iter_struct[? global.__ce_iter_index];
			global.__ce_iter_index = ds_map_find_next(global.__ce_iter_struct, global.__ce_iter_index);
			break;

		default:
			ce_assert(false, "Iteration of " + string(global.__ce_iter_type) + " is not supported!");
		}

		return true;
	}

	// Restore previous context at the end of the iteration.
	_ce_iter_restore_context();

	return false;
}