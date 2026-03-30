/// @func FORMS_WorkspaceProps()
///
/// @extends FORMS_WidgetProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_Workspace}.
function FORMS_WorkspaceProps(): FORMS_WidgetProps() constructor {}

/// @func FORMS_Workspace([_props])
///
/// @extends FORMS_Widget
///
/// @desc A container that widgets who represent individual workspaces are added to as tabs.
///
/// @param {Struct.FORMS_WorkspaceProps, Undefined} [_props] Properties to create the workspace with or `undefined`
/// (default).
function FORMS_Workspace(_props = undefined): FORMS_Widget(_props) constructor
{
	static Widget_update = update;

	/// @var {Struct.FORMS_WorkspaceTabs} A container that displays the workspace's tabs.
	/// @readonly
	TabContainer = new FORMS_WorkspaceTabs();

	TabContainer.Parent = self;

	/// @var {Array<Struct.FORMS_Widget>}
	/// @private
	__tabs = [];

	/// @var {Real}
	/// @private
	__tabCurrent = 0;

	/// @var {Real} Previous tab index for detecting workspace tab changes.
	/// @private
	__tabPrevious = 0;

	/// @var {Array<Array<Struct.FORMS_Window>>} Floating windows per workspace tab.
	/// @private
	__tabWindows = [];

	/// @var {Array<Struct>} Available workspace templates for the "+" button. Each entry is a struct with `Name`
	/// (string), `Icon` (font awesome constant or undefined), `IconFont` (font or undefined), and `Create` (function
	/// that returns a new workspace widget).
	///
	/// @example
	/// ```gml
	/// workspace.WorkspaceTemplates = [
	///     { Name: "Test Workspace", Icon: FA_ESolid.WindowMaximize, IconFont: FA_FntSolid12,
	///       Create: function() { return new TestWorkspace(); } },
	/// ];
	/// ```
	WorkspaceTemplates = [];

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
	/// @param {Struct.FORMS_Widget} _widget The widget to add to the workspace's tabs.
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

		if (__tabCurrent >= 0 && __tabCurrent < array_length(__tabs))
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

	/// @func register_window(_window)
	///
	/// @desc Registers a floating window with the current workspace tab. The window will only be visible when this
	/// workspace tab is active.
	///
	/// @param {Struct.FORMS_Window} _window The window to register.
	///
	/// @return {Struct.FORMS_Workspace} Returns `self`.
	static register_window = function (_window)
	{
		// Ensure array is large enough
		while (array_length(__tabWindows) <= __tabCurrent)
		{
			array_push(__tabWindows, []);
		}
		array_push(__tabWindows[__tabCurrent], _window);
		return self;
	}

	static update = function (_deltaTime)
	{
		Widget_update(_deltaTime);

		var _root = forms_get_root();

		// Handle workspace tab changes - swap floating windows
		if (__tabCurrent != __tabPrevious)
		{
			// Remove old tab's windows from root
			if (__tabPrevious < array_length(__tabWindows))
			{
				var _oldWindows = __tabWindows[__tabPrevious];
				for (var i = array_length(_oldWindows) - 1; i >= 0; --i)
				{
					var _w = _oldWindows[i];
					if (_w.__destroyed)
					{
						array_delete(_oldWindows, i, 1);
					}
					else if (_w.Parent == _root)
					{
						_root.remove_child(_w);
					}
				}
			}

			// Add new tab's windows to root
			if (__tabCurrent < array_length(__tabWindows))
			{
				var _newWindows = __tabWindows[__tabCurrent];
				for (var i = array_length(_newWindows) - 1; i >= 0; --i)
				{
					var _w = _newWindows[i];
					if (_w.__destroyed)
					{
						array_delete(_newWindows, i, 1);
					}
					else if (_w.Parent == undefined)
					{
						_root.add_child(_w);
					}
				}
			}

			__tabPrevious = __tabCurrent;
		}

		// Clean up destroyed windows from current tab's list
		if (__tabCurrent < array_length(__tabWindows))
		{
			var _windows = __tabWindows[__tabCurrent];
			for (var i = array_length(_windows) - 1; i >= 0; --i)
			{
				if (_windows[i].__destroyed)
				{
					array_delete(_windows, i, 1);
				}
			}
		}

		// Workspace tab reorder detection
		var _tc = TabContainer;
		var _tabDrag = forms_get_tab_drag();
		if (!_tabDrag.Active && _root.DragTarget == undefined)
		{
			var _mx = window_mouse_get_x();
			var _my = window_mouse_get_y();

			// Detect mouse press on a workspace tab
			if (mouse_check_button_pressed(mb_left)
				&& array_length(_tc.__tabXPositions) > 0
				&& _tc.__realHeight > 0)
			{
				for (var _ti = 0; _ti < array_length(_tc.__tabXPositions); ++_ti)
				{
					if (_mx >= _tc.__tabXPositions[_ti]
						&& _mx < _tc.__tabXPositions[_ti] + _tc.__tabWidths[_ti]
						&& _my >= _tc.__realY
						&& _my < _tc.__realY + _tc.__realHeight)
					{
						_tc.__pressedTabIndex = _ti;
						_tc.__pressedMouseX = _mx;
						_tc.__pressedMouseY = _my;
						break;
					}
				}
			}

			// Reorder when threshold exceeded (horizontal only, no pop-out)
			if (_tc.__pressedTabIndex >= 0 && mouse_check_button(mb_left))
			{
				var _dist = point_distance(_mx, _my, _tc.__pressedMouseX, _tc.__pressedMouseY);
				if (_dist > 8)
				{
					_tc.__reorderActive = true;
					var _pi = _tc.__pressedTabIndex;
					if (_pi < array_length(__tabs) && _pi < array_length(_tc.__tabXPositions))
					{
						_tc.__reorderOffsetX = _mx - (_tc.__tabXPositions[_pi] + _tc.__tabWidths[_pi] * 0.5);

						for (var _ri = 0; _ri < array_length(_tc.__tabXPositions); ++_ri)
						{
							var _tabMid = _tc.__tabXPositions[_ri] + _tc.__tabWidths[_ri] * 0.5;
							var _swapped = false;
							if (_mx < _tabMid && _ri < _pi)
							{
								var _moving = __tabs[_pi];
								array_delete(__tabs, _pi, 1);
								array_insert(__tabs, _ri, _moving);
								__tabCurrent = _ri;
								_tc.__pressedTabIndex = _ri;
								_swapped = true;

								// Also swap in __tabWindows
								if (_pi < array_length(__tabWindows) && _ri < array_length(__tabWindows))
								{
									var _movingW = __tabWindows[_pi];
									array_delete(__tabWindows, _pi, 1);
									array_insert(__tabWindows, _ri, _movingW);
								}
							}
							else if (_mx >= _tabMid && _ri > _pi)
							{
								var _moving = __tabs[_pi];
								array_delete(__tabs, _pi, 1);
								array_insert(__tabs, _ri, _moving);
								__tabCurrent = _ri;
								_tc.__pressedTabIndex = _ri;
								_swapped = true;

								// Also swap in __tabWindows
								if (_pi < array_length(__tabWindows) && _ri < array_length(__tabWindows))
								{
									var _movingW = __tabWindows[_pi];
									array_delete(__tabWindows, _pi, 1);
									array_insert(__tabWindows, _ri, _movingW);
								}
							}

							if (_swapped)
							{
								var _movingWidth = _tc.__tabWidths[_pi];
								array_delete(_tc.__tabWidths, _pi, 1);
								array_insert(_tc.__tabWidths, _ri, _movingWidth);
								for (var _qi = 1; _qi < array_length(_tc.__tabXPositions); ++_qi)
								{
									_tc.__tabXPositions[_qi] = _tc.__tabXPositions[_qi - 1] + _tc.__tabWidths[
										_qi - 1];
								}
								_tc.__reorderOffsetX = _mx - (_tc.__tabXPositions[_ri] + _tc.__tabWidths[_ri]
									* 0.5);
								__tabPrevious = __tabCurrent;
								break;
							}
						}
					}
				}
			}

			if (!mouse_check_button(mb_left))
			{
				_tc.__pressedTabIndex = -1;
				_tc.__reorderActive = false;
			}
		}

		TabContainer.update(_deltaTime);
		if (__tabCurrent >= 0 && __tabCurrent < array_length(__tabs))
		{
			var _tab = __tabs[__tabCurrent];
			_tab.update(_deltaTime);
		}
		return self;
	}

	static draw = function ()
	{
		var _style = forms_get_style();
		forms_draw_rectangle(__realX, __realY, __realWidth, __realHeight, _style.Background[1].get(), 1.0);

		var _tabCurrent = __tabCurrent; // Backup before it changes!
		TabContainer.draw();

		// Draw reordering workspace tab as overlay
		var _tc = TabContainer;
		if (_tc.__reorderActive && _tc.__pressedTabIndex >= 0
			&& _tc.__pressedTabIndex < array_length(__tabs))
		{
			var _pi = _tc.__pressedTabIndex;
			var _tab = __tabs[_pi];
			var _tabPadding = _style.Padding + 1;
			var _iconSpace = (_tab.Icon != undefined) ? 24 : 0;
			var _tabWidth = (_pi < array_length(_tc.__tabWidths)) ? _tc.__tabWidths[_pi] : 100;
			var _tabX = _tc.__tabXPositions[_pi] + _tc.__reorderOffsetX;
			var _tabY = _tc.__realY;
			var _tabH = _tc.__realHeight;

			draw_sprite_stretched_ext(
				FORMS_SprTabWorkspace, 0,
				_tabX, _tabY,
				_tabWidth, _tabH,
				_style.Background[2].get(), 1.0);

			var _contentX = _tabX + _tabPadding;
			var _contentY = _tabY + round((_tabH - string_height("M")) / 2);
			if (_tab.Icon != undefined)
			{
				fa_draw(_tab.IconFont, _tab.Icon, _contentX, _contentY, _style.Text.get());
				_contentX += _iconSpace;
			}
			draw_set_font(_style.Font);
			forms_draw_text(_contentX, _contentY, _tab.Name, _style.Text.get());
		}

		if (_tabCurrent >= 0 && _tabCurrent < array_length(__tabs))
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
/// @params {Struct.FORMS_WorkspaceTabsProps, Undefined} [_props] Properties to create the workspace tabs container with
/// or `undefined` (default).
function FORMS_WorkspaceTabs(_props = undefined): FORMS_Container(_props) constructor
{
	/// @var {Struct.FORMS_UnitValue} The width of the workspace tabs container. Defaults to 100%.
	Width.from_props(_props, "Width", 100, FORMS_EUnit.Percent);

	/// @var {Struct.FORMS_UnitValue} The height of the workspace tabs container. Defaults to 32px.
	Height.from_props(_props, "Height", 32);

	/// @var {Bool} Whether the default scrolling direction of the container is vertical (`true`) or horizontal
	/// (`false`). Defaults to `false`.
	IsDefaultScrollVertical = forms_get_prop(_props, "IsDefaultScrollVertical") ?? false;

	/// @var {Real}
	BackgroundColorIndex = 1;

	/// @var {Array<Real>} Absolute X positions of each tab.
	/// @private
	__tabXPositions = [];

	/// @var {Array<Real>} Widths of each tab.
	/// @private
	__tabWidths = [];

	/// @var {Real} Tab index pressed for potential drag, or -1.
	/// @private
	__pressedTabIndex = -1;

	/// @var {Real}
	/// @private
	__pressedMouseX = 0;

	/// @var {Real}
	/// @private
	__pressedMouseY = 0;

	/// @var {Bool} Whether a tab is currently being reordered.
	/// @private
	__reorderActive = false;

	/// @var {Real} Horizontal offset for the reordered tab's overlay.
	/// @private
	__reorderOffsetX = 0;

	static draw_content = function ()
	{
		var _style = forms_get_style();
		var _workspace = Parent;
		var _tabs = _workspace.__tabs;
		var _tabCount = array_length(_tabs);
		var _tabCurrent = _workspace.__tabCurrent;
		var _tabIndex = 0;

		var _tabPadding = _style.Padding + 1;
		Pen.PaddingX = 4;
		Pen.start();

		// Resize position tracking arrays
		array_resize(__tabXPositions, _tabCount);
		array_resize(__tabWidths, _tabCount);

		repeat(_tabCount)
		{
			var _tab = _tabs[_tabIndex];
			var _iconSpace = ((_tab.Icon != undefined) ? 24 : 0);
			var _tabStartX = Pen.X;

			var _tabWidth = _tabPadding
				+ _iconSpace
				+ string_width(_tab.Name) + 4 + 16
				+ _tabPadding;

			// Store absolute position for reorder detection
			__tabXPositions[_tabIndex] = __realX + _tabStartX - ScrollX;
			__tabWidths[_tabIndex] = _tabWidth;

			// Skip drawing if this tab is being reordered (drawn as overlay)
			if (__reorderActive && _tabIndex == __pressedTabIndex)
			{
				Pen.move(_tabWidth);
				++_tabIndex;
				continue;
			}

			if (_tabCurrent == _tabIndex)
			{
				draw_sprite_stretched_ext(
					FORMS_SprTabWorkspace, 0,
					Pen.X, 0,
					_tabWidth,
					__realHeight,
					_style.Background[2].get(), 1.0);
			}
			Pen.move(_tabPadding);
			if (_tab.Icon != undefined)
			{
				fa_draw(_tab.IconFont, _tab.Icon, Pen.X, Pen.Y, (_tabIndex == _tabCurrent) ? _style.Text
					.get()
					: _style.TextMuted.get());
				Pen.move(_iconSpace);
			}
			if (Pen.link(_tab.Name, { Muted: (_tabIndex != _tabCurrent) }))
			{
				_tabCurrent = _tabIndex;
				_workspace.__tabCurrent = _tabCurrent;
			}
			Pen.move(4);
			if (Pen.icon_solid(FA_ESolid.Xmark, { Width: 16, Muted: true }))
			{
				_tab.Parent = undefined;
				_tab.destroy();

				array_delete(_tabs, _tabIndex--, 1);
				--_tabCount;

				_tabCurrent = clamp(_tabCurrent, 0, _tabCount - 1);
				_workspace.__tabCurrent = _tabCurrent;
			}
			Pen.move(_tabPadding);
			++_tabIndex;
		}

		Pen.move(2);
		if (Pen.icon_solid(FA_ESolid.Plus, { Width: 24, Tooltip: "New Workspace" }))
		{
			var _templates = _workspace.WorkspaceTemplates;
			if (array_length(_templates) > 0)
			{
				var _options = [];
				for (var _ti = 0; _ti < array_length(_templates); ++_ti)
				{
					var _template = _templates[_ti];
					var _optProps = new FORMS_ContextMenuOptionProps();
					_optProps.Text = _template.Name;
					_optProps.Action = method({ workspace: _workspace, template: _template }, function ()
					{
						var _widget = template.Create();
						workspace.add_tab(_widget);
						workspace.__tabCurrent = array_length(workspace.__tabs) - 1;
						workspace.__tabPrevious = workspace.__tabCurrent;
					});
					array_push(_options, new FORMS_ContextMenuOption(_optProps));
				}

				var _menuPos = Pen.get_absolute_pos(Pen.X, Pen.Y + string_height("M"));
				var _contextMenu = new FORMS_ContextMenu(_options,
				{
					X: _menuPos[0],
					Y: _menuPos[1],
				});
				forms_get_root().add_child(_contextMenu);
			}
		}

		Pen.finish();

		ContentWidth = Pen.get_max_x();

		return self;
	}
}
