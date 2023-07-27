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
	/// @readonly
	/// @see FORMS_Content.SetSize
	Width = 0;

	/// @var {Real} The height of the content.
	/// @readonly
	/// @see FORMS_Content.SetSize
	Height = 0;

	/// @var {Function, Undefined} A function executed in the {@link FORMS_Content.Draw}
	/// method. The content is passed to it as the first argument.
	OnDraw = undefined;

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
		Width = max(_width, 1);
		Height = max(_height, 1);
		return self;
	};

	/// @func Draw()
	///
	/// @desc Draws the content.
	///
	/// @return {Struct.FORMS_Content} Returns `self`.
	static Draw = function ()
	{
		if (OnDraw != undefined)
		{
			OnDraw(self);
		}
		return self;
	};
}
