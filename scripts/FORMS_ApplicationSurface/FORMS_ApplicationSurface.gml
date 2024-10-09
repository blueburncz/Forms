/// @func FORMS_ApplicationSurfaceProps()
///
/// @extends FORMS_CompoundWidgetProps
///
/// @desc Properties accepted by the constructor of
/// {@link FORMS_ApplicationSurface}.
function FORMS_ApplicationSurfaceProps(): FORMS_CompoundWidgetProps() constructor
{
	/// @var {Id.Surface, Undefined} An ID of a surface to draw instead of the
	/// application surface or `undefined` to draw the application surface.
	Surface = undefined;

	/// @var {Bool, Undefined} Whether to draw the surface stretched (`true`) or
	/// scaled while keeping its aspect ratio (`false`).
	Stretch = undefined;

	/// @var {Constant.Color, Undefined} The color to fill the empty space around
	/// the surface with.
	BackgroundColor = undefined;

	/// @var {Real, Undefined} The alpha value of the background.
	BackgroundAlpha = forms_get_prop(_props, "BackgroundColor") ?? 1.0;
}

/// @func FORMS_ApplicationSurface([_props[, _children]])
///
/// @extends FORMS_CompoundWidget
///
/// @desc A collection of widget drawn on top of a surface (by default the
/// application surface).
///
/// @param {Struct.FORMS_ApplicationSurfaceProps, Undefined} [_props] Properties
/// to create the surface widget with or `undefined` (default).
/// @param {Array<Struct.FORMS_Widget>, Undefined} [_children] An array of child
/// widgets to add to the surface widget or `undefined` (default).
/* beautify ignore:start */
function FORMS_ApplicationSurface(_props = undefined, _children = undefined): FORMS_CompoundWidget(_props, _children) constructor
/* beautify ignore:end */
{
	static CompoundWidget_layout = layout;
	static CompoundWidget_draw = draw;

	/// @var {Id.Surface, Undefined} An ID of a surface to draw instead of the
	/// application surface or `undefined` (default) to draw the application
	/// surface.
	Surface = forms_get_prop(_props, "Surface");

	/// @var {Bool} Whether to draw the surface stretched (`true`) or scaled
	/// while keeping its aspect ratio (`false`, default).
	Stretch = forms_get_prop(_props, "Stretch") ?? false;

	/// @var {Constant.Color} The color to fill the empty space around the
	/// surface with. Defaults to `c_black`.
	BackgroundColor = forms_get_prop(_props, "BackgroundColor") ?? c_black;

	/// @var {Real} The alpha value of the background. Defaults to 1.
	BackgroundAlpha = forms_get_prop(_props, "BackgroundColor") ?? 1.0;

	__surfaceX = 0;
	__surfaceY = 0;
	__surfaceWidth = 0;
	__surfaceHeight = 0;
	__mouseX = 0;
	__mouseY = 0;

	/// @func get_surface()
	///
	/// @desc Retrieves the ID of the surface that the widget draws.
	///
	/// @return {Id.Surface} The ID of the surface that the widget draws or -1
	/// if {@link FORMS_ApplicationSurface.Surface} is `undefined` and the
	/// application surface is disabled.
	static get_surface = function ()
	{
		gml_pragma("forceinline");
		return Surface ?? (application_surface_is_enabled() ? application_surface : -1);
	};

	static layout = function ()
	{
		CompoundWidget_layout();

		var _surface = get_surface();

		if (Stretch)
		{
			__surfaceX = __realX;
			__surfaceY = __realY;
			__surfaceWidth = __realWidth;
			__surfaceHeight = __realHeight;
		}
		else if (surface_exists(_surface))
		{
			var _aspect = __realWidth / __realHeight;
			var _aspectSurface = surface_get_width(_surface) / surface_get_height(_surface);

			if (_aspectSurface > _aspect)
			{
				__surfaceWidth = __realWidth;
				__surfaceHeight = __realWidth / _aspectSurface;
			}
			else
			{
				__surfaceHeight = __realHeight;
				__surfaceWidth = __realHeight * _aspectSurface;
			}

			__surfaceX = floor(__realX + (__realWidth - __surfaceWidth) / 2);
			__surfaceY = floor(__realY + (__realHeight - __surfaceHeight) / 2);
		}

		__mouseX = forms_mouse_get_x() - __surfaceX;
		__mouseY = forms_mouse_get_y() - __surfaceY;
	};

	/// @func get_mouse_x()
	///
	/// @desc Retrieves the mouse X coordinate relative to the position of the
	/// surface which the widget draws.
	///
	/// @return {Real} The mouse X coordinate relative to the surface's position.
	static get_mouse_x = function ()
	{
		gml_pragma("forceinline");
		return __mouseX;
	};

	/// @func get_mouse_y()
	///
	/// @desc Retrieves the mouse Y coordinate relative to the position of the
	/// surface which the widget draws.
	///
	/// @return {Real} The mouse Y coordinate relative to the surface's position.
	static get_mouse_y = function ()
	{
		gml_pragma("forceinline");
		return __mouseY;
	};

	/// @func is_mouse_over()
	///
	/// @desc Checks whether mouse position is inside of a rectangle defined by
	/// the position and size of the surface that this widget draws.
	///
	/// @return {Bool} Returns `true` if mouse is inside of the rectangle.
	///
	/// @example
	/// The following example shows how to check whether the is mouse cursor
	/// inside of a surface drawn by a widget `viewport`, taking into account
	/// which widget is currently hovered (the top level widget underneath the
	/// mouse cursor must also be `viewport`).
	/// ```gml
	/// /// @desc Create event
	/// gui = new FORMS_RootWidget();
	/// viewport = new FORMS_ApplicationSurface({ Width: "100%", Height: "100%" });
	/// gui.add_child(viewport);
	///
	/// /// @desc Step event
	/// gui.update(delta_time);
	/// var _mouseInViewport = (gui.WidgetHovered == viewport && viewport.is_mouse_over());
	/// if (_mouseInViewport && mouse_check_button_pressed(mb_left))
	/// {
	///     // Use has clicked inside of the viewport...
	/// }
	/// ```
	static is_mouse_over = function ()
	{
		gml_pragma("forceinline");
		return (__mouseX >= 0 && __mouseX < __surfaceWidth &&
			__mouseY >= 0 && __mouseY < __surfaceHeight);
	};

	static draw = function ()
	{
		forms_draw_rectangle(__realX, __realY, __realWidth, __realHeight, BackgroundColor, BackgroundAlpha);

		var _surface = get_surface();
		if (surface_exists(_surface))
		{
			draw_surface_stretched(_surface, __surfaceX, __surfaceY, __surfaceWidth, __surfaceHeight);
		}

		CompoundWidget_draw();

		return self;
	};
}
