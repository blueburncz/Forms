/// @macro {Real} The major version number of Forms.
#macro FORMS_VERSION_MAJOR 0

/// @macro {Real} The minor version number of Forms.
#macro FORMS_VERSION_MINOR 1

/// @macro {Real} The patch version number of Forms.
#macro FORMS_VERSION_PATCH 0

/// @macro {String} The version of Forms as a string "major.minor.patch".
#macro FORMS_VERSION_STRING $"{FORMS_VERSION_MAJOR}.{FORMS_VERSION_MINOR}.{FORMS_VERSION_PATCH}"

/// @var {Constant.Color} The accent color. Used for example as color of the
/// tick icon in selected checboxes or the circle icon in selected radio buttons.
/// Default value is `0x5B9D00` ("GameMaker green").
global.formsAccentColor = 0x5B9D00;

/// @func forms_assert(_expr, _message)
///
/// @desc Calls `show_error(_message, true)` if given expression doesn't
/// evaluate to `true`.
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
function forms_draw_rectangle(_x, _y, _width, _height, _color = c_white, _alpha = 1.0)
{
	gml_pragma("forceinline");
	draw_sprite_stretched_ext(FORMS_SprRectangle, 0, _x, _y, _width, _height, _color, _alpha);
}

/// @func forms_draw_roundrect(_x, _y, _width, _height, [_radius, _color, _alpha])
///
/// @desc Draws a rectangle using a stretched sprite to save on batch breaks.
///
/// @param {Real} _x The X position of the rectangle.
/// @param {Real} _y The Y position of the rectangle.
/// @param {Real} _width The width of the rectangle.
/// @param {Real} _height The height of the rectangle.
/// @param {Real} _radius Corner radius, either 4 or 8. Defaults to 4.
/// @param {Constant.Color} [_color] The color of the rectangle. Defaults to
/// `c_white`.
/// @param {Real} [_alpha] The alpha value of the rectangle. Defaults to 1.
function forms_draw_roundrect(_x, _y, _width, _height, _radius = 4, _color = c_white, _alpha = 1.0)
{
	gml_pragma("forceinline");
	_radius = clamp((_radius div 4) * 4, 4, 8);
	draw_sprite_stretched_ext((_radius == 4) ? FORMS_SprRound4 : FORMS_SprRound8, 0, _x, _y, _width, _height, _color,
		_alpha);
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

	repeat(string_length(_string) + 1)
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

// @var {Id.DsStack}
/// @private
global.__formsScissorStack = ds_stack_create();

/// @var {Array<Real>, Undefined}
/// @private
global.__formsScissorRect = undefined;

/// @func forms_scissor_rect_push(_x, _y, _width, _height)
///
/// @desc Pushes the current scissor rectangle onto a stack and then changes it
/// to the intersection of the current one with the one specified. If there's no
/// scissor rectangle currently set, the size of the window is used instead.
///
/// @param {Real} _x The X coordinate of the top left corner of the scissor
/// rectangle to intersect the current one with.
/// @param {Real} _y The Y coordinate of the top left corner of the scissor
/// rectangle to intersect the current one with.
/// @param {Real} _width The width of the scrissor rectangle to intersect the
/// current one with.
/// @param {Real} _height The height of the scrissor rectangle to intersect the
/// current one with.
///
/// @see forms_scissor_rect_pop
function forms_scissor_rect_push(_x, _y, _width, _height)
{
	ds_stack_push(global.__formsScissorStack, global.__formsScissorRect);
	if (global.__formsScissorRect == undefined)
	{
		global.__formsScissorRect = [_x, _y, _x + _width, _y + _height];
	}
	else
	{
		global.__formsScissorRect = [
			max(global.__formsScissorRect[0], _x),
			max(global.__formsScissorRect[1], _y),
			min(global.__formsScissorRect[2], _x + _width),
			min(global.__formsScissorRect[3], _y + _height)
		];
	}
	gpu_set_scissor(
		global.__formsScissorRect[0],
		global.__formsScissorRect[1],
		global.__formsScissorRect[2] - global.__formsScissorRect[0],
		global.__formsScissorRect[3] - global.__formsScissorRect[1]
	);
}

/// @func forms_scissor_rect_pop()
///
/// @desc Pops a scissor rectangle from the stack and sets it as the current one.
///
/// @see forms_scissor_rect_push
function forms_scissor_rect_pop()
{
	global.__formsScissorRect = ds_stack_top(global.__formsScissorStack);
	ds_stack_pop(global.__formsScissorStack);
	if (global.__formsScissorRect == undefined)
	{
		gpu_set_scissor(0, 0, window_get_width(), window_get_height());
	}
	else
	{
		gpu_set_scissor(
			global.__formsScissorRect[0],
			global.__formsScissorRect[1],
			global.__formsScissorRect[2] - global.__formsScissorRect[0],
			global.__formsScissorRect[3] - global.__formsScissorRect[1]
		);
	}
}
