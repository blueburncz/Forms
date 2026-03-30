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

					// ========================================
					// Accent & Interactive Colors
					// ========================================

					Pen.text("Accent");
					Pen.next();
					if (Pen.color("color-accent", _style.Accent))
					{
						_style.Accent = Pen.get_result();
					}
					Pen.next();

					Pen.text("Focus");
					Pen.next();
					if (Pen.color("color-focus", _style.Focus))
					{
						_style.Focus = Pen.get_result();
					}
					Pen.next();

					// ========================================
					// Text Colors
					// ========================================

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

					Pen.text("Link");
					Pen.next();
					if (Pen.color("color-link", _style.Link))
					{
						_style.Link = Pen.get_result();
					}
					Pen.next();

					Pen.text("Error");
					Pen.next();
					if (Pen.color("color-error", _style.Error))
					{
						_style.Error = Pen.get_result();
					}
					Pen.next();

					Pen.text("Warning");
					Pen.next();
					if (Pen.color("color-warning", _style.Warning))
					{
						_style.Warning = Pen.get_result();
					}
					Pen.next();

					Pen.text("Success");
					Pen.next();
					if (Pen.color("color-success", _style.Success))
					{
						_style.Success = Pen.get_result();
					}
					Pen.next();

					Pen.text("Info");
					Pen.next();
					if (Pen.color("color-info", _style.Info))
					{
						_style.Info = Pen.get_result();
					}
					Pen.next();

					// ========================================
					// Background Colors
					// ========================================

					for (var i = 0; i < array_length(_style.Background); ++i)
					{
						Pen.text($"Background [{i}]");
						Pen.next();
						if (Pen.color($"color-background-{i}", _style.Background[i]))
						{
							_style.Background[@ i] = Pen.get_result();
						}
						Pen.next();
					}

					// ========================================
					// Scrollbar
					// ========================================

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

					Pen.text("Scrollbar Size Min");
					Pen.next();
					if (Pen.slider("scrollbar-size-min", _style.ScrollbarSizeMin, 16,
							128, { ShowText: true, Post: "px", Integers: true }))
					{
						_style.ScrollbarSizeMin = Pen.get_result();
					}
					Pen.next();

					// ========================================
					// Shadows & Overlays
					// ========================================

					Pen.text("Shadow");
					Pen.next();
					if (Pen.color("color-shadow", _style.Shadow))
					{
						_style.Shadow = Pen.get_result();
					}
					Pen.next();

					Pen.text("Modal Overlay");
					Pen.next();
					if (Pen.color("color-modal-overlay", _style.ModalOverlay))
					{
						_style.ModalOverlay = Pen.get_result();
					}
					Pen.next();

					// ========================================
					// Tooltips
					// ========================================

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

					// ========================================
					// Selection & Borders
					// ========================================

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

					// ========================================
					// Spacing & Layout
					// ========================================

					Pen.text("Splitter Size");
					Pen.next();
					if (Pen.slider("splitter-size", _style.SplitterSize, 2,
							16, { ShowText: true, Post: "px", Integers: true }))
					{
						_style.SplitterSize = Pen.get_result();
					}
					Pen.next();

					Pen.text("Padding");
					Pen.next();
					if (Pen.slider("padding", _style.Padding, 0, 32,
						{
							ShowText: true,
							Post: "px",
							Integers: true
						}))
					{
						_style.Padding = Pen.get_result();
					}
					Pen.next();

					Pen.text("Spacing");
					Pen.next();
					if (Pen.slider("spacing", _style.Spacing, 0, 16,
						{
							ShowText: true,
							Post: "px",
							Integers: true
						}))
					{
						_style.Spacing = Pen.get_result();
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
