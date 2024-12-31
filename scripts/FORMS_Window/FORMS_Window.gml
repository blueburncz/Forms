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
/// @extends FORMS_WidgetProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_Window}.
function FORMS_WindowProps(): FORMS_WidgetProps() constructor
{
	/// @var {Bool, Undefined} Whether the window should be moved to the center of the application window next time
	/// [layout](./FORMS_Widget.layout.html] is run.
	Center = undefined;

	/// @var {Bool, Undefined} Whether the window can be moved (`true`) or not (`false`).
	Movable = undefined;

	/// @var {Bool, Undefined} Whether the window size should be initialized automatically based on its contents.
	AutoSize = undefined;

	/// @var {Real, Undefined} Bitwise OR between directions in which the window can be resized. Use values from
	/// {@link FORMS_EWindowResize}.
	Resizable = undefined;

	/// @var {Bool, Undefined} Whether the window can be closed (`true`) or not (`false`).
	Closable = undefined;

	/// @var {Bool, Undefined} Whether the window should be destroyed on close (`true`) or just removed (`false`).
	DestroyOnClose = undefined;

	/// @var {Bool, Undefined} TODO: Add docs
	Blocking = undefined;

	/// @var {Asset.GMSprite, Undefined} The background sprite of the window, stretched over its entire size.
	BackgroundSprite = undefined;

	/// @var {Real, Undefined} The subimage of the background sprite to use.
	BackgroundIndex = undefined;
}

/// @func FORMS_Window([_widget[, _props]])
///
/// @extends FORMS_Widget
///
/// @desc A window.
///
/// @params {Struct.FORMS_Widget, Undefined} [_widget] A widget to embed into the window or `undefined`.
/// @params {Struct.FORMS_WindowProps, Undefined} [_props] Properties to create the window with or `undefined` (default).
function FORMS_Window(_widget, _props = undefined): FORMS_Widget(_props) constructor
{
	static Widget_layout = layout;
	static Widget_update = update;
	static Widget_draw = draw;
	static Widget_destroy = destroy;

	/// @var {Bool} Whether the window should be moved to the center of the application window next time
	/// [layout](./FORMS_Widget.layout.html] is run. Defaults to `false`.
	Center = forms_get_prop(_props, "Center") ?? false;

	/// @var {Bool} Whether the window can be moved. Defaults to `true`.
	Movable = forms_get_prop(_props, "Movable") ?? true;

	/// @var {Bool} Whether the window size should be initialized automatically based on its contents. Defaults to
	/// `false`.
	AutoSize = forms_get_prop(_props, "AutoSize") ?? false;

	/// @var {Real} Bitwise OR between directions in which the window can be resized. Use values from
	/// {@link FORMS_EWindowResize}. Defaults to {@link FORMS_EWindowResize.All}.
	Resizable = forms_get_prop(_props, "Resizable") ?? FORMS_EWindowResize.All;

	/// @var {Bool} Whether the window can be closed. Defaults to `true`.
	Closable = forms_get_prop(_props, "Closable") ?? true;

	/// @var {Bool} Whether the window should be destroyed on close (`true`, default) or just removed (`false`).
	DestroyOnClose = forms_get_prop(_props, "DestroyOnClose") ?? true;

	/// @var {Bool} TODO: Add docs
	Blocking = forms_get_prop(_props, "Blocking") ?? false;

	/// @var {Asset.GMSprite} The background sprite of the window, stretched over its entire size. Defaults to
	/// `FORMS_SprRound4`.
	BackgroundSprite = forms_get_prop(_props, "BackgroundSprite") ?? FORMS_SprRound4;

	/// @var {Real} The sub-image of the background sprite to use. Defaults to 0.
	BackgroundIndex = forms_get_prop(_props, "BackgroundIndex") ?? 0;

	/// @var {Struct.FORMS_WindowTitle} The window's title bar. Displays the name of the widget attached to this window.
	/// @readonly
	/// @see FORMS_Window.Widget
	Titlebar = new FORMS_WindowTitle();
	Titlebar.Parent = self;

	/// @var {Struct.FORMS_Widget, Undefined} The widget attached to this window or `undefined`.
	/// @readonly
	Widget = undefined;

	if (_widget != undefined)
	{
		set_widget(_widget);
	}

	/// @private
	__widthMin = 128;

	/// @private
	__heightMin = 64;

	/// @private
	__padding = 4;

	/// @private
	__move = false;

	/// @private
	__sizeInitialized = false;

	/// @private
	__resize = FORMS_EWindowResize.None;

	/// @var {Array<Real>}
	/// @private
	__mouseOffset = [0, 0];

	/// @var {Struct.FORMS_UnitValue} The width of the window. Defaults to 400.
	Width = Width.from_props(_props, "Width", 400);

	/// @var {Struct.FORMS_UnitValue} The height of the window. Defaults to 300.
	Height = Height.from_props(_props, "Height", 300);

	static remove_child = function (_child)
	{
		if (Titlebar == _child)
		{
			Titlebar.Parent = undefined;
			Titlebar = undefined;
		}
		if (Widget == _child)
		{
			Widget.Parent = undefined;
			Widget = undefined;
		}
		return self;
	}

	static find_widget = function (_id)
	{
		if (Id == _id)
		{
			return self;
		}
		if (Titlebar.Id == _id)
		{
			return Titlebar;
		}
		if (Widget != undefined && Widget.Id == _id)
		{
			return Widget;
		}
		return undefined;
	}

	/// @func set_widget(_widget)
	///
	/// @desc Changes the widget attached to the window.
	///
	/// @param {Struct.FORMS_Widget} _widget The new widget to attach.
	///
	/// @return {Struct.FORMS_Window} Returns `self`.
	///
	/// @note This **destroys** the widget attached previously! Remove it first with {@link FORMS_Widget.remove_self} if
	/// you don't want it to be destroyed.
	static set_widget = function (_widget)
	{
		if (Widget != undefined)
		{
			Widget.remove_self();
			Widget.destroy_later();
		}
		Widget = _widget;
		Widget.Parent = self;
		return self;
	}

	static layout = function ()
	{
		if (Blocking)
		{
			forms_get_root().WidgetHovered = undefined;
		}

		// TODO: Shouldn't this clamp to root widget's size?
		var _mouseX = clamp(forms_mouse_get_x(), 0, window_get_width());
		var _mouseY = clamp(forms_mouse_get_y(), 0, window_get_height());

		if (__resize != FORMS_EWindowResize.None)
		{
			if (__resize & FORMS_EWindowResize.Left)
			{
				var _xprev = X.Value;
				X.Value = min(_mouseX + __mouseOffset[0], __realX + __realWidth - __widthMin);
				Width.Value += _xprev - X.Value;
			}
			else if (__resize & FORMS_EWindowResize.Right)
			{
				Width.Value = max(_mouseX - __realX + __mouseOffset[0], __widthMin);
			}

			if (__resize & FORMS_EWindowResize.Top)
			{
				var _yprev = Y.Value;
				Y.Value = min(_mouseY + __mouseOffset[1], __realY + __realHeight - __heightMin);
				Height.Value += _yprev - Y.Value;
			}
			else if (__resize & FORMS_EWindowResize.Bottom)
			{
				Height.Value = max(_mouseY - __realY + __mouseOffset[1], __heightMin);
			}

			if (!mouse_check_button(mb_left))
			{
				forms_get_root().DragTarget = undefined;
				__resize = FORMS_EWindowResize.None;
			}
		}
		else if (__move)
		{
			X.Value = _mouseX + __mouseOffset[0];
			Y.Value = _mouseY + __mouseOffset[1];

			if (!mouse_check_button(mb_left))
			{
				forms_get_root().DragTarget = undefined;
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

		Widget_layout();

		var _innerX = __realX + __padding;
		var _innerY = __realY + __padding;
		var _innerWidth = __realWidth - __padding * 2;
		var _innerHeight = __realHeight - __padding * 2;
		var _titlebarHeight = 0;

		if (Titlebar != undefined)
		{
			with(Titlebar)
			{
				__realX = _innerX;
				__realY = _innerY;
				__realWidth = _innerWidth;
				__realHeight = floor(Height.get_absolute(_innerHeight, get_auto_height()));
				_titlebarHeight = __realHeight;
				layout();
			}
		}

		if (Widget != undefined)
		{
			with(Widget)
			{
				__realX = _innerX;
				__realY = _innerY + _titlebarHeight;
				__realWidth = _innerWidth;
				__realHeight = _innerHeight - _titlebarHeight;
				layout();
			}
		}

		if (AutoSize && Widget != undefined && !__sizeInitialized)
		{
			Width.Value = Widget.__realWidth + __padding * 2;
			Height.Value = _titlebarHeight + Widget.__realHeight + __padding * 2;
			Width.Unit = FORMS_EUnit.Pixel;
			Height.Unit = FORMS_EUnit.Pixel;
			__realWidth = Width.Value;
			__realHeight = Height.Value;

			Titlebar.__realWidth = Width.Value;
			Titlebar.layout();

			__sizeInitialized = true;
		}

		if (Center)
		{
			var _root = forms_get_root();
			X.Value = _root.__realX + floor((_root.__realWidth - __realWidth) / 2);
			Y.Value = _root.__realY + floor((_root.__realHeight - __realHeight) / 2);
			X.Unit = FORMS_EUnit.Pixel;
			Y.Unit = FORMS_EUnit.Pixel;
			__realX = X.Value;
			__realY = Y.Value;
			Center = false;
			layout(); // Re-run to fix titlebar and widget positions
		}

		return self;
	}

	static update = function (_deltaTime)
	{
		Widget_update(_deltaTime);

		var _resize = __resize;

		if (is_mouse_over() && forms_get_root().DragTarget == undefined)
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
				forms_get_root().DragTarget = self;
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

		Titlebar.update(_deltaTime);

		if (Widget != undefined)
		{
			Widget.update(_deltaTime);
		}

		return self;
	}

	static draw = function ()
	{
		var _root = forms_get_root();

		if (Blocking)
		{
			with(_root)
			{
				forms_draw_rectangle(__realX, __realY, __realWidth, __realHeight, c_black, 0.25);
			}
		}

		var _style = _root.Style;
		var _shadowOffset = 16;
		draw_sprite_stretched_ext(
			FORMS_SprShadow, 0,
			__realX - _shadowOffset,
			__realY - _shadowOffset,
			__realWidth + _shadowOffset * 2,
			__realHeight + _shadowOffset * 2,
			_style.Shadow.get(), _style.Shadow.get_alpha());

		draw_sprite_stretched_ext(
			BackgroundSprite, BackgroundIndex,
			__realX, __realY, __realWidth, __realHeight,
			_style.Background[2].get(), 1.0);

		if (Titlebar != undefined)
		{
			Titlebar.draw();
		}

		if (Widget != undefined)
		{
			Widget.draw();
		}

		return self;
	}

	static destroy = function ()
	{
		Widget_destroy();
		if (Titlebar != undefined)
		{
			Titlebar = Titlebar.destroy();
		}
		if (Widget != undefined)
		{
			Widget = Widget.destroy();
		}
		return undefined;
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
/// @params {Struct.FORMS_WindowTitleProps, Undefined} [_props] Properties to create the window title bar with or
/// `undefined` (default).
function FORMS_WindowTitle(_props = undefined): FORMS_Container(_props) constructor
{
	static Container_draw = draw;

	/// @var {Struct.FORMS_UnitValue} The width of the title bar. Defaults to 100%.
	Width = Width.from_props(_props, "Width", 100, FORMS_EUnit.Percent);

	/// @var {Struct.FORMS_UnitValue} The height of the title bar. Defaults to 24px.
	Height = Height.from_props(_props, "Height", 24);

	static draw_content = function ()
	{
		var _style = forms_get_style();
		Pen.PaddingY = round((__realHeight - string_height("M")) / 2);
		Pen.start();
		var _widget = Parent.Widget;
		if (_widget != undefined)
		{
			if (_widget.Icon != undefined)
			{
				var _width = fa_get_width(_widget.IconFont, _widget.Icon);
				fa_draw(_widget.IconFont, _widget.Icon, Pen.X + floor((16 - _width) / 2), Pen.Y, _style.Text
					.get());
				Pen.move(22);
			}
			Pen.text(_widget.Name);
		}
		var _iconWidth = 20;
		Pen.set_x(__realWidth - _iconWidth - 2);
		if (Parent.Closable
			&& Pen.icon_solid(FA_ESolid.Xmark, { Width: _iconWidth }))
		{
			if (Parent.DestroyOnClose)
			{
				Parent.destroy_later();
			}
			else
			{
				Parent.remove_self();
			}
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
			forms_get_root().DragTarget = Parent;
			Parent.__mouseOffset[@ 0] = Parent.__realX - forms_mouse_get_x();
			Parent.__mouseOffset[@ 1] = Parent.__realY - forms_mouse_get_y();
			Parent.__move = true;
		}
		return self;
	}
}
