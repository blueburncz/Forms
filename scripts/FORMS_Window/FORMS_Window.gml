/// @func FORMS_WindowProps()
///
/// @extends FORMS_FlexBoxProps
///
/// @desc
function FORMS_WindowProps()
	: FORMS_FlexBoxProps() constructor
{
	BackgroundSprite = undefined;

	BackgroundIndex = undefined;

	BackgroundColor = undefined;

	BackgroundAlpha = undefined;
}

/// @func FORMS_Window([_content[, _props]])
///
/// @extends FORMS_FlexBox
///
/// @desc
///
/// @params {Struct.FORMS_Content, Undefined} [_content]
/// @params {Struct.FORMS_WindowProps, Undefined} [_props]
function FORMS_Window(_content=undefined, _props=undefined)
	: FORMS_FlexBox(_props) constructor
{
	static FlexBox_update = update;
	static FlexBox_draw = draw;

	Width.from_props(_props, "Width", 400);
	Height.from_props(_props, "Height", 300);
	PaddingX.from_props(_props, "PaddingX", 4);
	PaddingY.from_props(_props, "PaddingY", 4);
	IsHorizontal = false;

	BackgroundSprite = forms_get_prop(_props, "BackgroundSprite") ?? FORMS_SprRound4;

	BackgroundIndex = forms_get_prop(_props, "BackgroundIndex") ?? 0;

	BackgroundColor = forms_get_prop(_props, "BackgroundColor") ?? #202020;

	BackgroundAlpha = forms_get_prop(_props, "BackgroundAlpha") ?? 1.0;

	ScrollPane = new FORMS_ScrollPane(_content, {
		Width: 100,
		WidthUnit: FORMS_EUnit.Percent,
		Flex: 1,
		Container: {
			BackgroundColor: #404040,
		}
	});

	add_child(ScrollPane);

	static update = function (_deltaTime)
	{
		FlexBox_update(_deltaTime);
		if (is_mouse_over())
		{
			var _mouseX = forms_mouse_get_x();
			var _mouseY = forms_mouse_get_y();

			if (_mouseX < __realX + 4 || _mouseX >= __realX + __realWidth - 4)
			{
				forms_set_cursor(cr_size_we);
			}
			else if (_mouseY < __realY + 4 || _mouseY >= __realY + __realHeight - 4)
			{
				forms_set_cursor(cr_size_ns);
			}
		}
		return self;
	};

	static draw = function ()
	{
		draw_sprite_stretched_ext(
			BackgroundSprite, BackgroundIndex,
			__realX, __realY, __realWidth, __realHeight,
			BackgroundColor, BackgroundAlpha);
		FlexBox_draw();
		return self;
	};
}
