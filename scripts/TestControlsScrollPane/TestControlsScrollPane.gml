function TestControlsScrollPane(): FORMS_ScrollPane() constructor
{
	Name = "Controls Test";
	Icon = FA_ESolid.List;

	// State variables
	Checked1 = false;
	Checked2 = true;
	Checked3 = false;
	Radio = 0;
	Slider = 0;
	SliderFloat = 0.5;
	SliderWide = 75;
	SliderDisabled = 50;
	DropdownValues = [
		"Apple",
		"Banana",
		"Cherry",
		"Dragon Fruit",
		"Elderberry",
		"Fig",
		"Grape",
	];
	DropdownValue = "Apple";
	DropdownStructValues = [
		{ Value: "red", Text: "Red Color" },
		{ Value: "green", Text: "Green Color" },
		{ Value: "blue", Text: "Blue Color" },
	];
	DropdownStructValue = "red";
	DropdownWideValue = "Option A";
	DropdownPaddedValue = "Normal";
	InputString = "";
	InputPassword = "";
	InputReal = 0;
	InputWithRibbon = "";
	InputPlaceholder = "";
	Color = new FORMS_Color(0xAA000000 | c_orange);
	ColorAccent = new FORMS_Color(0x5B9D00);
	ShowContextMenu = false;
	var _propsFolder = {
		Icon: FA_ESolid.FolderOpen,
		IconCollapsed: FA_ESolid.Folder,
		IconFont: FA_FntSolid12,
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
		var _style = forms_get_style();

		// Introduction
		Pen.start();
		Pen.text("FORMS Library - Comprehensive Controls Test").nl();
		Pen.text("This view demonstrates all available UI controls and their states.", { Muted: true }).nl();
		Pen.nl();

		// Text & Links Section
		if (Pen.section("Text & Links"))
		{
			Pen.text("Normal text").nl();
			Pen.text("Muted text", { Muted: true }).nl();
			Pen.text("Disabled text", { Disabled: true }).nl();

			if (Pen.link("Clickable link"))
			{
				show_debug_message("Link clicked!");
			}
			Pen.nl();

			if (Pen.link("Link with tooltip", { Tooltip: "This is a helpful tooltip!" }))
			{
				show_debug_message("Tooltip link clicked!");
			}
			Pen.nl();

			Pen.text("Long text that will be trimmed: ", { Trim: false });
			Pen.text("Lorem ipsum dolor sit amet consectetur adipiscing elit", { Trim: true, Tooltip: "Full text in tooltip" });
			Pen.nl();

			Pen.end_section();
		}

		// Buttons Section
		if (Pen.section("Buttons"))
		{
			// Normal button
			if (Pen.button("Normal Button", { Tooltip: "A standard button" }))
			{
				show_debug_message("Normal button clicked!");
			}
			Pen.space();

			// Active button
			if (Pen.button("Active Button", { Active: true, Tooltip: "This button is in active state" }))
			{
				show_debug_message("Active button clicked!");
			}
			Pen.space();

			// Disabled button
			Pen.button("Disabled Button", { Disabled: true, Tooltip: "This button is disabled" });
			Pen.nl();

			// Minimal buttons
			if (Pen.button("Minimal", { Minimal: true }))
			{
				show_debug_message("Minimal button clicked!");
			}
			Pen.space();

			if (Pen.button("Minimal Active", { Minimal: true, Active: true }))
			{
				show_debug_message("Minimal active button clicked!");
			}
			Pen.nl();

			// Button with custom width/padding
			if (Pen.button("Wide Button", { Width: 200, Padding: 16 }))
			{
				show_debug_message("Wide button clicked!");
			}
			Pen.nl();

			// Button that shows dialog
			if (Pen.button("Show Question Dialog"))
			{
				var _question = new FORMS_Question("You clicked the button!\n\nThis is a question dialog.", function (_button) {
					show_debug_message("Dialog button clicked: " + string(_button));
				});
				forms_get_root().add_child(_question);
			}
			Pen.nl();

			Pen.end_section();
		}

		// Checkboxes Section
		if (Pen.section("Checkboxes"))
		{
			// Basic checkbox
			if (Pen.checkbox(Checked1) | Pen.link(" Unchecked by default"))
			{
				Checked1 = !Checked1;
			}
			Pen.nl();

			// Checked by default
			_props = { Tooltip: "This checkbox has a tooltip!" };
			if (Pen.checkbox(Checked2, _props) | Pen.link(" Checked by default", _props))
			{
				Checked2 = !Checked2;
			}
			Pen.nl();

			// Checkbox with state indicator
			if (Pen.checkbox(Checked3))
			{
				Checked3 = !Checked3;
			}
			Pen.text(" State: " + (Checked3 ? "ON" : "OFF")).nl();

			Pen.end_section();
		}

		// Radio Buttons Section
		if (Pen.section("Radio Buttons"))
		{
			Pen.text("Select an option:", { Muted: true }).nl();

			if (Pen.radio(Radio == 0) | Pen.link(" Option 1: First choice"))
			{
				Radio = 0;
			}
			Pen.nl();

			if (Pen.radio(Radio == 1) | Pen.link(" Option 2: Second choice"))
			{
				Radio = 1;
			}
			Pen.nl();

			if (Pen.radio(Radio == 2) | Pen.link(" Option 3: Third choice"))
			{
				Radio = 2;
			}
			Pen.nl();

			if (Pen.radio(Radio == 3, { Tooltip: "Fourth option with tooltip" }) | Pen.link(" Option 4: Fourth choice"))
			{
				Radio = 3;
			}
			Pen.nl();

			Pen.text("Current selection: Option " + string(Radio + 1), { Muted: true }).nl();

			Pen.end_section();
		}

		// Sliders Section
		if (Pen.section("Sliders"))
		{
			// Integer slider with prefix/suffix
			if (Pen.slider("slider-int", Slider, -100, 100,
				{
					Pre: "Value: ",
					Post: "%",
					Integers: true,
					Tooltip: "Integer slider with prefix and suffix"
				}))
			{
				Slider = Pen.get_result();
			}
			Pen.nl();

			// Float slider without text
			if (Pen.slider("slider-float", SliderFloat, 0, 1,
				{
					ShowText: false,
					Tooltip: "Float slider 0.0 to 1.0"
				}))
			{
				SliderFloat = Pen.get_result();
			}
			Pen.text($" Float: {SliderFloat}").nl();

			// Disabled slider (visual only)
			Pen.text("Disabled slider:", { Muted: true }).nl();
			Pen.slider("slider-disabled", SliderDisabled, 0, 100, { Integers: true });
			Pen.nl();

			// Wide slider
			if (Pen.slider("slider-wide", SliderWide, 0, 100,
				{
					Width: 300,
					Pre: "Progress: ",
					Post: "%",
					Integers: true
				}))
			{
				SliderWide = Pen.get_result();
			}
			Pen.nl();

			Pen.end_section();
		}

		// Dropdowns Section
		if (Pen.section("Dropdowns"))
		{
			// Basic dropdown with string array
			if (Pen.dropdown("dropdown-basic", DropdownValue, DropdownValues))
			{
				DropdownValue = Pen.get_result();
			}
			Pen.text(" Basic dropdown: " + string(DropdownValue)).nl();

			// Dropdown with struct values (value + text)
			if (Pen.dropdown("dropdown-struct", DropdownStructValue, DropdownStructValues))
			{
				DropdownStructValue = Pen.get_result();
			}
			Pen.text(" Struct dropdown: " + string(DropdownStructValue)).nl();

			// Wide dropdown
			if (Pen.dropdown("dropdown-wide", DropdownWideValue, ["Option A", "Option B", "Option C"], { Width: 250 }))
			{
				DropdownWideValue = Pen.get_result();
			}
			Pen.nl();

			// Dropdown with custom padding
			if (Pen.dropdown("dropdown-padded", DropdownPaddedValue, ["Compact", "Normal", "Spacious"], { Padding: 8 }))
			{
				DropdownPaddedValue = Pen.get_result();
			}
			Pen.nl();

			Pen.end_section();
		}

		// Text Inputs Section
		if (Pen.section("Text Inputs"))
		{
			// String input with placeholder
			if (Pen.input("input-string", InputString, { Placeholder: "Enter some text..." }))
			{
				InputString = Pen.get_result();
			}
			Pen.text(" String input").nl();

			// Password input
			if (Pen.input("input-password", InputPassword, { Placeholder: "Enter password", Secret: true }))
			{
				InputPassword = Pen.get_result();
			}
			Pen.text(" Password (secret text)").nl();

			// Numeric input
			if (Pen.input("input-real", InputReal, { Tooltip: "Enter a number", Placeholder: "0.0" }))
			{
				InputReal = Pen.get_result();
			}
			Pen.text(" Numeric input: " + string(InputReal)).nl();

			// Input with ribbon (colored left border)
			if (Pen.input("input-ribbon", InputWithRibbon, { Ribbon: _style.Accent.get(), Placeholder: "Has accent ribbon" }))
			{
				InputWithRibbon = Pen.get_result();
			}
			Pen.text(" Input with ribbon").nl();

			// Placeholder demonstration
			if (Pen.input("input-placeholder", InputPlaceholder, { Placeholder: "This is a placeholder..." }))
			{
				InputPlaceholder = Pen.get_result();
			}
			Pen.text(" Placeholder text demo").nl();

			// Disabled input (visual only)
			Pen.input("input-disabled", "Disabled input", { Disabled: true });
			Pen.text(" Disabled state").nl();

			// Wide input
			if (Pen.input("input-wide", "Wide input field", { Width: 300 }))
			{
				// Value changed
			}
			Pen.nl();

			Pen.end_section();
		}

		// Color Inputs Section
		if (Pen.section("Color Inputs"))
		{
			// Standard color picker
			if (Pen.color("color-standard", Color))
			{
				Color = Pen.get_result();
			}
			Pen.text(" Standard color picker").nl();

			// Color with tooltip
			if (Pen.color("color-tooltip", ColorAccent, { Tooltip: "Click to change accent color" }))
			{
				ColorAccent = Pen.get_result();
			}
			Pen.text(" Accent color").nl();

			// Multiple color pickers in a row
			var _red = new FORMS_Color(c_red);
			var _green = new FORMS_Color(c_lime);
			var _blue = new FORMS_Color(c_blue);

			if (Pen.color("color-red", _red, { Width: 40 })) { _red = Pen.get_result(); }
			Pen.space();
			if (Pen.color("color-green", _green, { Width: 40 })) { _green = Pen.get_result(); }
			Pen.space();
			if (Pen.color("color-blue", _blue, { Width: 40 })) { _blue = Pen.get_result(); }
			Pen.text(" RGB palette").nl();

			// Disabled color picker
			Pen.color("color-disabled", new FORMS_Color(c_gray), { Disabled: true });
			Pen.text(" Disabled color").nl();

			Pen.end_section();
		}

		// Icons Section
		if (Pen.section("Icons"))
		{
			Pen.text("Font Awesome Icons:").nl();

			// Regular icons
			Pen.text("Regular: ", { Muted: true });
			if (Pen.icon_regular(FA_ERegular.AddressBook, { Width: 24, Tooltip: "Address Book" }))
			{
				show_debug_message("Address book icon clicked!");
			}
			Pen.space(0.5);
			Pen.icon_regular(FA_ERegular.Calendar, { Width: 24 });
			Pen.space(0.5);
			Pen.icon_regular(FA_ERegular.FileCode, { Width: 24 });
			Pen.nl();

			// Solid icons
			Pen.text("Solid: ", { Muted: true });
			if (Pen.icon_solid(FA_ESolid.House, { Width: 24, Tooltip: "Home" }))
			{
				show_debug_message("Home icon clicked!");
			}
			Pen.space(0.5);
			Pen.icon_solid(FA_ESolid.Gear, { Width: 24, Active: true, Tooltip: "Settings (Active)" });
			Pen.space(0.5);
			Pen.icon_solid(FA_ESolid.TruckFast, { Width: 24 });
			Pen.space(0.5);
			Pen.icon_solid(FA_ESolid.Heart, { Width: 24 });
			Pen.nl();

			// Brand icons
			Pen.text("Brands: ", { Muted: true });
			Pen.icon_brands(FA_EBrands.Github, { Width: 24, Tooltip: "GitHub" });
			Pen.space(0.5);
			Pen.icon_brands(FA_EBrands.Discord, { Width: 24 });
			Pen.space(0.5);
			Pen.icon_brands(FA_EBrands.Twitter, { Width: 24 });
			Pen.nl();

			// Icon states
			Pen.text("States: ", { Muted: true });
			Pen.icon_solid(FA_ESolid.Star, { Width: 24 });
			Pen.space(0.5);
			Pen.icon_solid(FA_ESolid.Star, { Width: 24, Muted: true, Tooltip: "Muted" });
			Pen.space(0.5);
			Pen.icon_solid(FA_ESolid.Star, { Width: 24, Disabled: true, Tooltip: "Disabled" });
			Pen.space(0.5);
			Pen.icon_solid(FA_ESolid.Star, { Width: 24, Active: true, Tooltip: "Active" });
			Pen.nl();

			// Different sizes
			Pen.text("Sizes: ", { Muted: true });
			Pen.icon_solid(FA_ESolid.Fire, { Width: 16 });
			Pen.space(0.5);
			Pen.icon_solid(FA_ESolid.Fire, { Width: 24 });
			Pen.space(0.5);
			Pen.icon_solid(FA_ESolid.Fire, { Width: 32 });
			Pen.space(0.5);
			Pen.icon_solid(FA_ESolid.Fire, { Width: 48 });
			Pen.nl();

			Pen.end_section();
		}

		// Sprites Section
		if (Pen.section("Sprites"))
		{
			Pen.text("Sprite buttons (clickable):", { Muted: true }).nl();

			// Use built-in sprites as examples
			if (Pen.sprite(FORMS_SprRound4, 0, { Width: 24, Height: 24, Tooltip: "Round sprite" }))
			{
				show_debug_message("Sprite clicked!");
			}
			Pen.space();

			if (Pen.sprite(FORMS_SprRound4, 0, { Width: 32, Height: 32, Active: true }))
			{
				show_debug_message("Active sprite clicked!");
			}
			Pen.space();

			Pen.sprite(FORMS_SprRound4, 0, { Width: 24, Height: 24, Disabled: true, Tooltip: "Disabled sprite" });
			Pen.nl();

			Pen.end_section();
		}

		// Separators Section
		if (Pen.section("Separators"))
		{
			Pen.text("Vertical separators:");
			Pen.space(2);
			Pen.vsep();
			Pen.space(2);
			Pen.text("Between");
			Pen.space(2);
			Pen.vsep({ Width: 32, Height: 20 });
			Pen.space(2);
			Pen.text("Elements");
			Pen.nl();

			Pen.end_section();
		}

		if (Pen.section("Trees"))
		{
			Tree.draw(Pen);
			Pen.end_section();
		}

		// Layout Modes Section
		if (Pen.section("Layout Modes"))
		{
			Pen.text("Column2 layout (auto 2-column):", { Muted: true }).nl();

			Pen.set_layout(FORMS_EPenLayout.Column2);

			Pen.text("Label 1:");
			Pen.next();
			Pen.text("Value 1");
			Pen.next();

			Pen.text("Label 2:");
			Pen.next();
			Pen.text("Value 2");
			Pen.next();

			Pen.text("Label 3:");
			Pen.next();
			Pen.text("Value 3");
			Pen.next();

			Pen.set_layout(FORMS_EPenLayout.Horizontal);
			Pen.nl();

			Pen.text("Vertical layout (auto newline):", { Muted: true }).nl();
			Pen.AutoNewline = true;
			Pen.text("Item 1");
			Pen.text("Item 2");
			Pen.text("Item 3");
			Pen.AutoNewline = false;

			Pen.end_section();
		}

		// Nested Sections
		if (Pen.section("Nested Sections"))
		{
			Pen.text("Sections can be nested infinitely").nl();

			if (Pen.section("Level 1"))
			{
				Pen.text("First level content").nl();

				if (Pen.section("Level 2a"))
				{
					Pen.text("Second level content A").nl();

					if (Pen.section("Level 3"))
					{
						Pen.text("Third level content").nl();
						Pen.end_section();
					}

					Pen.end_section();
				}

				if (Pen.section("Level 2b"))
				{
					Pen.text("Second level content B").nl();
					Pen.end_section();
				}

				Pen.end_section();
			}

			if (Pen.section("Collapsed by Default", { Collapsed: true }))
			{
				Pen.text("This section starts collapsed!").nl();
				Pen.end_section();
			}

			Pen.end_section();
		}

		// Style Colors Showcase
		if (Pen.section("Style Colors"))
		{
			Pen.text("Semantic colors from theme:", { Muted: true }).nl();

			// Draw color swatches
			draw_sprite_stretched_ext(FORMS_SprRound4, 0, Pen.X, Pen.Y, 16, 16, _style.Accent.get(), 1.0);
			Pen.space(5);
			Pen.text("Accent").nl();

			draw_sprite_stretched_ext(FORMS_SprRound4, 0, Pen.X, Pen.Y, 16, 16, _style.Focus.get(), 1.0);
			Pen.space(5);
			Pen.text("Focus").nl();

			draw_sprite_stretched_ext(FORMS_SprRound4, 0, Pen.X, Pen.Y, 16, 16, _style.Link.get(), 1.0);
			Pen.space(5);
			Pen.text("Link").nl();

			draw_sprite_stretched_ext(FORMS_SprRound4, 0, Pen.X, Pen.Y, 16, 16, _style.Error.get(), 1.0);
			Pen.space(5);
			Pen.text("Error").nl();

			draw_sprite_stretched_ext(FORMS_SprRound4, 0, Pen.X, Pen.Y, 16, 16, _style.Warning.get(), 1.0);
			Pen.space(5);
			Pen.text("Warning").nl();

			draw_sprite_stretched_ext(FORMS_SprRound4, 0, Pen.X, Pen.Y, 16, 16, _style.Success.get(), 1.0);
			Pen.space(5);
			Pen.text("Success").nl();

			draw_sprite_stretched_ext(FORMS_SprRound4, 0, Pen.X, Pen.Y, 16, 16, _style.Info.get(), 1.0);
			Pen.space(5);
			Pen.text("Info").nl();

			draw_sprite_stretched_ext(FORMS_SprRound4, 0, Pen.X, Pen.Y, 16, 16, _style.Highlight.get(), 1.0);
			Pen.space(5);
			Pen.text("Highlight").nl();

			Pen.text("Background levels:", { Muted: true }).nl();
			for (var i = 0; i < array_length(_style.Background); ++i)
			{
				draw_sprite_stretched_ext(FORMS_SprRound4, 0, Pen.X, Pen.Y, 16, 16, _style.Background[i].get(), 1.0);
				Pen.space(5);
				Pen.text($"Level {i}");
				if (i < array_length(_style.Background) - 1) Pen.space(2);
			}
			Pen.nl();

			Pen.end_section();
		}

		// Context Menu Example
		if (Pen.section("Context Menus"))
		{
			if (Pen.button("Show Context Menu"))
			{
				var _options = [];

				var _opt1 = new FORMS_ContextMenuOption("Copy");
				_opt1.Icon = FA_ESolid.Copy;
				_opt1.KeyboardShortcut = new FORMS_KeyboardShortcut([vk_control, ord("C")]);
				_opt1.Action = function() { show_debug_message("Copy clicked!"); };
				array_push(_options, _opt1);

				var _opt2 = new FORMS_ContextMenuOption("Paste");
				_opt2.Icon = FA_ESolid.Paste;
				_opt2.KeyboardShortcut = new FORMS_KeyboardShortcut([vk_control, ord("V")]);
				_opt2.Action = function() { show_debug_message("Paste clicked!"); };
				array_push(_options, _opt2);

				array_push(_options, new FORMS_ContextMenuSeparator()); // Separator

				var _opt3 = new FORMS_ContextMenuOption("Delete");
				_opt3.Icon = FA_ESolid.Trash;
				_opt3.KeyboardShortcut = new FORMS_KeyboardShortcut([vk_delete]);
				_opt3.Action = function() { show_debug_message("Delete clicked!"); };
				array_push(_options, _opt3);

				var _contextMenu = new FORMS_ContextMenu(_options, {
					X: window_mouse_get_x(),
					Y: window_mouse_get_y(),
				});
				forms_get_root().add_child(_contextMenu);
			}
			Pen.nl();

			Pen.text("Right-click context menus can be triggered on widgets", { Muted: true }).nl();

			Pen.end_section();
		}

		// Tooltips Showcase
		if (Pen.section("Tooltips"))
		{
			Pen.text("Hover over elements to see tooltips:", { Muted: true }).nl();

			Pen.text("Tooltip text", { Tooltip: "This is a basic tooltip!" });
			Pen.space(2);
			Pen.icon_solid(FA_ESolid.Info, { Tooltip: "Icon with tooltip", Width: 20 });
			Pen.space(2);
			if (Pen.button("Button", { Tooltip: "Button tooltip appears on hover" })) {}
			Pen.nl();

			Pen.end_section();
		}

		// Keyboard Shortcuts
		if (Pen.section("Keyboard Shortcuts"))
		{
			Pen.text("Example keyboard shortcuts:", { Muted: true }).nl();

			var _shortcut1 = new FORMS_KeyboardShortcut([vk_control, ord("S")]);
			Pen.text("Save: ");
			Pen.text(_shortcut1.to_string(), { Muted: true });
			Pen.nl();

			var _shortcut2 = new FORMS_KeyboardShortcut([vk_control, vk_shift, ord("P")]);
			Pen.text("Command Palette: ");
			Pen.text(_shortcut2.to_string(), { Muted: true });
			Pen.nl();

			var _shortcut3 = new FORMS_KeyboardShortcut([vk_f5]);
			Pen.text("Run: ");
			Pen.text(_shortcut3.to_string(), { Muted: true });
			Pen.nl();

			var _shortcut4 = new FORMS_KeyboardShortcut([vk_alt, vk_f4]);
			Pen.text("Exit: ");
			Pen.text(_shortcut4.to_string(), { Muted: true });
			Pen.nl();

			var _shortcut5 = new FORMS_KeyboardShortcut([vk_control, ord("Z")]);
			Pen.text("Undo: ");
			Pen.text(_shortcut5.to_string(), { Muted: true });
			Pen.nl();

			Pen.end_section();
		}

		Pen.finish();

		FORMS_CONTENT_UPDATE_SIZE;

		return self;
	}
}
