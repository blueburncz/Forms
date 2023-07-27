/// @func FORMS_Container([_x, _y, _width, _height])
///
/// @extends FORMS_Canvas
///
/// @desc A scrollable container.
///
/// @param {Real} [_x] The x position to create the container at.
/// @param {Real} [_y] The y position to create the container at.
/// @param {Real} [_width] The width of the container.
/// @param {Real} [_height] The width of the container.
///
/// @see FORMS_Content
function FORMS_Container(_x, _y, _width, _height)
	: FORMS_Canvas() constructor
{
	static Type = FORMS_EWidgetType.Container;

	/// @var {Struct.FORMS_Content}
	/// @see FORMS_Content
	/// @readonly
	/// @see FORMS_Container.SetContent
	Content = undefined;

	/// @var {Bool}
	/// @private
	ClickScroll = false;

	/// @var {Real}
	/// @private
	ClickScrollMouseX = 0;

	/// @var {Real}
	/// @private
	ClickScrollMouseY = 0;

	/// @var {Struct.FORMS_ScrollbarHor}
	/// @readonly
	ScrollbarHor = new FORMS_ScrollbarHor(self);

	/// @var {Struct.FORMS_ScrollbarVer}
	/// @readonly
	ScrollbarVer = new FORMS_ScrollbarVer(self);

	/// @func SetContent(_content)
	///
	/// @desc Sets content of the container.
	///
	/// @param {Struct.FORMS_Content} _content The content.
	///
	/// @return {Struct.FORMS_Container} Returns `self`.
	static SetContent = function (_content)
	{
		gml_pragma("forceinline");
		if (_content.Container != undefined)
		{
			show_error("Content already added to a container!", true);
		}
		Content = _content;
		Content.Container = self;
		return self;
	};

	/// @func GetContentHeight()
	///
	/// @desc Gets the height of the container's content.
	///
	/// @return {Real} The height of the container's content.
	static GetContentHeight = function ()
	{
		gml_pragma("forceinline");
		return ScrollbarVer.ContentSize;
	};

	/// @func GetContentWidth()
	///
	/// @desc Gets the width of the container's content.
	///
	/// @return {Real} The width of the container's content.
	static GetContentWidth = function ()
	{
		gml_pragma("forceinline");
		return ScrollbarHor.ContentSize;
	}

	/// @func SetContentHeight(_contentHeight)
	///
	/// @desc Sets height of the content of the container to the given value.
	///
	/// @param {Real} _contentHeight The new height of the container's content.
	static SetContentHeight = function (_contentHeight)
	{
		gml_pragma("forceinline");
		ScrollbarVer.ContentSize = max(1, _contentHeight);
	};

	/// @func SetContentWidth(_contentWidth)
	///
	/// @desc Sets width of the content of the container to the given value.
	///
	/// @param {Real} _contentWidth The new width of the container's content.
	static SetContentWidth = function (_contentWidth)
	{
		gml_pragma("forceinline");
		ScrollbarHor.ContentSize = max(1, _contentWidth);
	};

	static OnUpdate = function ()
	{
		FORMS_ContainerUpdate(self);
	};

	static OnDraw = function ()
	{
		FORMS_ContainerDraw(self);
	};

	if (_height != undefined)
	{
		SetRectangle(_x, _y, _width, _height);
	}
}

/// @func FORMS_ContainerDraw(_container)
///
/// @desc Draws the container.
///
/// @param {Struct.FORMS_Container} _container The container.
function FORMS_ContainerDraw(_container)
{
	// Draw items
	if (_container.BeginFill())
	{
		var _size = [0.1, 0.1];

		var _content = _container.Content;
		if (_content != undefined)
		{
			_content.Draw();
			_size = [_content.Width, _content.Height];
		}

		_container.SetContentWidth(_size[0]);
		_container.SetContentHeight(_size[1]);
		_container.EndFill();
	}

	// Draw container
	FORMS_CanvasDraw(_container);
}

/// @func FORMS_ContainerUpdate(_container)
///
/// @desc Updates the container.
///
/// @param {Struct.FORMS_Container} _container The container.
function FORMS_ContainerUpdate(_container)
{
	var _scrollbarHor = _container.ScrollbarHor;
	var _scrollbarVer = _container.ScrollbarVer;
	FORMS_CompoundWidgetUpdate(_container);

	// Click scroll
	if (mouse_check_button_pressed(mb_middle)
		&& _container.IsHovered()
		&& !FORMS_WidgetExists(FORMS_WIDGET_ACTIVE))
	{
		_container.ClickScroll = true;
		_container.ClickScrollMouseX = window_mouse_get_x();
		_container.ClickScrollMouseY = window_mouse_get_y();
		FORMS_WIDGET_ACTIVE = _container;
	}

	if (FORMS_WIDGET_ACTIVE == _container
		&& _container.ClickScroll)
	{
		_scrollbarHor.Scroll += (window_mouse_get_x() - _container.ClickScrollMouseX)
			/ _scrollbarHor.ScrollJump * 0.1;
		_scrollbarVer.Scroll += (window_mouse_get_y() - _container.ClickScrollMouseY)
			/ _scrollbarVer.ScrollJump * 0.1;

		_scrollbarHor.Scroll = clamp(_scrollbarHor.Scroll,
			0, _scrollbarHor.Size - _scrollbarHor.ThumbSize);
		_scrollbarVer.Scroll = clamp(_scrollbarVer.Scroll,
			0, _scrollbarVer.Size - _scrollbarVer.ThumbSize);

		if (!mouse_check_button(mb_middle))
		{
			_container.ClickScroll = false;
			FORMS_WIDGET_ACTIVE = undefined;
		}
		FORMS_CURSOR = cr_drag;
	}
}

/// @func FORMS_GetScrollbarHor(_widget)
///
/// @desc Retrieves a horizontal scrollbar of a widget.
///
/// @param {Struct.FORMS_Widget} _widget The widget.
///
/// @return {Struct.FORMS_ScrollbarHor, Undefined} The horizontal scrollbar or `undefined`.
function FORMS_GetScrollbarHor(_widget)
{
	gml_pragma("forceinline");
	return variable_struct_exists(_widget, "ScrollbarHor")
		? _widget.ScrollbarHor
		: undefined;
}

/// @func FORMS_GetScrollbarVer(_widget)
///
/// @desc Retrieves a vertical scrollbar of a widget.
///
/// @param {Struct.FORMS_Widget} _widget The widget.
///
/// @return {Struct.FORMS_ScrollbarVer, Undefined} The vertical scrollbar or `undefined`.
function FORMS_GetScrollbarVer(_widget)
{
	gml_pragma("forceinline");
	return variable_struct_exists(_widget, "ScrollbarVer")
		? _widget.ScrollbarVer
		: undefined;
}
