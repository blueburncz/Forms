function TestContainer()
	: FORMS_Container() constructor
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
	Color = 0xAA000000 | global.formsAccentColor;
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

	static draw_content = function ()
	{
		var _props;

		Pen.start()
			.text("Some stuff ")
			.text("Some other stuff!", { Color: global.formsAccentColor, Cursor: cr_handpoint, Tooltip: "Oh yeah!" })
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
