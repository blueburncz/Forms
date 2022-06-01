/// @func ce_struct_get(_struct, _name[, _default])
/// @desc Retrieves structure's property value.
/// @param {struct} _struct The structure.
/// @param {string} _name The property name.
/// @param {any} [_default] The value returned when the struct doesn't have
/// such property.
/// @return {any} The property value.
function ce_struct_get(_struct, _name)
{
	gml_pragma("forceinline");
	if (!variable_struct_exists(_struct, _name))
	{
		return (argument_count > 2)
			? argument[2]
			: undefined;
	}
	return variable_struct_get(_struct, _name);
}

/// @func ce_struct_set(_struct, _name, _value)
/// @desc Sets structure's property value.
/// @param {struct} _struct The structure.
/// @param {string} _name The property name.
/// @param {any} _value The value.
/// @note This is equivalent to using `variable_struct_set`.
function ce_struct_set(_struct, _name, _value)
{
	gml_pragma("forceinline");
	variable_struct_set(_struct, _name, _value);
}