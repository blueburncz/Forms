function EditContextMenu(): FORMS_ContextMenu() constructor
{
	array_push(
		Options,
		new FORMS_ContextMenuOption("Some"),
		new FORMS_ContextMenuOption("Stuff"),
		new FORMS_ContextMenuOption("Here")
	);
}
