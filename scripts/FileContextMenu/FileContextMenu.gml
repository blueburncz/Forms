function FileContextMenu(): FORMS_ContextMenu() constructor
{
	var _options = Options;

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
		new FORMS_ContextMenuOption("Project 2"),
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
	_option.KeyboardShortcut = global.ksPreferences;
	array_push(_options, _option);

	array_push(_options, new FORMS_ContextMenuSeparator());

	_option = new FORMS_ContextMenuOption("Exit");
	_option.Action = function ()
	{
		var _question = new FORMS_Question("Are you sure you want to exit?", function (_answer)
		{
			if (_answer == "OK")
			{
				game_end();
			}
		});
		forms_get_root().add_child(_question);
	};
	_option.KeyboardShortcut = new FORMS_KeyboardShortcut([vk_alt, vk_f4]);
	array_push(_options, _option);
}
