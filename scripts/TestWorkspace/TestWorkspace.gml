function TestWorkspace(): FORMS_FlexBox() constructor
{
	Name = "Test Workspace";
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

	_dock.get_second().set_tabs([
		new FORMS_ApplicationSurface({ Name: "Viewport", Width: "100%", Height: "100%", /*Resize: true*/ })
	]);

	_dock.get_second().split_up(0.6);
	//_dock.get_second().get_first().ShowTabs = false;
	_dock.get_second().get_second().set_tabs([
		new FORMS_FileBrowser({ Name: "File Browser", Width: "100%", Height: "100%" })
	]);
}
