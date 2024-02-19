/// @func FORMS_DropdownProps()
///
/// @extends FORMS_ContainerProps
///
/// @desc
function FORMS_DropdownProps()
	: FORMS_ContainerProps() constructor
{
}

/// @func FORMS_Dropdown(_id, _values, _index, _width[, _props])
///
/// @extends FORMS_Container
///
/// @param {String} _id The ID of the dropdown that opened this.
/// @param {Array} _values An array of values to select from.
/// @param {Real} _index The index of the currently selected value.
/// @param {Real} _width The width of the dropdown that opened this.
/// @param {Struct.FORMS_DropdownProps, Undefined} [_props]
function FORMS_Dropdown(_id, _values, _index, _width, _props=undefined)
	: FORMS_Container(undefined, _props) constructor
{
	static Container_layout = layout;
	static Container_update = update;

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

	ContentFit = true;

	{
		set_content(new FORMS_DropdownContent());
	}

	static update = function (_deltaTime)
	{
		Container_update(_deltaTime);
		if (!is_mouse_over() && mouse_check_button_pressed(mb_left))
		{
			destroy_later();
		}
		return self;
	};
}

/// @func FORMS_DropdownContent()
///
/// @extends FORMS_Content
///
/// @desc Draws contents of a {@link FORMS_Dropdown} widget.
function FORMS_DropdownContent()
	: FORMS_Content() constructor
{
	static draw = function ()
	{
		var _x = 0;
		var _y = 0;
		var _values = Container.DropdownValues;
		var _index = Container.DropdownIndex;
		var _dropdownWidth = Container.DropdownWidth;
		var _lineHeight = string_height("M");
		var _select = undefined;

		for (var i = 0; i < array_length(_values); ++i)
		{
			var _value = string(_values[i]);
			var _valueWidth = max(string_width(_value), _dropdownWidth);

			if (Pen.is_mouse_over(_x, _y, _valueWidth, _lineHeight))
			{
				forms_draw_rectangle(_x, _y, _valueWidth, _lineHeight, c_white, 0.3);
				if (forms_mouse_check_button_pressed(mb_left))
				{
					_select = i;
				}
				forms_set_cursor(cr_handpoint);
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
			forms_return_result(Container.DropdownId, _select);
			Container.destroy_later();
		}

		Width = _dropdownWidth;
		Height = _y;

		return self;
	};
}
