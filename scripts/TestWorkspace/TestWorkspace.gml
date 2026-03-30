global.ksPreferences = new FORMS_KeyboardShortcut(
	[vk_control, vk_shift, ord("P")], undefined,
	function ()
	{
		if (global.testPreferencesWindow.Parent == undefined)
		{
			forms_get_root().add_child(global.testPreferencesWindow);
		}
	});

/// @func __test_find_first_leaf_dock(_widget)
///
/// @desc Walks a widget tree to find the first leaf dock (a dock with tabs, not split).
///
/// @param {Struct} _widget Widget to search from.
///
/// @return {Struct.FORMS_Dock, Undefined}
function __test_find_first_leaf_dock(_widget)
{
	// If this is a dock
	if (variable_struct_exists(_widget, "__tabs") && variable_struct_exists(_widget, "__left"))
	{
		// Leaf dock
		if (_widget.__left == undefined)
		{
			return _widget;
		}
		// Branch - search children
		var _found = __test_find_first_leaf_dock(_widget.__left);
		if (_found != undefined) return _found;
		return __test_find_first_leaf_dock(_widget.__right);
	}

	// CompoundWidget children
	if (variable_struct_exists(_widget, "Children"))
	{
		for (var i = 0; i < array_length(_widget.Children); ++i)
		{
			var _found = __test_find_first_leaf_dock(_widget.Children[i]);
			if (_found != undefined) return _found;
		}
	}

	// Workspace / widget with tabs (traverse current tab)
	if (variable_struct_exists(_widget, "__tabs") && variable_struct_exists(_widget, "__tabCurrent"))
	{
		var _tabCurrent = _widget.__tabCurrent;
		if (_tabCurrent >= 0 && _tabCurrent < array_length(_widget.__tabs))
		{
			var _found = __test_find_first_leaf_dock(_widget.__tabs[_tabCurrent]);
			if (_found != undefined) return _found;
		}
	}

	// Window widget
	if (variable_struct_exists(_widget, "Widget") && _widget.Widget != undefined)
	{
		var _found = __test_find_first_leaf_dock(_widget.Widget);
		if (_found != undefined) return _found;
	}

	return undefined;
}

function TestWindowContextMenu(): FORMS_ContextMenu() constructor
{
	var _options = Options;

	var _option = new FORMS_ContextMenuOption("Controls Test");
	_option.Icon = FA_ESolid.List;
	_option.Action = function ()
	{
		var _tab = new TestControlsScrollPane();
		var _dock = new FORMS_Dock({ ShowTabs: false });
		_dock.__tabs = [_tab];
		_tab.Parent = _dock;
		var _window = new FORMS_Window(_dock,
		{
			Center: true,
			Width: 600,
			Height: 400,
		});
		forms_get_root().add_child(_window);
	};
	array_push(_options, _option);

	_option = new FORMS_ContextMenuOption("Viewport");
	_option.Icon = FA_ESolid.Camera;
	_option.Action = function ()
	{
		forms_open_single_instance("viewport", function ()
		{
			return new FORMS_ApplicationSurface(
			{
				Name: "Viewport",
				Icon: FA_ESolid.Camera,
				Width: "100%",
				Height: "100%",
			});
		});
	};
	array_push(_options, _option);

	array_push(_options, new FORMS_ContextMenuSeparator());

	_option = new FORMS_ContextMenuOption("Preferences");
	_option.KeyboardShortcut = global.ksPreferences;
	_option.Action = function ()
	{
		if (global.testPreferencesWindow.Parent == undefined)
		{
			forms_get_root().add_child(global.testPreferencesWindow);
		}
	};
	array_push(_options, _option);
}

function TestWorkspace(): FORMS_FlexBox() constructor
{
	Name = "Test Workspace";
	Icon = FA_ESolid.WindowMaximize;
	Width.from_string("100%");
	Height.from_string("100%");
	Flex = 1;
	Spacing.Value = 1;
	IsHorizontal = false;
	KeyboardShortcuts = [global.ksPreferences];

	var _menu = new FORMS_MenuBar([
		new FORMS_MenuBarItem("File", FileContextMenu),
		new FORMS_MenuBarItem("Edit", EditContextMenu),
		new FORMS_MenuBarItem("Window", TestWindowContextMenu),
		new FORMS_MenuBarItem("Help"),
	]);
	add_child(_menu);

	var _toolbar = new(function (): FORMS_Toolbar() constructor
	{
		static draw_content = function ()
		{
			Pen.start();
			Pen.icon_solid(FA_ESolid.House, { Tooltip: "Close Project" });
			Pen.vsep();
			Pen.icon_solid(FA_ESolid.File, { Tooltip: "New Project" });
			Pen.icon_solid(FA_ESolid.FolderOpen, { Tooltip: "Open Project" });
			Pen.icon_solid(FA_ESolid.FloppyDisk, { Tooltip: "Save Project" });
			Pen.vsep();
			Pen.icon_solid(FA_ESolid.Download, { Tooltip: "Create Executable" });
			Pen.vsep();
			Pen.icon_solid(FA_ESolid.Bug, { Tooltip: "Debug" });
			Pen.icon_solid(FA_ESolid.Play, { Tooltip: "Run" });
			Pen.icon_solid(FA_ESolid.Stop, { Tooltip: "Stop" });
			Pen.icon_solid(FA_ESolid.Brush, { Tooltip: "Clean" });
			Pen.vsep();
			Pen.icon_solid(FA_ESolid.Gear, { Tooltip: "Game Options" });
			Pen.icon_solid(FA_ESolid.CircleQuestion, { Tooltip: "Help" });
			Pen.vsep();
			Pen.icon_solid(FA_ESolid.MagnifyingGlassMinus, { Tooltip: "Zoom Out" });
			Pen.icon_solid(FA_ESolid.MagnifyingGlass, { Tooltip: "Zoom Reset" });
			Pen.icon_solid(FA_ESolid.MagnifyingGlassPlus, { Tooltip: "Zoom In" });
			Pen.icon_solid(FA_ESolid.Expand, { Tooltip: "Collapse/Expand" });
			Pen.vsep();
			Pen.icon_solid(FA_ESolid.Computer, { Tooltip: "Laptop Mode" });
			Pen.icon_solid(FA_ESolid.Robot, { Tooltip: "AI Assistant" });
			Pen.finish();
			FORMS_CONTENT_UPDATE_SIZE;
			return self;
		}
	})();
	add_child(_toolbar);

	var _dock = new FORMS_Dock(
	{
		Width: "100%",
		Height: "100%",
		Flex: 1,
	});
	add_child(_dock);

	_dock.set_tabs([
		new TestControlsScrollPane(),
		new TestControlsScrollPane(),
	]);

	_dock.split_left(0.25);

	var _viewport = new FORMS_ApplicationSurface(
	{
		Name: "Viewport",
		Icon: FA_ESolid.Camera,
		Width: "100%",
		Height: "100%",
		// Resize: true
	});
	forms_register_single_instance("viewport", _viewport);

	// Tool selection toolbar (top-left)
	var _toolBar = new(function (): FORMS_FloatingToolbar(
	{
		PositionX: 0.0,
		PositionY: 0.0,
	}) constructor
	{
		Tool = 0;

		static draw_content = function ()
		{
			Pen.start();
			if (Pen.icon_solid(FA_ESolid.ArrowPointer,
				{
					Width: 24,
					Tooltip: "Select",
					Active: (Tool
						== 0)
				}))
			{
				Tool = 0;
			}
			Pen.vsep();
			if (Pen.icon_solid(FA_ESolid.ArrowsUpDownLeftRight,
				{
					Width: 24,
					Tooltip: "Move",
					Active: (
						Tool == 1)
				}))
			{
				Tool = 1;
			}
			if (Pen.icon_solid(FA_ESolid.ArrowsRotate,
				{
					Width: 24,
					Tooltip: "Rotate",
					Active: (Tool
						== 2)
				}))
			{
				Tool = 2;
			}
			if (Pen.icon_solid(FA_ESolid.UpRightAndDownLeftFromCenter,
				{
					Width: 24,
					Tooltip: "Scale",
					Active: (Tool == 3)
				}))
			{
				Tool = 3;
			}
			Pen.finish();
			FORMS_CONTENT_UPDATE_SIZE;
			return self;
		}
	})();
	_viewport.add_child(_toolBar);

	// Rendering options toolbar (top-right)
	var _renderBar = new(function (): FORMS_FloatingToolbar(
	{
		PositionX: 1.0,
		PositionY: 0.0,
	}) constructor
	{
		ShowGrid = true;
		ShowGizmos = true;

		static draw_content = function ()
		{
			Pen.start();
			if (Pen.checkbox(ShowGrid) | Pen.link(" Grid"))
			{
				ShowGrid = !ShowGrid;
			}
			Pen.space(2);
			if (Pen.checkbox(ShowGizmos) | Pen.link(" Gizmos"))
			{
				ShowGizmos = !ShowGizmos;
			}
			Pen.finish();
			FORMS_CONTENT_UPDATE_SIZE;
			return self;
		}
	})();
	_viewport.add_child(_renderBar);

	// FPS counter (bottom-right)
	var _fpsBar = new(function (): FORMS_FloatingToolbar(
	{
		PositionX: 1.0,
		PositionY: 1.0,
		BackgroundAlpha: 0.6,
		Draggable: false,
	}) constructor
	{
		static draw_content = function ()
		{
			Pen.start();
			Pen.text($"{fps} FPS", { Muted: true });
			Pen.finish();
			FORMS_CONTENT_UPDATE_SIZE;
			return self;
		}
	})();
	_viewport.add_child(_fpsBar);

	_dock.get_second().set_tabs([
		_viewport
	]);

	_dock.get_second().split_up(0.6);
	_dock.get_second().get_second().set_tabs([
		new FORMS_FileBrowser({ Name: "File Browser", Width: "100%", Height: "100%" })
	]);
}
