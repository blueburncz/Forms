/// @func ce_instance_create_3d(_x[, _y, _z], _object)
/// @desc Creates an instance of an object at given x, y, z position
/// on a layer with id 0.
/// @param {real/real[]} _x The x position to create the instance at
/// or an array with `[x, y, z]` position.
/// @param {real} [_y] The y position to create the instance at. Not
/// used if `_x` is an array.
/// @param {real} [_z] The z position to create the instance at. Not
/// used if `_x` is an array.
/// @param {object} _object The object to create an instance of.
/// @return {real} The id of the created instance.
function ce_instance_create_3d(_x)
{
	gml_pragma("forceinline");

	var _y, _z, _object;

	if (argument_count == 4)
	{
		_y = argument[1];
		_z = argument[2];
		_object = argument[3];
	}
	else
	{
		_y = _x[1];
		_z = _x[2];
		_x = _x[0];
		_object = argument[1];
	}

	with (instance_create_layer(_x, _y, 0, _object))
	{
		z = _z;
		return id;
	}
}