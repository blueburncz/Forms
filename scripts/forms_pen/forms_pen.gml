/// @enum Enumeration of all possible mouse interactions with a control drawn
/// by {@link FORMS_Pen}.
enum FORMS_EControlAction
{
	/// @member Mouse is above a control.
	MouseOver = -2,
		/// @member A control was right-clicked.
		RightClick = -1,
		/// @member No action.
		None = 0,
		/// @member A control was left-clicked.
		Click = 1,
};

/// @enum Enumeration of all layouts available for {@link FORMS_Pen}.
enum FORMS_EPenLayout
{
	/// @member When {@link FORMS_Pen.next} is called, the pen stays on the same
	/// line. New lines are added with {@link FORMS_Pen.nl}.
	Horizontal,
	/// @member When {@link FORMS_Pen.next} is called, the pen moves onto the
	/// next line. 
	Vertical,
	/// @member There are two columns and when {@link FORMS_Pen.next} is called,
	/// the pen cycles through them, automatically adding a new line after the
	/// last column.
	Column2,
};

/// @func FORMS_Pen(_container)
///
/// @desc A struct used to draw text and controls (buttons, checkboxes, inputs
/// etc.) inside of {@link FORMS_Container}s.
///
/// @param {Struct.FORMS_Container} _container The container to which the pen belongs.
function FORMS_Pen(_container) constructor
{
	/// @var {Struct.FORMS_Container} The container to which the pen belongs.
	/// @readonly
	Container = _container;

	/// @var {Asset.GMFont, Undefined} The font to use or `undefined` (default)
	/// to keep the one currently set by `draw_set_font()`.
	Font = undefined;

	/// @var {Real, Undefined} The line height in pixels or `undefined` to
	/// compute it automatically from the height of the character "M" when using
	/// the currently set font.
	LineHeight = undefined;

	/// @var {Bool} Whether new lines should be added automatically after a text
	/// or a control is drawn. Defaults to `false`.
	AutoNewline = false;

	/// @var {Real} The X coordinate to start drawing at when
	/// {@link FORMS_Pen.start} is called and value to add to the maximum
	/// drawn-to X coordinate returned by {@link FORMS_Pen.get_max_x}.
	PaddingX = 8;

	/// @var {Real} The Y coordinate to start drawing at when
	/// {@link FORMS_Pen.start} is called and value to add to the maximum
	/// drawn-to Y coordinate returned by {@link FORMS_Pen.get_max_y}.
	PaddingY = 8;

	/// @var {Real} Spacing between drawn text and controls on the X axis.
	/// Defaults to 0.
	SpacingX = 0;

	/// @var {Real} Spacing between drawn text and controls on the Y axis.
	/// Defaults to 0.
	SpacingY = 8;

	/// @var {Real} The current X position of the pen.
	/// @readonly
	X = 0;

	/// @var {Real} The current Y position of the pen.
	/// @readonly
	Y = 0;

	/// @var {Real} The maximum drawn-to X coordinate, without padding.
	/// @readonly
	/// @see FORMS_Pen.get_max_x
	MaxX = 0;

	/// @var {Real} The maximum drawn-to Y coordinate, without padding.
	/// @readonly
	/// @see FORMS_Pen.get_max_y
	MaxY = 0;

	/// @var {Real} The X coordinate that the pen started drawing at, updated
	/// when {@link FORMS_Pen.start} is called.
	StartX = 0;

	/// @var {Real} The Y coordinate that the pen started drawing at, updated
	/// when {@link FORMS_Pen.start} is called.
	StartY = 0;

	/// @var {Real} The width of the container that the pen draws to minus
	/// padding. Updated when {@link FORMS_Pen.start} is called.
	/// @readonly
	Width = 0;

	/// @var {Real} The X coordinate of the first column in the current section.
	/// @see FORMS_Pen.section
	ColumnX1 = 0;

	/// @var {Real} The X coordinate of the second column in the current section.
	/// Available only when layout {@link FORMS_EPenLayout.Column2} is used in
	/// {@link FORMS_Pen.start}.
	/// @see FORMS_Pen.section
	ColumnX2 = 0;

	/// @private
	__columnWidth = 0;

	/// @private
	__columnCurrent = 0;

	/// @var {Real} The level of indentation used when drawing a new section
	/// with {@link FORMS_Pen.section}, in pixels. Defaults to 20.
	SectionIndent = 20;

	/// @private
	__sectionCurrent = 0;

	/// @private
	__sectionExpanded = {};

	/// @private
	__started = false;

	/// @private
	__layout = FORMS_EPenLayout.Horizontal;

	/// @private
	__fontBackup = -1;

	/// @private
	__lineHeight = 0;

	/// @private
	__widgetActive = undefined;

	/// @private
	__dropdownId = undefined;

	/// @private
	__dropdownIndex = 0;

	/// @private
	__dropdownValues = undefined;

	/// @private
	__dropdownX = 0;

	/// @private
	__dropdownY = 0;

	/// @private
	__dropdownWidth = 0;

	/// @private
	__dropdowns = {};

	/// @private
	__inputId = undefined;

	/// @private
	__inputValue = undefined;

	/// @private
	__inputIndexFrom = 1;

	/// @private
	__inputIndexTo = 1;

	/// @private
	__inputString = "";

	/// @private
	__inputTimer = 0;

	/// @private
	__result = undefined;

	/// @func get_column_width()
	///
	/// @desc Retrieves the current width of a single column.
	///
	/// @return {Real} The current width of a single column.
	static get_column_width = function ()
	{
		return __columnWidth;
	}

	/// @func get_control_width()
	///
	/// @desc Retrieves the width of the control drawn at the current position.
	///
	/// @return {Real} The width of the control drawn at the current position.
	static get_control_width = function ()
	{
		switch (__layout)
		{
			default: //case FORMS_EPenLayout.Horizontal:
				return 200;
			case FORMS_EPenLayout.Vertical:
				return __columnWidth;
			case FORMS_EPenLayout.Column2:
				return __columnWidth - X + ((__columnCurrent == 0) ? StartX : ColumnX2);
		}
	}

	/// @func get_result()
	///
	/// @desc Retrieves the result returned by the last drawn control and then
	/// forgets it (i.e. for each control this function can be called only once).
	///
	/// @return {Any} The result returned by the last drawn control.
	static get_result = function ()
	{
		var _result = __result;
		__result = undefined;
		return _result;
	}

	/// @private
	static __consume_result = function (_id)
	{
		if (forms_has_result(_id))
		{
			__result = forms_get_result(_id);
			return true;
		}
		return false;
	}

	/// @private
	static __assert_started = function ()
	{
		gml_pragma("forceinline");
		forms_assert(__started, "Must call method start first!");
	}

	/// @func set_layout(_layout)
	///
	/// @desc Changes the layout used by the pen.
	///
	/// @param {Real} _layout The new layout to use. Use values from
	/// {@link FORMS_EPenLayout}.
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	static set_layout = function (_layout)
	{
		__assert_started();
		__layout = _layout;
		ColumnX1 = StartX;
		switch (__layout)
		{
			case FORMS_EPenLayout.Horizontal:
				break;
			case FORMS_EPenLayout.Vertical:
				__columnWidth = Width;
				break;
			case FORMS_EPenLayout.Column2:
				__columnCurrent = 0;
				__columnWidth = floor(Width / 2);
				//ColumnX1 = StartX;
				ColumnX2 = StartY + __columnWidth;
				break;
		}
		return self;
	}

	/// @func start([_layout])
	///
	/// @desc Starts drawing text and controls with given layout. Must be always
	/// used first!
	///
	/// @param {Real} [_layout] Use values from {@link FORMS_EPenLayout}.
	/// Defaults to {@link FORMS_EPenLayout.Horizontal}.
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	static start = function (_layout = FORMS_EPenLayout.Horizontal)
	{
		forms_assert(!__started, "Must use method finish first!");
		forms_get_root(); // Note: Asserts!
		__started = true;
		X = PaddingX;
		Y = PaddingY;
		StartX = X;
		StartY = Y;
		MaxX = X;
		MaxY = Y;
		__fontBackup = draw_get_font();
		if (Font != undefined)
		{
			draw_set_font(Font);
		}
		__lineHeight = LineHeight ?? string_height("M");
		Width = Container.__realWidth - X * 2;
		set_layout(_layout);
		return self;
	}

	/// @func move([_x])
	///
	/// @desc Moves the pen on the X axis by given amount, incremented by the
	/// pen's current spacing configuration.
	///
	/// @param {Real} [_x] The amount to move the pen by on the X axis, without
	/// spacing.
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	///
	/// @see FORMS_Pen.SpacingX
	static move = function (_x)
	{
		X += _x + SpacingX;
		MaxX = max(MaxX, X);
		return self;
	}

	/// @func set_x(_x)
	///
	/// @desc Moves the pen to given X coordinate.
	///
	/// @param {Real} _x The new X coordinate of the pen.
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	static set_x = function (_x)
	{
		X = _x;
		MaxX = max(MaxX, X);
		return self;
	}

	/// @func get_max_x()
	///
	/// @desc Retrieves the maximum drawn-to X coordiante, incremented by the
	/// pen's current padding configuration.
	///
	/// @return {Real} The maximum drawn-to X coordiante, incremented by the
	/// pen's current padding configuration.
	///
	/// @see FORMS_Pen.MaxX
	/// @see FORMS_Pen.PaddingX
	static get_max_x = function ()
	{
		return MaxX + PaddingX;
	}

	/// @func get_max_y()
	///
	/// @desc Retrieves the maximum drawn-to Y coordiante, incremented by the
	/// pen's current padding configuration.
	///
	/// @return {Real} The maximum drawn-to Y coordiante, incremented by the
	/// pen's current padding configuration.
	///
	/// @see FORMS_Pen.MaxY
	/// @see FORMS_Pen.PaddingY
	static get_max_y = function ()
	{
		return MaxY + PaddingY;
	}

	/// @private
	static __move_or_nl = function (_x)
	{
		if (AutoNewline)
		{
			nl();
		}
		else
		{
			move(_x);
		}
	}

	/// @func next()
	///
	/// @desc Moves to the next position in the current layout (specified in
	/// method {@link BBMOD_Pen.start}).
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	///
	/// @see FORMS_EPenLayout
	static next = function ()
	{
		__assert_started();
		switch (__layout)
		{
			case FORMS_EPenLayout.Horizontal:
				break;
			case FORMS_EPenLayout.Vertical:
				nl();
				break;
			case FORMS_EPenLayout.Column2:
				if (__columnCurrent == 0)
				{
					__columnCurrent = 1;
					set_x(ColumnX2);
				}
				else
				{
					__columnCurrent = 0;
					nl();
				}
				break;
		}
		return self;
	}

	/// @func text(_text[, _props])
	///
	/// @desc Draws a text and moves the pen by its width (or adds a new line,
	/// if {@link FORMS_Pen.AutoNewline} is enabled).
	///
	/// @param {String} _text The text to draw.
	/// @param {Struct, Undefined} [_props] Properties to apply to the text or
	/// `undefined` (default).
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	static text = function (_text, _props = undefined)
	{
		// TODO: Add struct FORMS_PenTextProps
		__assert_started();
		var _textOriginal = _text;
		var _c = forms_get_prop(_props, "Color") ?? c_white;
		var _a = forms_get_prop(_props, "Alpha") ?? 1.0;
		var _textWidth = string_width(_text);
		var _trim = forms_get_prop(_props, "Trim") ?? (__layout == FORMS_EPenLayout.Column2);
		var _width = _trim ? get_control_width() : (forms_get_prop(_props, "Width") ?? _textWidth);
		var _shortened = false;
		if (_textWidth > _width)
		{
			while (_textWidth > _width && _text != "")
			{
				_text = string_copy(_text, 1, string_length(_text) - 1);
				_textWidth = string_width(_text);
			}
			_shortened = true;
		}
		var _textHeight = string_height(_text);
		var _mouseOver = is_mouse_over(X, Y, _textWidth, _textHeight);
		if (_mouseOver)
		{
			forms_set_tooltip(forms_get_prop(_props, "Tooltip") ?? (_shortened ? _textOriginal : undefined));
			forms_set_cursor(forms_get_prop(_props, "Cursor") ?? forms_get_cursor());
		}
		draw_text_color(X, Y, _text, _c, _c, _c, _c, _a);
		__move_or_nl(string_width(_text));
		return self;
	}

	/// @func link(_text[, _props])
	///
	/// @desc Draws an interactable text and moves the pen by its width (or adds
	/// a new line, if {@link FORMS_Pen.AutoNewline} is enabled).
	///
	/// @param {String} _text The text to draw.
	/// @param {Struct, Undefined} [_props] Properties to apply to the text or
	/// `undefined` (default).
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static link = function (_text, _props = undefined)
	{
		// TODO: Add struct FORMS_PenLinkProps
		__assert_started();
		var _c = forms_get_prop(_props, "Color") ?? c_white;
		var _a = forms_get_prop(_props, "Alpha") ?? 1.0;
		var _textWidth = string_width(_text);
		var _textHeight = string_height(_text);
		var _mouseOver = is_mouse_over(X, Y, _textWidth, _textHeight);
		if (_mouseOver)
		{
			forms_set_tooltip(forms_get_prop(_props, "Tooltip"));
			forms_set_cursor(forms_get_prop(_props, "Cursor") ?? cr_handpoint);
		}
		draw_text_color(X, Y, _text, _c, _c, _c, _c, _a);
		__move_or_nl(string_width(_text));
		if (_mouseOver)
		{
			if (forms_mouse_check_button_pressed(mb_left))
			{
				return FORMS_EControlAction.Click;
			}
			if (forms_mouse_check_button_pressed(mb_right))
			{
				return FORMS_EControlAction.RightClick;
			}
			return FORMS_EControlAction.MouseOver;
		}
		return FORMS_EControlAction.None;
	}

	/// @func is_mouse_over(_x, _y, _width, _height[, _id])
	///
	/// @desc Checks whether the mouse cursor is over given rectangle.
	///
	/// @param {Real} _x The X coordinate of the rectangle's top left corner.
	/// @param {Real} _y The Y coordinate of the rectangle's top left corner.
	/// @param {Real} _width The width of the rectangle.
	/// @param {Real} _height The height of the rectangle.
	/// @param {String, Undefined} [_id] An ID of a control. If defined, then
	/// there either must be no active control or it must be the one with given
	/// ID, otherwise the mouse-over is not registered.
	///
	/// @return {Bool} Returns `true` if the mouse cursor is above given
	/// rectangle.
	static is_mouse_over = function (_x, _y, _width, _height, _id = undefined)
	{
		var _root = forms_get_root();
		return (_root.WidgetHovered == Container
			&& forms_mouse_in_rectangle(_x, _y, _width, _height)
			&& (_root.WidgetActive == _id || _root.WidgetActive == undefined));
	}

	/// @func get_absolute_pos(_x, _y)
	///
	/// @desc Converts given coordinates within the current container to an
	/// absolute position in window-space.
	///
	/// @param {Real} _x The X position to convert.
	/// @param {Real} _y The Y position to convert.
	///
	/// @return {Array<Real>} An array containing the converted x, y coordinates.
	static get_absolute_pos = function (_x, _y)
	{
		var _world = matrix_get(matrix_world);
		return [
			Container.__realX + _x + _world[12],
			Container.__realY + _y + _world[13],
		];
	}

	/// @func icon(_icon, _font[, _props])
	///
	/// @desc Draws a Font Awesome icon using given font and moves the pen by
	/// its width (or adds a new line, if {@link FORMS_Pen.AutoNewline} is
	/// enabled).
	///
	/// @param {Real} _icon The icon to draw. Use values from {@link FA_ESolid},
	/// {@link FA_ERegular} or {@link FA_EBrands}.
	/// @param {Asset.GMFont} _font The font to use. Must correspond with the
	/// icon to be drawn!
	/// @param {Struct, Undefined} [_props] Properties to apply to the icon or
	/// `undefined` (default).
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static icon = function (_icon, _font, _props = undefined)
	{
		// TODO: Add struct FORMS_PenIconProps
		__assert_started();
		var _string = chr(_icon);
		var _fontPrev = draw_get_font();
		draw_set_font(_font);
		var _c = forms_get_prop(_props, "Color") ?? c_white;
		var _a = forms_get_prop(_props, "Alpha") ?? 1.0;
		var _iconWidth = string_width(_string);
		var _iconHeight = string_height(_string);
		var _width = forms_get_prop(_props, "Width") ?? _iconWidth;
		var _height = forms_get_prop(_props, "Height") ?? _iconHeight;
		var _mouseOver = is_mouse_over(X, Y, _width, _height);
		if (_mouseOver)
		{
			draw_sprite_stretched_ext(FORMS_SprRound4, 0, X, Y, _width, _height, 0x424242, 1.0);
			forms_set_tooltip(forms_get_prop(_props, "Tooltip"));
			forms_set_cursor(cr_handpoint);
		}
		draw_text_color(
			round(X + (_width - _iconWidth) / 2),
			round(Y + (_height - _iconHeight) / 2),
			_string,
			_c, _c, _c, _c, _a);
		draw_set_font(_fontPrev);
		__move_or_nl(_width);
		if (_mouseOver)
		{
			if (forms_mouse_check_button_pressed(mb_left))
			{
				return FORMS_EControlAction.Click;
			}
			if (forms_mouse_check_button_pressed(mb_right))
			{
				return FORMS_EControlAction.RightClick;
			}
			return FORMS_EControlAction.MouseOver;
		}
		return FORMS_EControlAction.None;
	}

	/// @func icon_regular(_icon[, _props])
	///
	/// @desc Draws a Font Awesome icon using the "regular" font and moves the
	/// pen by its width (or adds a new line, if {@link FORMS_Pen.AutoNewline}
	/// is enabled).
	///
	/// @param {Real} _icon The icon to draw. Use values from
	/// {@link FA_ERegular}.
	/// @param {Struct, Undefined} [_props] Properties to apply to the icon or
	/// `undefined` (default).
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static icon_regular = function (_icon, _props = undefined)
	{
		gml_pragma("forceinline");
		return icon(_icon, forms_get_prop(_props, "Font") ?? FA_FntRegular12, _props);
	}

	/// @func icon_solid(_icon[, _props])
	///
	/// @desc Draws a Font Awesome icon using the "solid" font and moves the
	/// pen by its width (or adds a new line, if {@link FORMS_Pen.AutoNewline}
	/// is enabled).
	///
	/// @param {Real} _icon The icon to draw. Use values from {@link FA_ESolid}.
	/// @param {Struct, Undefined} [_props] Properties to apply to the icon or
	/// `undefined` (default).
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static icon_solid = function (_icon, _props = undefined)
	{
		gml_pragma("forceinline");
		return icon(_icon, forms_get_prop(_props, "Font") ?? FA_FntSolid12, _props);
	}

	/// @func icon_brands(_icon[, _props])
	///
	/// @desc Draws a Font Awesome icon using the "brands" font and moves the
	/// pen by its width (or adds a new line, if {@link FORMS_Pen.AutoNewline}
	/// is enabled).
	///
	/// @param {Real} _icon The icon to draw. Use values from {@link FA_EBrands}.
	/// @param {Struct, Undefined} [_props] Properties to apply to the icon or
	/// `undefined` (default).
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static icon_brands = function (_icon, _props = undefined)
	{
		gml_pragma("forceinline");
		return icon(_icon, forms_get_prop(_props, "Font") ?? FA_FntBrands12, _props);
	}

	/// @func button(_text[, _props])
	///
	/// @desc Draws a button and moves the pen by its width (or adds a new line,
	/// if {@link FORMS_Pen.AutoNewline} is enabled).
	///
	/// @param {String} _text The button's text.
	/// @param {Struct, Undefined} [_props] Properties to apply to the button or
	/// `undefined` (default).
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static button = function (_text, _props = undefined)
	{
		// TODO: Add struct FORMS_PenButtonProps
		__assert_started();
		var _c = forms_get_prop(_props, "Color") ?? c_white;
		var _a = forms_get_prop(_props, "Alpha") ?? 1.0;
		var _textWidth = string_width(_text);
		var _textHeight = string_height(_text);
		var _padding = forms_get_prop(_props, "Padding") ?? 8;
		var _width = forms_get_prop(_props, "Width") ?? _textWidth + _padding * 2;
		var _height = forms_get_prop(_props, "Height") ?? __lineHeight;
		var _mouseOver = is_mouse_over(X, Y, _width, _height);
		draw_sprite_stretched_ext(FORMS_SprRound4, 0, X, Y, _width, _height, _mouseOver ? 0x555555 : 0x424242, 1.0);
		if (_mouseOver)
		{
			forms_set_tooltip(forms_get_prop(_props, "Tooltip"));
			forms_set_cursor(cr_handpoint);
		}
		draw_text_color(X + _padding, Y, _text, _c, _c, _c, _c, _a);
		__move_or_nl(_width);
		if (_mouseOver)
		{
			if (forms_mouse_check_button_pressed(mb_left))
			{
				return FORMS_EControlAction.Click;
			}
			if (forms_mouse_check_button_pressed(mb_right))
			{
				return FORMS_EControlAction.RightClick;
			}
			return FORMS_EControlAction.MouseOver;
		}
		return FORMS_EControlAction.None;
	}

	/// @func color(_id, _color[, _props])
	///
	/// @desc Draws a color input that opens a color picker when clicked and
	/// moves the pen by its width (or adds a new line, if
	/// {@link FORMS_Pen.AutoNewline} is enabled).
	///
	/// @func {String} _id The ID of the color input.
	/// @func {Struct.FORMS_Color} _color The color to be mixed.
	/// @func {Struct, Undefined} [_props] Properties to apply to the color
	/// input or `undefined`.
	///
	/// @return {Bool} Returns `true` if the color has changed. The new color
	/// can be retrieved using method {@link FORMS_Pen.get_result}.
	static color = function (_id, _color, _props = undefined)
	{
		// TODO: Add struct FORMS_PenColorProps
		__assert_started();
		_id = __make_id(_id);
		var _width = forms_get_prop(_props, "Width") ?? min(get_control_width(), 50);
		var _disabled = forms_get_prop(_props, "Disabled") ?? false;
		var _height = __lineHeight;
		var _mouseOver = (!_disabled && is_mouse_over(X, Y, _width, _height, _id));
		draw_sprite_stretched(FORMS_SprColor, 0, X, Y, _width, _height);
		draw_sprite_stretched_ext(
			FORMS_SprRound4, 0,
			X, Y,
			_width, _height,
			_color.get(), _color.get_alpha());
		if (_mouseOver)
		{
			forms_set_cursor(cr_handpoint);
			if (forms_mouse_check_button_pressed(mb_left))
			{
				if (forms_get_root().find_widget(_id + "#color-picker") == undefined)
				{
					var _world = matrix_get(matrix_world);
					// TODO: Window auto fit content
					var _colorPickerWidth = 200;
					var _colorPickerHeight = 370;
					var _colorPickerPos = get_absolute_pos(X, Y + _height);
					var _colorPicker = new FORMS_ColorPicker(_id, _color,
					{
						Id: _id + "#color-picker",
						Width: _colorPickerWidth,
						Height: _colorPickerHeight,
						X: clamp(_colorPickerPos[0], 0, window_get_width() - _colorPickerWidth),
						Y: clamp(_colorPickerPos[1], 0, window_get_height() - _colorPickerHeight),
					});
					forms_get_root().add_child(_colorPicker);
				}
			}
		}
		__move_or_nl(_width);
		return __consume_result(_id);
	}

	/// @func checkbox(_checked[, _props])
	///
	/// @desc Draws a checkbox and moves the pen by its width (or adds a new
	/// line, if {@link FORMS_Pen.AutoNewline} is enabled).
	///
	/// @param {Bool} _checked Whether the checkbox is checked (`true`) or not
	/// (`false`).
	/// @param {Struct, Undefined} [_props] Properties to apply to the checkbox
	/// or `undefined` (default).
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static checkbox = function (_checked, _props = undefined)
	{
		// TODO: Add struct FORMS_PenCheckboxProps
		__assert_started();
		var _width = __lineHeight;
		var _height = __lineHeight;
		var _mouseOver = is_mouse_over(X, Y, _width, _height);
		if (_mouseOver)
		{
			draw_sprite_stretched_ext(FORMS_SprRound4, 0, X - 1, Y - 1, _width + 2, _height + 2, 0x9D9D9D, 1.0);
		}
		draw_sprite_stretched_ext(FORMS_SprRound4, 0, X, Y, _width, _height, 0x171717, 1.0);
		if (_checked)
		{
			fa_draw(FA_FntSolid12, FA_ESolid.Check, X + 2, Y, global.formsAccentColor);
		}
		if (_mouseOver)
		{
			forms_set_tooltip(forms_get_prop(_props, "Tooltip"));
			forms_set_cursor(cr_handpoint);
		}
		__move_or_nl(_width);
		if (_mouseOver)
		{
			if (forms_mouse_check_button_pressed(mb_left))
			{
				return FORMS_EControlAction.Click;
			}
			if (forms_mouse_check_button_pressed(mb_right))
			{
				return FORMS_EControlAction.RightClick;
			}
			return FORMS_EControlAction.MouseOver;
		}
		return FORMS_EControlAction.None;
	}

	/// @func radio(_selected[, _props])
	///
	/// @desc Draws a radio button and moves the pen by its width (or adds a new
	/// line, if {@link FORMS_Pen.AutoNewline} is enabled).
	///
	/// @param {Bool} _selected Whether the radio button is selected (`true`)
	/// or not (`false`).
	/// @param {Struct, Undefined} [_props] Properties to apply to the radio
	/// button or `undefined` (default).
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static radio = function (_selected, _props = undefined)
	{
		// TODO: Add struct FORMS_PenRadioProps
		__assert_started();
		var _width = __lineHeight;
		var _height = __lineHeight;
		var _mouseOver = is_mouse_over(X, Y, _width, _height);
		draw_sprite_stretched_ext(FORMS_SprRadioButton, 0, X, Y, _width, _height, 0x171717, 1.0);
		if (_selected)
		{
			draw_sprite_stretched_ext(FORMS_SprRadioButton, 2, X, Y, _width, _height, global.formsAccentColor, 1.0);
		}
		if (_mouseOver)
		{
			draw_sprite_stretched_ext(FORMS_SprRadioButton, 1, X, Y, _width, _height, 0x9D9D9D, 1.0);
			forms_set_tooltip(forms_get_prop(_props, "Tooltip"));
			forms_set_cursor(cr_handpoint);
		}
		__move_or_nl(_width);
		if (_mouseOver)
		{
			if (forms_mouse_check_button_pressed(mb_left))
			{
				return FORMS_EControlAction.Click;
			}
			if (forms_mouse_check_button_pressed(mb_right))
			{
				return FORMS_EControlAction.RightClick;
			}
			return FORMS_EControlAction.MouseOver;
		}
		return FORMS_EControlAction.None;
	}

	/// @private
	static __make_id = function (_id)
	{
		gml_pragma("forceinline");
		return Container.Id + "#" + _id;
	}

	/// @func slider(_id, _value, _min, _max[, _props])
	///
	/// @desc Draws a slider and moves the pen by its width (or adds a new line,
	/// if {@link FORMS_Pen.AutoNewline} is enabled).
	///
	/// @param {String} _id The ID of the slider.
	/// @param {Real} _value The current slider value.
	/// @param {Real} _min The minimum slider value.
	/// @param {Real} _max The maximum slider value.
	/// @param {Struct, Undefined} [_props] Properties to apply to the slider or
	/// `undefined` (default).
	///
	/// @return {Bool} Returns `true` if the slider value has changed. The new
	/// value can be retrieved using method {@link FORMS_Pen.get_result}.
	static slider = function (_id, _value, _min, _max, _props = undefined)
	{
		// TODO: Add struct FORMS_PenSliderProps
		__assert_started();
		_id = __make_id(_id);
		var _valueNew = clamp(_value, _min, _max);
		var _width = forms_get_prop(_props, "Width") ?? get_control_width();
		var _height = __lineHeight;
		var _mouseOver = is_mouse_over(X, Y, _width, _height, _id);

		if (_mouseOver || __widgetActive == _id)
		{
			draw_sprite_stretched_ext(FORMS_SprRound4, 0, X - 1, Y - 1, _width + 2, _height + 2, 0x9D9D9D, 1.0);
		}
		draw_sprite_stretched_ext(FORMS_SprRound4, 0, X, Y, _width, _height, 0x171717, 1.0);
		draw_sprite_stretched_ext(FORMS_SprRound4, 0, X, Y, ((_valueNew - _min) / (_max - _min)) * _width, _height,
			0x424242, 1.0);
		draw_sprite_stretched_ext(FORMS_SprSlider, 0, X + ((_valueNew - _min) / (_max - _min)) * _width - 1, Y - 1,
			3, _height + 2, c_silver, 1.0);

		if (forms_get_prop(_props, "ShowText") ?? true)
		{
			draw_text(X + 4, Y, (forms_get_prop(_props, "Pre") ?? "") + string(_value) + (forms_get_prop(_props,
				"Post") ?? ""));
		}
		if (_mouseOver)
		{
			if (forms_mouse_check_button_pressed(mb_left))
			{
				__widgetActive = _id;
			}
			forms_set_tooltip(forms_get_prop(_props, "Tooltip"));
			forms_set_cursor(cr_handpoint);
		}
		if (__widgetActive == _id)
		{
			if (!mouse_check_button(mb_left))
			{
				__widgetActive = undefined;
			}
			_valueNew = lerp(_min, _max, clamp((forms_mouse_get_x() - X) / _width, 0, 1));
			forms_set_cursor(cr_handpoint);
			if (forms_get_prop(_props, "Integers") ?? false)
			{
				_valueNew = floor(_valueNew);
			}
		}

		if (_value != _valueNew)
		{
			forms_return_result(_id, _valueNew);
		}
		__move_or_nl(_width);
		return __consume_result(_id);
	}

	/// @func dropdown(_id, _value, _options[, _props])
	///
	/// @desc Draws a dropdown then opens a menu with available options when
	/// clicked and moves the pen by its width (or adds a new line, if
	/// {@link FORMS_Pen.AutoNewline} is enabled).
	///
	/// @param {String} _id The ID of the dropdown.
	/// @param {Real} _value The index of the currently selected option.
	/// @param {Array} _options An array of all available options.
	/// @param {Struct, Undefined} [_props] Properties to apply to the dropdown
	/// or `undefined` (default).
	///
	/// @return {Bool} Returns `true` if a new option was selected. The new
	/// index of the selected option can be retrieved using method
	/// {@link FORMS_Pen.get_result}.
	static dropdown = function (_id, _value, _options, _props = undefined)
	{
		// TODO: Add struct FORMS_PenDropdownProps
		__assert_started();
		_id = __make_id(_id);
		var _width = forms_get_prop(_props, "Width") ?? get_control_width();
		var _height = __lineHeight;
		var _padding = forms_get_prop(_props, "Padding") ?? 4;
		var _mouseOver = is_mouse_over(X, Y, _width, _height, _id);
		draw_sprite_stretched_ext(FORMS_SprRound4, 0, X, Y, _width, _height, 0x424242, 1.0);
		fa_draw(FA_FntSolid12, FA_ESolid.CaretDown, X + _width - 16, Y - 2, c_white, 0.5);

		var _textOriginal = "";
		var _index = array_length(_options) - 1;
		repeat(_index + 1)
		{
			var _option = _options[_index];
			if (is_struct(_option) && _value == _option.Value)
			{
				_textOriginal = string(_option[$ "Text"] ?? _option.Value);
				break;
			}
			else if (_value == _option)
			{
				_textOriginal = string(_option);
				break;
			}
			--_index;
		}

		if (_index >= 0)
		{
			var _text = _textOriginal;
			var _textWidth = string_width(_text);
			var _shortened = false;
			if (_textWidth > _width - _padding - 24)
			{
				while (_textWidth > _width - _padding - 24 && _text != "")
				{
					_text = string_copy(_text, 1, string_length(_text) - 1);
					_textWidth = string_width(_text);
				}
				_shortened = true;
			}
			draw_text(X + _padding, Y, _text);
			if (_shortened && _mouseOver)
			{
				forms_set_tooltip(_textOriginal);
			}
		}
		if (_mouseOver)
		{
			if (forms_mouse_check_button_pressed(mb_left))
			{
				if (__dropdowns[$  _id] == undefined
					|| !weak_ref_alive(__dropdowns[$  _id]))
				{
					var _dropdownPos = get_absolute_pos(X, Y + _height);
					var _dropdown = new FORMS_Dropdown(_id, _options, _index, _width,
					{
						X: _dropdownPos[0],
						Y: _dropdownPos[1],
					});
					forms_get_root().add_child(_dropdown);
					__dropdowns[$  _id] = weak_ref_create(_dropdown);
				}
				else
				{
					__dropdowns[$  _id].ref.destroy_later();
					__dropdowns[$  _id] = undefined;
				}
			}
			forms_set_cursor(cr_handpoint);
		}
		__move_or_nl(_width);
		return __consume_result(_id);
	}

	/// @func input(_id, _value[, _props])
	///
	/// @desc Draws an input (text or numeric) and moves the pen by its width
	/// (or adds a new line, if {@link FORMS_Pen.AutoNewline} is enabled).
	///
	/// @param {String} _id The ID of the input.
	/// @param {String, Real} _value The value inside of the input.
	/// @param {Struct, Undefined} [_props] Properties to apply to the input or
	/// `undefined` (default).
	///
	/// @return {Bool} Returns `true` if the input value has changed. The new
	/// value can be retrieved using method {@link FORMS_Pen.get_result}.
	static input = function (_id, _value, _props = undefined)
	{
		// TODO: Add struct FORMS_PenInputProps
		__assert_started();
		_id = __make_id(_id);

		var _x = X;
		var _y = Y;
		var _width = forms_get_prop(_props, "Width") ?? get_control_width();
		var _height = __lineHeight;
		var _ribbon = forms_get_prop(_props, "Ribbon");
		var _padding = forms_get_prop(_props, "Padding") ?? 4 + ((_ribbon != undefined) ? 2 : 0);
		var _disabled = forms_get_prop(_props, "Disabled") ?? false;
		var _mouseOver = (!_disabled && is_mouse_over(_x, _y, _width, _height, _id));

		if (_mouseOver)
		{
			if (forms_mouse_check_button_pressed(mb_left) && __inputId != _id)
			{
				if (__inputId != undefined)
				{
					forms_return_result(__inputId, is_real(__inputValue)
						? (forms_parse_real(__inputString) ?? __inputValue)
						: __inputString);
				}
				__inputId = _id;
				__inputValue = _value;
				__inputString = string(__inputValue);
				keyboard_string = "";
			}
			forms_set_cursor(cr_beam);
		}

		// Border when selected
		if (__inputId == _id)
		{
			draw_sprite_stretched_ext(FORMS_SprRound4, 0, _x - 1, _y - 1, _width + 2, _height + 2, 0x9D9D9D, 1.0);
		}

		// Background
		draw_sprite_stretched_ext(FORMS_SprRound4, 0, _x, _y, _width, _height, _disabled ? 0x101010 : 0x171717,
			1.0);

		// Ribbon
		if (_ribbon != undefined)
		{
			draw_sprite_stretched_ext(FORMS_SprRound4, 0, _x, _y, 2, _height, _ribbon, 1.0);
		}

		// Input is active...
		if (__inputId == _id)
		{
			var _stringToInsert = string_replace_all(keyboard_string, chr(127), "");
			var _keyboardStringLength = string_length(_stringToInsert);
			keyboard_string = "";

			__inputString += _stringToInsert;

			var _multitype = false;
			if (keyboard_check_pressed(vk_anykey))
			{
				__inputTimer = -300;
				_multitype = true;
			}
			else if (keyboard_check(vk_anykey))
			{
				__inputTimer += delta_time * 0.001;
				if (__inputTimer >= 50)
				{
					__inputTimer = 0;
					_multitype = true;
				}
			}

			var _inputLength = string_length(__inputString);

			if (_multitype
				&& keyboard_check(vk_backspace)
				&& __inputString != "")
			{
				__inputString = string_delete(__inputString, _inputLength, 1);
				--_inputLength;
			}
			else if (_multitype
				&& keyboard_check(vk_delete))
			{
				__inputString = string_delete(__inputString, _inputLength, 1);
				--_inputLength;
			}

			var _displayString = __inputString;
			var _stringWidth = string_width(_displayString);
			while (_stringWidth > _width - _padding * 2 && _displayString != "")
			{
				_displayString = string_delete(_displayString, 1, 1);
				_stringWidth = string_width(_displayString);
			}

			// Draw text
			draw_text(_x + _padding, _y, _displayString);

			// Draw input beam
			var _alpha = (keyboard_check(vk_anykey) || mouse_check_button(mb_any))
				? 1.0 : dsin(current_time * 0.5) * 0.5 + 0.5;
			forms_draw_rectangle(_x + _padding + _stringWidth, _y, 2, __lineHeight, global.formsAccentColor,
				_alpha);
		}
		else // Input not active...
		{
			var _displayString = forms_has_result(_id) ? string(forms_peek_result(_id)) : string(_value);
			var _displayColor = _disabled ? c_gray : c_white;
			if (_displayString == "")
			{
				_displayString = forms_get_prop(_props, "Placeholder") ?? "";
				_displayColor = c_gray;
			}
			var _stringLength = string_length(_displayString);
			var _trimmed = false;
			while (string_width(_displayString) > _width - _padding * 2 && _displayString != "")
			{
				_displayString = string_delete(_displayString, _stringLength--, 1);
				_trimmed = true;
			}

			// Draw text
			draw_text_color(_x + _padding, _y, _displayString, _displayColor, _displayColor, _displayColor,
				_displayColor, 1.0);

			if (_mouseOver)
			{
				var _tooltip = forms_get_prop(_props, "Tooltip");
				if (_tooltip != undefined)
				{
					forms_set_tooltip(_tooltip);
				}
				else if (_trimmed)
				{
					forms_set_tooltip(string(_value));
				}
			}
		}

		__move_or_nl(_width);

		if (__inputId == _id && (keyboard_check_pressed(vk_enter)
				|| (!_mouseOver && mouse_check_button_pressed(mb_left))))
		{
			var _valueNew = is_real(__inputValue)
				? (forms_parse_real(__inputString) ?? __inputValue)
				: __inputString;
			if (__inputValue != _valueNew)
			{
				forms_return_result(_id, _valueNew);
			}
			__inputId = undefined;
		}

		return __consume_result(_id);
	}

	/// @func section(_text[, _props])
	///
	/// @desc Draws a section, begins a new line and increases the current
	/// indentation level.
	///
	/// @param {String} _text The name of the section.
	/// @param {Struct, Undefined} [_props] Properties to apply to the section
	/// or `undefined` (default).
	///
	/// @return {Bool} Returns `true` if the section is expanded or `false` if 
	/// it's collapsed.
	///
	/// @see FORMS_Pen.SectionIndent
	static section = function (_text, _props = undefined)
	{
		// TODO: Add struct FORMS_PenSectionProps
		__assert_started();
		var _id = forms_get_prop(_props, "Id") ?? _text;
		__sectionExpanded[$  _id] ??= !(forms_get_prop(_props, "Collapsed") ?? false);
		var _width = Width;
		var _height = forms_get_prop(_props, "Height") ?? __lineHeight;
		var _indent = __sectionCurrent * SectionIndent;
		var _mouseOver = is_mouse_over(StartX, Y, _width, _height);
		draw_sprite_stretched_ext(FORMS_SprRound4, 0, StartX, Y, _width, _height, 0x3F3F3F, 1.0);
		fa_draw(FA_FntSolid12, __sectionExpanded[$  _id] ? FA_ESolid.AngleDown : FA_ESolid.AngleRight, StartX
			+ _indent + 4, Y, c_white, 0.5);
		draw_text(StartX + _indent + SectionIndent, Y, _text);
		if (_mouseOver)
		{
			forms_set_tooltip(forms_get_prop(_props, "Tooltip"));
			forms_set_cursor(cr_handpoint);
		}
		if (_mouseOver && forms_mouse_check_button_pressed(mb_left))
		{
			__sectionExpanded[$  _id] = !__sectionExpanded[$  _id];
		}
		if (__sectionExpanded[$  _id])
		{
			ColumnX1 += SectionIndent;
			nl();
			++__sectionCurrent;
			return true;
		}
		nl();
		return false;
	}

	/// @func end_section()
	///
	/// @desc Ends a section previously started with {@link FORMS_Pen.section}
	/// (which must have returned `true`) and decreased the current indentation
	/// level.
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	///
	/// @see FORMS_Pen.SectionIndent
	static end_section = function ()
	{
		__assert_started();
		ColumnX1 -= SectionIndent;
		--__sectionCurrent;
		nl(0);
		return self;
	}

	/// @func nl([_count])
	///
	/// @desc Adds given number of new lines.
	///
	/// @param {Real} [_count] The number of new lines to add. Defaults to 1.
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	///
	/// @see FORMS_Pen.SpacingY
	static nl = function (_count = 1)
	{
		gml_pragma("forceinline");
		__assert_started();

		if (__layout == FORMS_EPenLayout.Column2)
		{
			set_x((__columnCurrent == 0) ? ColumnX1 : ColumnX2);
		}
		else
		{
			set_x(ColumnX1);
		}

		Y += (__lineHeight + SpacingY) * _count;
		MaxY = max(MaxY, Y);

		return self;
	}

	/// @func finish()
	///
	/// @desc Finishes drawing with the pen. Must be always used before calling
	/// {@link FORMS_Pen.start} again!
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	static finish = function ()
	{
		__assert_started();
		__started = false;
		draw_set_font(__fontBackup);
		return self;
	}
}
