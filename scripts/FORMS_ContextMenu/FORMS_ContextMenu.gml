/// @func FORMS_ContextMenuItem()
///
/// @desc
function FORMS_ContextMenuItem() constructor
{
}

/// @func FORMS_ContextMenuSeparator()
///
/// @extends FORMS_ContextMenuItem()
///
/// @desc
function FORMS_ContextMenuSeparator()
	: FORMS_ContextMenuItem() constructor
{
}

/// @func FORMS_ContextMenuOption(_text)
///
/// @extends FORMS_ContextMenuItem()
///
/// @desc
///
/// @param {String} _text
function FORMS_ContextMenuOption(_text)
	: FORMS_ContextMenuItem() constructor
{
	/// @var {String}
	Text = _text;

	/// @var {String}
	Tooltip = "";

	/// @var {Function, Undefined}
	Action = undefined;

	/// @var {Array, Undefined}
	Arguments = undefined;

	// TODO: Context menu icons
	Icon = undefined;

	/// @var {Bool}
	Disabled = false;

	/// @var {Array<Struct.FORMS_ContextMenuItem>, Undefined}
	Options = undefined;

	/// @var {Struct.FORMS_KeyboardShortcut, Undefined}
	KeyboardShortcut = undefined;

	/// @func add_option(_option)
	///
	/// @desc
	///
	/// @param {Struct.FORMS_ContextMenuItem} _option
	///
	/// @return {Struct.FORMS_ContextMenuItem} Returns `self`.
	static add_option = function (_option)
	{
		Options ??= [];
		array_push(Options, _option);
		return self;
	};
}

/// @func FORMS_ContextMenuProps()
///
/// @extends FORMS_ContainerProps
///
/// @desc
function FORMS_ContextMenuProps()
	: FORMS_ContainerProps() constructor
{
}

/// @func FORMS_ContextMenu([_options[, _props]])
///
/// @extends FORMS_Container
///
/// @desc
///
/// @param {Array<Struct.FORMS_ContextMenuItem>} [_options]
/// @param {Struct.FORMS_ContextMenuProps, Undefined} [_props]
function FORMS_ContextMenu(_options=[], _props=undefined)
	: FORMS_Container(undefined, _props) constructor
{
	static Container_layout = layout;
	static Container_update = update;
	static Container_draw = draw;
	static Container_destroy = destroy;

	BackgroundSprite = forms_get_prop(_props, "BackgroundSprite") ?? FORMS_SprRound8;

	BackgroundColor = forms_get_prop(_props, "BackgroundColor") ?? 0x202020;

	/// @var {Array<Struct.FORMS_ContextMenuItem>}
	Options = _options;

	/// @var {Bool}
	CloseOnMouseLeave = false;

	/// @var {Struct.FORMS_ContextMenu, Undefined}
	/// @private
	__submenu = undefined;

	/// @var {Real}
	/// @private
	__submenuIndex = -1;

	ContentFit = true;

	{
		set_content(new FORMS_ContextMenuContent());
	}

	static layout = function ()
	{
		__realX = clamp(__realX, 0, window_get_width() - __realWidth);
		__realY = clamp(__realY, 0, window_get_height() - __realHeight);
		Container_layout();
		return self;
	};

	static update = function (_deltaTime)
	{
		Container_update(_deltaTime);
		if (keyboard_check_pressed(vk_escape)
			|| (!is_mouse_over() && mouse_check_button_pressed(mb_any)))
		{
			destroy_later();
		}
		return self;
	};

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
	};

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
	};
}

/// @func FORMS_ContextMenuContent()
///
/// @extends FORMS_Content
///
/// @desc
function FORMS_ContextMenuContent()
	: FORMS_Content() constructor
{
	static draw = function ()
	{
		var _options = Container.Options;
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
					_widthShortcut = max(string_width(">"), _widthShortcut);
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

				if (_mouseOver || Container.__submenuIndex == i)
				{
					draw_sprite_stretched_ext(FORMS_SprRound4, 0, _x, _y, _widthMax, _lineHeight, c_white, 0.3);
				}

				if (_mouseOver)
				{
					if (forms_mouse_check_button_pressed(mb_left))
					{
						_select = _option;
					}

					if (Container.__submenu != undefined
						&& Container.__submenuIndex != i)
					{
						Container.__submenu.destroy_later();
						Container.__submenu = undefined;
						Container.__submenuIndex = -1;
					}

					if (Container.__submenu == undefined
						&& _optionOptions != undefined)
					{
						var _submenu = new FORMS_ContextMenu(_optionOptions, {
							X: Container.__realX + _x + _widthMax + 8,
							Y: Container.__realY + _y,
						});
						forms_get_root().add_child(_submenu);
						Container.__submenu = _submenu;
						Container.__submenuIndex = i;
					}

					forms_set_cursor(cr_handpoint);
				}

				draw_text(_x, _y, _optionText);

				if (_optionOptions != undefined)
				{
					draw_set_halign(fa_right);
					draw_text_color(_x + _widthMax, _y, ">",
						c_silver, c_silver, c_silver, c_silver, 1.0);
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
			Container.destroy_later();
		}

		Width = _x + _widthMax + 8;
		Height = _y + 8;

		return self;
	};
}
