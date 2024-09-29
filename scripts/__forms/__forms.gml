/// @var {Constant.Color} The accent color. Used for example as color of the
/// tick icon in selected checboxes or the circle icon in selected radio buttons.
/// Default value is `0x5B9D00` ("GameMaker green").
global.formsAccentColor = 0x5B9D00;

/// @func forms_assert(_expr, _message)
///
/// @desc Shows an error if given expression doesn't evaluate to `true`.
///
/// @param {Bool} _expr The expression to check.
/// @param {String} _message The error message to show if expression is `false`.
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
/// @desc Draws a rectangle using a stretched sprite to save on batch breaks.
///
/// @param {Real} _x The X position of the rectangle.
/// @param {Real} _y The Y position of the rectangle.
/// @param {Real} _width The width of the rectangle.
/// @param {Real} _height The height of the rectangle.
/// @param {Constant.Color} [_color] The color of the rectangle. Defaults to
/// `c_white`.
/// @param {Real} [_alpha] The alpha value of the rectangle. Defaults to 1.
function forms_draw_rectangle(_x, _y, _width, _height, _color=c_white, _alpha=1.0)
{
	gml_pragma("forceinline");
	draw_sprite_stretched_ext(FORMS_SprRectangle, 0, _x, _y, _width, _height, _color, _alpha);
}

/// @func forms_char_is_digit(_char)
///
/// @desc Checks whether given character is a digit.
///
/// @param {String} _char The character to check.
///
/// @return {Bool} Returns `true` if the character is a digit.
function forms_char_is_digit(_char)
{
	gml_pragma("forceinline");
	return (_char >= "0" && _char <= "9");
}

/// @func forms_char_is_letter(_char)
///
/// @desc Checks whether given character is a letter.
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
/// @desc Tries to parse a real number from a string.
///
/// @param {String} _string The string to parse the number from.
///
/// @return {Real, Undefined} The parsed number or `undefined` if the string
/// does not represent a number.
///
/// @example
/// The following code tries to parse a number from a variable `_userInput`
/// (string) and stores the result into `_number`. If parsing fails, it defaults
/// to 0.
/// ```gml
/// var _number = forms_parse_real(_userInput) ?? 0;
/// ```
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
