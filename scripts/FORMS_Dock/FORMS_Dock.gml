/// @enum
enum FORMS_EDockSplit
{
	/// @member
	Horizontal,
	/// @member
	Vertical,
};

/// @func FORMS_DockProps()
///
/// @extends FORMS_WidgetProps
///
/// @desc
function FORMS_DockProps()
	: FORMS_WidgetProps() constructor
{
	/// @var {Constant.Color, Undefined}
	BackgroundColor = undefined;

	/// @var {Real, Undefined}
	BackgroundAlpha = undefined;

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

/// @func FORMS_Dock([_props])
///
/// @extends FORMS_Widget
///
/// @desc
///
/// @param {Struct.FORMS_DockProps, Undefined} [_props]
function FORMS_Dock(_props=undefined)
	: FORMS_Widget(_props) constructor
{
	static Widget_update = update;

	/// @var {Constant.Color}
	BackgroundColor = forms_get_prop(_props, "BackgroundColor") ?? 0x101010;

	/// @var {Real}
	BackgroundAlpha = forms_get_prop(_props, "BackgroundAlpha") ?? 1.0;

	/// @var {Real} Default is {@link FORMS_EDockSplit.Horizontal}.
	SplitType = forms_get_prop(_props, "SplitType") ?? FORMS_EDockSplit.Horizontal;

	/// @var {Real} Defaults to 0.5.
	SplitSize = forms_get_prop(_props, "SplitSize") ?? 0.5;

	/// @var {Real}
	SplitterSize = forms_get_prop(_props, "SplitterSize") ?? 6;

	/// @var {Constant.Color}
	SplitterColor = forms_get_prop(_props, "SplitterColor") ?? 0x101010;

	/// @var {Real}
	SplitterAlpha = forms_get_prop(_props, "SplitterAlpha") ?? 1.0;

	/// @var {Constant.Color}
	SplitterColorHover = forms_get_prop(_props, "SplitterColorHover") ?? 0x303030;

	/// @var {Real}
	SplitterAlphaHover = forms_get_prop(_props, "SplitterAlphaHover") ?? 1.0;

	/// @var {Constant.Color}
	SplitterColorActive = forms_get_prop(_props, "SplitterColorActive") ?? global.formsAccentColor;

	/// @var {Real}
	SplitterAlphaActive = forms_get_prop(_props, "SplitterAlphaActive") ?? 1.0;

	/// @var {Struct.FORMS_DockTabs}
	/// @private
	__tabContainer = new FORMS_DockTabs();

	/// @var {Array<Struct.FORMS_Widget>}
	/// @private
	__tabs = [];

	/// @var {Real}
	/// @private
	__tabCurrent = 0;

	/// @var {Struct.FORMS_Dock, Undefined}
	/// @private
	__left = undefined;

	/// @var {Struct.FORMS_Dock, Undefined}
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

	{
		__tabContainer.Parent = self;
	}

	/// @func get_first()
	///
	/// @desc
	///
	/// @return {Struct.FORMS_Dock}
	static get_first = function () { return __left; };

	/// @func get_second()
	///
	/// @desc
	///
	/// @return {Struct.FORMS_Dock}
	static get_second = function () { return __right; };

	/// @func set_tab(_tabs)
	///
	/// @desc
	///
	/// @param {Array<Struct.FORMS_Widget>} _tabs
	///
	/// @return {Struct.FORMS_Dock} Returns `self`.
	static set_tabs = function (_tabs)
	{
		forms_assert(array_length(__tabs) == 0, "Dock already has tabs!");
		__tabs = _tabs;
		var i = 0;
		repeat (array_length(__tabs))
		{
			__tabs[i++].Parent = self;
		}
		return self;
	};

	/// @func add_tab(_widget)
	///
	/// @desc
	///
	/// @param {Struct.FORMS_Widget} _widget
	///
	/// @return {Struct.FORMS_Dock} Returns `self`.
	static add_tab = function (_widget)
	{
		forms_assert(_widget.Parent == undefined, "Widget already has a parent!");
		forms_assert(__left == undefined && __right == undefined, "Cannot add tabs to a dock that is split!");
		array_push(__tabs, _widget);
		_widget.Parent = self;
		return self;
	};

	/// @private
	static __split = function (_type)
	{
		forms_assert(__left == undefined && __right == undefined, "Dock is already split!");

		SplitType = _type;

		__left = new FORMS_Dock();
		__left.Parent = self;

		__right = new FORMS_Dock();
		__right.Parent = self;
	};

	/// @func split_left()
	///
	/// @desc
	///
	/// @return {Struct.FORMS_Dock} Returns `self`.
	static split_left = function ()
	{
		__split(FORMS_EDockSplit.Horizontal);
		__left.set_tabs(__tabs);
		__tabs = [];
		return self;
	};

	/// @func split_right()
	///
	/// @desc
	///
	/// @return {Struct.FORMS_Dock} Returns `self`.
	static split_right = function ()
	{
		__split(FORMS_EDockSplit.Horizontal);
		__right.set_tabs(__tabs);
		__tabs = [];
		return self;
	};

	/// @func split_up()
	///
	/// @desc
	///
	/// @return {Struct.FORMS_Dock} Returns `self`.
	static split_up = function ()
	{
		__split(FORMS_EDockSplit.Vertical);
		__left.set_tabs(__tabs);
		__tabs = [];
		return self;
	};

	/// @func split_down()
	///
	/// @desc
	///
	/// @return {Struct.FORMS_Dock} Returns `self`.
	static split_down = function ()
	{
		__split(FORMS_EDockSplit.Vertical);
		__right.set_tabs(__tabs);
		__tabs = [];
		return self;
	};

	static layout = function ()
	{
		FORMS_LAYOUT_GENERATED;

		var _parentX = __realX;
		var _parentY = __realY;
		var _parentWidth = __realWidth;
		var _parentHeight = __realHeight;

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

		if (__left == undefined && __right == undefined)
		{
			with (__tabContainer)
			{
				var _autoWidth = get_auto_width();
				var _autoHeight = get_auto_height();

				__realWidth = floor(Width.get_absolute(_parentWidth, _autoWidth));
				__realHeight = floor(Height.get_absolute(_parentHeight, _autoHeight));
				__realX = floor(_parentX + X.get_absolute(_parentWidth, _autoWidth));
				__realY = floor(_parentY + Y.get_absolute(_parentHeight, _autoHeight));

				layout();
			}

			if (__tabCurrent < array_length(__tabs))
			{
				var _tab = __tabs[__tabCurrent];
				_tab.__realX = _parentX;
				_tab.__realY = _parentY + __tabContainer.__realHeight;
				_tab.__realWidth = _parentWidth;
				_tab.__realHeight = _parentHeight - __tabContainer.__realHeight;
				_tab.layout();
			}
		}
		else
		{
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

		if (__left == undefined && __right == undefined)
		{
			__tabContainer.update(_deltaTime);

			if (__tabCurrent < array_length(__tabs))
			{
				var _tab = __tabs[__tabCurrent];
				_tab.update(_deltaTime);
			}
		}
		else
		{
			if (__left != undefined)
			{
				__left.update(_deltaTime);
			}

			if (__right != undefined)
			{
				__right.update(_deltaTime);
			}
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

		forms_draw_rectangle(__realX, __realY, __realWidth, __realHeight, BackgroundColor, BackgroundAlpha);

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

		if (__left == undefined && __right == undefined)
		{
			var _tabCurrent = __tabCurrent; // Backup before it changes!
			__tabContainer.draw();
			if (_tabCurrent < array_length(__tabs))
			{
				__tabs[_tabCurrent].draw();
			}
		}
		else
		{
			if (__left != undefined)
			{
				__left.draw();
			}

			if (__right != undefined)
			{
				__right.draw();
			}
		}

		return self;
	};
}

/// @func FORMS_DockTabsProps()
///
/// @extends FORMS_ContainerProps
///
/// @desc
function FORMS_DockTabsProps()
	: FORMS_ContainerProps() constructor
{
}

/// @func FORMS_DockTabs([_props])
///
/// @extends FORMS_Container
///
/// @desc
///
/// @params {Struct.FORMS_DockTabsProps, Undefined} [_props]
function FORMS_DockTabs(_props=undefined)
	: FORMS_Container(undefined, _props) constructor
{
	{
		Width.from_props(_props, "Width", 100, FORMS_EUnit.Percent);
		Height.from_props(_props, "Height", 24);

		set_content(new FORMS_DockTabsContent());
	}
}

/// @func FORMS_DockTabsContent()
///
/// @extends FORMS_Content
///
/// @desc
function FORMS_DockTabsContent()
	: FORMS_Content() constructor
{
	static draw = function ()
	{
		var _dock = Container.Parent;
		var _tabs = _dock.__tabs;
		var _tabCount = array_length(_tabs);
		var _tabCurrent = _dock.__tabCurrent;
		var _tabIndex = 0;

		var _tabPadding = 9;
		Pen.PaddingX = 0;
		Pen.PaddingY = 3;
		Pen.start();

		repeat (_tabCount)
		{
			var _tab = _tabs[_tabIndex];
			var _iconSpace = ((_tab.Icon != undefined) ? 24 : 0);
			if (_tabCurrent == _tabIndex)
			{
				draw_sprite_stretched_ext(
					FORMS_SprTab, 0,
					Pen.X, 0,
					_tabPadding
						+ _iconSpace
						+ string_width(_tab.Name) + ((_tabCount > 1) ? 4 + 16 : 0)
						+ _tabPadding,
					Container.__realHeight,
					0x282828, 1.0
				);
			}
			Pen.move(_tabPadding);
			if (_tab.Icon != undefined)
			{
				fa_draw(_tab.IconFont, _tab.Icon, Pen.X, Pen.Y);
				Pen.move(_iconSpace);
			}
			if (Pen.link(_tab.Name, { Color: (_tabIndex == _tabCurrent) ? c_white : c_silver }))
			{
				_tabCurrent = _tabIndex;
				_dock.__tabCurrent = _tabCurrent;
			}
			if (_tabCount > 1)
			{
				Pen.move(4);
				if (Pen.icon_solid(FA_ESolid.Xmark, { Width: 16, Color: c_gray }))
				{
					_tab.Parent = undefined;
					_tab.destroy();

					array_delete(_tabs, _tabIndex--, 1);
					--_tabCount;

					_tabCurrent = clamp(_tabCurrent, 0, _tabCount - 1);
					_dock.__tabCurrent = _tabCurrent;
				}
			}
			Pen.move(_tabPadding);
			++_tabIndex;
		}

		Pen.finish();

		Width = Pen.get_max_x();

		return self;
	};
}
