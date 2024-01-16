/// @func FORMS_Content([_name])
///
/// @desc
///
/// @param {String} [_name]
function FORMS_Content(_name="")
{
	/// @var {String}
	Name = _name;

	// TODO: Content icons
	Icon = undefined;

	/// @var {Struct.FORMS_Container}
	/// @readonly
	Container = undefined;

	/// @var {Struct.FORMS_Pen}
	/// @readonly
	Pen = new FORMS_Pen(self);

	/// @var {Real}
	Width = 0;

	/// @var {Real}
	Height = 0;

	/// @func fetch_size()
	///
	/// @desc
	///
	/// @return {Struct.FORMS_Content} Returns `self`.
	static fetch_size = function ()
	{
		var _surface = surface_create(1, 1);
		surface_set_target(_surface);
		draw();
		surface_reset_target();
		surface_free(_surface);
		return self;
	};

	/// @func draw()
	///
	/// @desc
	///
	/// @return {Struct.FORMS_Content} Returns `self`.
	static draw = function ()
	{
		return self;
	};
}
