/// @enum Enumeration of window resize directions.
enum FORMS_EWindowResize
{
	/// @member Not resizing the window.
	None = 0b0000,
		/// @member Resizing the left side of a window.
		Left = 0b0001,
		/// @member Resizing the right side of a window.
		Right = 0b0010,
		/// @member Resizing the top side of a window.
		Top = 0b0100,
		/// @member Resizing the bottom side of a window.
		Bottom = 0b1000,
		/// @member Resizing the window on all sides.
		All = 0b1111,
};

/// @func FORMS_WindowProps()
///
/// @extends FORMS_FlexBoxProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_Window}.
function FORMS_WindowProps(): FORMS_FlexBoxProps() constructor
{
	/// @var {Bool, Undefined} Whether the window should be moved to the center
	/// of the application window next time [layout](./FORMS_Widget.layout.html]
	/// is run.
	Center = undefined;

	/// @var {Bool, Undefined} Whether the window can be moved (`true`) or not
	/// (`false`).
	Movable = undefined;

	/// @var {Real, Undefined} Bitwise OR between directions in which the window
	/// can be resized. Use values from {@link FORMS_EWindowResize}.
	Resizable = undefined;

	/// @var {Bool, Undefined} Whether the window can be closed (`true`) or not
	/// (`false`).
	Closable = undefined;

	/// @var {Asset.GMSprite, Undefined} The background sprite of the window,
	/// stretched over its entire size.
	BackgroundSprite = undefined;

	/// @var {Real, Undefined} The subimage of the background sprite to use.
	BackgroundIndex = undefined;

	/// @var {Constant.Color, Undefined} The tint color of the background sprite.
	BackgroundColor = undefined;

	/// @var {Real, Undefined} The alpha value of the background sprite.
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
function FORMS_Window(_widget, _props = undefined): FORMS_FlexBox(_props) constructor
{
	static FlexBox_layout = layout;
	static FlexBox_update = update;
	static FlexBox_draw = draw;

	/// @var {Bool} Whether the window should be moved to the center of the
	/// application window next time [layout](./FORMS_Widget.layout.html] is run.
	/// Defaults to `false`.
	Center = forms_get_prop(_props, "Center") ?? false;

	/// @var {Bool} Whether the window can be moved. Defaults to `true`.
	Movable = forms_get_prop(_props, "Movable") ?? true;

	/// @var {Real} Bitwise OR between directions in which the window can be
	/// resized. Use values from {@link FORMS_EWindowResize}. Defaults to
	/// {@link FORMS_EWindowResize.All}.
	Resizable = forms_get_prop(_props, "Resizable") ?? FORMS_EWindowResize.All;

	/// @var {Bool} Whether the window can be closed. Defaults to `true`.
	Closable = forms_get_prop(_props, "Closable") ?? true;

	/// @var {Asset.GMSprite} The background sprite of the window, stretched
	/// over its entire size. Defaults to `FORMS_SprRound4`.
	BackgroundSprite = forms_get_prop(_props, "BackgroundSprite") ?? FORMS_SprRound4;

	/// @var {Real} The subimage of the background sprite to use. Defaults to 0.
	BackgroundIndex = forms_get_prop(_props, "BackgroundIndex") ?? 0;

	/// @var {Constant.Color} The tint color of the background sprite. Defaults
	/// to `0x303030`.
	BackgroundColor = forms_get_prop(_props, "BackgroundColor") ?? 0x303030;

	/// @var {Real} The alpha value of the background sprite. Defaults to 1.
	BackgroundAlpha = forms_get_prop(_props, "BackgroundAlpha") ?? 1.0;

	/// @var {Struct.FORMS_WindowTitle} The window's title bar. Displays the
	/// name of the widget attached to this window.
	/// @readonly
	/// @see FORMS_Window.Widget
	Titlebar = new FORMS_WindowTitle();

	/// @var {Struct.BBMOD_Widget, Undefined} The widget attached to this window
	/// or `undefined`.
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

	/// @var {Bool} This property inherited from {@link FORMS_FlexBox} is set
	/// to `false` to stack contained widget vertically.
	IsHorizontal = false;

	/// @var {Struct.FORMS_UnitValue} The width of the window. Defaults to
	/// 400.
	Width = Width.from_props(_props, "Width", 400);

	/// @var {Struct.FORMS_UnitValue} The height of the window. Defaults
	/// to 300.
	Height = Height.from_props(_props, "Height", 300);

	/// @var {Struct.FORMS_UnitValue} This property inherited from
	/// {@link FORMS_FlexBox} is used as the size of the window's border on the
	/// X axis. Defaults to 4.
	PaddingX = PaddingX.from_props(_props, "PaddingX", __padding);

	/// @var {Struct.FORMS_UnitValue} This property inherited from
	/// {@link FORMS_FlexBox} is used as the size of the window's border on the
	/// Y axis. Defaults to 4.
	PaddingY = PaddingY.from_props(_props, "PaddingY", __padding);

	add_child(Titlebar);

	if (Widget != undefined)
	{
		add_child(Widget);
	}

	// TODO: Disable adding of more children (don't inherit from FlexBox???)

	/// @func set_widget(_widget)
	///
	/// @desc Changes the widget attached to the window.
	///
	/// @param {Struct.FORMS_Widget} _widget The new widget to attach.
	///
	/// @return {Struct.FORMS_Window} Returns `self`.
	///
	/// @note This **destroys** the widget attached previously! Remove it first
	/// with {@link FORMS_Widget.remove_self} if you don't want it to be
	/// destroyed.
	static set_widget = function (_widget)
	{
		if (Widget != undefined)
		{
			Widget.remove_self();
			Widget.destroy_later();
		}
		add_child(_widget);
		Widget = _widget;
		return self;
	}

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

		if (Center)
		{
			X.Value = floor((window_get_width() - __realWidth) / 2);
			Y.Value = floor((window_get_height() - __realHeight) / 2);
			X.Unit = FORMS_EUnit.Pixel;
			Y.Unit = FORMS_EUnit.Pixel;
			Center = false;
		}

		return self;
	}

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
	}

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
	}
}

/// @func FORMS_WindowTitleProps()
///
/// @extends FORMS_ContainerProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_WindowTitle}.
function FORMS_WindowTitleProps(): FORMS_ContainerProps() constructor {}

/// @func FORMS_WindowTitle([_props])
///
/// @extends FORMS_Container
///
/// @desc A title bar of a {@link FORMS_Window}.
///
/// @params {Struct.FORMS_WindowTitleProps, Undefined} [_props] Properties to
/// create the window title bar with or `undefined` (default).
function FORMS_WindowTitle(_props = undefined): FORMS_Container(_props) constructor
{
	static Container_draw = draw;

	/// @var {Struct.FORMS_UnitValue} The width of the title bar. Defaults
	/// to 100%.
	Width = Width.from_props(_props, "Width", 100, FORMS_EUnit.Percent);

	/// @var {Struct.FORMS_UnitValue} The height of the title bar.
	/// Defaults to 24px.
	Height = Height.from_props(_props, "Height", 24);

	// TODO: Docs
	BackgroundColor = forms_get_prop(_props, "BackgroundColor") ?? 0x181818;

	static draw_content = function ()
	{
		Pen.PaddingY = round((__realHeight - string_height("M")) / 2);
		Pen.start();
		Pen.text(Parent.Widget.Name);
		var _iconWidth = 20;
		Pen.set_x(__realWidth - _iconWidth - 2);
		if (Parent.Closable
			&& Pen.icon_solid(FA_ESolid.Xmark, { Width: _iconWidth }))
		{
			Parent.destroy_later();
		}
		Pen.finish();
		return self;
	}

	static draw = function (_deltaTime)
	{
		Container_draw();
		if (!Parent.__toDestroy
			&& Parent.Movable
			&& is_mouse_over()
			&& forms_mouse_check_button_pressed(mb_left))
		{
			forms_get_root().WidgetActive = Parent;
			Parent.__mouseOffset[@ 0] = Parent.__realX - forms_mouse_get_x();
			Parent.__mouseOffset[@ 1] = Parent.__realY - forms_mouse_get_y();
			Parent.__move = true;
		}
		return self;
	}
}
