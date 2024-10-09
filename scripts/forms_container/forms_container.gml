/// @macro {Code} A shorthand for
/// `ContentWidth = Pen.get_max_x(); ContentHeight = Pen.get_max_y();`. Useful
/// in {@link FORMS_Container.draw_content}.
/* beautify ignore:start */
#macro FORMS_CONTENT_UPDATE_SIZE \
    do { ContentWidth = Pen.get_max_x(); ContentHeight = Pen.get_max_y(); } until (1)
/* beautify ignore:end */

/// @func FORMS_ContainerProps()
///
/// @extends FORMS_WidgetProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_Container}.
function FORMS_ContainerProps(): FORMS_WidgetProps() constructor
{
	/// @var {Asset.GMSprite, Undefined} The background sprite of the container,
	/// stretched over its entire size.
	BackgroundSprite = undefined;

	/// @var {Real, Undefined} The subimage of the background sprite to use.
	BackgroundIndex = undefined;

	/// @var {Constant.Color, Undefined} The tint color of the background sprite.
	BackgroundColor = undefined;

	/// @var {Real, Undefined} The alpha value of the background sprite.
	BackgroundAlpha = undefined;

	/// @var {Bool, Undefined} Whether the default scrolling direction of the
	/// container is vertical (`true`) or horizontal (`false`).
	IsDefaultScrollVertical = undefined;

	/// @var {Bool, Undefined} Whether the container should be automatically
	/// resized to fit its content upon its creation.
	ContentFit = undefined;
}

/// @func FORMS_Container([_props])
///
/// @extends FORMS_Widget
///
/// @desc A widget that draws a scrollable content into a surface.
///
/// @param {Struct.FORMS_ContainerProps, Undefined} [_props] Properties to
/// create the container with or `undefined` (default).
function FORMS_Container(_props = undefined): FORMS_Widget(_props) constructor
{
	static Widget_layout = layout;

	/// @var {Id.Surface} The ID of the container's surface.
	/// @readonly
	Surface = -1;

	/// @var {Asset.GMSprite} The background sprite of the container, stretched
	/// over its entire size. Defaults to `FORMS_SprRectangle`.
	BackgroundSprite = forms_get_prop(_props, "BackgroundSprite") ?? FORMS_SprRectangle;

	/// @var {Real} The subimage of the background sprite to use. Defaults to 0.
	BackgroundIndex = forms_get_prop(_props, "BackgroundIndex") ?? 0;

	/// @var {Constant.Color} The tint color of the background sprite. Defaults
	/// to `0x272727`.
	BackgroundColor = forms_get_prop(_props, "BackgroundColor") ?? 0x272727;

	/// @var {Real} The alpha value of the background sprite. Defaults to 1.
	BackgroundAlpha = forms_get_prop(_props, "BackgroundAlpha") ?? 1.0;

	/// @var {Real} The scroll of the contents on the X axis. Defaults to 0.
	/// @readonly
	/// @see FORMS_Container.set_scroll_x
	ScrollX = 0;

	/// @var {Real} The scroll of the contents on the Y axis. Defaults to 0.
	/// @readonly
	/// @see FORMS_Container.set_scroll_y
	ScrollY = 0;

	/// @var {Bool} Whether the default scrolling direction of the container is
	/// vertical (`true`) or horizontal (`false`). Defaults to `true`.
	IsDefaultScrollVertical = forms_get_prop(_props, "IsDefaultScrollVertical") ?? true;

	/// @var {Bool} If `true` then the size of the container is recomputed from
	/// its contents the next time method [layout](./FORMS_Widget.layout.html)
	/// is called. Defaults to `false`.
	ContentFit = forms_get_prop(_props, "ContentFit") ?? false;

	/// @var {Struct.FORMS_Pen} A pen used by this container to draw text and
	/// controls like inputs, checkboxes, buttons etc.
	/// @readonly
	Pen = new FORMS_Pen(self);

	/// @var {Real} The width of the content. Defaults to 0.
	/// @see FORMS_Container.fetch_content_size
	ContentWidth = 0;

	/// @var {Real} The height of the content. Defaults to 0.
	/// @see FORMS_Container.fetch_content_size
	ContentHeight = 0;

	/// @func fetch_content_size()
	///
	/// @desc Draws the content into a off-screen surface to fetch its width and
	/// height.
	///
	/// @return {Struct.FORMS_Container} Returns `self`.
	static fetch_content_size = function ()
	{
		var _surface = surface_create(1, 1);
		surface_set_target(_surface);
		draw_content();
		surface_reset_target();
		surface_free(_surface);
		return self;
	}

	/// @func set_scroll_x(_scroll)
	///
	/// @desc Changes the container's scroll on the X axis.
	///
	/// @param {Real} _scroll The new scroll value. Clamped between 0 and the
	/// width of the container's content.
	///
	/// @return {Struct.FORMS_Container} Returns `self`.
	static set_scroll_x = function (_scroll)
	{
		gml_pragma("forceinline");
		ScrollX = round(clamp(_scroll, 0, max(ContentWidth - __realWidth, 0)));
		return self;
	}

	/// @func set_scroll_y(_scroll)
	///
	/// @desc Changes the container's scroll on the Y axis.
	///
	/// @param {Real} _scroll The new scroll value. Clamped between 0 and the
	/// height of the container's content.
	///
	/// @return {Struct.FORMS_Container} Returns `self`.
	static set_scroll_y = function (_scroll)
	{
		gml_pragma("forceinline");
		ScrollY = round(clamp(_scroll, 0, max(ContentHeight - __realHeight, 0)));
		return self;
	}

	static layout = function ()
	{
		if (ContentFit)
		{
			fetch_content_size();

			// TODO: Add setter
			Width.Value = ContentWidth;
			Width.Unit = FORMS_EUnit.Pixel;
			Height.Value = ContentHeight;
			Height.Unit = FORMS_EUnit.Pixel;

			__realWidth = ContentWidth;
			__realHeight = ContentHeight;

			ContentFit = false;
		}
		Widget_layout();
		return self;
	}

	static update = function (_deltaTime)
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

		// Clamp scroll
		set_scroll_x(ScrollX);
		set_scroll_y(ScrollY);

		return self;
	}

	/// @func draw_content()
	///
	/// @desc Draws contents of the container.
	///
	/// @return {Struct.FORMS_Container} Returns `self`.
	static draw_content = function ()
	{
		return self;
	}

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
		draw_clear_alpha(0, 0);
		draw_sprite_stretched_ext(
			BackgroundSprite, BackgroundIndex,
			0, 0, __realWidth, __realHeight,
			BackgroundColor, BackgroundAlpha);

		forms_push_mouse_coordinates(__realX - ScrollX, __realY - ScrollY);
		var _world = matrix_get(matrix_world);
		_world[@ 12] -= ScrollX;
		_world[@ 13] -= ScrollY;
		matrix_set(matrix_world, _world);
		draw_content();
		_world[@ 12] += ScrollX;
		_world[@ 13] += ScrollY;
		matrix_set(matrix_world, _world);

		var _size = 24;
		var _color = c_black; //global.formsAccentColor;
		var _alpha = 0.5;
		if (ScrollX > 0)
		{
			draw_sprite_stretched_ext(
				FORMS_SprScrollableX, 0,
				0, 0, _size, __realHeight,
				_color, _alpha);
		}
		if (ContentWidth - ScrollX > __realWidth)
		{
			draw_sprite_stretched_ext(
				FORMS_SprScrollableX, 1,
				__realWidth - _size, 0, _size, __realHeight,
				_color, _alpha);
		}

		if (ScrollY > 0)
		{
			draw_sprite_stretched_ext(
				FORMS_SprScrollableY, 0,
				0, 0, __realWidth, _size,
				_color, _alpha);
		}
		if (ContentHeight - ScrollY > __realHeight)
		{
			draw_sprite_stretched_ext(
				FORMS_SprScrollableY, 1,
				0, __realHeight - _size, __realWidth, _size,
				_color, _alpha);
		}

		forms_push_mouse_coordinates(-(__realX - ScrollX), -(__realY - ScrollY));
		surface_reset_target();

		draw_surface(Surface, __realX, __realY);

		return self;
	}

	static destroy = function ()
	{
		if (surface_exists(Surface)) { surface_free(Surface); }
		return undefined;
	}
}
