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

	LineHeight = undefined;

	LineSpace = 2;

	AutoNewline = false;

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

	__started = false;
	__columnX = 0;
	__fontBackup = -1;
	__lineHeight = 0;

	__widgetActive = undefined;

	__dropdownId = undefined;
	__dropdownIndex = 0;
	__dropdownValues = undefined;
	__dropdownX = 0;
	__dropdownY = 0;
	__dropdownWidth = 0;

	__inputId = undefined;
	__inputValue = undefined;

	__result = undefined;

	static get_result = function ()
	{
		var _result = __result;
		__result = undefined;
		return _result;
	};

	static __consume_result = function (_id)
	{
		if (forms_has_result(_id))
		{
			__result = forms_get_result(_id);
			return true;
		}
		return false;
	};

	static __assert_started = function ()
	{
		gml_pragma("forceinline");
		forms_assert(__started, "Must call method start first!");
	};

	static start = function (_x=0, _y=0)
	{
		forms_assert(!__started, "Must use method finish first!");
		forms_get_root(); // Note: Asserts!
		__started = true;
		X = _x;
		Y = _y;
		MaxX = _x;
		MaxY = _y;
		__columnX = _x;
		__fontBackup = draw_get_font();
		if (Font != undefined)
		{
			draw_set_font(Font);
		}
		__lineHeight = LineHeight ?? string_height("M");
		return self;
	};

	static move = function (_x)
	{
		X += _x;
		MaxX = max(MaxX, X);
		return self;
	};

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

	static text = function (_text, _props=undefined)
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
			forms_set_cursor(forms_get_prop(_props, "Cursor") ?? forms_get_cursor());
		}
		draw_text_color(X, Y, _text, _c, _c, _c, _c, _a);
		__move_or_nl(string_width(_text));
		return self;
	};

	static link = function (_text, _props=undefined)
	{
		__assert_started();
		var _c = forms_get_prop(_props, "Color") ?? c_orange;
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
		return (_mouseOver && forms_mouse_check_button_pressed(mb_left));
	};

	static is_mouse_over = function (_x, _y, _width, _height, _id=undefined)
	{
		var _root = forms_get_root();
		return (_root.WidgetHovered == Content.Container
			&& forms_mouse_in_rectangle(_x, _y, _width, _height)
			&& (_root.WidgetActive == _id || _root.WidgetActive == undefined));
	};

	static button = function (_text, _props=undefined)
	{
		__assert_started();
		var _c = forms_get_prop(_props, "Color") ?? c_white;
		var _a = forms_get_prop(_props, "Alpha") ?? 1.0;
		var _textWidth = string_width(_text);
		var _textHeight = string_height(_text);
		var _mouseOver = is_mouse_over(X, Y, _textWidth, _textHeight);
		if (_mouseOver)
		{
			forms_draw_rectangle(X, Y, _textWidth, _textHeight, c_white, 0.3);
			forms_set_tooltip(forms_get_prop(_props, "Tooltip"));
			forms_set_cursor(cr_handpoint);
		}
		draw_text_color(X, Y, _text, _c, _c, _c, _c, _a);
		__move_or_nl(_textWidth);
		return (_mouseOver && forms_mouse_check_button_pressed(mb_left));
	};

	static checkbox = function (_checked, _props=undefined)
	{
		__assert_started();
		var _width = __lineHeight;
		var _height = __lineHeight;
		var _mouseOver = is_mouse_over(X, Y, _width, _height);
		forms_draw_rectangle(X, Y, _width, _height, _checked ? c_orange : c_white);
		if (_mouseOver)
		{
			forms_set_tooltip(forms_get_prop(_props, "Tooltip"));
			forms_set_cursor(cr_handpoint);
		}
		__move_or_nl(_width);
		return (_mouseOver && forms_mouse_check_button_pressed(mb_left));
	};

	static radio = function (_selected, _props=undefined)
	{
		__assert_started();
		var _width = __lineHeight;
		var _height = __lineHeight;
		var _mouseOver = is_mouse_over(X, Y, _width, _height);
		draw_sprite_stretched_ext(FORMS_SprRadioButton, 0, X, Y, _width, _height, _selected ? c_orange : c_white, 1.0);
		if (_mouseOver)
		{
			forms_set_tooltip(forms_get_prop(_props, "Tooltip"));
			forms_set_cursor(cr_handpoint);
		}
		__move_or_nl(_width);
		return (_mouseOver && forms_mouse_check_button_pressed(mb_left));
	};

	static __make_id = function (_id)
	{
		gml_pragma("forceinline");
		return Content.Container.Id + "#" + _id;
	};

	static slider = function (_id, _value, _min, _max, _props=undefined)
	{
		__assert_started();
		_id = __make_id(_id);
		var _valueNew = clamp(_value, _min, _max);
		var _width = forms_get_prop(_props, "Width") ?? 200;
		var _height = __lineHeight;
		var _mouseOver = is_mouse_over(X, Y, _width, _height, _id);
		forms_draw_rectangle(X, Y, _width, _height, c_white, 0.5);
		forms_draw_rectangle(X, Y, ((_valueNew - _min) / (_max - _min)) * _width, _height, c_orange, 0.5);
		draw_text(X, Y, (forms_get_prop(_props, "Pre") ?? "") + string(_value) + (forms_get_prop(_props, "Post") ?? ""));
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

	static dropdown = function (_id, _index, _values, _props=undefined)
	{
		__assert_started();
		_id = __make_id(_id);
		var _width = forms_get_prop(_props, "Width") ?? 200;
		var _height = __lineHeight;
		var _mouseOver = is_mouse_over(X, Y, _width, _height, _id);
		forms_draw_rectangle(X, Y, _width, _height, c_white, 0.5);
		if (_index >= 0 && _index < array_length(_values))
		{
			draw_text(X, Y, _values[_index]);
		}
		if (_mouseOver)
		{
			if (forms_mouse_check_button_pressed(mb_left))
			{
				var _world = matrix_get(matrix_world);
				var _dropdown = new FORMS_Dropdown(_id, _values, _index, _width, {
					X: Content.Container.__realX + X + _world[12],
					Y: Content.Container.__realY + Y + _height + _world[13],
				});
				forms_get_root().add_child(_dropdown);
			}
			forms_set_cursor(cr_handpoint);
		}
		__move_or_nl(_width);
		return __consume_result(_id);
	};

	static input = function (_id, _value, _props=undefined)
	{
		__assert_started();
		_id = __make_id(_id);

		var _x = X;
		var _y = Y;
		var _width = forms_get_prop(_props, "Width") ?? 200;
		var _height = __lineHeight;
		var _mouseOver = is_mouse_over(_x, _y, _width, _height, _id);

		if (_mouseOver)
		{
			if (forms_mouse_check_button_pressed(mb_left) && __inputId != _id)
			{
				if (__inputId != undefined)
				{
					forms_return_result(__inputId, is_real(__inputValue) ? real(keyboard_string) : keyboard_string);
				}
				__inputId = _id;
				__inputValue = _value;
				keyboard_string = string(__inputValue);
			}
			forms_set_cursor(cr_beam);
		}

		forms_draw_rectangle(_x, _y, _width, _height, c_white, 0.5);

		if (__inputId == _id)
		{
			var _displayString = keyboard_string + "|";
			while (string_width(_displayString) > _width && _displayString != "")
			{
				_displayString = string_delete(_displayString, 1, 1);
			}
			draw_text(_x, _y, _displayString);
		}
		else
		{
			var _displayString = forms_has_result(_id) ? string(forms_peek_result(_id)) : string(_value);
			var _displayColor = c_white;
			if (_displayString == "")
			{
				_displayString = forms_get_prop(_props, "Placeholder") ?? "";
				_displayColor = c_gray;
			}
			var _stringLength = string_length(_displayString);
			var _trimmed = false;
			while (string_width(_displayString) > _width && _displayString != "")
			{
				_displayString = string_delete(_displayString, _stringLength--, 1);
				_trimmed = true;
			}
			draw_text_color(_x, _y, _displayString, _displayColor, _displayColor, _displayColor, _displayColor, 1.0);
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
			var _valueNew = is_real(__inputValue) ? real(keyboard_string) : keyboard_string;
			if (__inputValue != _valueNew)
			{
				forms_return_result(_id, _valueNew);
			}
			__inputId = undefined;
		}

		return __consume_result(_id);
	};

	static nl = function (_count=1)
	{
		gml_pragma("forceinline");
		__assert_started();
		X = __columnX;
		Y += (__lineHeight + LineSpace) * _count;
		MaxX = max(MaxX, X);
		MaxY = max(MaxY, Y);
		return self;
	};

	static finish = function ()
	{
		__assert_started();

		__started = false;

		draw_set_font(__fontBackup);

		return self;
	};

	static destroy = function ()
	{
		return undefined;
	};
}
