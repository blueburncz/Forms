function TestWorkspace(): FORMS_FlexBox() constructor
{
	Name = "Test Workspace";
	Icon = FA_ESolid.WindowMaximize;
	Width.from_string("100%");
	Height.from_string("100%");
	Flex = 1;
	Spacing.Value = 1;
	IsHorizontal = false;

	var _menu = new FORMS_MenuBar([
		new FORMS_MenuBarItem("File", FileContextMenu),
		new FORMS_MenuBarItem("Edit", EditContextMenu),
		new FORMS_MenuBarItem("Window"),
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

	_dock.split_left();
	_dock.SplitSize = 0.25;

	_dock.get_second().set_tabs([
		new FORMS_ApplicationSurface(
		{
			Name: "Viewport",
			Icon: FA_ESolid.Camera,
			Width: "100%",
			Height: "100%",
			// Resize: true
		})
	]);
	//_dock.get_second().ShowTabs = false;
}
