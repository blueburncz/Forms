global.testPreferencesWindow = new TestPreferencesWindow();

function TestPreferencesWindow(): FORMS_Window() constructor
{
	Width.from_string("600px");
	Height.from_string("400px");
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

					Pen.text("Accent");
					Pen.next();
					if (Pen.color("color-accent", _style.Accent))
					{
						_style.Accent = Pen.get_result();
					}
					Pen.next();

					Pen.text("Text");
					Pen.next();
					if (Pen.color("color-text", _style.Text))
					{
						_style.Text = Pen.get_result();
					}
					Pen.next();

					Pen.text("Muted Text");
					Pen.next();
					if (Pen.color("color-text-muted", _style.TextMuted))
					{
						_style.TextMuted = Pen.get_result();
					}
					Pen.next();

					Pen.text("Disabled Text");
					Pen.next();
					if (Pen.color("color-text-disabled", _style.TextDisabled))
					{
						_style.TextDisabled = Pen.get_result();
					}
					Pen.next();

					for (var i = 0; i < array_length(_style.Background); ++i)
					{
						Pen.text($"Background {i + 1}");
						Pen.next();
						if (Pen.color($"color-background-{i}", _style.Background[i]))
						{
							_style.Background[@ i] = Pen.get_result();
						}
						Pen.next();
					}

					Pen.text("Scrollbar");
					Pen.next();
					if (Pen.color("color-scrollbar", _style.Scrollbar))
					{
						_style.Scrollbar = Pen.get_result();
					}
					Pen.next();

					Pen.text("Scrollbar Hover");
					Pen.next();
					if (Pen.color("color-scrollbar-hover", _style.ScrollbarHover))
					{
						_style.ScrollbarHover = Pen.get_result();
					}
					Pen.next();

					Pen.text("Scrollbar Active");
					Pen.next();
					if (Pen.color("color-scrollbar-active", _style.ScrollbarActive))
					{
						_style.ScrollbarActive = Pen.get_result();
					}
					Pen.next();

					Pen.text("Shadow");
					Pen.next();
					if (Pen.color("color-shadow", _style.Shadow))
					{
						_style.Shadow = Pen.get_result();
					}
					Pen.next();

					Pen.text("Tooltip");
					Pen.next();
					if (Pen.color("color-tooltip", _style.Tooltip))
					{
						_style.Tooltip = Pen.get_result();
					}
					Pen.next();

					Pen.text("Tooltip Text");
					Pen.next();
					if (Pen.color("color-tooltip-text", _style.TooltipText))
					{
						_style.TooltipText = Pen.get_result();
					}
					Pen.next();

					Pen.text("Highlight");
					Pen.next();
					if (Pen.color("color-highlight", _style.Highlight))
					{
						_style.Highlight = Pen.get_result();
					}
					Pen.next();

					Pen.text("Border");
					Pen.next();
					if (Pen.color("color-border", _style.Border))
					{
						_style.Border = Pen.get_result();
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
		__window = undefined;

		static draw_content = function ()
		{
			Pen.start();

			if (Pen.button("Apply"))
			{
				__window ??= find_parent_type(TestPreferencesWindow);
				if (__window.DestroyOnClose)
				{
					__window.destroy_later();
				}
				else
				{
					__window.remove_self();
				}
			}

			if (Pen.button("Cancel"))
			{
				// TODO: Discard changes and close preferences window
			}

			Pen.finish();
			FORMS_CONTENT_UPDATE_SIZE;
			return self;
		}
	})();
	_flexBox.add_child(_container);
}
