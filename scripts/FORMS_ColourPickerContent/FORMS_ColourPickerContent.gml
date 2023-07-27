/// @func FORMS_ColourPickerContent()
///
/// @extends FORMS_Content
///
/// @desc Content of a Color Picker container.
function FORMS_ColourPickerContent()
	: FORMS_Content() constructor
{
	Title = "Color Picker";

	static Draw = function ()
	{
		var _container = Container;
		var _containerWidth = _container.Width;
		var _contentX = 8;
		var _contentY = 4;

		_container.Color = FORMS_DrawColourMix(_contentX, _contentY, _container.Color);
		_contentY += FORMS_ColourMixGetHeight() + 4;

		_container.Alpha = FORMS_DrawAlphaMix(_contentX, _contentY, _container.Alpha);
		_contentY += FORMS_AlphaMixGetHeight() + 4;

		SetSize(_containerWidth, _contentY);
		return self;
	};
}
