enum FORMS_EResize
{
	None = $0000,
	Left = $1000,
	Top = $0100,
	Right = $0010,
	Bottom = $0001,
	Horizontal = $1010,
	Vertical = $0101,
};

/// @func FORMS_Window()
///
/// @extends FORMS_CompoundWidget
function FORMS_Window()
	: FORMS_CompoundWidget() constructor
{
	static Type = FORMS_EWidgetType.Window;

	/// @var {Struct.FORMS_Container}
	/// @readonly
	TitleBar = new FORMS_Container();
	TitleBar.SetContent(new FORMS_WindowTitleBarContent());
	TitleBar.Background = FORMS_GetColor(FORMS_EStyle.Background);
	AddItem(TitleBar);

	/// @var {Struct.FORMS_Container}
	/// @readonly
	Container = new FORMS_Container();
	AddItem(Container);

	/// @var {FORMS_EResize}
	/// @private
	Resize = FORMS_EResize.None;

	/// @var {Bool}
	/// @private
	Drag = false;

	/// @var {Real}
	/// @private
	MouseOffsetX = 0;

	/// @var {Real}
	/// @private
	MouseOffsetY = 0;

	/// @var {Real}
	Border = 4;

	Depth = 16777216;

	/// @func SetContent(_content)
	///
	/// @desc Sets content of the window.
	///
	/// @param {Struct.FORMS_Content} _content The new content of the window.
	///
	/// @return {Struct.FORMS_Window} Returns `self`.
	static SetContent = function (_content)
	{
		gml_pragma("forceinline");
		Container.Content = _content;
		return self;
	};

	/// @func GetContent()
	///
	/// @desc Gets the content of the window.
	///
	/// @return {Struct.FORMS_Content} The content of the window.
	static GetContent = function ()
	{
		gml_pragma("forceinline");
		return Container.Content;
	};

	static OnUpdate = function ()
	{
		FORMS_WindowUpdate(self);
	};

	static OnDraw = function ()
	{
		FORMS_WindowDraw(self);
	};

	SetSize(300, 200);
}

/// @func FORMS_RedrawWindow(_window)
///
/// @desc Request redraw of the window.
///
/// @param {Struct.FORMS_Window} _window The window.
function FORMS_RedrawWindow(_window)
{
	gml_pragma("forceinline");
	FORMS_RequestRedraw(_window.Container);
	FORMS_RequestRedraw(_window.TitleBar);
}

/// @func FORMS_WindowDraw(_window)
///
/// @desc Draws the window.
///
/// @param {Struct.FORMS_Window} _window The window.
function FORMS_WindowDraw(_window)
{
	var _windowW = _window.Width;
	var _windowH = _window.Height;
	var _border = _window.Border;
	var _titleBar = _window.TitleBar;
	var _container = _window.Container;

	FORMS_MatrixPush(_window.X, _window.Y);

	// Shadow and border
	FORMS_DrawShadow(0, 0, _windowW, _windowH, FORMS_GetColor(FORMS_EStyle.Shadow), FORMS_GetColor(FORMS_EStyle.ShadowAlpha));
	var _selectedWidget = FORMS_WIDGET_SELECTED;
	var _colourBorder = FORMS_GetColor(FORMS_EStyle.WindowBorder);
	if (_selectedWidget == _window
		|| _window.IsAncestor(_selectedWidget))
	{
		_colourBorder = FORMS_GetColor(FORMS_EStyle.Active);
	}
	FORMS_DrawRectangle(0, 0, _windowW, _windowH, _colourBorder);

	// Title
	_titleBar.SetWidth(_windowW - _border * 2);
	FORMS_DrawItem(_titleBar, _border, _border);
	var _titleBarHeight = _titleBar.GetContentHeight();
	_titleBar.SetHeight(_titleBarHeight);

	// Content
	_container.SetSize(
		_windowW - _border * 2,
		_windowH - _titleBarHeight - _border * 2);
	FORMS_DrawItem(_container, _border, _titleBarHeight + _border);

	FORMS_MatrixRestore();

	_window.SetHeight(max(_window.Height, _titleBarHeight + _border));
}

/// @func FORMS_WindowUpdate(_window)
///
/// @desc Updates the window.
///
/// @param {Struct.FORMS_Window} _window The window.
function FORMS_WindowUpdate(_window)
{
	var _width = _window.Width;
	var _height = _window.Height;
	var _border = _window.Border;
	var _titleBar = _window.TitleBar;
	var _resize = _window.Resize;

	FORMS_CompoundWidgetUpdate(_window);

	if (mouse_check_button_pressed(mb_any)
		&& (_window.IsHovered()
		|| _window.IsAncestor(FORMS_WIDGET_HOVERED)))
	{
		FORMS_MoveItemToTop(_window);

		////////////////////////////////////////////////////////////////////////////
		// FIXME Stupid hack :(
		FORMS_WIDGET_SELECTED = _window;
		FORMS_RequestRedrawAll(FORMS_ROOT);
		////////////////////////////////////////////////////////////////////////////
	}

	var _titleBarHoveredForResize = (_titleBar.IsHovered()
									&& FORMS_MOUSE_Y < _border);

	if (_titleBar.IsHovered()
		&& !_titleBarHoveredForResize)
	{
		// Start dragging
		if (mouse_check_button_pressed(mb_left)
			&& FORMS_MOUSE_X < _width - FORMS_LINE_HEIGHT - _border)
		{
			_window.Drag = true;
			_window.MouseOffsetX= _window.X - window_mouse_get_x();
			_window.MouseOffsetY = _window.Y - window_mouse_get_y();
			FORMS_WIDGET_ACTIVE = _window;
		}
	}
	else if ((_window.IsHovered()
		|| _titleBarHoveredForResize)
		&& _resize == FORMS_EResize.None)
	{
		// Start resizing
		if (FORMS_MOUSE_X < _border)
		{
			_resize |= FORMS_EResize.Left;
		}
		else if (FORMS_MOUSE_X > _width - _border)
		{
			_resize |= FORMS_EResize.Right;
		}

		if (FORMS_MOUSE_Y < _border)
		{
			_resize |= FORMS_EResize.Top;
		}
		else if (FORMS_MOUSE_Y > _height - _border)
		{
			_resize |= FORMS_EResize.Bottom;
		}

		if (mouse_check_button_pressed(mb_left))
		{
			if (_resize & FORMS_EResize.Left)
			{
				_window.MouseOffsetX= window_mouse_get_x() - _window.X;
			}
			else if (_resize & FORMS_EResize.Right)
			{
				_window.MouseOffsetX= _window.X + _window.Width - window_mouse_get_x();
			}

			if (_resize & FORMS_EResize.Top)
			{
				_window.MouseOffsetY = window_mouse_get_y() - _window.Y;
			}
			else if (_resize & FORMS_EResize.Bottom)
			{
				_window.MouseOffsetY = _window.Y + _window.Height - window_mouse_get_y();
			}

			_window.Resize = _resize;
			FORMS_WIDGET_ACTIVE = _window;
		}
	}

	if (_window.Drag)
	{
		////////////////////////////////////////////////////////////////////////////
		// Dragging
		_window.SetPosition(
			clamp(window_mouse_get_x(), 0, window_get_width()) + _window.MouseOffsetX,
			clamp(window_mouse_get_y(), 0, window_get_height()) + _window.MouseOffsetY);
		if (!mouse_check_button(mb_left))
		{
			_window.Drag = false;
			FORMS_WIDGET_ACTIVE = undefined;
		}
	}

	if (_resize != FORMS_EResize.None)
	{
		////////////////////////////////////////////////////////////////////////////
		// Resizing

		// Set cursor
		if ((_resize & FORMS_EResize.Left
			&& _resize & FORMS_EResize.Top)
			|| (_resize & FORMS_EResize.Right
			&& _resize & FORMS_EResize.Bottom))
		{
			FORMS_CURSOR = cr_size_nwse;
		}
		else if ((_resize & FORMS_EResize.Left
			&& _resize & FORMS_EResize.Bottom)
			|| (_resize & FORMS_EResize.Right
			&& _resize & FORMS_EResize.Top))
		{
			FORMS_CURSOR = cr_size_nesw;
		}
		else if (_resize & FORMS_EResize.Horizontal)
		{
			FORMS_CURSOR = cr_size_we;
		}
		else if (_resize & FORMS_EResize.Vertical)
		{
			FORMS_CURSOR = cr_size_ns;
		}

		// Set size
		if (FORMS_WIDGET_ACTIVE == _window)
		{
			var _minWidth = 128 + _border * 2;
			if (_resize & FORMS_EResize.Right)
			{
				_window.SetWidth(max(FORMS_MOUSE_X + _window.MouseOffsetX, _minWidth));
			}
			else if (_resize & FORMS_EResize.Left)
			{
				var _widthOld = _window.Width;
				var _widthNew = max(_widthOld - FORMS_MOUSE_X + _window.MouseOffsetX, _minWidth);
				_window.SetWidth(_widthNew);
				_window.X = _window.X - (_widthNew - _widthOld);
			}

			var _minHeight = _titleBar.Height + _border * 2;
			if (_resize & FORMS_EResize.Bottom)
			{
				_window.SetHeight(max(FORMS_MOUSE_Y + _window.MouseOffsetY, _minHeight));
			}
			else if (_resize & FORMS_EResize.Top)
			{
				var _heightOld = _window.Height;
				var _heightNew = max(_heightOld - FORMS_MOUSE_Y + _window.MouseOffsetY, _minHeight)
				_window.SetHeight(_heightNew);
				_window.Y = _window.Y - (_heightNew - _heightOld);
			}

			if (!mouse_check_button(mb_left))
			{
				_window.Resize = FORMS_EResize.None;
				FORMS_WIDGET_ACTIVE = undefined;
			}
		}
	}
}

/// @func FORMS_WindowGetContent(_window)
///
/// @desc Gets the content of the window.
///
/// @param {Struct.FORMS_Window} _window The window.
///
/// @return {Struct.FORMS_Content} The content of the window.
function FORMS_WindowGetContent(_window)
{
	gml_pragma("forceinline");
	return _window.GetContent();
}

/// @func FORMS_WindowSetContent(_window, _content)
///
/// @desc Sets content of the window.
///
/// @param {Struct.FORMS_Window} _window The window.
/// @param {Struct.FORMS_Content} _content The new content of the window.
function FORMS_WindowSetContent(_window, _content)
{
	gml_pragma("forceinline");
	_window.SetContent(_content);
}
