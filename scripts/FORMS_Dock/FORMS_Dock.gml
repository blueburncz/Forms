/// @enum Enumeration of possible split direction of {@link FORMS_Dock}.
enum FORMS_EDockSplit
{
	/// @member Dock is split horizontally, i.e. it has one widget on the left
	/// and one on the right.
	Horizontal,
	/// @member Dock is split vertically, i.e. it has one widget at the top and
	/// one at the bottom.
	Vertical,
};

/// @func FORMS_DockProps()
///
/// @extends FORMS_WidgetProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_Dock}.
function FORMS_DockProps(): FORMS_WidgetProps() constructor
{
	/// @var {Constant.Color, Undefined} The background color of the dock.
	BackgroundColor = undefined;

	/// @var {Real, Undefined} The alpha value of the dock's background.
	BackgroundAlpha = undefined;

	/// @var {Real, Undefined} Whether the dock is split horizontally or
	/// vertically. Use values from {@link FORMS_EDockSplit}.
	SplitType = undefined;

	/// @var {Real, Undefined} The size of the split in range 0..1.
	SplitSize = undefined;

	/// @var {Real, Undefined} The size of the splitter that can be dragged with
	/// mouse to change the dock's split size.
	SplitterSize = undefined;

	/// @var {Constant.Color, Undefined} The color of the splitter.
	SplitterColor = undefined;

	/// @var {Real, Undefined} The alpha value of the splitter.
	SplitterAlpha = undefined;

	/// @var {Constant.Color, Undefined} The color of the splitter on mouse-over.
	SplitterColorHover = undefined;

	/// @var {Real, Undefined} The alpha value of the splitter on mouse-over.
	SplitterAlphaHover = undefined;

	/// @var {Constant.Color, Undefined} The color of the splitter when being
	/// dragged.
	SplitterColorActive = undefined;

	/// @var {Real, Undefined} The alpha value of the splitter when being
	/// dragged.
	SplitterAlphaActive = undefined;
}

/// @func FORMS_Dock([_props])
///
/// @extends FORMS_Widget
///
/// @desc A dock is a recursive structure that can be either split horizontally
/// or vertically or host widgets as its tabs.
///
/// @param {Struct.FORMS_DockProps, Undefined} [_props] Properties to create the
/// dock with or `undefined` (default).
function FORMS_Dock(_props = undefined): FORMS_Widget(_props) constructor
{
	static Widget_update = update;

	/// @var {Constant.Color} The background color of the dock. Defaults to
	/// `0x101010`.
	BackgroundColor = forms_get_prop(_props, "BackgroundColor") ?? 0x101010;

	/// @var {Real} The alpha value of the dock's background. Defaults to 1.
	BackgroundAlpha = forms_get_prop(_props, "BackgroundAlpha") ?? 1.0;

	/// @var {Real} Whether the dock is split horizontally or vertically. Use
	/// values from {@link FORMS_EDockSplit}. Default is
	/// {@link FORMS_EDockSplit.Horizontal}.
	SplitType = forms_get_prop(_props, "SplitType") ?? FORMS_EDockSplit.Horizontal;

	/// @var {Real} The split size of the dock. Defaults to 0.5.
	SplitSize = forms_get_prop(_props, "SplitSize") ?? 0.5;

	/// @var {Real} The size of the splitter that can be dragged with mouse to
	/// change the dock's split size. Defaults to 6.
	SplitterSize = forms_get_prop(_props, "SplitterSize") ?? 6;

	/// @var {Constant.Color} The color of the splitter. Defaults to `0x101010`.
	SplitterColor = forms_get_prop(_props, "SplitterColor") ?? 0x101010;

	/// @var {Real} The alpha value of the splitter. Defaults to 1.
	SplitterAlpha = forms_get_prop(_props, "SplitterAlpha") ?? 1.0;

	/// @var {Constant.Color} The color of the splitter on mouse-over. Defaults
	/// to `0x303030`.
	SplitterColorHover = forms_get_prop(_props, "SplitterColorHover") ?? 0x303030;

	/// @var {Real} The alpha value of the splitter on mouse-over. Defaults to 1.
	SplitterAlphaHover = forms_get_prop(_props, "SplitterAlphaHover") ?? 1.0;

	/// @var {Constant.Color} The color of the splitter when it's being dragged.
	/// Defaults to {@link global.formsAccentColor}.
	SplitterColorActive = forms_get_prop(_props, "SplitterColorActive") ?? global.formsAccentColor;

	/// @var {Real} The alpha value of the splitter when it's being dragged.
	/// Defaults to 1.
	SplitterAlphaActive = forms_get_prop(_props, "SplitterAlphaActive") ?? 1.0;

	/// @var {Struct.FORMS_DockTabs}
	/// @private
	__tabContainer = new FORMS_DockTabs();

	__tabContainer.Parent = self;

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

	/// @func get_first()
	///
	/// @desc Retrieves the first child (left or top, based on the dock's split
	/// type) of the dock.
	///
	/// @return {Struct.FORMS_Dock, Undefined} The first child of the dock or
	/// `undefined`.
	static get_first = function () { return __left; }

	/// @func get_second()
	///
	/// @desc Retrieves the second child (right or bottom, based on the dock's
	/// split type) of the dock.
	///
	/// @return {Struct.FORMS_Dock, Undefined} The second child of the dock or
	/// `undefined`.
	static get_second = function () { return __right; }

	/// @func set_tab(_tabs)
	///
	/// @desc Changes the array of widgets tabbed to the dock.
	///
	/// @param {Array<Struct.FORMS_Widget>} _tabs The new array tabbed widgets.
	///
	/// @return {Struct.FORMS_Dock} Returns `self`.
	static set_tabs = function (_tabs)
	{
		forms_assert(array_length(__tabs) == 0, "Dock already has tabs!"); // TODO: Why is this here? :thinking:
		__tabs = _tabs;
		var i = 0;
		repeat(array_length(__tabs))
		{
			__tabs[i++].Parent = self;
		}
		return self;
	}

	/// @func add_tab(_widget)
	///
	/// @desc Tabs a new widget to the dock.
	///
	/// @param {Struct.FORMS_Widget} _widget The widget to add to the dock's
	/// tabs.
	///
	/// @return {Struct.FORMS_Dock} Returns `self`.
	static add_tab = function (_widget)
	{
		forms_assert(_widget.Parent == undefined, "Widget already has a parent!");
		forms_assert(__left == undefined && __right == undefined, "Cannot add tabs to a dock that is split!");
		array_push(__tabs, _widget);
		_widget.Parent = self;
		return self;
	}

	/// @private
	static __split = function (_type)
	{
		forms_assert(__left == undefined && __right == undefined, "Dock is already split!");

		SplitType = _type;

		__left = new FORMS_Dock();
		__left.Parent = self;

		__right = new FORMS_Dock();
		__right.Parent = self;
	}

	/// @func split_left()
	///
	/// @desc Splits the dock horizontally, moving itself to the left and
	/// creating a new dock on the right.
	///
	/// @return {Struct.FORMS_Dock} Returns `self`.
	static split_left = function ()
	{
		__split(FORMS_EDockSplit.Horizontal);
		__left.set_tabs(__tabs);
		__tabs = [];
		return self;
	}

	/// @func split_right()
	///
	/// @desc Splits the dock horizontally, moving itself to the right and
	/// creating a new dock on the left.
	///
	/// @return {Struct.FORMS_Dock} Returns `self`.
	static split_right = function ()
	{
		__split(FORMS_EDockSplit.Horizontal);
		__right.set_tabs(__tabs);
		__tabs = [];
		return self;
	}

	/// @func split_up()
	///
	/// @desc Splits the dock vertically, moving itself to the top and creating
	/// a new dock at the bottom.
	///
	/// @return {Struct.FORMS_Dock} Returns `self`.
	static split_up = function ()
	{
		__split(FORMS_EDockSplit.Vertical);
		__left.set_tabs(__tabs);
		__tabs = [];
		return self;
	}

	/// @func split_down()
	///
	/// @desc Splits the dock vertically, moving itself to the bottom and
	/// creating a new dock at the top.
	///
	/// @return {Struct.FORMS_Dock} Returns `self`.
	static split_down = function ()
	{
		__split(FORMS_EDockSplit.Vertical);
		__right.set_tabs(__tabs);
		__tabs = [];
		return self;
	}

	static find_widget = function (_id)
	{
		if (Id == _id)
		{
			return self;
		}

		var _found = __tabContainer.find_widget(_id);
		if (_found != undefined)
		{
			return _found;
		}

		if (__left != undefined)
		{
			_found = __left.find_widget(_id);
			if (_found != undefined)
			{
				return _found;
			}
		}

		if (__right != undefined)
		{
			_found = __right.find_widget(_id);
			if (_found != undefined)
			{
				return _found;
			}
		}

		for (var i = array_length(__tabs) - 1; i >= 0; --i)
		{
			_found = __tabs[i].find_widget(_id);
			if (_found != undefined)
			{
				return _found;
			}
		}

		return undefined;
	}

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
			with(__tabContainer)
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
	}

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
	}

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
	}
}

/// @func FORMS_DockTabsProps()
///
/// @extends FORMS_ContainerProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_DockTabs}.
function FORMS_DockTabsProps(): FORMS_ContainerProps() constructor {}

/// @func FORMS_DockTabs([_props])
///
/// @extends FORMS_Container
///
/// @desc A container for tabs added to a {@link FORMS_Dock}.
///
/// @params {Struct.FORMS_DockTabsProps, Undefined} [_props]
function FORMS_DockTabs(_props = undefined): FORMS_Container(_props) constructor
{
	/// @var {Struct.FORMS_UnitValue} The containers's width. Defaults to
	/// 100%.
	Width = Width.from_props(_props, "Width", 100, FORMS_EUnit.Percent);

	/// @var {Struct.FORMS_UnitValue} The container's height. Defaults to
	/// 24px.
	Height = Height.from_props(_props, "Height", 24);

	// TODO: Docs
	BackgroundColor = forms_get_prop(_props, "BackgroundColor") ?? 0x181818;

	static draw_content = function ()
	{
		var _dock = Parent;
		var _tabs = _dock.__tabs;
		var _tabCount = array_length(_tabs);
		var _tabCurrent = _dock.__tabCurrent;
		var _tabIndex = 0;

		var _tabPadding = 9;
		Pen.PaddingX = 0;
		Pen.PaddingY = 3;
		Pen.start();

		repeat(_tabCount)
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
					__realHeight,
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
		ContentWidth = Pen.get_max_x();
		return self;
	}
}
