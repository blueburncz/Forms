/// @func FORMS_Content()
///
/// @desc
function FORMS_Content()
{
	/// @var {Struct.FORMS_Widget}
	/// @readonly
	Container = undefined;

	/// @var {Struct.FORMS_Pen}
	/// @readonly
	Pen = new FORMS_Pen();

	/// @var {Real}
	Width = 0;

	/// @var {Real}
	Height = 0;

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
