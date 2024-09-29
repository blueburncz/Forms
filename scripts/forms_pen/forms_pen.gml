/// @enum
enum FORMS_EControlAction
{
	MouseOver = -2,
	RightClick = -1,
	None = 0,
	Click = 1,
};

/// @enum
enum FORMS_EPenLayout
{
	Horizontal,
	Vertical,
	Column2,
};

/// @func FORMS_Pen(_content)
///
/// @desc
///
/// @param {Struct.FORMS_Content} _content
function FORMS_Pen(_content) constructor
{
	/// @var {Struct.FORMS_Content}
	/// @readonly
	Content = _content;

	/// @var {Asset.GMFont, Undefined}
	Font = undefined;

	/// @var {Real, Undefined}
	LineHeight = undefined;

	/// @var {Bool}
	AutoNewline = false;

	/// @var {Real}
	PaddingX = 8;

	/// @var {Real}
	PaddingY = 8;

	/// @var {Real}
	SpacingX = 0;

	/// @var {Real}
	SpacingY = 8;

	/// @var {Real}
	/// @readonly
	X = 0;

	/// @var {Real}
	/// @readonly
	Y = 0;

	/// @var {Real}
	/// @readonly
	MaxX = 0;

	/// @var {Real}
	/// @readonly
	MaxY = 0;

	/// @var {Real}
	StartX = 0;

	/// @var {Real}
	StartY = 0;

	/// @var {Real}
	/// @readonly
	Width = 0;

	/// @var {Real}
	ColumnX1 = 0;

	/// @var {Real}
	ColumnX2 = 0;

	/// @var {Real}
	__columnWidth = 0;

	/// @private
	__columnCurrent = 0;

	/// @var {Real}
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
	/// @desc
	///
	/// @return {Real}
	static get_column_width = function ()
	{
		return __columnWidth;
	};

	/// @func get_control_width()
	///
	/// @desc
	///
	/// @return {Real}
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
	};

	/// @func get_result()
	///
	/// @desc
	///
	/// @return {Any}
	static get_result = function ()
	{
		var _result = __result;
		__result = undefined;
		return _result;
	};

	/// @private
	static __consume_result = function (_id)
	{
		if (forms_has_result(_id))
		{
			__result = forms_get_result(_id);
			return true;
		}
		return false;
	};

	/// @private
	static __assert_started = function ()
	{
		gml_pragma("forceinline");
		forms_assert(__started, "Must call method start first!");
	};

	/// @func set_layout(_layout)
	///
	/// @desc
	///
	/// @param {Real} _layout Use values from {@link FORMS_EPenLayout}.
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	static set_layout = function (_layout)
	{
		__assert_started();
		__layout = _layout;
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
			ColumnX1 = StartX;
			ColumnX2 = StartY + __columnWidth;
			break;
		}
		return self;
	};

	/// @func start([_layout])
	///
	/// @desc
	///
	/// @param {Real} [_layout] Use values from {@link FORMS_EPenLayout}.
	/// Defaults to {@link FORMS_EPenLayout.Horizontal}.
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	static start = function (_layout=FORMS_EPenLayout.Horizontal)
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
		Width = Content.Container.__realWidth - X * 2;
		set_layout(_layout);
		return self;
	};

	/// @func move([_x])
	///
	/// @desc
	///
	/// @param {Real} [_x]
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	///
	/// @see FORMS_Pen.SpacingX
	static move = function (_x)
	{
		X += _x + SpacingX;
		MaxX = max(MaxX, X);
		return self;
	};

	/// @func set_x(_x)
	///
	/// @desc
	///
	/// @param {Real} _x
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	static set_x = function (_x)
	{
		X = _x;
		MaxX = max(MaxX, X);
		return self;
	};

	/// @func get_max_x()
	///
	/// @desc
	///
	/// @return {Real}
	static get_max_x = function ()
	{
		return MaxX + PaddingX;
	};

	/// @func get_max_y()
	///
	/// @desc
	///
	/// @return {Real}
	static get_max_y = function ()
	{
		return MaxY + PaddingY;
	};

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
	};

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
	};

	/// @func text(_text[, _props])
	///
	/// @desc
	///
	/// @param {String} _text
	/// @param {Struct, Undefined} [_props]
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	static text = function (_text, _props=undefined)
	{
		__assert_started();
		var _textOriginal = _text;
		var _c = forms_get_prop(_props, "Color") ?? c_white;
		var _a = forms_get_prop(_props, "Alpha") ?? 1.0;
		var _textWidth = string_width(_text);
		var _width = forms_get_prop(_props, "Width") ?? get_control_width(); //_textWidth;
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
	};

	/// @func link(_text[, _props])
	///
	/// @desc
	///
	/// @param {String} _text
	/// @param {Struct, Undefined} [_props]
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static link = function (_text, _props=undefined)
	{
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
			return forms_mouse_check_button_pressed(mb_left)
				? FORMS_EControlAction.Click
				: FORMS_EControlAction.MouseOver;
		}
		return FORMS_EControlAction.None;
	};

	/// @func is_mouse_over(_x, _y, _width, _height[, _id])
	///
	/// @desc
	///
	/// @param {Real} _x
	/// @param {Real} _y
	/// @param {Real} _width
	/// @param {Real} _height
	/// @param {String, Undefined} [_id]
	///
	/// @return {Bool}
	static is_mouse_over = function (_x, _y, _width, _height, _id=undefined)
	{
		var _root = forms_get_root();
		return (_root.WidgetHovered == Content.Container
			&& forms_mouse_in_rectangle(_x, _y, _width, _height)
			&& (_root.WidgetActive == _id || _root.WidgetActive == undefined));
	};

	/// @func get_absolute_pos(_x, _y)
	///
	/// @desc
	///
	/// @param {Real} _x
	/// @param {Real} _y
	///
	/// @return {Array<Real>}
	static get_absolute_pos = function (_x, _y)
	{
		var _world = matrix_get(matrix_world);
		return [
			Content.Container.__realX + _x + _world[12],
			Content.Container.__realY + _y + _world[13],
		];
	};

	/// @func icon_regular(_icon, _font[, _props])
	///
	/// @desc
	///
	/// @param {Real} _icon Use values from {@link FA_ERegular}.
	/// @param {Asset.GMFont} _font
	/// @param {Struct, Undefined} [_props]
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static icon = function (_icon, _font, _props=undefined)
	{
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
			return forms_mouse_check_button_pressed(mb_left)
				? FORMS_EControlAction.Click
				: FORMS_EControlAction.MouseOver;
		}
		return FORMS_EControlAction.None;
	};

	/// @func icon_regular(_icon[, _props])
	///
	/// @desc
	///
	/// @param {Real} _icon Use values from {@link FA_ERegular}.
	/// @param {Struct, Undefined} [_props]
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static icon_regular = function (_icon, _props=undefined)
	{
		gml_pragma("forceinline");
		return icon(_icon, forms_get_prop(_props, "Font") ?? FA_FntRegular12, _props);
	};

	/// @func icon_solid(_icon[, _props])
	///
	/// @desc
	///
	/// @param {Real} _icon Use values from {@link FA_ESolid}.
	/// @param {Struct, Undefined} [_props]
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static icon_solid = function (_icon, _props=undefined)
	{
		gml_pragma("forceinline");
		return icon(_icon, forms_get_prop(_props, "Font") ?? FA_FntSolid12, _props);
	};

	/// @func icon_brands(_icon[, _props])
	///
	/// @desc
	///
	/// @param {Real} _icon Use values from {@link FA_EBrands}.
	/// @param {Struct, Undefined} [_props]
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static icon_brands = function (_icon, _props=undefined)
	{
		gml_pragma("forceinline");
		return icon(_icon, forms_get_prop(_props, "Font") ?? FA_FntBrands12, _props);
	};

	/// @func button(_text[, _props])
	///
	/// @desc
	///
	/// @param {String} _text
	/// @param {Struct, Undefined} [_props]
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static button = function (_text, _props=undefined)
	{
		__assert_started();
		var _c = forms_get_prop(_props, "Color") ?? c_white;
		var _a = forms_get_prop(_props, "Alpha") ?? 1.0;
		var _textWidth = string_width(_text);
		var _textHeight = string_height(_text);
		var _padding = forms_get_prop(_props, "Padding") ?? 8;
		var _width = forms_get_prop(_props, "Width") ?? _textWidth + _padding * 2;
		var _height = forms_get_prop(_props, "Height") ?? __lineHeight;
		var _mouseOver = is_mouse_over(X, Y, _width, _height);
		draw_sprite_stretched_ext(FORMS_SprRound4, 0, X, Y, _width, _height, 0x424242, 1.0);
		if (_mouseOver)
		{
			forms_set_tooltip(forms_get_prop(_props, "Tooltip"));
			forms_set_cursor(cr_handpoint);
		}
		draw_text_color(X + _padding, Y, _text, _c, _c, _c, _c, _a);
		__move_or_nl(_width);
		if (_mouseOver)
		{
			return forms_mouse_check_button_pressed(mb_left)
				? FORMS_EControlAction.Click
				: FORMS_EControlAction.MouseOver;
		}
		return FORMS_EControlAction.None;
	};

	/// @func color(_id, _color[, _props])
	///
	/// @desc
	///
	/// @func {String} _id
	/// @func {Real} _color
	/// @func {Struct, Undefined} [_props]
	///
	/// @return {Bool} Returns true if the value has changed. New value can be
	/// retrieved using method {@link FORMS_Pen.get_result}.
	static color = function (_id, _color, _props=undefined)
	{
		__assert_started();
		_id = __make_id(_id);
		var _width = forms_get_prop(_props, "Width") ?? min(get_control_width(), 50);
		var _height = __lineHeight;
		var _mouseOver = is_mouse_over(X, Y, _width, _height);
		draw_sprite_stretched(FORMS_SprColor, 0, X, Y, _width, _height);
		draw_sprite_stretched_ext(
			FORMS_SprRound4, 0,
			X, Y,
			_width, _height,
			_color & 0xFFFFFF, ((_color >> 24) & 0xFF) / 255.0);
		if (_mouseOver)
		{
			forms_set_cursor(cr_handpoint);
			if (forms_mouse_check_button_pressed(mb_left))
			{
				var _world = matrix_get(matrix_world);
				// TODO: Window auto fit content
				var _colorPickerWidth = 200;
				var _colorPickerHeight = 180;
				var _colorPickerPos = get_absolute_pos(X, Y + _height);
				var _colorPicker = new FORMS_ColorPicker(_id, _color, {
					Width: _colorPickerWidth,
					Height: _colorPickerHeight,
					X: clamp(_colorPickerPos[0], 0, window_get_width() - _colorPickerWidth),
					Y: clamp(_colorPickerPos[1], 0, window_get_height() - _colorPickerHeight),
				});
				forms_get_root().add_child(_colorPicker);
			}
		}
		__move_or_nl(_width);
		return __consume_result(_id);
	};

	/// @func checkbox(_checked[, _props])
	///
	/// @desc
	///
	/// @param {Bool} _checked
	/// @param {Struct, Undefined} [_props]
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static checkbox = function (_checked, _props=undefined)
	{
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
			return forms_mouse_check_button_pressed(mb_left)
				? FORMS_EControlAction.Click
				: FORMS_EControlAction.MouseOver;
		}
		return FORMS_EControlAction.None;
	};

	/// @func radio(_selected[, _props])
	///
	/// @desc
	///
	/// @param {Bool} _selected
	/// @param {Struct, Undefined} [_props]
	///
	/// @return {Real} Returns a value from {@link FORMS_EControlAction}.
	static radio = function (_selected, _props=undefined)
	{
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
			return forms_mouse_check_button_pressed(mb_left)
				? FORMS_EControlAction.Click
				: FORMS_EControlAction.MouseOver;
		}
		return FORMS_EControlAction.None;
	};

	/// @private
	static __make_id = function (_id)
	{
		gml_pragma("forceinline");
		return Content.Container.Id + "#" + _id;
	};

	/// @func slider(_id, _value, _min, _max[, _props])
	///
	/// @desc
	///
	/// @param {String} _id
	/// @param {Real} _value
	/// @param {Real} _min
	/// @param {Real} _max
	/// @param {Struct, Undefined} [_props]
	///
	/// @return {Bool} Returns true if the value has changed. New value can be
	/// retrieved using method {@link FORMS_Pen.get_result}.
	static slider = function (_id, _value, _min, _max, _props=undefined)
	{
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
		draw_sprite_stretched_ext(FORMS_SprRound4, 0, X, Y, ((_valueNew - _min) / (_max - _min)) * _width, _height, 0x424242, 1.0);
		draw_sprite_stretched_ext(FORMS_SprSlider, 0, X + ((_valueNew - _min) / (_max - _min)) * _width - 1, Y - 1, 3, _height + 2, c_silver, 1.0);

		if (forms_get_prop(_props, "ShowText") ?? true)
		{
			draw_text(X + 4, Y, (forms_get_prop(_props, "Pre") ?? "") + string(_value) + (forms_get_prop(_props, "Post") ?? ""));
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
		}
		if (forms_get_prop(_props, "Integers") ?? false)
		{
			_valueNew = floor(_valueNew);
		}
		if (_value != _valueNew)
		{
			forms_return_result(_id, _valueNew);
		}
		__move_or_nl(_width);
		return __consume_result(_id);
	};

	/// @func dropdown(_id, _value, _options[, _props])
	///
	/// @desc
	///
	/// @param {String} _id
	/// @param {Real} _value
	/// @param {Array} _options
	/// @param {Struct, Undefined} [_props]
	///
	/// @return {Bool} Returns true if the value has changed. New value can be
	/// retrieved using method {@link FORMS_Pen.get_result}.
	static dropdown = function (_id, _value, _options, _props=undefined)
	{
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
		repeat (_index + 1)
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
				if (__dropdowns[$ _id] == undefined
					|| !weak_ref_alive(__dropdowns[$ _id]))
				{
					var _dropdownPos = get_absolute_pos(X, Y + _height);
					var _dropdown = new FORMS_Dropdown(_id, _options, _index, _width, {
						X: _dropdownPos[0],
						Y: _dropdownPos[1],
					});
					forms_get_root().add_child(_dropdown);
					__dropdowns[$ _id] = weak_ref_create(_dropdown);
				}
				else
				{
					__dropdowns[$ _id].ref.destroy_later();
					__dropdowns[$ _id] = undefined;
				}
			}
			forms_set_cursor(cr_handpoint);
		}
		__move_or_nl(_width);
		return __consume_result(_id);
	};

	/// @func input(_id, _value[, _props])
	///
	/// @desc
	///
	/// @param {String} _id
	/// @param {String, Real} _value
	/// @param {Struct, Undefined} [_props]
	///
	/// @return {Bool} Returns true if the value has changed. New value can be
	/// retrieved using method {@link FORMS_Pen.get_result}.
	static input = function (_id, _value, _props=undefined)
	{
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
		draw_sprite_stretched_ext(FORMS_SprRound4, 0, _x, _y, _width, _height, _disabled ? 0x101010 : 0x171717, 1.0);

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
			forms_draw_rectangle(_x + _padding + _stringWidth, _y, 2, __lineHeight, global.formsAccentColor, _alpha);
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
			draw_text_color(_x + _padding, _y, _displayString, _displayColor, _displayColor, _displayColor, _displayColor, 1.0);

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
	};

	/// @func section(_text[, _props])
	///
	/// @desc
	///
	/// @param {String} _text
	/// @param {Struct, Undefined} [_props]
	///
	/// @return {Bool} Returns `true` if the section is expanded.
	static section = function (_text, _props=undefined)
	{
		__assert_started();
		var _id = forms_get_prop(_props, "Id") ?? _text;
		__sectionExpanded[$ _id] ??= !(forms_get_prop(_props, "Collapsed") ?? false);
		var _width = Width;
		var _height = forms_get_prop(_props, "Height") ?? __lineHeight;
		var _indent = __sectionCurrent * SectionIndent;
		var _mouseOver = is_mouse_over(StartX, Y, _width, _height);
		draw_sprite_stretched_ext(FORMS_SprRound4, 0, StartX, Y, _width, _height, 0x3F3F3F, 1.0);
		fa_draw(FA_FntSolid12, __sectionExpanded[$ _id] ? FA_ESolid.AngleDown : FA_ESolid.AngleRight, StartX + _indent + 4, Y, c_white, 0.5);
		draw_text(StartX + _indent + SectionIndent, Y, _text);
		if (_mouseOver)
		{
			forms_set_tooltip(forms_get_prop(_props, "Tooltip"));
			forms_set_cursor(cr_handpoint);
		}
		if (_mouseOver && forms_mouse_check_button_pressed(mb_left))
		{
			__sectionExpanded[$ _id] = !__sectionExpanded[$ _id];
		}
		if (__sectionExpanded[$ _id])
		{
			ColumnX1 += SectionIndent;
			nl();
			++__sectionCurrent;
			return true;
		}
		nl();
		return false;
	};

	/// @func end_section()
	///
	/// @desc
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	static end_section = function ()
	{
		__assert_started();
		ColumnX1 -= SectionIndent;
		--__sectionCurrent;
		nl(0);
		return self;
	};

	/// @func nl([_count])
	///
	/// @desc
	///
	/// @param {Real} [_count]
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	///
	/// @see FORMS_Pen.SpacingY
	static nl = function (_count=1)
	{
		gml_pragma("forceinline");
		__assert_started();

		if (__layout == FORMS_EPenLayout.Column2)
		{
			set_x((__columnCurrent == 0) ? ColumnX1 : ColumnX2);
		}
		else
		{
			set_x(StartX);
		}

		Y += (__lineHeight + SpacingY) * _count;
		MaxY = max(MaxY, Y);

		return self;
	};

	/// @func finish()
	///
	/// @desc
	///
	/// @return {Struct.FORMS_Pen} Returns `self`.
	static finish = function ()
	{
		__assert_started();
		__started = false;
		draw_set_font(__fontBackup);
		return self;
	};
}
