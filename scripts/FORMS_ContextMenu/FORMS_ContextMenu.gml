/// @func FORMS_ContextMenuItem()
///
/// @desc Base struct for context menu items.
///
/// @see FORMS_ContextMenu
function FORMS_ContextMenuItem() constructor {}

/// @func FORMS_ContextMenuSeparator()
///
/// @extends FORMS_ContextMenuItem
///
/// @desc A separator used to divide context menus into categories. Displayed
/// as a horizontal line.
///
/// @see FORMS_ContextMenu
function FORMS_ContextMenuSeparator(): FORMS_ContextMenuItem() constructor {}

/// @func FORMS_ContextMenuOptionProps()
///
/// @desc Properties accepted by the constructor of
/// {@link FORMS_ContextMenuOption}.
function FORMS_ContextMenuOptionProps() constructor
{
	/// @var {String} The option's text.
	Text = "";

	/// @var {String, Undefined} The tooltip displayed on mouse-over.
	Tooltip = undefined;

	/// @var {Function, Undefined} A function executed when the option is
	/// clicked.
	Action = undefined;

	/// @var {Array, Undefined} An array of arguments passed to `Action` when
	/// the option is clicked.
	Arguments = undefined;

	// TODO: Implement context menu icons
	Icon = undefined;

	IconFont = undefined;

	/// @var {Bool, Undefined} Whether the option is disabled (`true`) or
	/// enabled (`false`).
	Disabled = undefined;

	/// @var {Array<Struct.FORMS_ContextMenuItem>, Undefined} An array of
	/// sub-options opened on mouse-over.
	Options = undefined;

	/// @var {Struct.FORMS_KeyboardShortcut, Undefined} A keyboard shortcut
	/// drawn next to the option.
	KeyboardShortcut = undefined;
}

/// @func FORMS_ContextMenuOption(_textOrProps)
///
/// @extends FORMS_ContextMenuItem
///
/// @desc An option in a context menu.
///
/// @param {String, Struct.FORMS_ContextMenuOptionProps} _textOrProps Either
/// text (the name of the option) or properties to create the context menu
/// option with.
///
/// @see FORMS_ContextMenu
function FORMS_ContextMenuOption(_textOrProps): FORMS_ContextMenuItem() constructor
{
	var _isProps = is_struct(_textOrProps);

	/// @var {String} The option's text.
	Text = _isProps ? _textOrProps.Text : _textOrProps;

	/// @var {String} The tooltip displayed on mouse-over. Defaults to an empty
	/// string.
	Tooltip = (_isProps ? forms_get_prop(_textOrProps, "Tooltip") : undefined) ?? "";

	/// @var {Function, Undefined} A function executed when the option is
	/// clicked or `undefined` (default).
	Action = (_isProps ? forms_get_prop(_textOrProps, "Action") : undefined);

	/// @var {Array, Undefined} An array of arguments passed to `Action` when
	/// the option is clicked or `undefined` (no arguments, default).
	Arguments = (_isProps ? forms_get_prop(_textOrProps, "Arguments") : undefined);

	// TODO: Implement context menu icons
	Icon = undefined;

	IconFont = FA_FntRegular12;

	/// @var {Bool} Whether the option is disabled (`true`) or enabled (`false`).
	/// Defaults to `false`.
	Disabled = (_isProps ? forms_get_prop(_textOrProps, "Disabled") : undefined) ?? false;

	/// @var {Array<Struct.FORMS_ContextMenuItem>, Undefined} An array of
	/// sub-options opened on mouse-over or `undefined` (default).
	Options = (_isProps ? forms_get_prop(_textOrProps, "Options") : undefined);

	/// @var {Struct.FORMS_KeyboardShortcut, Undefined} A keyboard shortcut
	/// drawn next to the option or `undefined` (default).
	KeyboardShortcut = (_isProps ? forms_get_prop(_textOrProps, "KeyboardShortcut") : undefined);

	/// @func add_option(_option)
	///
	/// @desc Adds a sub-option. These are displayed in another context menu
	/// on mouse-over.
	///
	/// @param {Struct.FORMS_ContextMenuItem} _option The option to add.
	///
	/// @return {Struct.FORMS_ContextMenuItem} Returns `self`.
	static add_option = function (_option)
	{
		Options ??= [];
		array_push(Options, _option);
		return self;
	}
}

/// @func FORMS_ContextMenuProps()
///
/// @extends FORMS_ContainerProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_ContextMenu}.
function FORMS_ContextMenuProps(): FORMS_ContainerProps() constructor {}

/// @func FORMS_ContextMenu([_options[, _props]])
///
/// @extends FORMS_Container
///
/// @desc A context menu with support for unlimited sub-menus. Its position is
/// automatically adjusted to be always visible inside the window.
///
/// @param {Array<Struct.FORMS_ContextMenuItem>} [_options] An array of context
/// menu options.
/// @param {Struct.FORMS_ContextMenuProps, Undefined} [_props] Properties to
/// create the context menu with or `undefined` (default).
function FORMS_ContextMenu(_options = [], _props = undefined): FORMS_Container(_props) constructor
{
	static Container_layout = layout;
	static Container_update = update;
	static Container_draw = draw;
	static Container_destroy = destroy;

	/// @var {Array<Struct.FORMS_ContextMenuItem>} An array of context menu
	/// options.
	Options = _options;

	/// @var {Bool} Whether the context menu should close on mouse leave.
	/// Defaults to `false`.
	CloseOnMouseLeave = false;

	/// @var {Struct.FORMS_ContextMenu, Undefined}
	/// @private
	__parentMenu = undefined;

	/// @var {Struct.FORMS_ContextMenu, Undefined}
	/// @private
	__submenu = undefined;

	/// @var {Real}
	/// @private
	__submenuIndex = -1;

	/// @var {Asset.GMSprite} The background sprite of the context menu,
	/// stretched over its entire size. Defaults to `FORMS_SprRound8`.
	BackgroundSprite = forms_get_prop(_props, "BackgroundSprite") ?? FORMS_SprRound8;

	/// @var {Constant.Color} The tint color of the background sprite. Defaults
	/// to `0x101010`.
	BackgroundColor = forms_get_prop(_props, "BackgroundColor") ?? 0x101010;

	/// @var {Bool} If `true` then the size of the context menu is recomputed
	/// from its contents the next time method
	/// [layout](./FORMS_Widget.layout.html) is called. Defaults to `true`.
	ContentFit = true;

	static draw_content = function ()
	{
		var _options = Options;
		var _select = undefined;

		var _widthText = 0;
		var _widthShortcut = 0;

		for (var i = 0; i < array_length(_options); ++i)
		{
			var _option = _options[i];

			if (is_instanceof(_option, FORMS_ContextMenuOption))
			{
				_widthText = max(string_width(_option.Text), _widthText);

				if (_option.Options != undefined)
				{
					_widthShortcut = max(24, _widthShortcut);
				}
				else if (_option.KeyboardShortcut != undefined)
				{
					_widthShortcut = max(string_width(_option.KeyboardShortcut.to_string()), _widthShortcut);
				}
			}
		}

		var _widthMax = _widthText + ((_widthShortcut > 0) ? 16 : 0) + _widthShortcut;

		var _x = 8;
		var _y = 8;
		var _lineHeight = string_height("M");

		for (var i = 0; i < array_length(_options); ++i)
		{
			var _option = _options[i];

			if (is_instanceof(_option, FORMS_ContextMenuSeparator))
			{
				var _height = floor(_lineHeight * 0.5);
				forms_draw_rectangle(_x, _y + floor((_height - 1) * 0.5), _widthMax, 1, c_silver, 0.2);
				_y += _height;
			}
			else
			{
				var _optionText = _option.Text;
				var _optionShortcut = _option.KeyboardShortcut;
				var _optionOptions = _option.Options;
				var _mouseOver = Pen.is_mouse_over(_x, _y, _widthMax, _lineHeight);

				if (_mouseOver || __submenuIndex == i)
				{
					draw_sprite_stretched_ext(FORMS_SprRound4, 0, _x, _y, _widthMax, _lineHeight, c_white, 0.3);
				}

				if (_mouseOver)
				{
					if (forms_mouse_check_button_pressed(mb_left))
					{
						_select = _option;
					}

					if (__submenu != undefined
						&& __submenuIndex != i)
					{
						__submenu.destroy_later();
						__submenu = undefined;
						__submenuIndex = -1;
					}

					if (__submenu == undefined
						&& _optionOptions != undefined)
					{
						var _submenu = new FORMS_ContextMenu(_optionOptions,
						{
							X: _x,
							Y: __realY + _y,
						});
						forms_get_root().add_child(_submenu);
						_submenu.__parentMenu = self;
						__submenu = _submenu;
						__submenuIndex = i;
					}

					forms_set_cursor(cr_handpoint);
				}

				draw_text(_x, _y, _optionText);

				if (_optionOptions != undefined)
				{
					draw_set_halign(fa_right);
					fa_draw(FA_FntSolid12, FA_ESolid.AngleRight, _x + _widthMax, _y, c_silver);
					draw_set_halign(fa_left);
				}
				else if (_optionShortcut != undefined)
				{
					draw_set_halign(fa_right);
					draw_text_color(_x + _widthMax, _y, _optionShortcut.to_string(),
						c_silver, c_silver, c_silver, c_silver, 1.0);
					draw_set_halign(fa_left);
				}

				_y += _lineHeight;
			}
		}

		if (_select != undefined)
		{
			if (_select.Action != undefined)
			{
				if (_select.Arguments != undefined)
				{
					script_execute_ext(_select.Action, _select.Arguments);
				}
				else
				{
					_select.Action();
				}
			}
			destroy_later();
		}

		ContentWidth = _x + _widthMax + 8;
		ContentHeight = _y + 8;
		return self;
	}

	static layout = function ()
	{
		if (__realWidth == 0) //run initial positioning
		{
			Container_layout(); //run first to determine menu size
			if (__parentMenu != undefined)
			{
				//Check if parent menu has parent menu and check if its on the left
				if (__parentMenu.__parentMenu != undefined) && (__parentMenu.__realX < __parentMenu.__parentMenu
					.__realX)
				{
					X.Value = __parentMenu.__realX - __realWidth - 2;
				}
				else
				{
					var _parentMenuRightX = __parentMenu.__realX + __parentMenu.__realWidth + 2;
					if ((window_get_width() - _parentMenuRightX) < __realWidth)
					{
						X.Value = __parentMenu.__realX - __realWidth - 2;
					}
					else
					{
						X.Value = _parentMenuRightX;
					}
				}
				__realX = floor(Parent.__realX + X.get_absolute());
			}
		}

		__realX = clamp(__realX, 0, window_get_width() - __realWidth);
		__realY = clamp(__realY, 0, window_get_height() - __realHeight);
		Container_layout();
		return self;
	}

	static update = function (_deltaTime)
	{
		Container_update(_deltaTime);
		if (keyboard_check_pressed(vk_escape)
			|| (!is_mouse_over() && mouse_check_button_pressed(mb_any)))
		{
			destroy_later();
		}
		return self;
	}

	static draw = function ()
	{
		var _shadowOffset = 16;
		draw_sprite_stretched_ext(
			FORMS_SprShadow, 0,
			__realX - _shadowOffset,
			__realY - _shadowOffset,
			__realWidth + _shadowOffset * 2,
			__realHeight + _shadowOffset * 2,
			c_black, 0.5);

		Container_draw();

		return self;
	}

	static destroy = function ()
	{
		if (__submenu != undefined)
		{
			if (__submenu.has_parent())
			{
				__submenu.remove_self();
			}
			__submenu.destroy();
			__submenu = undefined;
		}
		Container_destroy();
		return undefined;
	}
}
