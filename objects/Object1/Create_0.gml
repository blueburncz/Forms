application_surface_draw_enable(false);

gui = FORMS_Init();

guiMenu = new FORMS_MenuBar();
guiMenu.AddItem(new FORMS_MenuBarItem("File", function (_contextMenu) {
	var _ksExit = new FORMS_KeyboardShortcut(game_end);
	_ksExit.AddKey(vk_alt);
	_ksExit.AddKey(vk_f4);
	_contextMenu.AddItem(new FORMS_ContextMenuItem("Exit", game_end, _ksExit, "Exit program"));
}));
guiMenu.AddItem(new FORMS_MenuBarItem("Help", function (_contextMenu) {
	_contextMenu.AddItem(new FORMS_ContextMenuItem("BlueBurn.cz", function () {
		url_open("https://blueburn.cz");
	}, undefined, "Open BlueBurn.cz"));
}));

gui.AddItem(guiMenu);
