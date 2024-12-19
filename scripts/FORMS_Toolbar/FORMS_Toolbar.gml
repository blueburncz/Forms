/// @func FORMS_ToolbarProps()
///
/// @extends FORMS_ContainerProps
///
/// @desc TODO
function FORMS_ToolbarProps(): FORMS_ContainerProps() constructor {}

/// @func FORMS_Toolbar([_props])
///
/// @extends FORMS_Container
///
/// @desc TODO
///
/// @param {Struct.FORMS_ToolbarProps, Undefined} [_props]
function FORMS_Toolbar(_props = undefined): FORMS_Container(_props) constructor
{
	/// @var {Struct.FORMS_UnitValue} The width of the toolbar. Defaults to 100%.
	Width = Width.from_props(_props, "Width", 100, FORMS_EUnit.Percent);

	/// @var {Struct.FORMS_UnitValue} The height of the window. Defaults to 28px.
	Height = Height.from_props(_props, "Height", 28);

	Pen.PaddingY = 4;
	Pen.SpacingX = 2;
}
