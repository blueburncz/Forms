/// @func FORMS_FloatingToolbarProps()
///
/// @extends FORMS_ContainerProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_FloatingToolbar}.
function FORMS_FloatingToolbarProps(): FORMS_ContainerProps() constructor
{
	/// @var {Real, Undefined} Horizontal position as a ratio (0.0 = left edge, 1.0 = right edge).
	PositionX = undefined;

	/// @var {Real, Undefined} Vertical position as a ratio (0.0 = top edge, 1.0 = bottom edge).
	PositionY = undefined;

	/// @var {Real, Undefined} Background alpha (0 = fully transparent, 1 = opaque).
	BackgroundAlpha = undefined;

	/// @var {Bool, Undefined} Whether the toolbar can be dragged.
	Draggable = undefined;
}

/// @func FORMS_FloatingToolbar([_props])
///
/// @extends FORMS_Container
///
/// @desc A floating toolbar that positions itself inside its parent widget using percentage-relative coordinates.
/// Designed to be used as a child of {@link FORMS_ApplicationSurface} for viewport-embedded toolbars (similar to
/// Unity/Unreal viewport overlays). Position is stored as ratios (0.0-1.0), so the toolbar stays at the same
/// relative position when the parent resizes.
///
/// @param {Struct.FORMS_FloatingToolbarProps, Undefined} [_props] Properties to create the toolbar with or `undefined`
/// (default).
///
/// @example
/// ```gml
/// var _viewport = new FORMS_ApplicationSurface({ Width: "100%", Height: "100%" });
///
/// var _toolbar = new (function (): FORMS_FloatingToolbar({
///     PositionX: 0.0,  // Left edge
///     PositionY: 0.0,  // Top edge
///     Draggable: true,
/// }) constructor {
///     static draw_content = function () {
///         Pen.start();
///         Pen.icon_solid(FA_ESolid.ArrowsUpDownLeftRight, { Width: 24 });
///         Pen.icon_solid(FA_ESolid.ArrowsRotate, { Width: 24 });
///         Pen.finish();
///         FORMS_CONTENT_UPDATE_SIZE;
///         return self;
///     }
/// })();
/// _viewport.add_child(_toolbar);
/// ```
function FORMS_FloatingToolbar(_props = undefined): FORMS_Container(_props) constructor
{
	static Container_layout = layout;
	static Container_update = update;
	static Container_draw = draw;

	/// @var {Real} Horizontal position as a ratio (0.0 = left edge, 1.0 = right edge). Defaults to 0.0.
	PositionX = forms_get_prop(_props, "PositionX") ?? 0.0;

	/// @var {Real} Vertical position as a ratio (0.0 = top edge, 1.0 = bottom edge). Defaults to 0.0.
	PositionY = forms_get_prop(_props, "PositionY") ?? 0.0;

	/// @var {Real, Undefined} Background alpha override (0 = fully transparent, 1 = opaque). If `undefined`, uses
	/// `Style.FloatingToolbarAlpha`.
	BackgroundAlpha = forms_get_prop(_props, "BackgroundAlpha");

	/// @var {Bool} Whether the toolbar can be dragged. Defaults to `true`.
	Draggable = forms_get_prop(_props, "Draggable") ?? true;

	/// @var {Bool} Whether the toolbar is visible. Defaults to `true`.
	Visible = true;

	/// @var {Bool} Whether the toolbar lays out items horizontally (`true`) or vertically (`false`).
	/// Toggled by clicking the grip icon.
	IsHorizontal = true;

	// Rounded background sprite
	BackgroundSprite = FORMS_SprRound8;

	// Toolbar-appropriate pen settings
	Pen.PaddingY = 4;
	Pen.SpacingX = 2;

	/// @private
	__dragging = false;

	/// @private
	__dragPressed = false;

	/// @private
	__dragPressX = 0;

	/// @private
	__dragPressY = 0;

	/// @private
	__dragOffsetX = 0;

	/// @private
	__dragOffsetY = 0;

	/// @private
	__margin = 4;

	static layout = function ()
	{
		var _parent = Parent;
		if (_parent == undefined) return self;

		// Size from content (updated each frame by FORMS_CONTENT_UPDATE_SIZE in draw_content)
		// ContentWidth/Height already include Pen padding on all sides
		__realWidth = max(ContentWidth, 28);
		__realHeight = max(ContentHeight, 28);

		var _parentX = _parent.__realX;
		var _parentY = _parent.__realY;
		var _parentW = _parent.__realWidth;
		var _parentH = _parent.__realHeight;

		// Position from percentage, clamped within parent bounds with margin
		var _availW = max(_parentW - __realWidth - __margin * 2, 0);
		var _availH = max(_parentH - __realHeight - __margin * 2, 0);
		__realX = _parentX + __margin + round(_availW * PositionX);
		__realY = _parentY + __margin + round(_availH * PositionY);

		// Update hovered state
		if (forms_mouse_in_rectangle(__realX, __realY, __realWidth, __realHeight))
		{
			forms_get_root().WidgetHovered = self;
		}

		return self;
	}

	static update = function (_deltaTime)
	{
		if (!Visible) return self;

		Container_update(_deltaTime);

		if (!Draggable) return self;

		var _root = forms_get_root();

		if (__dragging)
		{
			// Update absolute position from mouse
			var _absX = forms_mouse_get_x() + __dragOffsetX;
			var _absY = forms_mouse_get_y() + __dragOffsetY;

			// Convert back to percentage
			var _parent = Parent;
			if (_parent != undefined)
			{
				var _availW = max(_parent.__realWidth - __realWidth - __margin * 2, 1);
				var _availH = max(_parent.__realHeight - __realHeight - __margin * 2, 1);
				PositionX = clamp((_absX - _parent.__realX - __margin) / _availW, 0, 1);
				PositionY = clamp((_absY - _parent.__realY - __margin) / _availH, 0, 1);
			}

			if (!mouse_check_button(mb_left))
			{
				__dragging = false;
				_root.DragTarget = undefined;
			}
		}
		else if (is_mouse_over()
			&& _root.DragTarget == undefined
			&& mouse_check_button_pressed(mb_left))
		{
			// Record press position for drag threshold
			__dragPressX = forms_mouse_get_x();
			__dragPressY = forms_mouse_get_y();
			__dragPressed = true;
		}

		// Start drag only after moving past threshold
		if (__dragPressed && mouse_check_button(mb_left))
		{
			var _dist = point_distance(forms_mouse_get_x(), forms_mouse_get_y(), __dragPressX, __dragPressY);
			if (_dist > 4)
			{
				__dragging = true;
				__dragPressed = false;
				_root.DragTarget = self;
				__dragOffsetX = __realX - forms_mouse_get_x();
				__dragOffsetY = __realY - forms_mouse_get_y();
			}
		}

		// Click (press + release without drag) on grip area toggles orientation
		if (__dragPressed && !mouse_check_button(mb_left))
		{
			__dragPressed = false;
			var _mx = forms_mouse_get_x();
			var _my = forms_mouse_get_y();
			var _onGrip = IsHorizontal
				? (_mx >= __realX && _mx < __realX + 18 && _my >= __realY && _my < __realY + __realHeight)
				: (_mx >= __realX && _mx < __realX + __realWidth && _my >= __realY && _my < __realY + 18);
			if (_onGrip)
			{
				IsHorizontal = !IsHorizontal;
			}
		}

		return self;
	}

	static draw = function ()
	{
		if (!Visible) return self;
		if (__realWidth <= 0 || __realHeight <= 0) return self;

		var _style = forms_get_style();
		var _alpha = BackgroundAlpha ?? _style.FloatingToolbarAlpha;

		// Surface management
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

		// Rounded background with style color
		draw_sprite_stretched_ext(
			BackgroundSprite, BackgroundIndex,
			0, 0, __realWidth, __realHeight,
			_style.FloatingToolbarBackground.get(), 1.0);

		// Grip handle (clickable to toggle orientation)
		if (Draggable)
		{
			var _gripIcon = IsHorizontal ? FA_ESolid.GripVertical : FA_ESolid.GripLines;
			draw_set_font(FA_FntSolid12);
			var _gripW = string_width(chr(_gripIcon));
			var _gripH = string_height(chr(_gripIcon));

			if (IsHorizontal)
			{
				fa_draw(FA_FntSolid12, _gripIcon,
					4, floor((__realHeight - _gripH) / 2),
					_style.TextMuted.get());
			}
			else
			{
				fa_draw(FA_FntSolid12, _gripIcon,
					floor((__realWidth - _gripW) / 2), 4,
					_style.TextMuted.get());
			}
		}

		// Set pen padding and auto-newline based on orientation
		if (IsHorizontal)
		{
			Pen.PaddingX = Draggable ? 18 : 4;
			Pen.PaddingY = 4;
			Pen.AutoNewline = false;
		}
		else
		{
			Pen.PaddingX = 4;
			Pen.PaddingY = Draggable ? 18 : 4;
			Pen.AutoNewline = true;
		}

		// Content
		forms_push_mouse_coordinates(__realX - ScrollX, __realY - ScrollY);
		var _world = matrix_get(matrix_world);
		_world[@ 12] -= ScrollX;
		_world[@ 13] -= ScrollY;
		matrix_set(matrix_world, _world);
		draw_content();
		_world[@ 12] += ScrollX;
		_world[@ 13] += ScrollY;
		matrix_set(matrix_world, _world);
		forms_push_mouse_coordinates(-(__realX - ScrollX), -(__realY - ScrollY));

		surface_reset_target();

		// Draw surface with alpha
		draw_surface_ext(Surface, __realX, __realY, 1, 1, 0, c_white, _alpha);

		return self;
	}

	/// @func draw_content()
	///
	/// @desc Override this method to draw the toolbar's content using the Pen. The Pen layout (horizontal/vertical)
	/// is set automatically based on {@link FORMS_FloatingToolbar.IsHorizontal} - call `Pen.start()` without arguments.
	///
	/// @return {Struct.FORMS_FloatingToolbar} Returns `self`.
	static draw_content = function ()
	{
		Pen.start();
		Pen.finish();
		FORMS_CONTENT_UPDATE_SIZE;
		return self;
	}
}
