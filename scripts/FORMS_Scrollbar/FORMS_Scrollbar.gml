/// @func FORMS_ScrollbarProps()
///
/// @extends FORMS_WidgetProps
///
/// @desc
function FORMS_ScrollbarProps()
	: FORMS_WidgetProps() constructor
{
	/// @var {Constant.Color, Undefined}
	BackgroundColor = undefined;

	/// @var {Real, Undefined}
	BackgroundAlpha = undefined;

	/// @var {Constant.Color, Undefined}
	ThumbColor = undefined;

	/// @var {Real, Undefined}
	ThumbAlpha = undefined;

	/// @var {Constant.Color, Undefined}
	ThumbColorHover = undefined;

	/// @var {Real, Undefined}
	ThumbAlphaHover = undefined;

	/// @var {Constant.Color, Undefined}
	ThumbColorActive = undefined;

	/// @var {Real, Undefined}
	ThumbAlphaActive = undefined;

	/// @var {Real, Undefined}
	ThumbSizeMin = undefined;
}

/// @func FORMS_Scrollbar(_target[, _props])
///
/// @extends FORMS_Widget
///
/// @desc
///
/// @param {Struct.FORMS_Container} _target
/// @param {Struct.FORMS_ScrollbarProps, Undefined} [_props]
function FORMS_Scrollbar(_target, _props=undefined)
	: FORMS_Widget(_props) constructor
{
	/// @var {Struct.FORMS_Container}
	Target = _target;

	/// @var {Constant.Color}
	BackgroundColor = forms_get_prop(_props, "BackgroundColor") ?? c_silver;

	/// @var {Real}
	BackgroundAlpha = forms_get_prop(_props, "BackgroundAlpha") ?? 1.0;

	/// @var {Constant.Color}
	ThumbColor = forms_get_prop(_props, "ThumbColor") ?? c_maroon;

	/// @var {Real}
	ThumbAlpha = forms_get_prop(_props, "ThumbAlpha") ?? 1.0;

	/// @var {Constant.Color}
	ThumbColorHover = forms_get_prop(_props, "ThumbColorHover") ?? c_red;

	/// @var {Real}
	ThumbAlphaHover = forms_get_prop(_props, "ThumbAlphaHover") ?? 0.5;

	/// @var {Constant.Color}
	ThumbColorActive = forms_get_prop(_props, "ThumbColorActive") ?? c_orange;

	/// @var {Real}
	ThumbAlphaActive = forms_get_prop(_props, "ThumbAlphaActive") ?? 1.0;

	/// @var {Real}
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
	};
}

/// @func FORMS_HScrollbar(_target[, _props])
///
/// @extends FORMS_Scrollbar
///
/// @desc
///
/// @param {Struct.FORMS_Container} _target
/// @param {Struct.FORMS_ScrollbarProps, Undefined} [_props]
function FORMS_HScrollbar(_target, _props=undefined)
	: FORMS_Scrollbar(_target, _props) constructor
{
	static Scrollbar_update = update;

	Height.from_props(_props, "Height", 8);

	static update = function (_deltaTime)
	{
		Scrollbar_update(_deltaTime);

		var _scrollNew = __handle_scrolling(
			Target.ScrollX,
			forms_mouse_get_x(),
			__realX,
			__realWidth,
			Target.Content.Width,
			Target.__realWidth);

		Target.set_scroll_x(_scrollNew);

		return self;
	};

	static draw = function ()
	{
		forms_draw_rectangle(__realX, __realY, __realWidth, __realHeight, BackgroundColor, BackgroundAlpha);
		var _root = forms_get_root();
		var _color = (_root.WidgetActive == self) ? ThumbColorActive
			: (__thumbIsHovered ? ThumbColorHover : ThumbColor);
		var _alpha = (_root.WidgetActive == self) ? ThumbAlphaActive
			: (__thumbIsHovered ? ThumbAlphaHover : ThumbAlpha);
		forms_draw_rectangle(__thumbPos, __realY, __thumbSize, __realHeight, _color, _alpha);
		return self;
	};
}

/// @func FORMS_VScrollbar(_target[, _props])
///
/// @extends FORMS_Scrollbar
///
/// @desc
///
/// @param {Struct.FORMS_Container} _target
/// @param {Struct.FORMS_ScrollbarProps, Undefined} [_props]
function FORMS_VScrollbar(_target, _props=undefined)
	: FORMS_Scrollbar(_target, _props) constructor
{
	static Scrollbar_update = update;

	Width.from_props(_props, "Width", 8);

	static update = function (_deltaTime)
	{
		Scrollbar_update(_deltaTime);

		var _scrollNew = __handle_scrolling(
			Target.ScrollY,
			forms_mouse_get_y(),
			__realY,
			__realHeight,
			Target.Content.Height,
			Target.__realHeight);

		Target.set_scroll_y(_scrollNew);

		return self;
	};

	static draw = function ()
	{
		forms_draw_rectangle(__realX, __realY, __realWidth, __realHeight, BackgroundColor, BackgroundAlpha);
		var _root = forms_get_root();
		var _color = (_root.WidgetActive == self) ? ThumbColorActive
			: (__thumbIsHovered ? ThumbColorHover : ThumbColor);
		var _alpha = (_root.WidgetActive == self) ? ThumbAlphaActive
			: (__thumbIsHovered ? ThumbAlphaHover : ThumbAlpha);
		forms_draw_rectangle(__realX, __thumbPos, __realWidth, __thumbSize, _color, _alpha);
		return self;
	};
}
