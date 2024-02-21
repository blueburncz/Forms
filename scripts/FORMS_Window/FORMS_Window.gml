/// @enum
enum FORMS_EWindowResize
{
	None   = 0b0000,
	Left   = 0b0001,
	Right  = 0b0010,
	Top    = 0b0100,
	Bottom = 0b1000,
	All    = 0b1111,
};

/// @func FORMS_WindowProps()
///
/// @extends FORMS_FlexBoxProps
///
/// @desc
function FORMS_WindowProps()
	: FORMS_FlexBoxProps() constructor
{
	/// @var {Bool, Undefined} Whether the window can be moved. Default value is true.
	Movable = undefined;

	/// @var {Real, Undefined} Bitwise OR between directions in which the window
	/// can be resized. Use values from {@link FORMS_EWindowResize}. Default
	/// value is {@link FORMS_EWindowResize.All}.
	Resizable = undefined;

	/// @var {Asset.GMSprite}
	BackgroundSprite = undefined;

	/// @var {Real}
	BackgroundIndex = undefined;

	/// @var {Constant.Color}
	BackgroundColor = undefined;

	/// @var {Real}
	BackgroundAlpha = undefined;
}

/// @func FORMS_Window([_widget[, _props]])
///
/// @extends FORMS_FlexBox
///
/// @desc
///
/// @params {Struct.FORMS_Widget, Undefined} [_widget]
/// @params {Struct.FORMS_WindowProps, Undefined} [_props]
function FORMS_Window(_widget, _props=undefined)
	: FORMS_FlexBox(_props) constructor
{
	static FlexBox_layout = layout;
	static FlexBox_update = update;
	static FlexBox_draw = draw;

	/// @var {Bool} Whether the window can be moved. Default value is true.
	Movable = forms_get_prop(_props, "Movable") ?? true;

	/// @var {Real} Bitwise OR between directions in which the window can be
	/// resized. Use values from {@link FORMS_EWindowResize}. Default value is
	/// {@link FORMS_EWindowResize.All}.
	Resizable = forms_get_prop(_props, "Resizable") ?? FORMS_EWindowResize.All;

	/// @var {Asset.GMSprite}
	BackgroundSprite = forms_get_prop(_props, "BackgroundSprite") ?? FORMS_SprRound4;

	/// @var {Real}
	BackgroundIndex = forms_get_prop(_props, "BackgroundIndex") ?? 0;

	/// @var {Constant.Color}
	BackgroundColor = forms_get_prop(_props, "BackgroundColor") ?? 0x303030;

	/// @var {Real}
	BackgroundAlpha = forms_get_prop(_props, "BackgroundAlpha") ?? 1.0;

	/// @var {Struct.FORMS_WindowTitle}
	/// @readonly
	Titlebar = new FORMS_WindowTitle();

	/// @var {Struct.BBMOD_Widget}
	/// @readonly
	Widget = _widget;

	/// @private
	__widthMin = 128;

	/// @private
	__heightMin = 64;

	/// @private
	__padding = 4;

	/// @private
	__move = false;

	/// @private
	__resize = FORMS_EWindowResize.None;

	/// @var {Array<Real>}
	/// @private
	__mouseOffset = [0, 0];

	{
		IsHorizontal = false;
		Width.from_props(_props, "Width", 400);
		Height.from_props(_props, "Height", 300);
		PaddingX.from_props(_props, "PaddingX", __padding);
		PaddingY.from_props(_props, "PaddingY", __padding);

		add_child(Titlebar);
		add_child(Widget);
	}

	// TODO: Disable adding of more children (don't inherit from FlexBox???)

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
		else if (__move)
		{
			X.Value = forms_mouse_get_x() + __mouseOffset[0];
			Y.Value = forms_mouse_get_y() + __mouseOffset[1];

			if (!mouse_check_button(mb_left))
			{
				forms_get_root().WidgetActive = undefined;
				__move = false;
			}
		}
		else
		{
			if (X.Value + __realWidth <= 0)
			{
				X.Value = 0;
			}
			else if (X.Value >= window_get_width())
			{
				X.Value = window_get_width() - __realWidth;
			}

			if (Y.Value + __realHeight <= 0)
			{
				Y.Value = 0;
			}
			else if (Y.Value >= window_get_height())
			{
				Y.Value = window_get_height() - __realHeight;
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

			if (_mouseX < __realX + __padding
				&& Resizable & FORMS_EWindowResize.Left)
			{
				_resize |= FORMS_EWindowResize.Left;
				_mouseOffsetX = __realX - _mouseX;
			}
			else if (_mouseX >= __realX + __realWidth - __padding
				&& Resizable & FORMS_EWindowResize.Right)
			{
				_resize |= FORMS_EWindowResize.Right;
				_mouseOffsetX = __realX + __realWidth - _mouseX;
			}

			if (_mouseY < __realY + __padding
				&& Resizable & FORMS_EWindowResize.Top)
			{
				_resize |= FORMS_EWindowResize.Top;
				_mouseOffsetY = __realY - _mouseY;
			}
			else if (_mouseY >= __realY + __realHeight - __padding
				&& Resizable & FORMS_EWindowResize.Bottom)
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
		var _shadowOffset = 16;
		draw_sprite_stretched_ext(
			FORMS_SprShadow, 0,
			__realX - _shadowOffset,
			__realY - _shadowOffset,
			__realWidth + _shadowOffset * 2,
			__realHeight + _shadowOffset * 2,
			c_black, 0.5);

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
		if (Parent.Movable
			&& is_mouse_over()
			&& forms_mouse_check_button_pressed(mb_left))
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
			Container.Parent.Widget.Name);
		return self;
	};
}
