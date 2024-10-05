application_surface_draw_enable(false);
draw_set_font(FORMS_FntNormal);

gui = new FORMS_RootWidget();

var _vbox = new FORMS_FlexBox({
	Width: "100%",
	Height: "100%",
	IsHorizontal: false,
});

gui.add_child(_vbox);

function FileContextMenu() : FORMS_ContextMenu() constructor
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
	_option.KeyboardShortcut = new FORMS_KeyboardShortcut([vk_control, vk_shift, ord("P")]);
	array_push(_options, _option);

	array_push(_options, new FORMS_ContextMenuSeparator());

	_option = new FORMS_ContextMenuOption("Exit");
	_option.Action = game_end;
	_option.KeyboardShortcut = new FORMS_KeyboardShortcut([vk_alt, vk_f4]);
	array_push(_options, _option);
}

function EditContextMenu() : FORMS_ContextMenu() constructor
{
	array_push(
		Options,
		new FORMS_ContextMenuOption("Some"),
		new FORMS_ContextMenuOption("Stuff"),
		new FORMS_ContextMenuOption("Here")
	);
}

menu = new FORMS_MenuBar([
	new FORMS_MenuBarItem("File", FileContextMenu),
	new FORMS_MenuBarItem("Edit", EditContextMenu),
	new FORMS_MenuBarItem("Window"),
	new FORMS_MenuBarItem("Help"),
]);
_vbox.add_child(menu);

function TestContent() : FORMS_Content() constructor
{
	Checked1 = false;
	Checked2 = true;
	Radio = 0;
	Slider = 0;
	DropdownValues = [
		"Some",
		"Stuff",
		"Here",
		"That",
		"You",
		"Can",
		"Select",
	];
	DropdownIndex = 0;
	InputString = "";
	InputReal = 0;
	Color = new FORMS_Color(0xAA000000 | c_orange)
	var _propsFolder = {
		Icon: FA_ESolid.FolderOpen,
		IconCollapsed: FA_ESolid.Folder,
		IconFont: FA_FntSolid12,
		IconColor: c_gray,
	};
	var _propsFile = {
		Icon: FA_ESolid.File,
		IconFont: FA_FntSolid12,
	};
	Tree = new FORMS_Tree([
		new FORMS_TreeItem("Item 1", _propsFolder, [
			new FORMS_TreeItem("Item A", _propsFile),
			new FORMS_TreeItem("Item B", _propsFile),
		]),
		new FORMS_TreeItem("Item 2", _propsFolder, [
			new FORMS_TreeItem("Item C", _propsFolder, [
				new FORMS_TreeItem("Some", _propsFile),
				new FORMS_TreeItem("Folder", _propsFolder, [
					new FORMS_TreeItem("Oh", _propsFile),
					new FORMS_TreeItem("Yeah", _propsFile),
				]),
				new FORMS_TreeItem("Here", _propsFile),
			]),
			new FORMS_TreeItem("Item D", _propsFile),
		]),
	]);

	static draw = function ()
	{
		var _props;

		Pen.start()
			.text("Some stuff ")
			.text("Some other stuff!", { Color: c_orange, Cursor: cr_handpoint, Tooltip: "Oh yeah!" })
			.nl();

		if (Pen.button("Click me!", { Tooltip: "Click the button!" }))
			show_debug_message("Clicked!");
		Pen.nl();

		if (Pen.checkbox(Checked1) | Pen.link(" Label 1"))
			Checked1 = !Checked1;
		Pen.nl();

		_props = { Tooltip: "Checkbox with a clickable label!" };
		if (Pen.checkbox(Checked2, _props) | Pen.link(" Label 2", _props))
			Checked2 = !Checked2;
		Pen.nl();

		if (Pen.radio(Radio == 0) | Pen.link(" Radio 1"))
			Radio = 0;
		Pen.nl();

		if (Pen.radio(Radio == 1) | Pen.link(" Radio 2"))
			Radio = 1;
		Pen.nl();

		if (Pen.radio(Radio == 2) | Pen.link(" Radio 3"))
			Radio = 2;
		Pen.nl();

		if (Pen.slider("slider", Slider, -100, 100, { Pre: "X: ", Post: "%", Integers: true, Tooltip: "This is the best slider ever!" }))
			Slider = Pen.get_result();
		Pen.text(" Slider").nl();

		if (Pen.dropdown("dropdown", DropdownIndex, DropdownValues))
			DropdownIndex = Pen.get_result();
		Pen.text(" Dropdown").nl();

		if (Pen.input("input-string", InputString, { Placeholder: "Some text here..." }))
			InputString = Pen.get_result();
		Pen.text(" String input").nl();

		if (Pen.input("input-real", InputReal, { Tooltip: "This one has a tooltip!" }))
			InputReal = Pen.get_result();
		Pen.text(" Real input").nl();

		Pen.icon_regular(FA_ERegular.AddressBook, { Width: 24 });
		Pen.move(2);
		Pen.icon_solid(FA_ESolid.TruckFast, { Width: 24 });
		Pen.move(2);
		Pen.icon_brands(FA_EBrands.Github, { Width: 24 });
		Pen.nl();

		if (Pen.color("input-color", Color))
			Color = Pen.get_result();
		Pen.text(" Color input").nl();

		Tree.draw(Pen);

		Pen.finish();

		FORMS_CONTENT_UPDATE_SIZE;

		return self;
	};
}

var _workspace = new FORMS_Workspace({
	Width: "100%",
	Height: "100%",
	Flex: 1,
});
_vbox.add_child(_workspace);

var _dock = new FORMS_Dock({
	Name: "Workspace 1",
	Width: "100%",
	Height: "100%",
});
_workspace.add_tab(_dock);

var _scrollPane1 = new FORMS_ScrollPane(new TestContent(), {
	Width: "100%",
	Flex: 1,
	//Container: {
	//	BackgroundColor: make_color_hsv(random(255), 255, 50),
	//}
});
_scrollPane1.Name = "Test Content 1";

var _scrollPane2 = new FORMS_ScrollPane(new TestContent(), {
	Width: "100%",
	Flex: 1,
	//Container: {
	//	BackgroundColor: make_color_hsv(random(255), 255, 50),
	//}
});
_scrollPane2.Name = "Test Content 2";

_dock.add_tab(_scrollPane1);
_dock.add_tab(_scrollPane2);
_dock.split_left();

var _scrollPane3 = new FORMS_ScrollPane(new TestContent(), {
	Width: "100%",
	Flex: 1,
	//Container: {
	//	BackgroundColor: make_color_hsv(random(255), 255, 50),
	//}
});
_scrollPane3.Name = "Test Content 3";

var _window = new FORMS_Window(_scrollPane3, {
	X: 100,
	Y: 100,
});

gui.add_child(_window);

var _scrollPane4 = new FORMS_ScrollPane(new TestContent(), {
	Width: "100%",
	Flex: 1,
	//Container: {
	//	BackgroundColor: make_color_hsv(random(255), 255, 50),
	//}
});
_scrollPane4.Name = "Workspace 2";
_workspace.add_tab(_scrollPane4);
