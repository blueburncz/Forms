/// @func FORMS_DropdownProps()
///
/// @extends FORMS_ContainerProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_Dropdown}.
function FORMS_DropdownProps(): FORMS_ContainerProps() constructor {}

/// @func FORMS_Dropdown(_id, _values, _index, _width[, _props])
///
/// @extends FORMS_Container
///
/// @desc A container that draws options of a
/// [dropdown](./FORMS_Pen.dropdown.html).
///
/// @param {String} _id The ID of the dropdown that opened this.
/// @param {Array} _values An array of values to select from.
/// @param {Real} _index The index of the currently selected value.
/// @param {Real} _width The width of the dropdown that opened this.
/// @param {Struct.FORMS_DropdownProps, Undefined} [_props] Properties to create
/// the container with or `undefined`.
function FORMS_Dropdown(_id, _values, _index, _width, _props = undefined): FORMS_Container(_props) constructor
{
	static Container_layout = layout;
	static Container_update = update;
	static Container_draw = draw;

	/// @var {String} The ID of the dropdown that opened this.
	/// @readonly
	DropdownId = _id;

	/// @var {Array} An array of values to select from.
	/// @readonly
	DropdownValues = _values;

	/// @var {Real} The index of the currently selected value.
	/// @readonly
	DropdownIndex = _index;

	/// @var {Real} The width of the dropdown that opened this.
	/// @readonly
	DropdownWidth = _width;

	/// @var {Bool} If `true` then the size of the container is recomputed from
	/// its contents the next time method [layout](./FORMS_Widget.layout.html)
	/// is called. Defaults to `true`.
	ContentFit = true;

	/// @var {Constant.Color} The tint color of the background sprite. Defaults
	/// to `0x181818`.
	BackgroundColor = 0x181818;

	static draw_content = function ()
	{
		var _x = 0;
		var _y = 0;
		var _values = DropdownValues;
		var _index = DropdownIndex;
		var _dropdownWidth = DropdownWidth;
		var _lineHeight = string_height("M");
		var _select = undefined;

		for (var i = 0; i < array_length(_values); ++i)
		{
			var _option = _values[i];
			var _value = string(
				is_struct(_option)
				? (_option[$ "Text"] ?? _option.Value)
				: _option
			);
			var _stringWidth = string_width(_value);
			var _valueWidth = max(_stringWidth, _dropdownWidth);

			if (Pen.is_mouse_over(_x, _y, _valueWidth, _lineHeight))
			{
				forms_draw_rectangle(_x, _y, _valueWidth, _lineHeight, c_white, 0.3);
				if (forms_mouse_check_button_pressed(mb_left))
				{
					_select = i;
				}
				forms_set_cursor(cr_handpoint);
				if (_stringWidth > __realWidth)
				{
					forms_set_tooltip(_value);
				}
			}
			else if (i == _index)
			{
				forms_draw_rectangle(_x, _y, _valueWidth, _lineHeight, c_white, 0.1);
			}

			draw_text(_x, _y, _value);

			_y += _lineHeight;
		}

		if (_select != undefined)
		{
			var _option = _values[_select];
			var _value = is_struct(_option) ? _option.Value : _option;
			forms_return_result(DropdownId, _value);
			destroy_later();
		}

		ContentWidth = _dropdownWidth;
		ContentHeight = _y;

		return self;
	}

	static layout = function ()
	{
		var _windowHeight = window_get_height();
		__realHeight = min(__realHeight, _windowHeight);
		__realX = clamp(__realX, 0, window_get_width() - __realWidth);
		__realY = clamp(__realY, 0, _windowHeight - __realHeight);
		Container_layout();
		return self;
	}

	static update = function (_deltaTime)
	{
		Container_update(_deltaTime);
		if (!is_mouse_over() && mouse_check_button_pressed(mb_left))
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
}
