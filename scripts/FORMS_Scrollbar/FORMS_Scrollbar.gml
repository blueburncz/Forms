/// @func FORMS_ScrollbarProps()
///
/// @extends FORMS_WidgetProps
///
/// @desc
function FORMS_ScrollbarProps()
	: FORMS_WidgetProps() constructor
{
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

	/// @var {Real}
	ThumbSizeMin = forms_get_prop(_props, "ThumbSizeMin") ?? 32;

	__thumbPos = 0;
	__thumbSize = 0;
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

		__thumbSize = (_containerSize / _contentSize) * _scrollbarSize;
		__thumbSize = max(__thumbSize, ThumbSizeMin);
		__thumbSize = min(__thumbSize, _scrollbarSize);
		__thumbPos = _scrollbarPos + (_scrollbarSize - __thumbSize) * _scrollLinear;

		var _isMouseOver = is_mouse_over();
		var _root = forms_get_root();

		if (_isMouseOver && forms_mouse_check_button_pressed(mb_left))
		{
			if (_mousePos > __thumbPos
				&& _mousePos < __thumbPos + __thumbSize)
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
		draw_rectangle_color(__realX, __realY, __realX + __realWidth, __realY + __realHeight,
			c_silver, c_silver, c_silver, c_silver, false);
		var _color = (forms_get_root().WidgetActive == self) ? c_orange : c_maroon;
		draw_rectangle_color(__thumbPos, __realY, __thumbPos + __thumbSize, __realY + __realHeight,
			_color, _color, _color, _color, false);
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
		draw_rectangle_color(__realX, __realY, __realX + __realWidth, __realY + __realHeight,
			c_silver, c_silver, c_silver, c_silver, false);
		var _color = (forms_get_root().WidgetActive == self) ? c_orange : c_maroon;
		draw_rectangle_color(__realX, __thumbPos, __realX + __realWidth, __thumbPos + __thumbSize,
			_color, _color, _color, _color, false);
		return self;
	};
}
