/// @enum
enum FORMS_EDockDest
{
	/// @member
	Tab = $1,
	/// @member
	Left = $10,
	/// @member
	Right = $20,
	/// @member
	Top = $40,
	/// @member
	Bottom = $80,
};

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

/// @func FORMS_Dock([_props[, _leftOrTop[, _rightOrBottom]]])
///
/// @extends FORMS_Widget
///
/// @desc
///
/// @param {Struct.FORMS_DockProps, Undefined} [_props]
/// @param {Struct.FORMS_Widget, Undefined} [_leftOrTop]
/// @param {Struct.FORMS_Widget, Undefined} [_rightOrBottom]
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

	/// @var {Real}
	/// @private
	__splitterPos = 0;

	/// @var {Bool}
	/// @private
	__splitterIsHovered = false;

	//if (_leftOrTop != undefined)
	//{
	//	forms_assert(__left.Parent == undefined, "Widget already has a parent!");
	//	__left = _leftOrTop;
	//	_leftOrTop.Parent = self;
	//}

	//if (_rightOrBottom != undefined)
	//{
	//	forms_assert(__right.Parent == undefined, "Widget already has a parent!");
	//	__right = _rightOrBottom;
	//	_rightOrBottom.Parent = self;
	//}

	/// @func dock_widget(_widget, _dest)
	///
	/// @desc
	///
	/// @param {Struct.FORMS_Widget} _widget
	/// @param {Real} _dest Use values from {@link FORMS_EDockDest}.
	static dock_widget = function (_widget, _dest)
	{
		forms_assert(_widget.Parent == undefined, "Widget already has a parent!");

		switch (_dest)
		{
		case FORMS_EDockDest.Tab:
			{
				forms_assert(__right == undefined, "Dock cannot be split when adding a tab!");
				__left = _widget;
				__left.Parent = self;
			}
			break;

		case FORMS_EDockDest.Left:
		case FORMS_EDockDest.Top:
			{
				var _clone = new FORMS_Dock();
				_clone.Parent = self;
				_clone.SplitType = SplitType;
				_clone.SplitSize = SplitSize;
				_clone.__left = __left;
				if (_clone.__left != undefined) { _clone.__left.Parent = _clone; }
				_clone.__right = __right;
				if (_clone.__right != undefined) { _clone.__right.Parent = _clone; }

				SplitType = (_dest == FORMS_EDockDest.Left)
					? FORMS_EDockSplit.Horizontal
					: FORMS_EDockSplit.Vertical;

				__left = new FORMS_Dock();
				__left.Parent = self;
				__left.dock_widget(_widget, FORMS_EDockDest.Tab);

				__right = _clone;
			}
			break;

		case FORMS_EDockDest.Right:
		case FORMS_EDockDest.Bottom:
			{
				var _clone = new FORMS_Dock();
				_clone.Parent = self;
				_clone.SplitType = SplitType;
				_clone.SplitSize = SplitSize;
				_clone.__left = __left;
				if (_clone.__left != undefined) { _clone.__left.Parent = _clone; }
				_clone.__right = __right;
				if (_clone.__right != undefined) { _clone.__right.Parent = _clone; }

				SplitType = (_dest == FORMS_EDockDest.Right)
					? FORMS_EDockSplit.Horizontal
					: FORMS_EDockSplit.Vertical;

				__left = _clone;

				__right = new FORMS_Dock();
				__right.Parent = self;
				__right.dock_widget(_widget, FORMS_EDockDest.Tab);
			}
			break;

		default:
			forms_assert(false, "Invalid dock destination!");
			break;
		}

		return self;
	};

	static layout = function ()
	{
		var _parentX = __realX;
		var _parentY = __realY;
		var _parentWidth = __realWidth;
		var _parentHeight = __realHeight;

		if (forms_mouse_in_rectangle(__realX, __realY, __realWidth, __realHeight))
		{
			var _root = forms_get_root();
			_root.WidgetHovered = self;
			if (!is_instanceof(Parent, FORMS_Dock))
			{
				_root.__dockRoot = self;
			}

			var _mousePos = (SplitType == FORMS_EDockSplit.Horizontal)
				? forms_mouse_get_x() : forms_mouse_get_y();

			if (__right == undefined
				|| _mousePos < __splitterPos
				|| _mousePos > __splitterPos + SplitterSize)
			{
				_root.__dockUnderCursor = self;
			}
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
			if (__right == undefined)
			{
				__left.__realX = __realX;
				__left.__realY = __realY;
				__left.__realWidth = __realWidth;
				__left.__realHeight = __realHeight;
			}
			else if (SplitType == FORMS_EDockSplit.Horizontal)
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
			if (__left == undefined)
			{
				__right.__realX = __realX;
				__right.__realY = __realY;
				__right.__realWidth = __realWidth;
				__right.__realHeight = __realHeight;
			}
			else if (SplitType == FORMS_EDockSplit.Horizontal)
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

		var _root = forms_get_root();
		var _mousePos = (SplitType == FORMS_EDockSplit.Horizontal)
			? forms_mouse_get_x() : forms_mouse_get_y();

		__splitterIsHovered = (__left != undefined
			&& __right != undefined
			&& is_mouse_over()
			&& _root.WidgetActive == undefined
			&& _mousePos > __splitterPos
			&& _mousePos < __splitterPos + SplitterSize);

		var _resize = __resize;

		if (__splitterIsHovered)
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

		//forms_draw_rectangle(__realX, __realY, __realWidth, __realHeight, c_white, 0.1);

		if (__left != undefined && __right != undefined)
		{
			if (SplitType == FORMS_EDockSplit.Horizontal)
			{
				forms_draw_rectangle(__splitterPos, __realY, SplitterSize, __realHeight, _color, _alpha);
			}
			else
			{
				forms_draw_rectangle(__realX, __splitterPos, __realWidth, SplitterSize, _color, _alpha);
			}
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
