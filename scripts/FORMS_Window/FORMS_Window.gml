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

/// @enum
enum FORMS_EWindowResize
{
	None = 0,
	Left = 1,
	Right = 2,
	Top = 4,
	Bottom = 8,
};

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
	static FlexBox_layout = layout;
	static FlexBox_update = update;
	static FlexBox_draw = draw;

	__widthMin = 128;
	Width.from_props(_props, "Width", 400);
	__heightMin = 64;
	Height.from_props(_props, "Height", 300);
	__padding = 4;
	PaddingX.from_props(_props, "PaddingX", __padding);
	PaddingY.from_props(_props, "PaddingY", __padding);
	IsHorizontal = false;

	BackgroundSprite = forms_get_prop(_props, "BackgroundSprite") ?? FORMS_SprRound4;

	BackgroundIndex = forms_get_prop(_props, "BackgroundIndex") ?? 0;

	BackgroundColor = forms_get_prop(_props, "BackgroundColor") ?? #202020;

	BackgroundAlpha = forms_get_prop(_props, "BackgroundAlpha") ?? 1.0;

	__move = false;
	__resize = FORMS_EWindowResize.None;
	__mouseOffset = [0, 0];

	Titlebar = new FORMS_WindowTitle();

	ScrollPane = new FORMS_ScrollPane(_content, {
		Width: 100,
		WidthUnit: FORMS_EUnit.Percent,
		Flex: 1,
		Container: {
			BackgroundColor: #404040,
		}
	});

	add_child(Titlebar);
	add_child(ScrollPane);

	static layout = function ()
	{
		if (__resize != FORMS_EWindowResize.None)
		{
			if (__resize & FORMS_EWindowResize.Left)
			{
				var _xprev = X.Value;
				X.Value = min(forms_mouse_get_x() + __mouseOffset[0], __realX + __realWidth - __widthMin);
				Width.Value += _xprev - X.Value;
			}
			else if (__resize & FORMS_EWindowResize.Right)
			{
				Width.Value = max(forms_mouse_get_x() - __realX + __mouseOffset[0], __widthMin);
			}

			if (__resize & FORMS_EWindowResize.Top)
			{
				var _yprev = Y.Value;
				Y.Value = min(forms_mouse_get_y() + __mouseOffset[1], __realY + __realHeight - __heightMin);
				Height.Value += _yprev - Y.Value;
			}
			else if (__resize & FORMS_EWindowResize.Bottom)
			{
				Height.Value = max(forms_mouse_get_y() - __realY + __mouseOffset[1], __heightMin);
			}

			if (!mouse_check_button(mb_left))
			{
				forms_get_root().WidgetActive = undefined;
				__resize = FORMS_EWindowResize.None;
			}
		}

		if (__move)
		{
			X.Value = forms_mouse_get_x() + __mouseOffset[0];
			Y.Value = forms_mouse_get_y() + __mouseOffset[1];

			if (!mouse_check_button(mb_left))
			{
				forms_get_root().WidgetActive = undefined;
				__move = false;
			}
		}

		FlexBox_layout();

		return self;
	};

	static update = function (_deltaTime)
	{
		FlexBox_update(_deltaTime);

		var _resize = __resize;

		if (is_mouse_over() && forms_get_root().WidgetActive == undefined)
		{
			var _mouseX = forms_mouse_get_x();
			var _mouseY = forms_mouse_get_y();
			var _mouseOffsetX = 0;
			var _mouseOffsetY = 0;

			if (_mouseX < __realX + __padding)
			{
				_resize |= FORMS_EWindowResize.Left;
				_mouseOffsetX = __realX - _mouseX;
			}
			else if (_mouseX >= __realX + __realWidth - __padding)
			{
				_resize |= FORMS_EWindowResize.Right;
				_mouseOffsetX = __realX + __realWidth - _mouseX;
			}

			if (_mouseY < __realY + __padding)
			{
				_resize |= FORMS_EWindowResize.Top;
				_mouseOffsetY = __realY - _mouseY;
			}
			else if (_mouseY >= __realY + __realHeight - __padding)
			{
				_resize |= FORMS_EWindowResize.Bottom;
				_mouseOffsetY = __realY + __realHeight - _mouseY;
			}

			if (_resize != FORMS_EWindowResize.None
				&& forms_mouse_check_button_pressed(mb_left))
			{
				forms_get_root().WidgetActive = self;
				__resize = _resize;
				__mouseOffset[@ 0] = _mouseOffsetX;
				__mouseOffset[@ 1] = _mouseOffsetY;
			}
		}

		if ((_resize & FORMS_EWindowResize.Left && _resize & FORMS_EWindowResize.Top)
			|| (_resize & FORMS_EWindowResize.Right && _resize & FORMS_EWindowResize.Bottom))
		{
			forms_set_cursor(cr_size_nwse);
		}
		else if ((_resize & FORMS_EWindowResize.Left && _resize & FORMS_EWindowResize.Bottom)
			|| (_resize & FORMS_EWindowResize.Right && _resize & FORMS_EWindowResize.Top))
		{
			forms_set_cursor(cr_size_nesw);
		}
		else if (_resize & FORMS_EWindowResize.Left || _resize & FORMS_EWindowResize.Right)
		{
			forms_set_cursor(cr_size_we);
		}
		else if (_resize & FORMS_EWindowResize.Top || _resize & FORMS_EWindowResize.Bottom)
		{
			forms_set_cursor(cr_size_ns);
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

/// @func FORMS_WindowTitle([_props])
///
/// @extends FORMS_Container
///
/// @desc
///
/// @params {Struct.FORMS_ContainerProps, Undefined} [_props]
function FORMS_WindowTitle(_props=undefined)
	: FORMS_Container(undefined, _props) constructor
{
	static Container_update = update;

	Width.from_props(_props, "Width", 100, FORMS_EUnit.Percent);
	Height.from_props(_props, "Height", 24);

	set_content(new FORMS_WindowTitleContent());

	static update = function (_deltaTime)
	{
		if (is_mouse_over() && forms_mouse_check_button_pressed(mb_left))
		{
			forms_get_root().WidgetActive = Parent;
			Parent.__mouseOffset[@ 0] = Parent.__realX - forms_mouse_get_x();
			Parent.__mouseOffset[@ 1] = Parent.__realY - forms_mouse_get_y();
			Parent.__move = true;
		}
		Container_update(_deltaTime);
		return self;
	};
}

/// @func FORMS_WindowTitleContent()
///
/// @extends FORMS_Content
///
/// @desc
function FORMS_WindowTitleContent()
	: FORMS_Content() constructor
{
	static draw = function ()
	{
		draw_text(0, floor((Container.__realHeight - string_height("M")) * 0.5),
			Container.Parent.ScrollPane.Container.Content.Name);
		return self;
	};
}
