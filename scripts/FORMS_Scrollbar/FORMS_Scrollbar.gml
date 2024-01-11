function FORMS_Scrollbar(_props=undefined)
	: FORMS_Widget(_props) constructor
{
	__thumbPos = 0;
	__thumbSize = 0;
	__mouseOffset = 0;
}

function FORMS_VScrollbar(_target, _props=undefined)
	: FORMS_Scrollbar(_props) constructor
{
	static Scrollbar_update = update;

	Width.from_props(_props, "Width", 8);

	/// @var {Struct.FORMS_Container}
	Target = _target;

	static update = function (_deltaTime)
	{
		Scrollbar_update(_deltaTime);

		var _scroll = Target.ScrollY;
		var _scrollMax = Target.Content.Height - Target.__realHeight;
		var _scrollLinear = clamp(_scroll / _scrollMax, 0, 1);

		__thumbSize = (Target.__realHeight / Target.Content.Height) * __realHeight;
		__thumbSize = max(__thumbSize, 32);
		__thumbSize = min(__thumbSize, __realHeight);
		__thumbPos = __realY + (__realHeight - __thumbSize) * _scrollLinear;

		var _scrollWheel = is_mouse_over() * (mouse_wheel_down() - mouse_wheel_up()) * string_height("M");
		Target.set_scroll_y(Target.ScrollY + _scrollWheel);

		if (is_mouse_over()
			&& forms_mouse_check_button_pressed(mb_left))
		{
			if (forms_mouse_get_y() > __thumbPos
				&& forms_mouse_get_y() < __thumbPos + __thumbSize)
			{
				__mouseOffset = __thumbPos - forms_mouse_get_y();
			}
			else
			{
				__mouseOffset = -__thumbSize / 2;
			}
			forms_get_root().WidgetActive = self;
		}

		if (forms_get_root().WidgetActive == self)
		{
			var _scrollLinear = (forms_mouse_get_y() - __realY + __mouseOffset) / (__realHeight - __thumbSize);
			var _scrollNew = _scrollLinear * _scrollMax;

			Target.set_scroll_y(_scrollNew);

			if (!mouse_check_button(mb_left))
			{
				forms_get_root().WidgetActive = undefined;
			}
		}

		return self;
	};

	static draw = function ()
	{
		draw_rectangle_color(__realX, __realY, __realX + __realWidth, __realY + __realHeight,
			c_silver, c_silver, c_silver, c_silver, false);
		var _color = (forms_get_root().WidgetActive == self) ? c_orange : c_maroon;
		draw_rectangle_color(__realX, __thumbPos, __realX + __realWidth, __thumbPos + __thumbSize,
			_color, _color, _color, _color, false);
		return self;
	};
}
