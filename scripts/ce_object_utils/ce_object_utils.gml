/// @func ce_object_get_base(_object)
/// @param {real} _object The object index.
/// @return {real} The index of the base object in the object's ancestors
/// hierarchy.
/// @example
/// If object `C` has parent `B` and object `B` has parent `A`, then
/// `ce_object_get_base(C) would return `A`.
function ce_object_get_base(_object)
{
	while (true)
	{
		var _parent = object_get_parent(_object);
		if (_parent < 0)
		{
			return _object;
		}
		_object = _parent;
	}
}

/// @func ce_object_is(_a, _b)
/// @param {real} _a The index of object A.
/// @param {real} _b The index of object B.
/// @return {bool} `true` if object A is or inherits from object B.
function ce_object_is(_a, _b)
{
	gml_pragma("forceinline");
	return (_a == _b || object_is_ancestor(_a, _b));
}