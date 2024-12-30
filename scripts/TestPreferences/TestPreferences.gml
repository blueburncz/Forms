global.testPreferencesWindow = new TestPreferencesWindow();

function TestPreferencesWindow(): FORMS_Window() constructor
{
	Center = true;
	DestroyOnClose = false;

	var _flexBox = new FORMS_FlexBox({ Name: "Preferences", Icon: FA_ESolid.Gear, IsHorizontal: false });
	set_widget(_flexBox);

	var _dock = new FORMS_Dock({ Width: "100%", Flex: 1 });
	_flexBox.add_child(_dock);

	_dock.split_left(0.3);

	with(_dock.get_first())
	{
		ShowTabs = false;
		set_tabs([
			new(function (): FORMS_ScrollPane() constructor
			{
				Pen.PaddingX = 0;
				static draw_content = function ()
				{
					Pen.start();
					Pen.tree_item("UI Style", { Selected: true });
					Pen.finish();
					FORMS_CONTENT_UPDATE_SIZE;
					return self;
				}
			})()
		]);
	}

	with(_dock.get_second())
	{
		ShowTabs = false;
		set_tabs([
			new(function (): FORMS_ScrollPane() constructor
			{
				static draw_content = function ()
				{
					var _style = forms_get_style();
					Pen.start(FORMS_EPenLayout.Column2);

					Pen.text("Accent Color");
					Pen.next();
					if (Pen.color("input-accent-color", new FORMS_Color(0xFF000000 | _style
							.Accent)))
					{
						_style.Accent = Pen.get_result().get();
					}
					Pen.next();

					Pen.text("Text Color");
					Pen.next();
					if (Pen.color("input-text-color", new FORMS_Color(0xFF000000 | _style
							.Text)))
					{
						_style.Text = Pen.get_result().get();
					}
					Pen.next();

					Pen.text("Muted Text Color");
					Pen.next();
					if (Pen.color("input-text-muted-color", new FORMS_Color(0xFF000000 | _style
							.TextMuted)))
					{
						_style.TextMuted = Pen.get_result().get();
					}
					Pen.next();

					Pen.text("Disabled Text Color");
					Pen.next();
					if (Pen.color("input-text-disabled-color", new FORMS_Color(0xFF000000
							| _style.TextDisabled)))
					{
						_style.TextDisabled = Pen.get_result().get();
					}
					Pen.next();

					for (var i = 0; i < array_length(_style.Background); ++i)
					{
						Pen.text($"Background Color {i + 1}");
						Pen.next();
						if (Pen.color($"input-background-color-{i}", new FORMS_Color(0xFF000000
								| _style.Background[i])))
						{
							_style.Background[@ i] = Pen.get_result().get();
						}
						Pen.next();
					}

					Pen.text("Scrollbar");
					Pen.next();
					if (Pen.color("Scrollbar", new FORMS_Color(0xFF000000 | _style.Scrollbar)))
					{
						_style.Scrollbar = Pen.get_result().get();
					}
					Pen.next();

					Pen.text("ScrollbarHover");
					Pen.next();
					if (Pen.color("ScrollbarHover", new FORMS_Color(0xFF000000 | _style
							.ScrollbarHover)))
					{
						_style.ScrollbarHover = Pen.get_result().get();
					}
					Pen.next();

					Pen.text("ScrollbarActive");
					Pen.next();
					if (Pen.color("ScrollbarActive", new FORMS_Color(0xFF000000 | _style
							.ScrollbarActive)))
					{
						_style.ScrollbarActive = Pen.get_result().get();
					}
					Pen.next();

					Pen.text("Shadow");
					Pen.next();
					if (Pen.color("Shadow", new FORMS_Color(0xFF000000 | _style.Shadow)))
					{
						_style.Shadow = Pen.get_result().get();
					}
					Pen.next();

					Pen.text("ShadowAlpha");
					Pen.next();
					if (Pen.color("ShadowAlpha", new FORMS_Color(0xFF000000 | _style
							.ShadowAlpha)))
					{
						_style.ShadowAlpha = Pen.get_result().get();
					}
					Pen.next();

					Pen.text("Tooltip");
					Pen.next();
					if (Pen.color("Tooltip", new FORMS_Color(0xFF000000 | _style.Tooltip)))
					{
						_style.Tooltip = Pen.get_result().get();
					}
					Pen.next();

					Pen.text("TooltipText");
					Pen.next();
					if (Pen.color("TooltipText", new FORMS_Color(0xFF000000 | _style
							.TooltipText)))
					{
						_style.TooltipText = Pen.get_result().get();
					}
					Pen.next();

					Pen.text("Highlight");
					Pen.next();
					if (Pen.color("Highlight", new FORMS_Color(0xFF000000 | _style.Highlight)))
					{
						_style.Highlight = Pen.get_result().get();
					}
					Pen.next();

					Pen.text("Border");
					Pen.next();
					if (Pen.color("Border", new FORMS_Color(0xFF000000 | _style.Border)))
					{
						_style.Border = Pen.get_result().get();
					}
					Pen.next();

					Pen.finish();
					FORMS_CONTENT_UPDATE_SIZE;
					return self;
				}
			})()
		]);
	}

	var _container = new(function (): FORMS_Container() constructor
	{
		Width.from_string("100%");
		Height.from_string("32px");
		Pen.SpacingX = 4;

		static draw_content = function ()
		{
			Pen.start();
			if (Pen.button("Apply")) {}
			if (Pen.button("Cancel")) {}
			Pen.finish();
			FORMS_CONTENT_UPDATE_SIZE;
			return self;
		}
	})();
	_flexBox.add_child(_container);
}
