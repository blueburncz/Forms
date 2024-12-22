/// @macro {Code} Returns mouse state from a {@link FORMS_Pen} method. Requires
/// local variable `_mouseOver`!
/* beautify ignore:start */
#macro FORMS_PEN_RETURN_MOUSE_STATE \
	if (_mouseOver) \
	{ \
		if (forms_mouse_check_button_pressed(mb_left)) \
		{ \
			return FORMS_EControlAction.Click; \
		} \
		if (forms_mouse_check_button_pressed(mb_right)) \
		{ \
			return FORMS_EControlAction.RightClick; \
		} \
		return FORMS_EControlAction.MouseOver; \
	} \
	return FORMS_EControlAction.None
/* beautify ignore:end */

/// @enum Enumeration of all possible mouse interactions with a control drawn by {@link FORMS_Pen}.
enum FORMS_EControlAction
{
	/// @member A caret next to a control was left-clicked.
	CaretClick = -3,
		/// @member Mouse is above a control.
		MouseOver = -2,
		/// @member A control was right-clicked.
		RightClick = -1,
		/// @member No action.
		None = 0,
		/// @member A control was left-clicked.
		Click = 1,
};

/// @func FORMS_PenTextProps()
///
/// @desc Properties accepted by method {@link FORMS_Pen.text}.
function FORMS_PenTextProps() constructor
{
	/// @var {Constant.Color, Undefined} The color of the text to draw.
	Color = undefined;

	/// @var {Real, Undefined} The alpha value of the text to draw.
	Alpha = undefined;

	/// @var {Bool, Undefined} If `true` then property `Width` is ignored and the text is trimmed from the right to the
	/// current control width.
	/// @see FORMS_Pen.get_control_width
	Trim = undefined;

	/// @var {Real, Undefined} The maximum width of the text in pixels. The text is trimmed from the right if larger.
	Width = undefined;

	/// @var {String, Undefined} The tooltip text to show on mouse-over.
	Tooltip = undefined;

	/// @var {Constant.Cursor, Undefined} The cursor to use on mouse-over.
	Cursor = undefined;
}

/// @func FORMS_PenLinkProps()
///
/// @desc Properties accepted by method {@link FORMS_Pen.link}.
function FORMS_PenLinkProps(): FORMS_PenTextProps() constructor {}

/// @func FORMS_PenIconProps()
///
/// @desc Properties accepted by method {@link FORMS_Pen.icon}.
function FORMS_PenIconProps() constructor
{
	/// @var {Constant.Color, Undefined} The color of the icon.
	Color = undefined;

	/// @var {Real, Undefined} The alpha value of the icon.
	Alpha = undefined;

	/// @var {Real, Undefined} Horizontal padding around the icon.
	Padding = undefined;

	/// @var {Real, Undefined} The width of the icon.
	Width = undefined;

	/// @var {Real, Undefined} The height of the icon.
	Height = undefined;

	/// @var {Constant.Color, Undefined} The icon's background color.
	BackgroundColor = undefined;

	/// @var {Real, Undefined} The alpha value of the icon's background.
	BackgroundAlpha = undefined;

	/// @var {Constant.Color, Undefined} The icon's background color on mouse-over.
	BackgroundColorHover = undefined;

	/// @var {Real, Undefined} The alpha value of the icon's background on mouse-over.
	BackgroundAlphaHover = undefined;

	/// @var {String, Undefined} The tooltip text to show on mouse-over.
	Tooltip = undefined;
}

/// @func FORMS_PenIconRegularProps()
///
/// @desc Properties accepted by method {@link FORMS_Pen.icon_regular}.
function FORMS_PenIconRegularProps(): FORMS_PenIconProps() constructor
{
	/// @var {Asset.GMFont, Undefined} The font to use with the icon.
	Font = undefined;
}

/// @func FORMS_PenIconSolidProps()
///
/// @desc Properties accepted by method {@link FORMS_Pen.icon_solid}.
function FORMS_PenIconSolidProps(): FORMS_PenIconProps() constructor
{
	/// @var {Asset.GMFont, Undefined} The font to use with the icon.
	Font = undefined;
}

/// @func FORMS_PenIconBrandsProps()
///
/// @desc Properties accepted by method {@link FORMS_Pen.icon_brands}.
function FORMS_PenIconBrandsProps(): FORMS_PenIconProps() constructor
{
	/// @var {Asset.GMFont, Undefined} The font to use with the icon.
	Font = undefined;
}

/// @func FORMS_PenButtonProps()
///
/// @desc Properties accepted by method {@link FORMS_Pen.button}.
function FORMS_PenButtonProps() constructor
{
	/// @var {Constant.Color, Undefined} The color of the button's text.
	Color = undefined;

	/// @var {Real, Undefined} The alpha value of the button's text.
	Alpha = undefined;

	/// @var {Real, Undefined} The horizontal padding around the button's text.
	Padding = undefined;

	/// @var {Real, Undefined} The width of the button.
	Width = undefined;

	/// @var {Real, Undefined} The height of the button.
	Height = undefined;

	/// @var {Constant.Color, Undefined} The button's background color.
	BackgroundColor = undefined;

	/// @var {Real, Undefined} The alpha value of the button's background.
	BackgroundAlpha = undefined;

	/// @var {Constant.Color, Undefined} The button's background color on mouse-over.
	BackgroundColorHover = undefined;

	/// @var {Real, Undefined} The alpha value of the button's background on mouse-over.
	BackgroundAlphaHover = undefined;

	/// @var {String, Undefined} The tooltip text to show on mouse-over.
	Tooltip = undefined;
}

/// @func FORMS_PenColorProps()
///
/// @desc Properties accepted by method {@link FORMS_Pen.color}.
function FORMS_PenColorProps() constructor
{
	/// @var {Real, Undefined} The width of the color input.
	Width = undefined;

	/// @var {Bool, Undefined} Whether the color input is disabled (`true`) or not (`false`).
	Disabled = undefined;

	/// @var {String, Undefined} The tooltip text to show on mouse-over.
	Tooltip = undefined;
}

/// @func FORMS_PenCheckboxProps()
///
/// @desc Properties accepted by method {@link FORMS_Pen.checkbox}.
function FORMS_PenCheckboxProps() constructor
{
	/// @var {Constant.Color, Undefined} The color of the tick.
	Color = undefined;

	/// @var {Real, Undefined} The alpha value of the tick.
	Alpha = undefined;

	/// @var {Constant.Color, Undefined} The background color.
	BackgroundColor = undefined;

	/// @var {Real, Undefined} The alpha value of the background.
	BackgroundAlpha = undefined;

	/// @var {Constant.Color, Undefined} The color of the border shown on mouse-over.
	BorderColor = undefined;

	/// @var {Real, Undefined} The alpha value of the border.
	BorderAlpha = undefined;

	/// @var {String, Undefined} The tooltip text to show on mouse-over.
	Tooltip = undefined;
}

/// @func FORMS_PenRadioProps()
///
/// @desc Properties accepted by method {@link FORMS_Pen.radio}.
function FORMS_PenRadioProps() constructor
{
	/// @var {Constant.Color, Undefined} The color of the tick.
	Color = undefined;

	/// @var {Real, Undefined} The alpha value of the tick.
	Alpha = undefined;

	/// @var {Constant.Color, Undefined} The background color.
	BackgroundColor = undefined;

	/// @var {Real, Undefined} The alpha value of the background.
	BackgroundAlpha = undefined;

	/// @var {Constant.Color, Undefined} The color of the border shown on mouse-over.
	BorderColor = undefined;

	/// @var {Real, Undefined} The alpha value of the border.
	BorderAlpha = undefined;

	/// @var {String, Undefined} The tooltip text to show on mouse-over.
	Tooltip = undefined;
}

/// @func FORMS_PenSliderProps()
///
/// @desc Properties accepted by method {@link FORMS_Pen.slider}.
function FORMS_PenSliderProps() constructor
{
	/// @var {Real, Undefined} The width of the slider.
	Width = undefined;

	/// @var {Constant.Color, Undefined} The color of text shown on the slider.
	Color = undefined;

	/// @var {Real, Undefined} The alpha value of the text shown on the slider.
	Alpha = undefined;

	/// @var {Constant.Color, Undefined} The color of the border shown on mouse-over or when the slider is active.
	BorderColor = undefined;

	/// @var {Real, Undefined} The alpha value of the border shown on mouse-over or when the slider is active.
	BorderAlpha = undefined;

	/// @var {Constant.Color, Undefined} The color of the slider's background.
	BackgroundColor = undefined;

	/// @var {Real, Undefined} The alpha value of the slider's background.
	BackgroundAlpha = undefined;

	/// @var {Constant.Color, Undefined} The fill color of the slider.
	FillColor = undefined;

	/// @var {Real, Undefined} The alpha value of the slider's fill.
	FillAlpha = undefined;

	/// @var {Constant.Color, Undefined} The color of the slider's thumb.
	SliderColor = undefined;

	/// @var {Real, Undefined} The alpha value of the slider's thumb.
	SliderAlpha = undefined;

	/// @var {Bool, Undefined} Whether to show the slider value as text (`true`) or not (`false`).
	ShowText = undefined;

	/// @var {String, Undefined} The text to prepend the slider's value with.
	Pre = undefined;

	/// @var {String, Undefined} The text to append to the slider's value.
	Post = undefined;

	/// @var {Bool, Undefined} Whether only integer values are allowed (`true`) or not (`false`).
	Integers = undefined;

	/// @var {String, Undefined} The tooltip text shown on mouse-over.
	Tooltip = undefined;
}

/// @func FORMS_PenDropdownProps()
///
/// @desc Properties accepted by method {@link FORMS_Pen.dropdown}.
function FORMS_PenDropdownProps() constructor
{
	/// @var {Real, Undefined} The width of the dropdown.
	Width = undefined;

	/// @var {Real, Undefined} The horizontal padding around dropdown text.
	Padding = undefined;

	/// @var {Constant.Color, Undefined} The color of the dropdown's background.
	BackgroundColor = undefined;

	/// @var {Real, Undefined} The alpha value of the dropdown's background.
	BackgroundAlpha = undefined;

	/// @var {Constant.Color, Undefined} The caret color.
	CaretColor = undefined;

	/// @var {Real, Undefined} The alpha value of the caret.
	CaretAlpha = undefined;

	/// @var {Constant.Color, Undefined} The text color.
	Color = undefined;

	/// @var {Real, Undefined} The alpha value of the text.
	Alpha = undefined;
}

/// @enum Enumeration of all layouts available for {@link FORMS_Pen}.
enum FORMS_EPenLayout
{
	/// @member When {@link FORMS_Pen.next} is called, the pen stays on the same line. New lines are added with
	/// {@link FORMS_Pen.nl}.
	Horizontal,
	/// @member When {@link FORMS_Pen.next} is called, the pen moves onto the next line.
	Vertical,
	/// @member There are two columns and when {@link FORMS_Pen.next} is called, the pen cycles through them,
	/// automatically adding a new line after the last column.
	Column2,
};

/// @func FORMS_Pen(_container)
///
/// @desc A struct used to draw text and controls (buttons, checkboxes, inputs etc.) inside of {@link FORMS_Container}s.
///
/// @param {Struct.FORMS_Container} _container The container to which the pen belongs.
function FORMS_Pen(_container) constructor
{
	/// @var {Struct.FORMS_Container} The container to which the pen belongs.
	/// @readonly
	Container = _container;

	/// @var {Asset.GMFont, Undefined} The font to use or `undefined` (default) to keep the one currently set by
	/// `draw_set_font()`.
	Font = undefined;

	/// @var {Real, Undefined} The line height in pixels or `undefined` to compute it automatically from the height of
	/// the character "M" when using the currently set font.
	LineHeight = undefined;

	/// @var {Bool} Whether new lines should be added automatically after a text or a control is drawn. Defaults to
	/// `false`.
	AutoNewline = false;

	/// @var {Real} The X coordinate to start drawing at when {@link FORMS_Pen.start} is called and value to add to the
	/// maximum drawn-to X coordinate returned by {@link FORMS_Pen.get_max_x}.
	PaddingX = 8;

	/// @var {Real} The Y coordinate to start drawing at when {@link FORMS_Pen.start} is called and value to add to the
	/// maximum drawn-to Y coordinate returned by {@link FORMS_Pen.get_max_y}.
	PaddingY = 8;

	/// @var {Real} Spacing between drawn text and controls on the X axis. Defaults to 0.
	SpacingX = 0;

	/// @var {Real} Spacing between drawn text and controls on the Y axis. Defaults to 0.
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

	/// @var {Real} The X coordinate that the pen started drawing at, updated when {@link FORMS_Pen.start} is called.
	StartX = 0;

	/// @var {Real} The Y coordinate that the pen started drawing at, updated when {@link FORMS_Pen.start} is called.
	StartY = 0;

	/// @var {Real} The width of the container that the pen draws to minus padding. Updated when {@link FORMS_Pen.start}
	/// is called. @readonly
	Width = 0;

	/// @var {Real} The X coordinate of the first column in the current section.
	/// @see FORMS_Pen.section
	ColumnX1 = 0;

	/// @var {Real} The X coordinate of the second column in the current section. Available only when layout
	/// {@link FORMS_EPenLayout.Column2} is used in {@link FORMS_Pen.start}.
	/// @see FORMS_Pen.section
	ColumnX2 = 0;

	/// @private
	__columnWidth = 0;

	/// @private
	__columnCurrent = 0;

	/// @var {Real} The level of indentation used when drawing a new section with {@link FORMS_Pen.section}, in pixels.
	/// Defaults to 20.
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

	/// @var {String, Undefined} The ID of the currently active input or `undefined` if there isn't one.
	/// @private
	__inputId = undefined;

	/// @var {Any} Backup of the original value of the currently active input.
	/// @private
	__inputValue = undefined;

	/// @private
	__inputIndexFrom = 1;

	/// @private
	__inputIndexTo = 1;

	//// @private
	__inputIndexDraw = 1;

	/// @private
	__inputSelect = false;

	/// @private
	__inputSelectTimer = 0;

	/// @private
	__inputString = "";

	/// @private
	__inputTimer = 0;

	/// @private
	__result = undefined;

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
	/// @desc Retrieves the maximum drawn-to X coordinate, incremented by the pen's current padding configuration.
	///
	/// @return {Real} The maximum drawn-to X coordinate, incremented by the pen's current padding configuration.
	///
	/// @see FORMS_Pen.MaxX
	/// @see FORMS_Pen.PaddingX
	static get_max_x = function ()
	{
		return MaxX + PaddingX;
	}

	/// @func get_max_y()
	///
	/// @desc Retrieves the maximum drawn-to Y coordinate, incremented by the pen's current padding configuration.
	///
	/// @return {Real} The maximum drawn-to Y coordinate, incremented by the pen's current padding configuration.
	///
	/// @see FORMS_Pen.MaxY
	/// @see FORMS_Pen.PaddingY
	static get_max_y = function ()
	{
		return MaxY + PaddingY;
	}

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
	/// @desc Retrieves the result returned by the last drawn control and then forgets it (i.e. for each control this
	/// function can be called only once).
	///
	/// @return {Any} The result returned by the last drawn control.
	static get_result = function ()
	{
		var _result = __result;
		__result = undefined;
		return _result;
	}

	/// @func __consume_result()
	///
	/// @param {String} _id
	///
	/// @return {Bool}
	///
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

	/// @func __assert_started()
	///
	/// @desc Asserts that {@link FORMS_Pen.start} was called.
	///
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
	/// @param {Real} _layout The new layout to use. Use values from {@link FORMS_EPenLayout}.
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
	/// @desc Starts drawing text and controls with given layout. Must be always used first!
	///
	/// @param {Real} [_layout] Use values from {@link FORMS_EPenLayout}. Defaults to {@link FORMS_EPenLayout.Horizontal}.
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

	/// @func finish()
	///
	/// @desc Finishes drawing with the pen. Must be always used before calling {@link FORMS_Pen.start} again!
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	static finish = function ()
	{
		__assert_started();
		__started = false;
		draw_set_font(__fontBackup);
		return self;
	}

	/// @func move([_x])
	///
	/// @desc Moves the pen on the X axis by given amount, incremented by the pen's current spacing configuration.
	///
	/// @param {Real} [_x] The amount to move the pen by on the X axis, without spacing.
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

	/// @func __move_or_nl(_x)
	///
	/// @desc Moves by X or adds a new line of {@link FORMS_Pen.AutoNewline} is enabled.
	///
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
	/// @desc Moves to the next position in the current layout (specified in method {@link FORMS_Pen.start}).
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

	/// @func __make_id(_id)
	///
	/// @param {String} _id
	///
	/// @return {String}
	///
	/// @private
	static __make_id = function (_id)
	{
		gml_pragma("forceinline");
		return Container.Id + "#" + _id;
	}

	/// @func is_mouse_over(_x, _y, _width, _height[, _id])
	///
	/// @desc Checks whether the mouse cursor is over given rectangle.
	///
	/// @param {Real} _x The X coordinate of the rectangle's top left corner.
	/// @param {Real} _y The Y coordinate of the rectangle's top left corner.
	/// @param {Real} _width The width of the rectangle.
	/// @param {Real} _height The height of the rectangle.
	/// @param {String, Undefined} [_id] An ID of a control. If defined, then there either must be no active control or
	/// it must be the one with given ID, otherwise the mouse-over is not registered.
	///
	/// @return {Bool} Returns `true` if the mouse cursor is above given rectangle.
	static is_mouse_over = function (_x, _y, _width, _height, _id = undefined)
	{
		var _root = forms_get_root();
		return (_root.WidgetHovered == Container
			&& forms_mouse_in_rectangle(_x, _y, _width, _height)
			&& (_root.WidgetActive == _id || _root.WidgetActive == undefined));
	}

	/// @func get_absolute_pos(_x, _y)
	///
	/// @desc Converts given coordinates within the current container to an absolute position in window-space.
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

	/// @func text(_text[, _props])
	///
	/// @desc Draws a text and moves the pen by its width (or adds a new line, if {@link FORMS_Pen.AutoNewline} is
	/// enabled).
	///
	/// @param {String} _text The text to draw.
	/// @param {Struct.FORMS_PenTextProps, Undefined} [_props] Properties to apply to the text or `undefined` (default).
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	static text = function (_text, _props = undefined)
	{
		__assert_started();

		var _textOriginal = _text;
		var _color = forms_get_prop(_props, "Color") ?? c_white;
		var _alpha = forms_get_prop(_props, "Alpha") ?? 1.0;
		var _textWidth = string_width(_text);
		var _textHeight = string_height(_text);
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

		var _mouseOver = is_mouse_over(X, Y, _textWidth, _textHeight);

		if (_mouseOver)
		{
			forms_set_tooltip(forms_get_prop(_props, "Tooltip") ?? (_shortened ? _textOriginal : undefined));
			forms_set_cursor(forms_get_prop(_props, "Cursor") ?? forms_get_cursor());
		}

		draw_text_color(X, Y, _text, _color, _color, _color, _color, _alpha);
		__move_or_nl(string_width(_text));

		return self;
	}

	/// @func link(_text[, _props])
	///
	/// @desc Draws an interactive text and moves the pen by its width (or adds a new line, if
	/// {@link FORMS_Pen.AutoNewline} is enabled).
	///
	/// @param {String} _text The text to draw.
	/// @param {Struct.FORMS_PenLinkProps, Undefined} [_props] Properties to apply to the text or `undefined` (default).
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static link = function (_text, _props = undefined)
	{
		__assert_started();

		var _textOriginal = _text;
		var _color = forms_get_prop(_props, "Color") ?? c_white;
		var _alpha = forms_get_prop(_props, "Alpha") ?? 1.0;
		var _textWidth = string_width(_text);
		var _textHeight = string_height(_text);
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

		var _mouseOver = is_mouse_over(X, Y, _textWidth, _textHeight);

		if (_mouseOver)
		{
			forms_set_tooltip(forms_get_prop(_props, "Tooltip") ?? (_shortened ? _textOriginal : undefined));
			forms_set_cursor(forms_get_prop(_props, "Cursor") ?? forms_get_cursor());
		}

		draw_text_color(X, Y, _text, _color, _color, _color, _color, _alpha);
		__move_or_nl(string_width(_text));

		FORMS_PEN_RETURN_MOUSE_STATE;
	}

	/// @func icon(_icon, _font[, _props])
	///
	/// @desc Draws a Font Awesome icon using given font and moves the pen by its width (or adds a new line, if
	/// {@link FORMS_Pen.AutoNewline} is enabled).
	///
	/// @param {Real} _icon The icon to draw. Use values from {@link FA_ESolid}, {@link FA_ERegular} or {@link FA_EBrands}.
	/// @param {Asset.GMFont} _font The font to use. Must correspond with the icon to be drawn!
	/// @param {Struct.FORMS_PenIconProps, Undefined} [_props] Properties to apply to the icon or `undefined` (default).
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static icon = function (_icon, _font, _props = undefined)
	{
		__assert_started();

		var _string = chr(_icon);
		var _fontPrev = draw_get_font();
		draw_set_font(_font);
		var _color = forms_get_prop(_props, "Color") ?? c_white;
		var _alpha = forms_get_prop(_props, "Alpha") ?? 1.0;
		var _iconWidth = string_width(_string);
		var _iconHeight = string_height(_string);
		var _padding = forms_get_prop(_props, "Padding") ?? 4;
		var _width = forms_get_prop(_props, "Width") ?? _iconWidth + _padding * 2;
		var _height = forms_get_prop(_props, "Height") ?? _iconHeight;
		var _backgroundColor = forms_get_prop(_props, "BackgroundColor") ?? 0x424242;
		var _backgroundAlpha = forms_get_prop(_props, "BackgroundAlpha") ?? 0.0;
		var _backgroundColorHover = forms_get_prop(_props, "BackgroundColorHover") ?? 0x424242;
		var _backgroundAlphaHover = forms_get_prop(_props, "BackgroundAlphaHover") ?? 1.0;
		var _mouseOver = is_mouse_over(X, Y, _width, _height);

		if (_mouseOver)
		{
			forms_set_tooltip(forms_get_prop(_props, "Tooltip"));
			forms_set_cursor(cr_handpoint);
		}

		draw_sprite_stretched_ext(FORMS_SprRound4, 0, X, Y, _width, _height,
			_mouseOver ? _backgroundColorHover : _backgroundColor,
			_mouseOver ? _backgroundAlphaHover : _backgroundAlpha);
		draw_text_color(
			round(X + (_width - _iconWidth) / 2),
			round(Y + (_height - _iconHeight) / 2),
			_string,
			_color, _color, _color, _color, _alpha);
		draw_set_font(_fontPrev);
		__move_or_nl(_width);

		FORMS_PEN_RETURN_MOUSE_STATE;
	}

	/// @func icon_regular(_icon[, _props])
	///
	/// @desc Draws a Font Awesome icon using the "regular" font and moves the pen by its width (or adds a new line, if
	/// {@link FORMS_Pen.AutoNewline} is enabled).
	///
	/// @param {Real} _icon The icon to draw. Use values from
	/// {@link FA_ERegular}.
	/// @param {Struct.FORMS_PenIconRegularProps, Undefined} [_props] Properties to apply to the icon or `undefined`
	/// (default).
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static icon_regular = function (_icon, _props = undefined)
	{
		gml_pragma("forceinline");
		return icon(_icon, forms_get_prop(_props, "Font") ?? FA_FntRegular12, _props);
	}

	/// @func icon_solid(_icon[, _props])
	///
	/// @desc Draws a Font Awesome icon using the "solid" font and moves the pen by its width (or adds a new line, if
	/// {@link FORMS_Pen.AutoNewline} is enabled).
	///
	/// @param {Real} _icon The icon to draw. Use values from {@link FA_ESolid}.
	/// @param {Struct.FORMS_PenIconSolidProps, Undefined} [_props] Properties to apply to the icon or `undefined`
	/// (default).
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static icon_solid = function (_icon, _props = undefined)
	{
		gml_pragma("forceinline");
		return icon(_icon, forms_get_prop(_props, "Font") ?? FA_FntSolid12, _props);
	}

	/// @func icon_brands(_icon[, _props])
	///
	/// @desc Draws a Font Awesome icon using the "brands" font and moves the pen by its width (or adds a new line, if
	/// {@link FORMS_Pen.AutoNewline} is enabled).
	///
	/// @param {Real} _icon The icon to draw. Use values from {@link FA_EBrands}.
	/// @param {Struct.FORMS_PenIconBrandsProps, Undefined} [_props] Properties to apply to the icon or `undefined`
	/// (default).
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static icon_brands = function (_icon, _props = undefined)
	{
		gml_pragma("forceinline");
		return icon(_icon, forms_get_prop(_props, "Font") ?? FA_FntBrands12, _props);
	}

	/// @func vsep([_props])
	///
	/// @desc Draws a vertical separator.
	///
	/// @param {Struct, Undefined} [_props] Properties to apply to the separator or `undefined`.
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	static vsep = function (_props = undefined)
	{
		__assert_started();

		var _color = forms_get_prop(_props, "Color") ?? c_dkgray;
		var _alpha = forms_get_prop(_props, "Alpha") ?? 1.0;
		var _width = forms_get_prop(_props, "Width") ?? __lineHeight;
		var _height = forms_get_prop(_props, "Height") ?? __lineHeight;

		forms_draw_rectangle(X + floor(_width / 2), Y, 1, _height, _color, _alpha);

		__move_or_nl(_width);

		return self;
	}

	/// @func button(_text[, _props])
	///
	/// @desc Draws a button and moves the pen by its width (or adds a new line, if {@link FORMS_Pen.AutoNewline} is
	/// enabled).
	///
	/// @param {String} _text The button's text.
	/// @param {Struct.FORMS_PenButtonProps, Undefined} [_props] Properties to apply to the button or `undefined`
	/// (default).
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static button = function (_text, _props = undefined)
	{
		__assert_started();

		var _color = forms_get_prop(_props, "Color") ?? c_white;
		var _alpha = forms_get_prop(_props, "Alpha") ?? 1.0;
		var _textWidth = string_width(_text);
		var _padding = forms_get_prop(_props, "Padding") ?? 8;
		var _width = forms_get_prop(_props, "Width") ?? _textWidth + _padding * 2;
		var _height = forms_get_prop(_props, "Height") ?? __lineHeight;
		var _backgroundColor = forms_get_prop(_props, "BackgroundColor") ?? 0x424242;
		var _backgroundAlpha = forms_get_prop(_props, "BackgroundAlpha") ?? 1.0;
		var _backgroundColorHover = forms_get_prop(_props, "BackgroundColorHover") ?? 0x555555;
		var _backgroundAlphaHover = forms_get_prop(_props, "BackgroundAlphaHover") ?? 1.0;
		var _mouseOver = is_mouse_over(X, Y, _width, _height);

		if (_mouseOver)
		{
			forms_set_tooltip(forms_get_prop(_props, "Tooltip"));
			forms_set_cursor(cr_handpoint);
		}

		draw_sprite_stretched_ext(FORMS_SprRound4, 0, X, Y, _width, _height,
			_mouseOver ? _backgroundColorHover : _backgroundColor,
			_mouseOver ? _backgroundAlphaHover : _backgroundAlpha);
		draw_text_color(X + _padding, Y, _text, _color, _color, _color, _color, _alpha);
		__move_or_nl(_width);

		FORMS_PEN_RETURN_MOUSE_STATE;
	}

	/// @func color(_id, _color[, _props])
	///
	/// @desc Draws a color input that opens a color picker when clicked and moves the pen by its width (or adds a new
	/// line, if {@link FORMS_Pen.AutoNewline} is enabled).
	///
	/// @func {String} _id The ID of the color input.
	/// @func {Struct.FORMS_Color} _color The color to be mixed.
	/// @func {Struct.FORMS_PenColorProps, Undefined} [_props] Properties to apply to the color input or `undefined`.
	///
	/// @return {Bool} Returns `true` if the color has changed. The new color can be retrieved using method
	/// {@link FORMS_Pen.get_result}.
	static color = function (_id, _color, _props = undefined)
	{
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
			forms_set_tooltip(forms_get_prop(_props, "Tooltip"));
			forms_set_cursor(cr_handpoint);

			if (forms_mouse_check_button_pressed(mb_left))
			{
				var _colorPickerId = _id + "#color-picker";

				if (forms_get_root().find_widget(_colorPickerId) == undefined)
				{
					// TODO: Window auto fit content
					var _colorPickerWidth = 200;
					var _colorPickerHeight = 370;
					var _colorPickerPos = get_absolute_pos(X, Y + _height);
					var _colorPicker = new FORMS_ColorPicker(_id, _color,
					{
						Id: _colorPickerId,
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
	/// @desc Draws a checkbox and moves the pen by its width (or adds a new line, if {@link FORMS_Pen.AutoNewline} is
	/// enabled).
	///
	/// @param {Bool} _checked Whether the checkbox is checked (`true`) or not (`false`).
	/// @param {Struct.FORMS_PenCheckboxProps, Undefined} [_props] Properties to apply to the checkbox or `undefined`
	/// (default).
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static checkbox = function (_checked, _props = undefined)
	{
		__assert_started();

		var _width = __lineHeight;
		var _height = __lineHeight;
		var _backgroundColor = forms_get_prop(_props, "BackgroundColor") ?? 0x171717;
		var _backgroundAlpha = forms_get_prop(_props, "BackgroundAlpha") ?? 1.0;
		var _mouseOver = is_mouse_over(X, Y, _width, _height);

		if (_mouseOver)
		{
			forms_set_tooltip(forms_get_prop(_props, "Tooltip"));
			forms_set_cursor(cr_handpoint);
		}

		// Border
		if (_mouseOver)
		{
			var _borderColor = forms_get_prop(_props, "BorderColor") ?? 0x9D9D9D;
			var _borderAlpha = forms_get_prop(_props, "BorderAlpha") ?? 1.0;

			draw_sprite_stretched_ext(FORMS_SprRound4, 0, X - 1, Y - 1, _width + 2, _height + 2, _borderColor,
				_borderAlpha);
		}

		// Background
		draw_sprite_stretched_ext(FORMS_SprRound4, 0, X, Y, _width, _height, _backgroundColor, _backgroundAlpha);

		// Icon
		if (_checked)
		{
			var _color = forms_get_prop(_props, "Color") ?? global.formsAccentColor;
			var _alpha = forms_get_prop(_props, "Alpha") ?? 1.0;

			fa_draw(FA_FntSolid12, FA_ESolid.Check, X + 2, Y, _color, _alpha);
		}

		__move_or_nl(_width);

		FORMS_PEN_RETURN_MOUSE_STATE;
	}

	/// @func radio(_selected[, _props])
	///
	/// @desc Draws a radio button and moves the pen by its width (or adds a new line, if {@link FORMS_Pen.AutoNewline}
	/// is enabled).
	///
	/// @param {Bool} _selected Whether the radio button is selected (`true`) or not (`false`).
	/// @param {Struct.FORMS_PenRadioProps, Undefined} [_props] Properties to apply to the radio button or `undefined`
	/// (default).
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static radio = function (_selected, _props = undefined)
	{
		__assert_started();

		var _width = __lineHeight;
		var _height = __lineHeight;
		var _backgroundColor = forms_get_prop(_props, "BackgroundColor") ?? 0x171717;
		var _backgroundAlpha = forms_get_prop(_props, "BackgroundAlpha") ?? 1.0;
		var _mouseOver = is_mouse_over(X, Y, _width, _height);

		if (_mouseOver)
		{
			forms_set_tooltip(forms_get_prop(_props, "Tooltip"));
			forms_set_cursor(cr_handpoint);
		}

		// Background
		draw_sprite_stretched_ext(FORMS_SprRadioButton, 0, X, Y, _width, _height, _backgroundColor,
			_backgroundAlpha);
		// Border
		if (_mouseOver)
		{
			var _borderColor = forms_get_prop(_props, "BorderColor") ?? 0x9D9D9D;
			var _borderAlpha = forms_get_prop(_props, "BorderAlpha") ?? 1.0;

			draw_sprite_stretched_ext(FORMS_SprRadioButton, 1, X, Y, _width, _height, _borderColor, _borderAlpha);
		}
		// Tick
		if (_selected)
		{
			var _color = forms_get_prop(_props, "Color") ?? global.formsAccentColor;
			var _alpha = forms_get_prop(_props, "Alpha") ?? 1.0;

			draw_sprite_stretched_ext(FORMS_SprRadioButton, 2, X, Y, _width, _height, _color, _alpha);
		}

		__move_or_nl(_width);

		FORMS_PEN_RETURN_MOUSE_STATE;
	}

	/// @func slider(_id, _value, _min, _max[, _props])
	///
	/// @desc Draws a slider and moves the pen by its width (or adds a new line, if {@link FORMS_Pen.AutoNewline} is
	/// enabled).
	///
	/// @param {String} _id The ID of the slider.
	/// @param {Real} _value The current slider value.
	/// @param {Real} _min The minimum slider value.
	/// @param {Real} _max The maximum slider value.
	/// @param {Struct.FORMS_PenSliderProps, Undefined} [_props] Properties to apply to the slider or `undefined`
	/// (default).
	///
	/// @return {Bool} Returns `true` if the slider value has changed. The new value can be retrieved using method
	/// {@link FORMS_Pen.get_result}.
	static slider = function (_id, _value, _min, _max, _props = undefined)
	{
		__assert_started();

		_id = __make_id(_id);

		var _valueNew = clamp(_value, _min, _max);
		var _width = forms_get_prop(_props, "Width") ?? get_control_width();
		var _height = __lineHeight;
		var _color = forms_get_prop(_props, "Color") ?? c_white;
		var _alpha = forms_get_prop(_props, "Alpha") ?? 1.0;
		var _fillColor = forms_get_prop(_props, "FillColor") ?? 0x424242;
		var _fillAlpha = forms_get_prop(_props, "FillAlpha") ?? 1.0;
		var _backgroundColor = forms_get_prop(_props, "BackgroundColor") ?? 0x171717;
		var _backgroundAlpha = forms_get_prop(_props, "BackgroundAlpha") ?? 1.0;
		var _sliderColor = forms_get_prop(_props, "SliderColor") ?? c_silver;
		var _sliderAlpha = forms_get_prop(_props, "SliderAlpha") ?? 1.0;
		var _mouseOver = is_mouse_over(X, Y, _width, _height, _id);

		// Border
		if (_mouseOver || __widgetActive == _id)
		{
			var _borderColor = forms_get_prop(_props, "BorderColor") ?? 0x9D9D9D;
			var _borderAlpha = forms_get_prop(_props, "BorderAlpha") ?? 1.0;

			draw_sprite_stretched_ext(FORMS_SprRound4, 0, X - 1, Y - 1, _width + 2, _height + 2, _borderColor,
				_borderAlpha);
		}
		// Background
		draw_sprite_stretched_ext(FORMS_SprRound4, 0, X, Y, _width, _height, _backgroundColor, _backgroundAlpha);
		// Fill
		var _fillWidth = ((_valueNew - _min) / (_max - _min)) * _width;
		draw_sprite_stretched_ext(FORMS_SprRound4, 0, X, Y, _fillWidth, _height, _fillColor, _fillAlpha);
		// Slider
		draw_sprite_stretched_ext(FORMS_SprSlider, 0, X + _fillWidth - 1, Y - 1, 3, _height + 2, _sliderColor,
			_sliderAlpha);
		// Text
		if (forms_get_prop(_props, "ShowText") ?? true)
		{
			forms_draw_text(X + 4, Y, (forms_get_prop(_props, "Pre") ?? "") + string(_value) + (forms_get_prop(
				_props, "Post") ?? ""), _color, _alpha);
		}

		if (_mouseOver)
		{
			if (forms_mouse_check_button_pressed(mb_left))
			{
				__widgetActive = _id; // Start dragging
			}

			forms_set_tooltip(forms_get_prop(_props, "Tooltip"));
			forms_set_cursor(cr_handpoint);
		}

		if (__widgetActive == _id)
		{
			if (!mouse_check_button(mb_left))
			{
				__widgetActive = undefined; // Stop dragging
			}

			_valueNew = lerp(_min, _max, clamp((forms_mouse_get_x() - X) / _width, 0, 1));
			if (forms_get_prop(_props, "Integers") ?? false)
			{
				_valueNew = floor(_valueNew);
			}

			forms_set_cursor(cr_handpoint);
		}

		__move_or_nl(_width);

		if (_value != _valueNew)
		{
			forms_return_result(_id, _valueNew);
		}
		return __consume_result(_id);
	}

	/// @func dropdown(_id, _value, _options[, _props])
	///
	/// @desc Draws a dropdown then opens a menu with available options when clicked and moves the pen by its width (or
	/// adds a new line, if {@link FORMS_Pen.AutoNewline} is enabled).
	///
	/// @param {String} _id The ID of the dropdown.
	/// @param {Real} _value The index of the currently selected option.
	/// @param {Array} _options An array of all available options.
	/// @param {Struct.FORMS_PenDropdownProps, Undefined} [_props] Properties to apply to the dropdown or `undefined`
	/// (default).
	///
	/// @return {Bool} Returns `true` if a new option was selected. The new index of the selected option can be
	/// retrieved using method {@link FORMS_Pen.get_result}.
	static dropdown = function (_id, _value, _options, _props = undefined)
	{
		__assert_started();

		_id = __make_id(_id);

		var _width = forms_get_prop(_props, "Width") ?? get_control_width();
		var _height = __lineHeight;
		var _padding = forms_get_prop(_props, "Padding") ?? 4;
		var _backgroundColor = forms_get_prop(_props, "BackgroundColor") ?? 0x424242;
		var _backgroundAlpha = forms_get_prop(_props, "BackgroundAlpha") ?? 1.0;
		var _caretColor = forms_get_prop(_props, "CaretColor") ?? c_white;
		var _caretAlpha = forms_get_prop(_props, "CaretAlpha") ?? 0.5;
		var _color = forms_get_prop(_props, "Color") ?? c_white;
		var _alpha = forms_get_prop(_props, "Alpha") ?? 1.0;
		var _mouseOver = is_mouse_over(X, Y, _width, _height, _id);

		// Background
		draw_sprite_stretched_ext(FORMS_SprRound4, 0, X, Y, _width, _height, _backgroundColor, _backgroundAlpha);
		// Caret icon
		fa_draw(FA_FntSolid12, FA_ESolid.CaretDown, X + _width - 16, Y - 2, _caretColor, _caretAlpha);

		// Find current value
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

		// Draw current value
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
			forms_draw_text(X + _padding, Y, _text, _color, _alpha);
			if (_shortened && _mouseOver)
			{
				forms_set_tooltip(_textOriginal);
			}
		}

		if (_mouseOver)
		{
			// Open dropdown options
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
						Container,
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

	/// @private
	static __input_cut = function ()
	{
		__input_copy();

		if (__inputIndexFrom != __inputIndexTo)
		{
			__input_delete_selected();
		}
		else
		{
			__inputString = "";
			__inputIndexFrom = 1;
			__inputIndexTo = 1;
		}
	}

	/// @private
	static __input_copy = function ()
	{
		var _indexMin, _indexMax;

		if (__inputIndexFrom != __inputIndexTo)
		{
			_indexMin = min(__inputIndexFrom, __inputIndexTo);
			_indexMax = max(__inputIndexFrom, __inputIndexTo);
		}
		else
		{
			_indexMin = 1;
			_indexMax = string_length(__inputString) + 1;
		}

		clipboard_set_text(string_copy(__inputString, _indexMin, _indexMax - _indexMin));
	}

	/// @private
	static __input_paste = function ()
	{
		__input_delete_selected();
		var _clipboard = clipboard_get_text();
		__inputString = string_insert(_clipboard, __inputString, __inputIndexFrom);
		__inputIndexFrom += string_length(_clipboard);
		__inputIndexTo = __inputIndexFrom;
	}

	/// @private
	static __input_select_all = function ()
	{
		__inputIndexFrom = 1;
		__inputIndexTo = string_length(__inputString) + 1;
	}

	/// @private
	static __input_delete_selected = function ()
	{
		if (__inputIndexFrom != __inputIndexTo)
		{
			var _indexMin = min(__inputIndexFrom, __inputIndexTo);
			var _indexMax = max(__inputIndexFrom, __inputIndexTo);
			__inputString = string_delete(__inputString, _indexMin, _indexMax - _indexMin);
			__inputIndexFrom = _indexMin;
			__inputIndexTo = _indexMin;
		}
	}

	/// @func input(_id, _value[, _props])
	///
	/// @desc Draws an input (text or numeric) and moves the pen by its width (or adds a new line, if
	/// {@link FORMS_Pen.AutoNewline} is enabled).
	///
	/// @param {String} _id The ID of the input.
	/// @param {String, Real} _value The value inside of the input.
	/// @param {Struct, Undefined} [_props] Properties to apply to the input or `undefined` (default).
	///
	/// @return {Bool} Returns `true` if the input value has changed. The new value can be retrieved using method
	/// {@link FORMS_Pen.get_result}.
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
		var _textX = _x + _padding;
		var _disabled = forms_get_prop(_props, "Disabled") ?? false;
		var _mouseOver = (!_disabled && is_mouse_over(_x, _y, _width, _height, _id));
		var _secret = forms_get_prop(_props, "Secret") ?? false;

		var _displayColor = _disabled ? c_gray : c_white;
		var _displayString;
		var _fromX;
		var _toX;
		var _click = false;

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//
		// Update input
		//

		if (_mouseOver)
		{
			var _doSelect = false;

			// Open context menu on RMB click
			if (forms_mouse_check_button_pressed(mb_right))
			{
				var _options = [];

				{
					var _option = new FORMS_ContextMenuOption("Cut");
					_option.KeyboardShortcut = new FORMS_KeyboardShortcut([vk_control, ord("X")]);
					_option.Action = method(self, __input_cut);
					array_push(_options, _option);
				}

				{
					var _option = new FORMS_ContextMenuOption("Copy");
					_option.KeyboardShortcut = new FORMS_KeyboardShortcut([vk_control, ord("C")]);
					_option.Action = method(self, __input_copy);
					array_push(_options, _option);
				}

				{
					var _option = new FORMS_ContextMenuOption("Paste");
					_option.KeyboardShortcut = new FORMS_KeyboardShortcut([vk_control, ord("V")]);
					_option.Action = method(self, __input_paste);
					array_push(_options, _option);
				}

				{
					var _option = new FORMS_ContextMenuOption("Select All");
					_option.KeyboardShortcut = new FORMS_KeyboardShortcut([vk_control, ord("A")]);
					_option.Action = method(self, __input_select_all);
					array_push(_options, _option);
				}

				var _contextMenu = new FORMS_ContextMenu(_options,
				{
					X: window_mouse_get_x(),
					Y: window_mouse_get_y(),
					TargetControl: _id,
				});
				forms_get_root().add_child(_contextMenu);

				_doSelect = true;
			}

			// Select the input on LMB click
			_click = forms_mouse_check_button_pressed(mb_left);

			if ((_doSelect || _click) && __inputId != _id)
			{
				if (__inputId != undefined)
				{
					forms_return_result(__inputId, is_real(__inputValue)
						? (forms_parse_real(__inputString) ?? __inputValue)
						: __inputString);
				}
				__inputId = _id;
				forms_get_root().KeyboardUsed = true;
				__inputValue = _value;
				__inputString = string(__inputValue);
				__inputIndexFrom = 1;
				__inputIndexTo = string_length(__inputString) + 1;
				__inputIndexDraw = 1;

				_click = false; // Consume click to avoid selecting text right away!
			}

			// Use beam cursor on mouse-over
			forms_set_cursor(cr_beam);
		}

		if (__inputId == _id)
		{
			////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// Input *IS* active
			//

			// Handle repeat of a held-down keyboard key
			// TODO: Make input repeat speed configurable
			var _acceptInput = false;
			if (keyboard_check_pressed(vk_anykey))
			{
				__inputTimer = -300;
				_acceptInput = true;
			}
			else if (keyboard_check(vk_anykey))
			{
				__inputTimer += delta_time * 0.001;
				if (__inputTimer >= 50)
				{
					__inputTimer = 0;
					_acceptInput = true;
				}
			}

			// Handle input
			if (_acceptInput)
			{
				if (keyboard_check(vk_control))
				{
					if (keyboard_check(ord("A")))
					{
						__input_select_all();
					}
					else if (keyboard_check(ord("C")))
					{
						__input_copy();
					}
					else if (keyboard_check(ord("X")))
					{
						__input_cut();
					}
					else if (keyboard_check(ord("V")))
					{
						__input_paste();
					}
				}
				else if (!forms_key_is_control_key(keyboard_key))
				{
					if (__inputIndexFrom != __inputIndexTo)
					{
						__input_delete_selected();
					}
					__inputString = string_insert(keyboard_lastchar, __inputString, __inputIndexFrom++);
					__inputIndexTo = __inputIndexFrom;
				}
				else if (keyboard_check(vk_backspace))
				{
					if (__inputIndexFrom != __inputIndexTo)
					{
						__input_delete_selected();
					}
					else if (__inputIndexFrom > 1)
					{
						__inputString = string_delete(__inputString, --__inputIndexFrom, 1);
						__inputIndexTo = __inputIndexFrom;
					}
				}
				else if (keyboard_check(vk_delete))
				{
					if (__inputIndexFrom == __inputIndexTo)
					{
						__inputString = string_delete(__inputString, __inputIndexFrom, 1);
					}
					else
					{
						__input_delete_selected();
					}
				}
				else if (keyboard_check(vk_left))
				{
					if (keyboard_check(vk_shift))
					{
						if (__inputIndexTo > 1)
						{
							--__inputIndexTo;
						}
					}
					else
					{
						if (__inputIndexFrom != __inputIndexTo)
						{
							__inputIndexFrom = min(__inputIndexFrom, __inputIndexTo);
							__inputIndexTo = __inputIndexFrom;
						}
						else if (__inputIndexFrom > 1)
						{
							__inputIndexTo = --__inputIndexFrom;
						}
					}
				}
				else if (keyboard_check(vk_right))
				{
					if (keyboard_check(vk_shift))
					{
						if (__inputIndexTo <= string_length(__inputString))
						{
							++__inputIndexTo;
						}
					}
					else
					{
						if (__inputIndexFrom != __inputIndexTo)
						{
							__inputIndexFrom = max(__inputIndexFrom, __inputIndexTo);
							__inputIndexTo = __inputIndexFrom;
						}
						else if (__inputIndexFrom <= string_length(__inputString))
						{
							__inputIndexTo = ++__inputIndexFrom;
						}
					}
				}
			}

			// Trim text from the left based on the position of the input cursor
			var _inputStringLength = string_length(__inputString);
			_displayString = _secret ? string_repeat("*", _inputStringLength) : __inputString;

			__inputIndexDraw = clamp(__inputIndexDraw, 1, _inputStringLength + 1);

			var _drawX = string_width(string_copy(_displayString, 1, __inputIndexDraw - 1));
			_fromX = string_width(string_copy(_displayString, 1, __inputIndexFrom - 1)) - _drawX;
			_toX = string_width(string_copy(_displayString, 1, __inputIndexTo - 1)) - _drawX;

			// TODO: This looks terrible for performance. We should come up with something better...
			while (_toX > (_width - _padding * 2) && __inputIndexDraw <= _inputStringLength)
			{
				++__inputIndexDraw;
				_drawX = string_width(string_copy(_displayString, 1, __inputIndexDraw - 1));
				_fromX = string_width(string_copy(_displayString, 1, __inputIndexFrom - 1)) - _drawX;
				_toX = string_width(string_copy(_displayString, 1, __inputIndexTo - 1)) - _drawX;
			}

			while (_toX < 0 && __inputIndexDraw > 1)
			{
				--__inputIndexDraw;
				_drawX = string_width(string_copy(_displayString, 1, __inputIndexDraw - 1));
				_fromX = string_width(string_copy(_displayString, 1, __inputIndexFrom - 1)) - _drawX;
				_toX = string_width(string_copy(_displayString, 1, __inputIndexTo - 1)) - _drawX;
			}

			_displayString = string_delete(_displayString, 1, __inputIndexDraw - 1);

			// Trim text from the right so it doesn't overflow the input
			var _stringLength = string_length(_displayString);
			while (string_width(_displayString) > (_width - _padding * 2) && _displayString != "")
			{
				_displayString = string_delete(_displayString, _stringLength--, 1);
			}

			// Rectangle select with mouse
			var _mouseIndex = 0;
			repeat(string_length(_displayString))
			{
				if (_textX + string_width(string_copy(_displayString, 1, _mouseIndex + 1))
					> forms_mouse_get_x())
				{
					break;
				}
				++_mouseIndex;
			}
			_mouseIndex += __inputIndexDraw;

			if (_click)
			{
				if (!keyboard_check(vk_shift))
				{
					__inputIndexFrom = _mouseIndex;
				}
				__inputSelect = true;
				__inputSelectTimer = 0;
			}

			if (!mouse_check_button(mb_left))
			{
				__inputSelect = false;
			}

			if (__inputSelect)
			{
				var _tick = false;

				__inputSelectTimer += delta_time * 0.001;
				if (__inputSelectTimer >= 50)
				{
					__inputSelectTimer = 0;
					_tick = true;
				}

				if ((forms_mouse_get_x() - _textX) > (_width - _padding * 2))
				{
					if (_tick)
					{
						__inputIndexTo = min(__inputIndexTo + 1, string_length(__inputString) + 1);
					}
				}
				else if (forms_mouse_get_x() < _textX)
				{
					if (_tick)
					{
						__inputIndexTo = max(__inputIndexTo - 1, 1);
					}
				}
				else
				{
					__inputIndexTo = _mouseIndex;
				}

				// Use beam cursor when selecting text
				forms_set_cursor(cr_beam);
			}
		}
		else
		{
			////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// Input is *NOT* active
			//

			// Display placeholder or the input value?
			_displayString = forms_has_result(_id) ? string(forms_peek_result(_id)) : string(_value);
			if (_displayString == "")
			{
				_displayString = forms_get_prop(_props, "Placeholder") ?? "";
				_displayColor = c_gray;
			}
			else if (_secret)
			{
				_displayString = string_repeat("*", string_length(_displayString));
			}

			// Trim display string from the right
			// TODO: Make trim direction configurable
			var _stringLength = string_length(_displayString);
			var _trimmed = false;
			while (string_width(_displayString) > (_width - _padding * 2) && _displayString != "")
			{
				_displayString = string_delete(_displayString, _stringLength--, 1);
				_trimmed = true;
			}

			// Show tooltip
			if (_mouseOver)
			{
				var _tooltip = forms_get_prop(_props, "Tooltip");
				if (_tooltip != undefined)
				{
					forms_set_tooltip(_tooltip);
				}
				else if (_trimmed && !_secret)
				{
					forms_set_tooltip(string(_value));
				}
			}
		}

		// Return new value on Enter or click outside of the input
		if (__inputId == _id
			&& (keyboard_check_pressed(vk_enter) || (!_mouseOver && mouse_check_button_pressed(mb_any))))
		{
			var _doReturn = true;

			// Check whether we haven't selected an option in a context menu that was opened by this input
			var _hovered = forms_get_root().WidgetHovered;
			if (_hovered != undefined
				&& is_instanceof(_hovered, FORMS_ContextMenu)
				&& _hovered.TargetControl == _id)
			{
				_doReturn = false;
			}

			if (_doReturn)
			{
				var _valueNew = is_real(__inputValue)
					? (forms_parse_real(__inputString) ?? __inputValue)
					: __inputString;
				if (__inputValue != _valueNew)
				{
					forms_return_result(_id, _valueNew);
				}
				__inputId = undefined;
				forms_get_root().KeyboardUsed = false;
			}
		}

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//
		// Draw input
		//

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

		// Selection rectangle
		if (__inputId == _id && __inputIndexFrom != __inputIndexTo)
		{
			var _minX = min(_fromX, _toX);
			var _rectX = _minX;
			var _rectWidth = max(_fromX, _toX) - _minX;

			_rectX = clamp(_rectX, 0, _width - _padding * 2);
			_rectWidth = clamp(_rectWidth, 1, _width - _padding * 2 - _rectX);

			forms_draw_rectangle(_textX + _rectX, _y, _rectWidth, __lineHeight, global.formsAccentColor, 1.0);
		}

		// Text
		forms_draw_text(_textX, _y, _displayString, _displayColor, 1.0);

		// Input beam
		if (__inputId == _id && __inputIndexFrom == __inputIndexTo)
		{
			var _alpha = (keyboard_check(vk_anykey) || mouse_check_button(mb_any))
				? 1.0 : dsin(current_time * 0.5) * 0.5 + 0.5;

			forms_draw_rectangle(_textX + _fromX, _y, 1, __lineHeight, global.formsAccentColor, _alpha);
		}

		__move_or_nl(_width);

		return __consume_result(_id);
	}

	/// @func tree_item(_text[, _props])
	///
	/// @desc Draws a tree item.
	///
	/// @param {String} _text The name of the tree item.
	/// @param {Struct, Undefined} [_props] Properties to apply to the tree item or `undefined` (default).
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static tree_item = function (_text, _props = undefined)
	{
		// TODO: Add struct FORMS_PenInputProps
		__assert_started();

		var _action = FORMS_EControlAction.None;

		var _iconWidth = forms_get_prop(_props, "IconWidth") ?? 24;
		var _icon = forms_get_prop(_props, "Icon");
		var _iconFont = forms_get_prop(_props, "IconFont") ?? FA_FntRegular12;
		var _iconCollapsed = forms_get_prop(_props, "IconCollapsed");
		var _iconCollapsedFont = forms_get_prop(_props, "IconCollapsedFont");
		var _iconColor = forms_get_prop(_props, "IconColor") ?? c_white;
		var _iconAlpha = forms_get_prop(_props, "IconAlpha") ?? 1.0;
		var _caretColor = forms_get_prop(_props, "CaretColor") ?? c_white;
		var _caretAlpha = forms_get_prop(_props, "CaretAlpha") ?? 1.0;

		var _hasChildren = forms_get_prop(_props, "HasChildren") ?? false;
		var _collapsed = forms_get_prop(_props, "Collapsed") ?? false;
		var _selected = forms_get_prop(_props, "Selected") ?? false;

		var _spacingY = floor(SpacingY / 2);
		var _backgroundX = Container.ScrollX;
		var _backgroundY = Y - _spacingY;
		var _backgroundWidth = Container.__realWidth; //Width
		var _backgroundHeight = __lineHeight + _spacingY * 2;

		var _mouseOver = is_mouse_over(_backgroundX, _backgroundY, _backgroundWidth, _backgroundHeight);

		if (_mouseOver)
		{
			_action = FORMS_EControlAction.MouseOver;
		}

		if (_selected)
		{
			forms_draw_rectangle(_backgroundX, _backgroundY, _backgroundWidth, _backgroundHeight, 0x766056, 1.0);
		}

		// Caret
		if (_hasChildren)
		{
			var _iconProps = {
				Color: _caretColor,
				Alpha: _caretAlpha,
				Width: _iconWidth,
				BackgroundColorHover: c_white,
				BackgroundAlphaHover: 0.1,
			};
			if (icon_solid(_collapsed ? FA_ESolid.CaretRight : FA_ESolid.CaretDown, _iconProps))
			{
				_action = FORMS_EControlAction.CaretClick;
			}
		}
		else
		{
			move(_iconWidth);
		}

		// Icon
		var _iconFinal = (_collapsed || !_hasChildren) ? (_iconCollapsed ?? _icon) : _icon;
		if (_iconFinal != undefined)
		{
			var _iconFontFinal = (_collapsed || !_hasChildren) ? (_iconCollapsedFont ?? _iconFont) : _iconFont;
			icon(_iconFinal, _iconFontFinal,
			{
				Color: _iconColor,
				Alpha: _iconAlpha,
				Width: _iconWidth,
				BackgroundColorHover: c_white,
				BackgroundAlphaHover: 0.1
			});
		}

		// Text
		if (link(_text) || (_mouseOver && forms_mouse_check_button_pressed(mb_left)))
		{
			_action = FORMS_EControlAction.Click;
		}

		__move_or_nl(_backgroundWidth - X);

		return _action;
	}

	/// @func section(_text[, _props])
	///
	/// @desc Draws a section, begins a new line and increases the current indentation level.
	///
	/// @param {String} _text The name of the section.
	/// @param {Struct, Undefined} [_props] Properties to apply to the section or `undefined` (default).
	///
	/// @return {Bool} Returns `true` if the section is expanded or `false` if it's collapsed.
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
	/// @desc Ends a section previously started with {@link FORMS_Pen.section} (which must have returned `true`) and
	/// decreases the current indentation level.
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

	/// @func destroy()
	///
	/// @desc Destroys the pen.
	///
	/// @return {Undefined} Always returns `undefined`.
	static destroy = function ()
	{
		if (__inputId != undefined)
		{
			forms_get_root().KeyboardUsed = false;
		}
		return undefined;
	}
}
