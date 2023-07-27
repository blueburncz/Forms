/// @func FORMS_Pen([_x[, _y]])
///
/// @desc
///
/// @param {Real} [_x]
/// @param {Real} [_y]
function FORMS_Pen(_x=0, _y=0) constructor
{
	/// @var {Real}
	X = _x;

	/// @var {Real}
	ColumnX = _x;

	/// @var {Real}
	Y = _y;

	/// @var {Real}
	LineHeight = FORMS_LINE_HEIGHT;

	/// @var {Real}
	MaxX = _x;

	/// @var {Real}
	MaxY = _y;

	/// @var {Bool}
	KeepPosition = false;

	/// @func Newline([_count])
	///
	/// @desc
	///
	/// @param {Real} [_count]
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	static Newline = function (_count=1)
	{
		gml_pragma("forceinline");
		if (!KeepPosition)
		{
			X = ColumnX;
			Y += LineHeight * _count;
			MaxX = max(X, MaxX);
			MaxY = max(Y, MaxY);
		}
		return self;
	};

	/// @func Move(_x[, _y])
	///
	/// @desc
	///
	/// @param {Real} _x
	/// @param {Real} [_y]
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	static Move = function (_x, _y=0)
	{
		gml_pragma("forceinline");
		if (!KeepPosition)
		{
			X += _x;
			Y += _y;
			MaxX = max(X, MaxX);
			MaxY = max(Y, MaxY);
		}
		return self;
	};
}
