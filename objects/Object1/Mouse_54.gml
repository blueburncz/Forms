var _options = [];

var _option = new FORMS_ContextMenuOption("New Project");
_option.KeyboardShortcut = new FORMS_KeyboardShortcut([vk_control, ord("N")]);
array_push(_options, _option);

_option = new FORMS_ContextMenuOption("Open Project");
_option.KeyboardShortcut = new FORMS_KeyboardShortcut([vk_control, ord("O")]);
array_push(_options, _option);

_option = new FORMS_ContextMenuOption("Import Project");
array_push(_options, _option);

_option = new FORMS_ContextMenuOption("Recent Projects");
_option.Options = [
	new FORMS_ContextMenuOption("Project 1"),
	new FORMS_ContextMenuOption("Project 2").add_option(new FORMS_ContextMenuOption("Some shit")),
	new FORMS_ContextMenuOption("Project 3"),
];
array_push(_options, _option);

array_push(_options, new FORMS_ContextMenuSeparator());

_option = new FORMS_ContextMenuOption("Save Project");
_option.KeyboardShortcut = new FORMS_KeyboardShortcut([vk_control, ord("S")]);
array_push(_options, _option);

_option = new FORMS_ContextMenuOption("Save Project As");
_option.KeyboardShortcut = new FORMS_KeyboardShortcut([vk_control, vk_shift, ord("S")]);
array_push(_options, _option);

_option = new FORMS_ContextMenuOption("Export Project");
array_push(_options, _option);

array_push(_options, new FORMS_ContextMenuSeparator());

_option = new FORMS_ContextMenuOption("New IDE");
array_push(_options, _option);

array_push(_options, new FORMS_ContextMenuSeparator());

_option = new FORMS_ContextMenuOption("Preferences");
_option.KeyboardShortcut = new FORMS_KeyboardShortcut([vk_control, vk_shift, ord("P")]);
array_push(_options, _option);

array_push(_options, new FORMS_ContextMenuSeparator());

_option = new FORMS_ContextMenuOption("Exit");
_option.Action = game_end;
_option.KeyboardShortcut = new FORMS_KeyboardShortcut([vk_alt, vk_f4]);
array_push(_options, _option);

var _contextMenu = new FORMS_ContextMenu(_options, {
	X: window_mouse_get_x(),
	Y: window_mouse_get_y(),
});
gui.add_child(_contextMenu);
