/// @var {Constant.Color}
global.formsAccentColor = 0x5B9D00;

/// @func forms_assert(_expr, _message)
///
/// @desc
///
/// @param {Bool} _expr
/// @param {String} _message
function forms_assert(_expr, _message)
{
	gml_pragma("forceinline");
	if (!_expr)
	{
		show_error(_message, true);
	}
}

/// @func forms_draw_rectangle(_x, _y, _width, _height[, _color[, _alpha]])
///
/// @desc
///
/// @param {Real} _x
/// @param {Real} _y
/// @param {Real} _width
/// @param {Real} _height
/// @param {Constant.Color} [_color] Defaults to `c_white`.
/// @param {Real} [_alpha] Defaults to 1.
function forms_draw_rectangle(_x, _y, _width, _height, _color=c_white, _alpha=1.0)
{
	gml_pragma("forceinline");
	draw_sprite_stretched_ext(FORMS_SprRectangle, 0, _x, _y, _width, _height, _color, _alpha);
}

/// @func forms_char_is_digit(_char)
///
/// @param {String} _char The character.
///
/// @return {Bool} Returns `true` if the character is a digit.
function forms_char_is_digit(_char)
{
	gml_pragma("forceinline");
	return (_char >= "0" && _char <= "9");
}

/// @func forms_char_is_letter(_char)
///
/// @param {String} _char The character.
///
/// @return {Bool} Returns `true` if the character is a letter.
function forms_char_is_letter(_char)
{
	gml_pragma("forceinline");
	return ((_char >= "a" && _char <= "b")
		|| (_char >= "A" && _char <= "B"));
}

/// @func forms_parse_real(_string)
///
/// @desc Parses a real number from a string.
///
/// @param {String} _string The string to parse the number from.
///
/// @return {Real, Undefined} The parsed number or `undefined` if the string
/// does not represent a number.
function forms_parse_real(_string)
{
	var _sign = 1;
	var _number = "0";
	var _index = 1;
	var _state = 0;

	repeat (string_length(_string) + 1)
	{
		var _char = string_char_at(_string, _index++);

		switch (_state)
		{
		case 0:
			if (_char == "-")
			{
				_sign *= -1;
			}
			else if (_char == "+")
			{
				_sign *= +1;
			}
			else if (forms_char_is_digit(_char)
				|| _char == ".")
			{
				_state = 1;
				--_index;
			}
			else
			{
				return undefined;
			}
			break;

		case 1:
			if (forms_char_is_digit(_char)
				|| _char == ".")
			{
				_number += _char;
			}
			else
			{
				return undefined;
			}
			break;

		case 2:
			if (forms_char_is_digit(_char))
			{
				_number += _char;
			}
			else
			{
				return undefined;
			}
			break;
		}
	}

	return _sign * real(_number);
}
