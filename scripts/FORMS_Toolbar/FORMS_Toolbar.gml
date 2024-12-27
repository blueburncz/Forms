/// @func FORMS_ToolbarProps()
///
/// @extends FORMS_ContainerProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_Toolbar}.
function FORMS_ToolbarProps(): FORMS_ContainerProps() constructor {}

/// @func FORMS_Toolbar([_props])
///
/// @extends FORMS_Container
///
/// @desc A basic horizontal toolbar.
///
/// @param {Struct.FORMS_ToolbarProps, Undefined} [_props] Properties to create the toolbar with or `undefined`
/// (default).
function FORMS_Toolbar(_props = undefined): FORMS_Container(_props) constructor
{
	/// @var {Struct.FORMS_UnitValue} The width of the toolbar. Defaults to 100%.
	Width = Width.from_props(_props, "Width", 100, FORMS_EUnit.Percent);

	/// @var {Struct.FORMS_UnitValue} The height of the window. Defaults to 28px.
	Height = Height.from_props(_props, "Height", 28);

	Pen.PaddingY = 4;
	Pen.SpacingX = 2;
}
