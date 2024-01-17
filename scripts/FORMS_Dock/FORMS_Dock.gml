/// @enum
enum FORMS_EDockSplit
{
	/// @member
	Horizontal,
	/// @member
	Vertical,
};

function FORMS_DockProps()
	: FORMS_WidgetProps() constructor
{
	/// @var {Real, Undefined} Use values from {@link FORMS_EDockSplit}.
	SplitType = undefined;

	/// @var {Real, Undefined}
	SplitSize = undefined;

	/// @var {Real, Undefined}
	SplitterSize = undefined;

	/// @var {Constant.Color, Undefined}
	SplitterColor = undefined;

	/// @var {Real, Undefined}
	SplitterAlpha = undefined;

	/// @var {Constant.Color, Undefined}
	SplitterColorHover = undefined;

	/// @var {Real, Undefined}
	SplitterAlphaHover = undefined;

	/// @var {Constant.Color, Undefined}
	SplitterColorActive = undefined;

	/// @var {Real, Undefined}
	SplitterAlphaActive = undefined;
}

function FORMS_Dock(_props=undefined, _leftOrTop=undefined, _rightOrBottom=undefined)
	: FORMS_Widget(_props) constructor
{
	static Widget_update = update;

	/// @var {Real} Default is {@link FORMS_EDockSplit.Horizontal}.
	SplitType = forms_get_prop(_props, "SplitType") ?? FORMS_EDockSplit.Horizontal;

	/// @var {Real} Defaults to 0.5.
	SplitSize = forms_get_prop(_props, "SplitSize") ?? 0.5;

	/// @var {Real}
	SplitterSize = forms_get_prop(_props, "SplitterSize") ?? 8;

	/// @var {Constant.Color}
	SplitterColor = forms_get_prop(_props, "SplitterColor") ?? c_maroon;

	/// @var {Real}
	SplitterAlpha = forms_get_prop(_props, "SplitterAlpha") ?? 1.0;

	/// @var {Constant.Color}
	SplitterColorHover = forms_get_prop(_props, "SplitterColorHover") ?? merge_color(c_red, c_silver, 0.5);

	/// @var {Real}
	SplitterAlphaHover = forms_get_prop(_props, "SplitterAlphaHover") ?? 1.0;

	/// @var {Constant.Color}
	SplitterColorActive = forms_get_prop(_props, "SplitterColorActive") ?? c_orange;

	/// @var {Real}
	SplitterAlphaActive = forms_get_prop(_props, "SplitterAlphaActive") ?? 1.0;

	/// @var {Struct.FORMS_Widget, Undefined}
	/// @private
	__left = undefined;

	/// @var {Struct.FORMS_Widget, Undefined}
	/// @private
	__right = undefined;

	/// @var {Bool}
	/// @private
	__resize = false;

	/// @var {Real}
	/// @private
	__mouseOffset = 0;

	__splitterPos = 0;
	__splitterIsHovered = false;

	if (_leftOrTop != undefined)
	{
		set_left(_leftOrTop);
	}

	if (_rightOrBottom != undefined)
	{
		set_right(_rightOrBottom);
	}

	static set_left = function (_widget)
	{
		if (__left != undefined)
		{
			__left.remove_self();
		}
		forms_assert(_widget.Parent == undefined, "Widget already has a parent!");
		__left = _widget;
		_widget.Parent = self;
		return self;
	};

	static set_top = set_left;

	static set_right = function (_widget)
	{
		if (__right != undefined)
		{
			__right.remove_self();
		}
		forms_assert(_widget.Parent == undefined, "Widget already has a parent!");
		__right = _widget;
		_widget.Parent = self;
		return self;
	};

	static set_bottom = set_right;

	static layout = function ()
	{
		var _parentX = __realX;
		var _parentY = __realY;
		var _parentWidth = __realWidth;
		var _parentHeight = __realHeight;

		if (forms_mouse_in_rectangle(__realX, __realY, __realWidth, __realHeight))
		{
			forms_get_root().WidgetHovered = self;
		}

		if (SplitType == FORMS_EDockSplit.Horizontal)
		{
			if (__resize)
			{
				SplitSize = (forms_mouse_get_x() - __realX + __mouseOffset) / __realWidth;
			}

			SplitSize = clamp(SplitSize, 0.1, 0.9);
			__splitterPos = round(__realX + __realWidth * SplitSize - SplitterSize * 0.5);
		}
		else
		{
			if (__resize)
			{
				SplitSize = (forms_mouse_get_y() - __realY + __mouseOffset) / __realHeight;
			}

			SplitSize = clamp(SplitSize, 0.1, 0.9);
			__splitterPos = round(__realY + __realHeight * SplitSize - SplitterSize * 0.5);
		}

		if (__resize && !mouse_check_button(mb_left))
		{
			forms_get_root().WidgetActive = undefined;
			__resize = false;
		}

		if (__left != undefined)
		{
			if (SplitType == FORMS_EDockSplit.Horizontal)
			{
				__left.__realX = __realX;
				__left.__realY = __realY;
				__left.__realWidth = __splitterPos - __realX;
				__left.__realHeight = __realHeight;
			}
			else
			{
				__left.__realX = __realX;
				__left.__realY = __realY;
				__left.__realWidth = __realWidth;
				__left.__realHeight = __splitterPos - __realY;
			}

			__left.layout();
		}

		if (__right != undefined)
		{
			if (SplitType == FORMS_EDockSplit.Horizontal)
			{
				__right.__realX = __splitterPos + SplitterSize;
				__right.__realY = __realY;
				__right.__realWidth = __realWidth - __right.__realX + __realX;
				__right.__realHeight = __realHeight;
			}
			else
			{
				__right.__realX = __realX;
				__right.__realY = __splitterPos + SplitterSize;
				__right.__realWidth = __realWidth;
				__right.__realHeight = __realHeight - __right.__realY + __realY;
			}

			__right.layout();
		}

		return self;
	};

	static update = function (_deltaTime)
	{
		Widget_update(_deltaTime);

		var _mousePos = (SplitType == FORMS_EDockSplit.Horizontal)
			? forms_mouse_get_x() : forms_mouse_get_y();

		__splitterIsHovered = (is_mouse_over()
			&& _mousePos > __splitterPos
			&& _mousePos < __splitterPos + SplitterSize);

		var _root = forms_get_root();
		var _resize = __resize;

		if (__splitterIsHovered && _root.WidgetActive == undefined)
		{
			_resize = true;

			if (forms_mouse_check_button_pressed(mb_left))
			{
				__mouseOffset = __splitterPos + SplitterSize * 0.5 - _mousePos;
				_root.WidgetActive = self;
				__resize = true;
			}
		}

		if (_resize)
		{
			forms_set_cursor((SplitType == FORMS_EDockSplit.Horizontal) ? cr_size_we : cr_size_ns);
		}

		if (__left != undefined)
		{
			__left.update(_deltaTime);
		}

		if (__right != undefined)
		{
			__right.update(_deltaTime);
		}

		return self;
	};

	static draw = function ()
	{
		var _root = forms_get_root();
		var _color = (_root.WidgetActive == self) ? SplitterColorActive
			: (__splitterIsHovered ? SplitterColorHover : SplitterColor);
		var _alpha = (_root.WidgetActive == self) ? SplitterAlphaActive
			: (__splitterIsHovered ? SplitterAlphaHover : SplitterAlpha);

		forms_draw_rectangle(__realX, __realY, __realWidth, __realHeight, c_white, 0.1);

		if (SplitType == FORMS_EDockSplit.Horizontal)
		{
			forms_draw_rectangle(__splitterPos, __realY, SplitterSize, __realHeight, _color, _alpha);
		}
		else
		{
			forms_draw_rectangle(__realX, __splitterPos, __realWidth, SplitterSize, _color, _alpha);
		}

		if (__left != undefined)
		{
			__left.draw();
		}

		if (__right != undefined)
		{
			__right.draw();
		}

		return self;
	};
}
