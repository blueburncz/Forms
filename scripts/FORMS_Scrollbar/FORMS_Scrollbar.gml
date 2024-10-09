/// @func FORMS_ScrollbarProps()
///
/// @extends FORMS_WidgetProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_Scrollbar}.
function FORMS_ScrollbarProps(): FORMS_WidgetProps() constructor
{
	/// @var {Constant.Color, Undefined} The color of the scrollbar's background.
	BackgroundColor = undefined;

	/// @var {Real, Undefined} The alpha value of the scrollbar's background.
	BackgroundAlpha = undefined;

	/// @var {Constant.Color, Undefined} The color of the scrollbar's thumb.
	ThumbColor = undefined;

	/// @var {Real, Undefined} The alpha value of the scrollbar's thumb.
	ThumbAlpha = undefined;

	/// @var {Constant.Color, Undefined} The color of the scrollbar's thumb on
	/// mouse-over.
	ThumbColorHover = undefined;

	/// @var {Real, Undefined} The alpha value of the scrollbar's thumb on
	/// mouse-over.
	ThumbAlphaHover = undefined;

	/// @var {Constant.Color, Undefined} The color of the scrollbar's thumb when
	/// it's being dragged.
	ThumbColorActive = undefined;

	/// @var {Real, Undefined} The alpha value of the scrollbar's thumb when
	/// it's being dragged.
	ThumbAlphaActive = undefined;

	/// @var {Real, Undefined} The minimum size of the scrollbar's thumb.
	ThumbSizeMin = undefined;
}

/// @func FORMS_Scrollbar(_target[, _props])
///
/// @extends FORMS_Widget
///
/// @desc Base struct for scrollbars.
///
/// @param {Struct.FORMS_Container} _target The container that this scrollbar
/// scrolls.
/// @param {Struct.FORMS_ScrollbarProps, Undefined} [_props] Properties to
/// create the scrollbar with or `undefined` (default).
function FORMS_Scrollbar(_target, _props = undefined): FORMS_Widget(_props) constructor
{
	/// @var {Struct.FORMS_Container} The container that this scrollbar scrolls.
	Target = _target;

	/// @var {Constant.Color} The color of the scrollbar's background. Defaults
	/// to `0x272727`.
	BackgroundColor = forms_get_prop(_props, "BackgroundColor") ?? 0x272727;

	/// @var {Real} The alpha value of the scrollbar's background. Defaults to 1.
	BackgroundAlpha = forms_get_prop(_props, "BackgroundAlpha") ?? 1.0;

	/// @var {Constant.Color} The color of the scrollbar's thumb. Defaults to
	/// `0x4D4D4D`.
	ThumbColor = forms_get_prop(_props, "ThumbColor") ?? 0x4D4D4D;

	/// @var {Real} The alpha value of the scrollbar's thumb. Defaults to 1.
	ThumbAlpha = forms_get_prop(_props, "ThumbAlpha") ?? 1.0;

	/// @var {Constant.Color} The color of the scrollbar's thumb on mouse-over.
	/// Defaults to `0x575757`.
	ThumbColorHover = forms_get_prop(_props, "ThumbColorHover") ?? 0x575757;

	/// @var {Real} The alpha value of the scrollbar's thumb on mouse-over.
	/// Defaults to 1.
	ThumbAlphaHover = forms_get_prop(_props, "ThumbAlphaHover") ?? 1.0;

	/// @var {Constant.Color} The color of the scrollbar's thumb when it's being
	/// dragged. Defaults to `0x898989`.
	ThumbColorActive = forms_get_prop(_props, "ThumbColorActive") ?? 0x898989;

	/// @var {Real} The alpha value of the scrollbar's thumb when it's being
	/// dragged. Defaults to 1.
	ThumbAlphaActive = forms_get_prop(_props, "ThumbAlphaActive") ?? 1.0;

	/// @var {Real} The minimum size of the scrollbar's thumb. Defaults to 32.
	ThumbSizeMin = forms_get_prop(_props, "ThumbSizeMin") ?? 32;

	__thumbPos = 0;
	__thumbSize = 0;
	__thumbIsHovered = false;
	__mouseOffset = 0;

	/// @func __handle_scrolling(_scroll, _mousePos, _scrollbarPos, _scrollbarSize, _contentSize, _containerSize)
	///
	/// @desc
	///
	/// @param {Real} _scroll
	/// @param {Real} _mousePos
	/// @param {Real} _scrollbarPos
	/// @param {Real} _scrollbarSize
	/// @param {Real} _contentSize
	/// @param {Real} _containerSize
	///
	/// @return {Real}
	///
	/// @private
	static __handle_scrolling = function (
		_scroll, _mousePos, _scrollbarPos, _scrollbarSize, _contentSize, _containerSize)
	{
		if (_contentSize <= _containerSize)
		{
			__thumbPos = _scrollbarPos;
			__thumbSize = _scrollbarSize;
			return _scroll;
		}

		var _scrollNew = _scroll;
		var _scrollMax = _contentSize - _containerSize;
		var _scrollLinear = clamp(_scroll / _scrollMax, 0, 1);
		var _isMouseOver = is_mouse_over();
		var _root = forms_get_root();

		__thumbSize = (_containerSize / _contentSize) * _scrollbarSize;
		__thumbSize = max(__thumbSize, ThumbSizeMin);
		__thumbSize = min(__thumbSize, _scrollbarSize);
		__thumbPos = _scrollbarPos + (_scrollbarSize - __thumbSize) * _scrollLinear;
		__thumbIsHovered = (_isMouseOver
			&& _root.WidgetActive == undefined
			&& _mousePos > __thumbPos
			&& _mousePos < __thumbPos + __thumbSize);

		if (_isMouseOver && forms_mouse_check_button_pressed(mb_left))
		{
			if (__thumbIsHovered)
			{
				__mouseOffset = __thumbPos - _mousePos;
			}
			else
			{
				__mouseOffset = -__thumbSize / 2;
			}
			_root.WidgetActive = self;
		}

		if (_root.WidgetActive == self)
		{
			var _scrollNewLinear =
				(_mousePos - _scrollbarPos + __mouseOffset) / (_scrollbarSize - __thumbSize);
			_scrollNew = _scrollNewLinear * _scrollMax;

			if (!mouse_check_button(mb_left))
			{
				_root.WidgetActive = undefined;
			}
		}
		else
		{
			var _scrollWheel =
				_isMouseOver * (mouse_wheel_down() - mouse_wheel_up()) * string_height("M");
			_scrollNew = _scroll + _scrollWheel;
		}

		return _scrollNew;
	}
}

/// @func FORMS_HScrollbarProps()
///
/// @extends FORMS_ScrollbarProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_HScrollbar}.
function FORMS_HScrollbarProps(): FORMS_ScrollbarProps() constructor {}

/// @func FORMS_HScrollbar(_target[, _props])
///
/// @extends FORMS_Scrollbar
///
/// @desc A horizontal scrollbar.
///
/// @param {Struct.FORMS_Container} _target The container that this scrollbar
/// scrolls on the X axis.
/// @param {Struct.FORMS_HScrollbarProps, Undefined} [_props] Properties to
/// create the scrollbar with or `undefined` (default).
function FORMS_HScrollbar(_target, _props = undefined): FORMS_Scrollbar(_target, _props) constructor
{
	static Scrollbar_update = update;

	/// @var {Struct.FORMS_UnitValue} The height of the scrollbar.
	/// Defaults to 8px.
	Height = Height.from_props(_props, "Height", 8);

	static update = function (_deltaTime)
	{
		Scrollbar_update(_deltaTime);

		var _scrollNew = __handle_scrolling(
			Target.ScrollX,
			forms_mouse_get_x(),
			__realX,
			__realWidth,
			Target.ContentWidth,
			Target.__realWidth);

		Target.set_scroll_x(_scrollNew);

		return self;
	}

	static draw = function ()
	{
		forms_draw_rectangle(__realX, __realY, __realWidth, __realHeight, BackgroundColor, BackgroundAlpha);
		var _root = forms_get_root();
		var _color = (_root.WidgetActive == self) ? ThumbColorActive
			: (__thumbIsHovered ? ThumbColorHover : ThumbColor);
		var _alpha = (_root.WidgetActive == self) ? ThumbAlphaActive
			: (__thumbIsHovered ? ThumbAlphaHover : ThumbAlpha);
		draw_sprite_stretched_ext(FORMS_SprRound4, 0, __thumbPos, __realY, __thumbSize, __realHeight, _color,
			_alpha);
		return self;
	}
}

/// @func FORMS_VScrollbarProps()
///
/// @extends FORMS_ScrollbarProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_VScrollbar}.
function FORMS_VScrollbarProps(): FORMS_ScrollbarProps() constructor {}

/// @func FORMS_VScrollbar(_target[, _props])
///
/// @extends FORMS_Scrollbar
///
/// @desc A vertical scrollbar.
///
/// @param {Struct.FORMS_Container} _target The container that this scrollbar
/// scrolls on the Y axis.
/// @param {Struct.FORMS_VScrollbarProps, Undefined} [_props] Properties to
/// create the scrollbar with or `undefined` (default).
function FORMS_VScrollbar(_target, _props = undefined): FORMS_Scrollbar(_target, _props) constructor
{
	static Scrollbar_update = update;

	/// @var {Struct.FORMS_UnitValue} The width of the scrollbar. Defaults
	/// to 8px.
	Width = Width.from_props(_props, "Width", 8);

	static update = function (_deltaTime)
	{
		Scrollbar_update(_deltaTime);

		var _scrollNew = __handle_scrolling(
			Target.ScrollY,
			forms_mouse_get_y(),
			__realY,
			__realHeight,
			Target.ContentHeight,
			Target.__realHeight);

		Target.set_scroll_y(_scrollNew);

		return self;
	}

	static draw = function ()
	{
		forms_draw_rectangle(__realX, __realY, __realWidth, __realHeight, BackgroundColor, BackgroundAlpha);
		var _root = forms_get_root();
		var _color = (_root.WidgetActive == self) ? ThumbColorActive
			: (__thumbIsHovered ? ThumbColorHover : ThumbColor);
		var _alpha = (_root.WidgetActive == self) ? ThumbAlphaActive
			: (__thumbIsHovered ? ThumbAlphaHover : ThumbAlpha);
		draw_sprite_stretched_ext(FORMS_SprRound4, 0, __realX, __thumbPos, __realWidth, __thumbSize, _color,
			_alpha);
		return self;
	}
}
