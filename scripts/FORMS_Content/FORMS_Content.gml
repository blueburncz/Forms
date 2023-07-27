/// @func FORMS_Content()
///
/// @desc The base struct for container contents.
///
/// @see FORMS_Container
function FORMS_Content() constructor
{
	/// @see {Struct.FORMS_Container} The container that has this content.
	/// @see FORMS_Container
	Container = undefined;

	/// @var {String} The content title.
	Title = "";

	/// @var {Asset.GMSprite} The content icon sprite.
	Icon = undefined;

	/// @var {Real} The icon subimage.
	IconSubimage = 0;

	/// @var {String} The content description.
	Description = "";

	/// @var {Real} The width of the content.
	Width = 0;

	/// @var {Real} The height of the content.
	Height = 0;

	/// @func SetSize(_width, _height)
	///
	/// @desc Sets the size of the content.
	///
	/// @desc {Real} _width The content width.
	/// @desc {Real} _height The content height.
	///
	/// @return {Struct.FORMS_Content} Returns `self`.
	static SetSize = function (_width, _height)
	{
		gml_pragma("forceinline");
		Width = _width;
		Height = _height;
		return self;
	};

	/// @func Draw()
	///
	/// @desc Draws the content.
	///
	/// @return {Struct.FORMS_Content} Returns `self`.
	static Draw = function ()
	{
		return self;
	};
}
