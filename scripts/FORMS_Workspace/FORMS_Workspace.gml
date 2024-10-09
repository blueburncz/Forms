/// @func FORMS_WorkspaceProps()
///
/// @extends FORMS_WidgetProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_Workspace}.
function FORMS_WorkspaceProps(): FORMS_WidgetProps() constructor
{
	/// @var {Constant.Color, Undefined} The background color of the workspace.
	BackgroundColor = undefined;

	/// @var {Real, Undefined} The alpha value of the bakground.
	BackgroundAlpha = undefined;
}

/// @func FORMS_Workspace([_props])
///
/// @extends FORMS_Widget
///
/// @desc A container that widgets who represent inividual workspaces are added
/// to as tabs.
///
/// @param {Struct.FORMS_WorkspaceProps, Undefined} [_props] Properties to
/// create the workspace with or `undefined` (default).
function FORMS_Workspace(_props = undefined): FORMS_Widget(_props) constructor
{
	static Widget_update = update;

	/// @var {Constant.Color} The background color of the workspace. Defaults
	/// to `0x202020`.
	BackgroundColor = forms_get_prop(_props, "BackgroundColor") ?? 0x202020;

	/// @var {Real} The alpha value of the background. Defaults to 1.
	BackgroundAlpha = forms_get_prop(_props, "BackgroundAlpha") ?? 1.0;

	/// @var {Struct.FORMS_WorkspaceTabs} A container that displays the
	/// workspace's tabs.
	/// @readonly
	TabContainer = new FORMS_WorkspaceTabs();

	TabContainer.Parent = self;

	/// @var {Array<Struct.FORMS_Widget>}
	/// @private
	__tabs = [];

	/// @var {Real}
	/// @private
	__tabCurrent = 0;

	/// @func set_tab(_tabs)
	///
	/// @desc Changes the array of widgets tabbed to the workspace.
	///
	/// @param {Array<Struct.FORMS_Widget>} _tabs The new array tabbed widgets.
	///
	/// @return {Struct.FORMS_Workspace} Returns `self`.
	static set_tabs = function (_tabs)
	{
		forms_assert(array_length(__tabs) == 0,
			"Workspace already has tabs!"); // TODO: Why is this here? :thinking:
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
	/// @param {Struct.FORMS_Widget} _widget The widget to add to the workspace's
	/// tabs.
	///
	/// @return {Struct.FORMS_Workspace} Returns `self`.
	static add_tab = function (_widget)
	{
		forms_assert(_widget.Parent == undefined, "Widget already has a parent!");
		array_push(__tabs, _widget);
		_widget.Parent = self;
		return self;
	}

	static layout = function ()
	{
		FORMS_LAYOUT_GENERATED;

		var _parentX = __realX;
		var _parentY = __realY;
		var _parentWidth = __realWidth;
		var _parentHeight = __realHeight;

		with(TabContainer)
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
			_tab.__realY = _parentY + TabContainer.__realHeight;
			_tab.__realWidth = _parentWidth;
			_tab.__realHeight = _parentHeight - TabContainer.__realHeight;
			_tab.layout();
		}

		return self;
	}

	static update = function (_deltaTime)
	{
		Widget_update(_deltaTime);
		TabContainer.update(_deltaTime);
		if (__tabCurrent < array_length(__tabs))
		{
			var _tab = __tabs[__tabCurrent];
			_tab.update(_deltaTime);
		}
		return self;
	}

	static draw = function ()
	{
		forms_draw_rectangle(
			__realX, __realY, __realWidth, __realHeight,
			BackgroundColor, BackgroundAlpha);

		var _tabCurrent = __tabCurrent; // Backup before it changes!
		TabContainer.draw();
		if (_tabCurrent < array_length(__tabs))
		{
			__tabs[_tabCurrent].draw();
		}

		return self;
	}
}

/// @func FORMS_WorkspaceTabsProps()
///
/// @extends FORMS_ContainerProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_WorkspaceTabs}.
function FORMS_WorkspaceTabsProps(): FORMS_ContainerProps() constructor {}

/// @func FORMS_WorkspaceTabs([_props])
///
/// @extends FORMS_Container
///
/// @desc A container that displays tabs added to a {@link FORMS_Workspace}.
///
/// @params {Struct.FORMS_WorkspaceTabsProps, Undefined} [_props] Properties to
/// create the workspace tabs container with or `undefined` (default).
function FORMS_WorkspaceTabs(_props = undefined): FORMS_Container(_props) constructor
{
	/// @var {Struct.FORMS_UnitValue} The width of the workspace tabs
	/// container. Defaults to 100%.
	Width.from_props(_props, "Width", 100, FORMS_EUnit.Percent);

	/// @var {Struct.FORMS_UnitValue} The height of the workspace tabs
	/// container. Defaults to 32px.
	Height.from_props(_props, "Height", 32);

	// TODO: Docs
	BackgroundColor = forms_get_prop(_props, "BackgroundColor") ?? 0x181818;

	static draw_content = function ()
	{
		var _workspace = Parent;
		var _tabs = _workspace.__tabs;
		var _tabCount = array_length(_tabs);
		var _tabCurrent = _workspace.__tabCurrent;
		var _tabIndex = 0;

		var _tabPadding = 9;
		Pen.PaddingX = 4;
		Pen.start();

		repeat(_tabCount)
		{
			var _tab = _tabs[_tabIndex];
			var _iconSpace = ((_tab.Icon != undefined) ? 24 : 0);
			if (_tabCurrent == _tabIndex)
			{
				draw_sprite_stretched_ext(
					FORMS_SprTabWorkspace, 0,
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
				_workspace.__tabCurrent = _tabCurrent;
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
					_workspace.__tabCurrent = _tabCurrent;
				}
			}
			Pen.move(_tabPadding);
			++_tabIndex;
		}

		Pen.move(2);
		if (Pen.icon_solid(FA_ESolid.Plus, { Width: 24 }))
		{
			// TODO: Open context menu with workspaces
		}

		Pen.finish();

		ContentWidth = Pen.get_max_x();

		return self;
	}
}
