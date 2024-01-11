/// @func FORMS_ContainerProps()
///
/// @extends FORMS_WidgetProps
function FORMS_ContainerProps()
	: FORMS_WidgetProps() constructor
{
	/// @var {Constant.Color, Undefined}
	BackgroundColor = undefined;

	/// @var {Real, Undefined}
	BackgroundAlpha = undefined;
}

/// @func FORMS_Container([_content[, _props]])
///
/// @extends FORMS_Widget
///
/// @desc
///
/// @param {Struct.FORMS_Content, Undefined} [_content]
/// @param {Struct.FORMS_ContainerProps, Undefined} [_props]
function FORMS_Container(_content=undefined, _props=undefined)
	: FORMS_Widget(_props) constructor
{
	/// @var {Struct.FORMS_Content, Undefined}
	/// @readonly
	Content = undefined;

	set_content(_content);

	/// @var {Id.Surface}
	/// @readonly
	Surface = -1;

	/// @var {Constant.Color}
	BackgroundColor = forms_get_prop(_props, "BackgroundColor") ?? c_black;

	/// @var {Real}
	BackgroundAlpha = forms_get_prop(_props, "BackgroundAlpha") ?? 1.0;

	/// @var {Real}
	/// @readonly
	/// @see FORMS_Container.set_scroll_x
	ScrollX = 0;

	/// @var {Real}
	/// @readonly
	/// @see FORMS_Container.set_scroll_y
	ScrollY = 0;

	/// @var {Bool}
	IsDefaultScrollVertical = true;

	/// @func set_content(_content)
	///
	/// @desc
	///
	/// @param {Struct.FORMS_Content, Undefined} _content
	///
	/// @return {Struct.FORMS_Container} Returns `self`.
	static set_content = function (_content)
	{
		if (Content != undefined)
		{
			Content.Container = undefined;
		}
		Content = _content;
		if (Content != undefined)
		{
			forms_assert(Content.Container == undefined, "Content is already added to a container!");
			Content.Container = self;
		}
		return self;
	};

	/// @func set_scroll_x(_scroll)
	///
	/// @desc
	///
	/// @param {Real} _scroll
	///
	/// @return {Struct.FORMS_Container} Returns `self`.
	static set_scroll_x = function (_scroll)
	{
		ScrollX = clamp(_scroll, 0, max(Content.Width - __realWidth, 0));
		return self;
	};

	/// @func set_scroll_y(_scroll)
	///
	/// @desc
	///
	/// @param {Real} _scroll
	///
	/// @return {Struct.FORMS_Container} Returns `self`.
	static set_scroll_y = function (_scroll)
	{
		ScrollY = clamp(_scroll, 0, max(Content.Height - __realHeight, 0));
		return self;
	};

	static update = function ()
	{
		if (Content != undefined)
		{
			var _scroll = is_mouse_over() * (mouse_wheel_down() - mouse_wheel_up()) * string_height("M");
			if (keyboard_check(vk_control) == IsDefaultScrollVertical)
			{
				ScrollX += _scroll;
			}
			else
			{
				ScrollY += _scroll;
			}
		}
		//else
		//{
		//	ScrollX = 0;
		//	ScrollY = 0;
		//}

		// Clamp scroll
		set_scroll_x(ScrollX);
		set_scroll_y(ScrollY);

		return self;
	};

	static draw = function ()
	{
		if (__realWidth <= 0 || __realHeight <= 0)
		{
			return self;
		}

		if (!surface_exists(Surface))
		{
			Surface = surface_create(__realWidth, __realHeight);
		}
		else if (surface_get_width(Surface) != __realWidth
			|| surface_get_height(Surface) != __realHeight)
		{
			surface_resize(Surface, __realWidth, __realHeight);
		}

		surface_set_target(Surface);
		draw_clear_alpha(BackgroundColor, BackgroundAlpha);
		if (Content != undefined)
		{
			forms_push_mouse_coordinates(__realX - ScrollX, __realY - ScrollY);
			var _world = matrix_get(matrix_world);
			_world[@ 12] -= ScrollX;
			_world[@ 13] -= ScrollY;
			matrix_set(matrix_world, _world);
			Content.draw();
			_world[@ 12] += ScrollX;
			_world[@ 13] += ScrollY;
			matrix_set(matrix_world, _world);
			forms_push_mouse_coordinates(-(__realX - ScrollX), -(__realY - ScrollY));
		}
		surface_reset_target();

		draw_surface(Surface, __realX, __realY);

		return self;
	};
}