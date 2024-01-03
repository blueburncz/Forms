/// @func FORMS_Dropdown(_id, _values, _index, _width[, _props])
///
/// @extends FORMS_Container
///
/// @param {String} _id
/// @param {Array} _values
/// @param {Real} _index
/// @param {Real} _width
/// @param {Struct.FORMS_ContainerProps, Undefined} [_props]
function FORMS_Dropdown(_id, _values, _index, _width, _props=undefined)
	: FORMS_Container(undefined, _props) constructor
{
	static Container_layout = layout;
	static Container_update = update;

	set_content(new FORMS_DropdownContent());

	/// @var {String}
	DropdownId = _id;

	/// @var {Array}
	DropdownValues = _values;

	/// @var {Real}
	DropdownIndex = _index;

	/// @var {Real}
	DropdownWidth = _width;

	__contentFit = true;

	static layout = function ()
	{
		if (__contentFit)
		{
			Content.fetch_size();
			__contentFit = false;
		}
		__realWidth = Content.Width;
		__realHeight = Content.Height;
		Container_layout();
		return self;
	};

	static update = function (_deltaTime)
	{
		Container_update(_deltaTime);
		if (!is_mouse_over() && mouse_check_button_pressed(mb_left))
		{
			remove_self();
			destroy();
		}
		return self;
	};
}

/// @func FORMS_DropdownContent()
///
/// @extends FORMS_Content
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
				draw_rectangle(_x, _y, _x + _valueWidth - 1, _y + _lineHeight - 1, true);
				if (forms_mouse_check_button_pressed(mb_left))
				{
					_select = i;
				}
				forms_set_cursor(cr_handpoint);
			}
			else if (i == _index)
			{
				draw_rectangle(_x, _y, _x + _valueWidth - 1, _y + _lineHeight - 1, true);
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
