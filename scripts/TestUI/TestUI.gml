function TestUI()
	: FORMS_RootWidget() constructor
{
	var _vbox = new FORMS_FlexBox({
		Width: "100%",
		Height: "100%",
		Spacing: 1,
		IsHorizontal: false,
	});
	add_child(_vbox);

	var _workspace = new FORMS_Workspace({
		Width: "100%",
		Flex: 1,
	});
	_vbox.add_child(_workspace);

	var _testWorkspace1 = new TestWorkspace();
	_workspace.add_tab(_testWorkspace1);

	var _testWorkspace2 = new TestWorkspace();
	_workspace.add_tab(_testWorkspace2);

	var _statusBar = new TestStatusBar();
	_vbox.add_child(_statusBar);

	var _welcomeWindow = new FORMS_Window(new TestWelcomeContainer(), { Center: true });
	add_child(_welcomeWindow);
}
