/// @func FORMS_Pen()
///
/// @desc
function FORMS_Pen() constructor
{
	Font = -1;

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

	__result = undefined;
	__asyncResults = {};

	__dropdownId = undefined;
	__dropdownIndex = 0;
	__dropdownValues = undefined;
	__dropdownX = 0;
	__dropdownY = 0;
	__dropdownWidth = 0;

	__inputId = undefined;
	__inputValue = undefined;

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
		draw_set_font(Font);
		__lineHeight = LineHeight ?? string_height("M");
		__result = undefined;
		return self;
	};

	static __move = function (_x)
	{
		if (AutoNewline)
		{
			nl();
		}
		else
		{
			X += _x;
			MaxX = max(MaxX, X);
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
		__move(string_width(_text));
		return self;
	};

	static link = function (_text, _props=undefined)
	{
		__assert_started();
		var _c = forms_get_prop(_props, "Color") ?? c_aqua;
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
		__move(string_width(_text));
		return (_mouseOver && mouse_check_button_pressed(mb_left));
	};

	static is_mouse_over = function (_x, _y, _width, _height, _id=undefined)
	{
		var _mouseX = forms_mouse_get_x();
		var _mouseY = forms_mouse_get_y();
		return (_mouseX >= _x && _mouseX < _x + _width
			&& _mouseY >= _y && _mouseY < _y + _height
			&& (_id == undefined || __widgetActive == _id || __widgetActive == undefined));
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
			draw_rectangle(X, Y, X + _textWidth - 1, Y + _textHeight - 1, true);
			forms_set_tooltip(forms_get_prop(_props, "Tooltip"));
			forms_set_cursor(cr_handpoint);
		}
		draw_text_color(X, Y, _text, _c, _c, _c, _c, _a);
		__move(_textWidth);
		return (_mouseOver && mouse_check_button_pressed(mb_left));
	};

	static checkbox = function (_checked, _props=undefined)
	{
		__assert_started();
		var _width = __lineHeight;
		var _height = __lineHeight;
		var _mouseOver = is_mouse_over(X, Y, _width, _height);
		draw_rectangle(X, Y, X + _width - 1, Y + _height - 1, !_checked);
		if (_mouseOver)
		{
			forms_set_tooltip(forms_get_prop(_props, "Tooltip"));
			forms_set_cursor(cr_handpoint);
		}
		__move(_width);
		return (_mouseOver && mouse_check_button_pressed(mb_left));
	};

	static radio = function (_selected, _props=undefined)
	{
		__assert_started();
		var _width = __lineHeight;
		var _height = __lineHeight;
		var _radius = _width / 2;
		var _mouseOver = is_mouse_over(X, Y, _width, _height);
		draw_circle(X + _radius, Y + _radius, _radius, !_selected);
		if (_mouseOver)
		{
			forms_set_tooltip(forms_get_prop(_props, "Tooltip"));
			forms_set_cursor(cr_handpoint);
		}
		__move(_width);
		return (_mouseOver && mouse_check_button_pressed(mb_left));
	};

	static slider = function (_id, _value, _min, _max, _props=undefined)
	{
		__assert_started();
		var _valueNew = clamp(_value, _min, _max);
		var _changed = false;
		var _width = forms_get_prop(_props, "Width") ?? 200;
		var _height = __lineHeight;
		var _mouseOver = is_mouse_over(X, Y, _width, _height, _id);
		draw_rectangle(X, Y, X + _width - 1, Y + _height - 1, true);
		draw_text(X, Y, (forms_get_prop(_props, "Pre") ?? "") + string(_value) + (forms_get_prop(_props, "Post") ?? ""));
		if (_mouseOver)
		{
			if (mouse_check_button_pressed(mb_left))
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
			__result = _valueNew;
			_changed = true;
		}
		__move(_width);
		return _changed;
	};

	static __consume_result = function (_id, _value)
	{
		var _changed = false;
		if (variable_struct_exists(__asyncResults, _id))
		{
			var _valueNew = __asyncResults[$ _id];
			if (_value != _valueNew)
			{
				__result = _valueNew;
				_changed = true;
			}
			variable_struct_remove(__asyncResults, _id);
		}
		return _changed;
	};

	static dropdown = function (_id, _index, _values, _props=undefined)
	{
		__assert_started();
		var _width = forms_get_prop(_props, "Width") ?? 200;
		var _height = __lineHeight;
		var _mouseOver = is_mouse_over(X, Y, _width, _height, _id);
		draw_rectangle(X, Y, X + _width - 1, Y + _height - 1, true);
		if (_index >= 0 && _index < array_length(_values))
		{
			draw_text(X, Y, _values[_index]);
		}
		if (_mouseOver)
		{
			if (mouse_check_button_pressed(mb_left))
			{
				__dropdownId = _id;
				__dropdownIndex = _index;
				__dropdownValues = _values;
				__dropdownX = X;
				__dropdownY = Y + _height;
				__dropdownWidth = _width;
			}
			forms_set_cursor(cr_handpoint);
		}
		__move(_width);
		return __consume_result(_id, _index);
	};

	static __dropdown_options = function ()
	{
		var _x = __dropdownX;
		var _y = __dropdownY;
		var _select = undefined;
		for (var i = 0; i < array_length(__dropdownValues); ++i)
		{
			var _value = string(__dropdownValues[i]);
			var _valueWidth = max(string_width(_value), __dropdownWidth);
			draw_rectangle_color(_x, _y, _x + _valueWidth - 1, _y + __lineHeight - 1, 0, 0, 0, 0, false);
			if (is_mouse_over(_x, _y, _valueWidth, __lineHeight))
			{
				draw_rectangle(_x, _y, _x + _valueWidth - 1, _y + __lineHeight - 1, true);
				if (mouse_check_button_pressed(mb_left))
				{
					_select = i;
				}
				forms_set_cursor(cr_handpoint);
			}
			else if (i == __dropdownIndex)
			{
				draw_rectangle(_x, _y, _x + _valueWidth - 1, _y + __lineHeight - 1, true);
			}
			draw_text(_x, _y, _value);
			_y += __lineHeight;
		}
		if (_select != undefined)
		{
			__asyncResults[$ __dropdownId] = _select;
			__dropdownId = undefined;
			__dropdownValues = undefined;
		}
	};

	static input = function (_id, _value, _props=undefined)
	{
		__assert_started();
	
		var _x = X;
		var _y = Y;
		var _width = forms_get_prop(_props, "Width") ?? 200;
		var _height = __lineHeight;
		var _mouseOver = is_mouse_over(_x, _y, _width, _height, _id);

		if (_mouseOver)
		{
			if (mouse_check_button_pressed(mb_left) && __inputId != _id)
			{
				if (__inputId != undefined)
				{
					__asyncResults[$ __inputId] =
						is_real(__inputValue) ? real(keyboard_string) : keyboard_string;
				}
				__inputId = _id;
				__inputValue = _value;
				keyboard_string = string(__inputValue);
			}
			forms_set_cursor(cr_beam);
		}

		draw_rectangle(_x, _y, _x + _width - 1, _y + _height - 1, true);
	
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
			var _displayString = string(_value);
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

		__move(_width);

		if (__inputId == _id && (keyboard_check_pressed(vk_enter)
			|| (mouse_check_button_pressed(mb_left) && !_mouseOver)))
		{
			__inputId = undefined;
			var _valueNew = is_real(__inputValue) ? real(keyboard_string) : keyboard_string;
			if (__inputValue != _valueNew)
			{
				__result = _valueNew;
				return true;
			}
		}

		return __consume_result(_id, _value);
	};

	static get_result = function ()
	{
		var _result = __result;
		__result = undefined;
		return _result;
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

		if (__dropdownId != undefined)
		{
			__dropdown_options();
		}

		draw_set_font(__fontBackup);

		return self;
	};

	static destroy = function ()
	{
		return undefined;
	};
}
