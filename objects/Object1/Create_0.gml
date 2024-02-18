application_surface_draw_enable(false);
draw_set_font(FORMS_FntNormal);

gui = new FORMS_RootWidget();

function TestContent() : FORMS_Content("Test Content") constructor
{
	Checked1 = false;
	Checked2 = true;
	Radio = 0;
	Slider = 0;
	DropdownValues = [
		"Some",
		"Shit",
		"Here",
		"That",
		"You",
		"Can",
		"Select",
	];
	DropdownIndex = 0;
	InputString = "";
	InputReal = 0;

	static draw = function ()
	{
		var _props;

		Pen.start(8, 8)
			.text("Some shit ")
			.text("Some other shit!", { Color: c_orange, Cursor: cr_handpoint, Tooltip: "Oh yeah!" })
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

		Pen.finish();

		Width = Pen.MaxX + 8;
		Height = Pen.MaxY + 8;

		return self;
	};
}

var _dock = new FORMS_Dock({
	Width: 100,
	WidthUnit: FORMS_EUnit.Percent,
	Height: 100,
	HeightUnit: FORMS_EUnit.Percent,
});

gui.add_child(_dock);

var _scrollPane1 = new FORMS_ScrollPane(new TestContent(), {
	Width: 100,
	WidthUnit: FORMS_EUnit.Percent,
	Flex: 1,
	Container: {
		BackgroundColor: make_color_hsv(random(255), 255, 50),
	}
});
_scrollPane1.Name = "Test Content 1";

var _scrollPane2 = new FORMS_ScrollPane(new TestContent(), {
	Width: 100,
	WidthUnit: FORMS_EUnit.Percent,
	Flex: 1,
	Container: {
		BackgroundColor: make_color_hsv(random(255), 255, 50),
	}
});
_scrollPane2.Name = "Test Content 2";

_dock.add_tab(_scrollPane1);
_dock.add_tab(_scrollPane2);

var _scrollPane3 = new FORMS_ScrollPane(new TestContent(), {
	Width: 100,
	WidthUnit: FORMS_EUnit.Percent,
	Flex: 1,
	Container: {
		BackgroundColor: make_color_hsv(random(255), 255, 50),
	}
});
_scrollPane3.Name = "Test Content 3";

var _window = new FORMS_Window(_scrollPane3, {
	X: 100,
	Y: 100,
});

gui.add_child(_window);
