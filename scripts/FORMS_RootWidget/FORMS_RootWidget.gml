/// @var {Struct.FORMS_RootWidget, Undefined}
/// @private
global.__formsRoot = undefined;

/// @enum Mouse button states.
enum FORMS_EMouseState
{
	/// @member TODO: Add docs
	Released = -1,
		/// @member TODO: Add docs
		Off = 0,
		/// @member TODO: Add docs
		Held = 1,
		/// @member TODO: Add docs
		Pressed = 2,
};

/// @enum TODO: Add docs
enum FORMS_EDragState
{
	/// @member TODO: Add docs
	None,
	/// @member TODO: Add docs
	Start,
	/// @member TODO: Add docs
	Dragging,
	/// @member TODO: Add docs
	End,
};

/// @func forms_get_root()
///
/// @desc Returns the currently active root widget.
///
/// Available only in scope of [update](./FORMS_Widget.update.html) and [draw](./FORMS_Widget.draw.html) of the
/// [root widget](./FORMS_RootWidget.html), otherwise ends with an error!
///
/// @return {Struct.FORMS_RootWidget} The root widget.
function forms_get_root()
{
	gml_pragma("forceinline");
	forms_assert(global.__formsRoot != undefined, "Root widget not found!");
	return global.__formsRoot;
}

/// @func FORMS_RootWidgetProps()
///
/// @extends FORMS_CompoundWidgetProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_RootWidget}.
function FORMS_RootWidgetProps(): FORMS_CompoundWidget() constructor
{
	/// @var {Struct.FORMS_Style, Undefined} The style of the UI.
	Style = undefined;
}

/// @func FORMS_RootWidget([_props[, _children]])
///
/// @extends FORMS_CompoundWidget
///
/// @desc Must be used as the root widget of user interfaces!
///
/// @param {Struct.FORMS_RootWidgetProps, Undefined} [_props] Properties to create the root widget with or `undefined`
/// (default).
/// @param {Array<Struct.FORMS_Widget>, Undefined} [_children] An array of child widgets to add to the root widget or
/// `undefined` (default).
///
/// @example
/// ```gml
/// /// @desc Create event
/// gui = new FORMS_RootWidget();
/// // Add widgets to gui here...
///
/// /// @desc Step event
/// gui.update(delta_time);
///
/// /// @desc Draw event
/// gui.draw();
///
/// /// @desc Clean Up event
/// gui = gui.destroy();
/// ```
function FORMS_RootWidget(_props = undefined, _children = undefined): FORMS_CompoundWidget(_props,
	_children) constructor
{
	static CompoundWidget_layout = layout;
	static CompoundWidget_update = update;
	static CompoundWidget_draw = draw;
	static CompoundWidget_destroy = destroy;

	/// @var {Struct.FORMS_Style} The style of the UI.
	Style = forms_get_prop(_props, "Style") ?? new FORMS_Style();

	/// @var {Real} The current mouse X coordinate. When rendering into a {@link FORMS_Container}, it's relative to the
	/// container's position and scroll!
	/// @readonly
	MouseX = 0;

	/// @var {Real} The current mouse Y coordinate. When rendering into a {@link FORMS_Container}, it's relative to the
	/// container's position and scroll!
	/// @readonly
	MouseY = 0;

	/// @var {Struct.FORMS_Widget, Undefined} The widget that is currently underneath the mouse cursor or `undefined`.
	/// @readonly
	WidgetHovered = undefined;

	/// @var {Any} A thing that is currently being dragged with the mouse or `undefined`.
	DragTarget = undefined;

	/// @var {Bool} Whether the UI currently captures keyboard input (`true`) or not (`false`).
	/// @readonly
	KeyboardUsed = false;

	/// @var {Struct.FORMS_UnitValue} The widget's width. Defaults to 100% of the window width.
	Width = Width.from_props(_props, "Width", 100, FORMS_EUnit.Percent);

	/// @var {Struct.FORMS_UnitValue} The widget's height. Defaults to 100% of the window height.
	Height = Height.from_props(_props, "Height", 100, FORMS_EUnit.Percent);

	__mouseButtons = {};

	__tooltip = undefined;
	__tooltipLast = undefined;
	__tooltipTimer = 0;

	__cursor = cr_default;
	__cursorLast = __cursor;

	__results = {};

	__dragStartX = 0;
	__dragStartY = 0;
	__dragThreshold = 2;

	/// @var {Bool}
	/// @readonly
	DragState = FORMS_EDragState.None;

	/// @var {Array<Struct.FORMS_Widget>}
	/// @private
	__widgetsToDestroy = [];

	/// @func return_result(_id, _value)
	///
	/// @desc Used to return a result from a control drawn by a {@link FORMS_Pen}.
	///
	/// @param {String} _id The ID of the control that returns a value.
	/// @param {Any} _value The value to return.
	///
	/// @return {Struct.FORMS_RootWidget} Returns `self`.
	static return_result = function (_id, _value)
	{
		__results[$  _id] = _value;
		return self;
	}

	/// @func has_result(_id)
	///
	/// @desc Checks whether there's a result returned by a control draw by a {@link FORMS_Pen} with given ID.
	///
	/// @param {String} _id The ID of the control.
	///
	/// @return {Bool} Returns `true` if there's available result returned by a control with given ID.
	static has_result = function (_id)
	{
		return variable_struct_exists(__results, _id);
	}

	/// @func peek_result(_id)
	///
	/// @desc Retrieves a result returned by a control drawn by a {@link FORMS_Pen} with given ID, without removing it
	/// from stored results.
	///
	/// @param {String} _id The ID of the control.
	///
	/// @return {Any} The result returned by a control with given ID or `undefined` if there isn't one available.
	static peek_result = function (_id)
	{
		return __results[$  _id];
	}

	/// @func get_result(_id)
	///
	/// @desc Retrieves a result returned by a control drawn by a {@link FORMS_Pen} with given ID and removes it from
	/// stored results.
	///
	/// @param {String} _id The ID of the control.
	///
	/// @return {Any} The result returned by a control with given ID or `undefined` if there isn't one available.
	static get_result = function (_id)
	{
		var _result = __results[$  _id];
		variable_struct_remove(__results, _id);
		return _result;
	}

	static layout = function ()
	{
		var _windowWidth = window_get_width();
		var _windowHeight = window_get_height();

		__realX = floor(X.get_absolute(_windowWidth));
		__realY = floor(Y.get_absolute(_windowHeight));
		__realWidth = floor(Width.get_absolute(_windowWidth));
		__realHeight = floor(Height.get_absolute(_windowHeight));

		WidgetHovered = undefined;

		CompoundWidget_layout();

		return self;
	}

	static update = function (_deltaTime)
	{
		global.__formsRoot = self;

		MouseX = window_mouse_get_x();
		MouseY = window_mouse_get_y();
		__mouseButtons = {};
		__tooltip = undefined;
		__cursor = cr_default;

		if (mouse_check_button_pressed(mb_left))
		{
			__dragStartX = MouseX;
			__dragStartY = MouseY;
			DragState = FORMS_EDragState.None;
		}

		if (mouse_check_button(mb_left))
		{
			if (point_distance(MouseX, MouseY, __dragStartX, __dragStartY) > __dragThreshold)
			{
				if (DragState == FORMS_EDragState.None)
				{
					DragState = FORMS_EDragState.Start;
				}
				else if (DragState == FORMS_EDragState.Start)
				{
					DragState = FORMS_EDragState.Dragging;
				}
			}
		}
		else if (DragState == FORMS_EDragState.End)
		{
			DragState = FORMS_EDragState.None;
		}

		if (mouse_check_button_released(mb_left))
		{
			if (DragState == FORMS_EDragState.Dragging)
			{
				DragState = FORMS_EDragState.End;
			}
		}

		layout();
		CompoundWidget_update(_deltaTime);

		global.__formsRoot = undefined;
		return self;
	}

	static draw = function ()
	{
		global.__formsRoot = self;

		forms_draw_rectangle(__realX, __realY, __realWidth, __realHeight, Style.Background[1].get());

		gpu_push_state();
		gpu_set_tex_filter(true);
		gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);

		CompoundWidget_draw();

		gpu_pop_state();

		if (is_struct(DragTarget) && variable_struct_exists(DragTarget, "draw_drag_target"))
		{
			DragTarget.draw_drag_target(window_mouse_get_x() + 16, window_mouse_get_y() + 16);
		}

		if (__tooltip != undefined && DragTarget == undefined)
		{
			if (__tooltip != __tooltipLast || mouse_check_button(mb_any))
			{
				__tooltipTimer = 0;
			}
			else
			{
				__tooltipTimer += delta_time * 0.001;
			}
			if (__tooltipTimer >= 500)
			{
				var _tooltipPaddingX = 8;
				var _tooltipPaddingY = 4;
				var _tooltipWidth = string_width(__tooltip) + _tooltipPaddingX * 2;
				var _tooltipHeight = string_height(__tooltip) + _tooltipPaddingY * 2;
				var _tooltipX = clamp(forms_mouse_get_x() + 16, 0, window_get_width() - _tooltipWidth);
				var _tooltipY = clamp(forms_mouse_get_y() + 16, 0, window_get_height() - _tooltipHeight);
				var _tooltipAlpha = min((__tooltipTimer - 500) / 100, 1);

				var _shadowOffset = 16;
				draw_sprite_stretched_ext(
					FORMS_SprShadow, 0,
					_tooltipX - _shadowOffset,
					_tooltipY - _shadowOffset,
					_tooltipWidth + _shadowOffset * 2,
					_tooltipHeight + _shadowOffset * 2,
					Style.Shadow.get(), Style.Shadow.get_alpha());

				draw_sprite_stretched_ext(
					FORMS_SprRound4,
					0,
					_tooltipX,
					_tooltipY,
					_tooltipWidth,
					_tooltipHeight,
					Style.Tooltip.get(),
					_tooltipAlpha);
				forms_draw_text(
					_tooltipX + _tooltipPaddingX,
					_tooltipY + _tooltipPaddingY,
					__tooltip,
					Style.TooltipText.get(),
					_tooltipAlpha);
			}
		}
		else
		{
			__tooltipTimer = 0;
		}
		__tooltipLast = __tooltip;

		if (__cursor != __cursorLast)
		{
			window_set_cursor(__cursor);
			__cursorLast = __cursor;
		}

		__process_destroy_later();

		global.__formsRoot = undefined;
		return self;
	}

	/// @func push_mouse_coordinates(_x, _y)
	///
	/// @desc Used to make mouse coordinates relative to position of a {@link FORMS_Container} that's currently being
	/// drawn into.
	///
	/// @param {Real} _x The value to subtract from the mouse X position.
	/// @param {Real} _y The value to subtract from the mouse Y position.
	///
	/// @return {Struct.FORMS_RootWidget} Returns `self`.
	static push_mouse_coordinates = function (_x, _y)
	{
		MouseX -= _x;
		MouseY -= _y;
		return self;
	}

	/// @func set_tooltip(_tooltip)
	///
	/// @desc Changes the current tooltip text.
	///
	/// @param {String, Undefined} _tooltip The new tooltip text or `undefined`.
	///
	/// @return {Struct.FORMS_RootWidget} Returns `self`.
	static set_tooltip = function (_tooltip)
	{
		__tooltip = _tooltip;
		return self;
	}

	/// @func set_cursor(_cursor)
	///
	/// @desc Changes the current mouse cursor style.
	///
	/// @param {Constant.Cursor} _cursor The new mouse cursor style.
	///
	/// @return {Struct.FORMS_RootWidget} Returns `self`.
	static set_cursor = function (_cursor)
	{
		__cursor = _cursor;
		return self;
	}

	/// @func get_cursor()
	///
	/// @desc Retrieves the current mouse cursor style.
	///
	/// @return {Constant.Cursor} The current mouse cursor style.
	static get_cursor = function ()
	{
		return __cursor;
	}

	/// @func __check_mouse_status(_button)
	///
	/// @desc Returns the current status of the given mouse button, and updates it if not already set.
	///
	/// @param {Constant.MouseButton} _button The mouse button to check.
	///
	/// @return {Real} Value from {@link FORMS_EMouseState}
	static __check_mouse_status = function (_button)
	{
		if (!struct_exists(__mouseButtons, _button))
		{
			var _status = undefined;
			_status ??= mouse_check_button_pressed(_button) ? FORMS_EMouseState.Pressed : undefined;
			_status ??= mouse_check_button(_button) ? FORMS_EMouseState.Held : undefined;
			_status ??= mouse_check_button_released(_button) ? FORMS_EMouseState.Released : undefined;
			_status ??= FORMS_EMouseState.Off;
			__mouseButtons[$  _button] = _status;
		}
		return __mouseButtons[$  _button];
	}

	/// @func check_mouse_pressed(_button)
	///
	/// @desc Checks whether given mouse button is pressed. Consecutive checks for the same button will return `false`
	/// until the next [update](./FORMS_Widget.update.html).
	///
	/// @param {Constant.MouseButton} _button The mouse button to check.
	///
	/// @return {Bool} Returns `true` if given mouse button is pressed.
	static check_mouse_pressed = function (_button)
	{
		if (__check_mouse_status(_button) == FORMS_EMouseState.Pressed)
		{
			mouse_set_button_status(_button, FORMS_EMouseState.Held);
			return true;
		}
		return false;
	}

	/// @func check_mouse(_button)
	///
	/// @desc Checks whether given mouse button is held down.
	///
	/// @param {Constant.MouseButton} _button The mouse button to check.
	///
	/// @return {Bool} Returns `true` if given mouse button is held down.
	static check_mouse = function (_button)
	{
		var _button_status = __check_mouse_status(_button);
		return (_button_status == FORMS_EMouseState.Held || _button_status == FORMS_EMouseState.Pressed);
	}

	/// @func check_mouse_released(_button)
	///
	/// @desc Checks whether given mouse button has been released.
	///
	/// @param {Constant.MouseButton} _button The mouse button to check.
	///
	/// @return {Bool} Returns `true` if given mouse button has been released.
	static check_mouse_released = function (_button)
	{
		return __check_mouse_status(_button) == FORMS_EMouseState.Released;
	}

	/// @func mouse_set_button_status(_button)
	///
	/// @desc Sets the given mouse button's status.
	///
	/// @param {Constant.MouseButton} _button The mouse button to set.
	/// @param {Real} _status Value from Enum {@link FORMS_EMouseState}.
	static mouse_set_button_status = function (_button, _status)
	{
		__mouseButtons[$  _button] = _status;
	}

	/// @private
	static __process_destroy_later = function ()
	{
		for (var i = array_length(__widgetsToDestroy) - 1; i >= 0; --i)
		{
			with(__widgetsToDestroy[i])
			{
				if (!__destroyed)
				{
					destroy();
				}
			}
		}
		__widgetsToDestroy = [];
	}

	static destroy = function ()
	{
		global.__formsRoot = self;
		CompoundWidget_destroy();
		__process_destroy_later();
		global.__formsRoot = undefined;
		return undefined;
	}
}

/// @func forms_push_mouse_coordinates(_x, _y)
///
/// @desc Used to make mouse coordinates relative to position of a {@link FORMS_Container} that's currently being drawn
/// into.
///
/// Available only in scope of [update](./FORMS_Widget.update.html) and [draw](./FORMS_Widget.draw.html) of the
/// [root widget](./FORMS_RootWidget.html), otherwise ends with an error!
///
/// @param {Real} _x The value to subtract from the mouse X position.
/// @param {Real} _y The value to subtract from the mouse Y position.
///
/// @note This is a shorthand for `forms_get_root().push_mouse_coordinates(_x, _y)`.
///
/// @see forms_get_root
/// @see FORMS_RootWidget.push_mouse_coordinates
function forms_push_mouse_coordinates(_x, _y)
{
	gml_pragma("forceinline");
	forms_get_root().push_mouse_coordinates(_x, _y);
}

/// @func forms_mouse_get_x()
///
/// @desc Retrieves the current mouse X coordinate. When rendering into a {@link FORMS_Container}, it's relative to the
/// containers position and scroll!
///
/// Available only in scope of [update](./FORMS_Widget.update.html) and [draw](./FORMS_Widget.draw.html) of the
/// [root widget](./FORMS_RootWidget.html), otherwise ends with an error!
///
/// @return {Real} The current mouse X coordinate.
///
/// @note This is a shorthand for `forms_get_root().MouseX`.
///
/// @see forms_get_root
/// @see FORMS_RootWidget.MouseX
function forms_mouse_get_x()
{
	gml_pragma("forceinline");
	return forms_get_root().MouseX;
}

/// @func forms_mouse_get_y()
///
/// @desc Retrieves the current mouse Y coordinate. When rendering into a {@link FORMS_Container}, it's relative to the
/// containers position and scroll!
///
/// Available only in scope of [update](./FORMS_Widget.update.html) and [draw](./FORMS_Widget.draw.html) of the
/// [root widget](./FORMS_RootWidget.html), otherwise ends with an error!
///
/// @return {Real} The current mouse Y coordinate.
///
/// @note This is a shorthand for `forms_get_root().MouseY`.
///
/// @see forms_get_root
/// @see FORMS_RootWidget.MouseY
function forms_mouse_get_y()
{
	gml_pragma("forceinline");
	return forms_get_root().MouseY;
}

/// @func forms_mouse_check_button_pressed(_button)
///
/// @desc Checks whether given mouse button is pressed. Consecutive checks for the same button will return `false` until
/// the next [update](./FORMS_Widget.update.html) of the [root widget](./FORMS_RootWidget.html).
///
/// Available only in scope of [update](./FORMS_Widget.update.html) and [draw](./FORMS_Widget.draw.html) of the
/// [root widget](./FORMS_RootWidget.html), otherwise ends with an error!
///
/// @param {Constant.MouseButton} _button The mouse button to check.
///
/// @return {Bool} Returns `true` if given mouse button is pressed.
///
/// @note This is a shorthand for `forms_get_root().check_mouse_pressed(_button)`.
///
/// @see forms_get_root
/// @see FORMS_RootWidget.check_mouse_pressed
function forms_mouse_check_button_pressed(_button)
{
	gml_pragma("forceinline");
	return forms_get_root().check_mouse_pressed(_button);
}

/// @func forms_mouse_check_button(_button)
///
/// @desc Checks whether given mouse button is held down.
///
/// @param {Constant.MouseButton} _button The mouse button to check.
///
/// @return {Bool} Returns `true` if given mouse button is held down.
function forms_mouse_check_button(_button)
{
	gml_pragma("forceinline");
	return forms_get_root().check_mouse(_button);
}

/// @func forms_mouse_check_button_released(_button)
///
/// @desc Checks whether given mouse button has been released.
///
/// @param {Constant.MouseButton} _button The mouse button to check.
///
/// @return {Bool} Returns `true` if given mouse button has been released.
function forms_mouse_check_button_released(_button)
{
	gml_pragma("forceinline");
	return forms_get_root().check_mouse_released(_button);
}

/// @func forms_mouse_set_button_status(_button, _status)
///
/// @desc Sets the given mouse button's status.
///
/// @param {Constant.MouseButton} _button The mouse button to set.
/// @param {Real} _status Value from Enum {@link FORMS_EMouseState}.
function forms_mouse_set_button_status(_button, _status)
{
	gml_pragma("forceinline");
	forms_get_root().mouse_set_button_status(_button, _status);
}

/// @func forms_mouse_in_rectangle(_x, _y, _width, _height)
///
/// @desc Checks whether the mouse coordinates returned by {@link forms_mouse_get_x} and {@link forms_mouse_get_y} are
/// inside of given rectangle.
///
/// Available only in scope of [update](./FORMS_Widget.update.html) and [draw](./FORMS_Widget.draw.html) of the
/// [root widget](./FORMS_RootWidget.html), otherwise ends with an error!
///
/// @param {Real} _x The X coordinate of the rectangle's top left corner.
/// @param {Real} _y The Y coordinate of the rectangle's top left corner.
/// @param {Real} _width The width of the rectangle.
/// @param {Real} _height The height of the rectangle.
///
/// @return {Bool} Returns `true` if the mouse coordinates are inside of the rectangle.
function forms_mouse_in_rectangle(_x, _y, _width, _height)
{
	var _mouseX = forms_mouse_get_x();
	var _mouseY = forms_mouse_get_y();
	return (_mouseX >= _x && _mouseX < _x + _width
		&& _mouseY >= _y && _mouseY < _y + _height);
}

/// @func forms_set_tooltip(_tooltip)
///
/// @desc Changes the current tooltip text.
///
/// Available only in scope of [update](./FORMS_Widget.update.html) and [draw](./FORMS_Widget.draw.html) of the
/// [root widget](./FORMS_RootWidget.html), otherwise ends with an error!
///
/// @param {String, Undefined} _tooltip The new tooltip text or `undefined`.
///
/// @note This is a shorthand for `forms_get_root().set_tooltip(_tooltip)`.
///
/// @see forms_get_root
/// @see FORMS_RootWidget.set_tooltip
function forms_set_tooltip(_tooltip)
{
	gml_pragma("forceinline");
	forms_get_root().set_tooltip(_tooltip);
}

/// @func forms_set_cursor(_cursor)
///
/// @desc Changes the current mouse cursor style.
///
/// Available only in scope of [update](./FORMS_Widget.update.html) and [draw](./FORMS_Widget.draw.html) of the
/// [root widget](./FORMS_RootWidget.html), otherwise ends with an error!
///
/// @param {Constant.Cursor} _cursor The new mouse cursor style.
///
/// @note This is a shorthand for `forms_get_root().set_cursor(_cursor)`.
///
/// @see forms_get_root
/// @see FORMS_RootWidget.set_cursor
function forms_set_cursor(_cursor)
{
	gml_pragma("forceinline");
	forms_get_root().set_cursor(_cursor);
}

/// @func forms_get_cursor()
///
/// @desc Retrieves the current mouse cursor style.
///
/// Available only in scope of [update](./FORMS_Widget.update.html) and [draw](./FORMS_Widget.draw.html) of the
/// [root widget](./FORMS_RootWidget.html), otherwise ends with an error!
///
/// @return {Constant.Cursor} The current mouse cursor style.
///
/// @note This is a shorthand for `forms_get_root().get_cursor()`.
///
/// @see forms_get_root
/// @see FORMS_RootWidget.get_cursor
function forms_get_cursor()
{
	gml_pragma("forceinline");
	return forms_get_root().get_cursor();
}

/// @func forms_return_result(_id, _value)
///
/// @desc Used to return a result from a control drawn by a {@link FORMS_Pen}.
///
/// Available only in scope of [update](./FORMS_Widget.update.html) and [draw](./FORMS_Widget.draw.html) of the
/// [root widget](./FORMS_RootWidget.html), otherwise ends with an error!
///
/// @param {String} _id The ID of the control that returns a value.
/// @param {Any} _value The value to return.
///
/// @note This is a shorthand for `forms_get_root().return_result(_id, _value)`.
///
/// @see forms_get_root
/// @see FORMS_RootWidget.return_result
function forms_return_result(_id, _value)
{
	gml_pragma("forceinline");
	forms_get_root().return_result(_id, _value);
}

/// @func forms_has_result(_id)
///
/// @desc Checks whether there's a result returned by a control draw by a {@link FORMS_Pen} with given ID.
///
/// Available only in scope of [update](./FORMS_Widget.update.html) and [draw](./FORMS_Widget.draw.html) of the
/// [root widget](./FORMS_RootWidget.html), otherwise ends with an error!
///
/// @param {String} _id The ID of the control.
///
/// @return {Bool} Returns `true` if there's available result returned by a control with given ID.
///
/// @note This is a shorthand for `forms_get_root().has_result(_id)`.
///
/// @see forms_get_root
/// @see FORMS_RootWidget.has_result
function forms_has_result(_id)
{
	gml_pragma("forceinline");
	return forms_get_root().has_result(_id);
}

/// @func forms_peek_result(_id)
///
/// @desc Retrieves a result returned by a control drawn by a {@link FORMS_Pen} with given ID, without removing it from
/// stored results.
///
/// Available only in scope of [update](./FORMS_Widget.update.html) and [draw](./FORMS_Widget.draw.html) of the
/// [root widget](./FORMS_RootWidget.html), otherwise ends with an error!
///
/// @param {String} _id The ID of the control.
///
/// @return {Any} The result returned by a control with given ID or `undefined` if there isn't one available.
///
/// @note This is a shorthand for `forms_get_root().peek_result(_id)`.
///
/// @see forms_get_root
/// @see FORMS_RootWidget.peek_result
function forms_peek_result(_id)
{
	gml_pragma("forceinline");
	return forms_get_root().peek_result(_id);
}

/// @func forms_get_result(_id)
///
/// @desc Retrieves a result returned by a control drawn by a {@link FORMS_Pen} with given ID and removes it from stored
/// results.
///
/// Available only in scope of [update](./FORMS_Widget.update.html) and [draw](./FORMS_Widget.draw.html) of the
/// [root widget](./FORMS_RootWidget.html), otherwise ends with an error!
///
/// @param {String} _id The ID of the control.
///
/// @return {Any} The result returned by a control with given ID or `undefined` if there isn't one available.
///
/// @note This is a shorthand for `forms_get_root().get_result(_id)`.
///
/// @see forms_get_root
/// @see FORMS_RootWidget.get_result
function forms_get_result(_id)
{
	gml_pragma("forceinline");
	return forms_get_root().get_result(_id);
}

/// @func forms_get_style()
///
/// @desc Retrieves the current UI style.
///
/// Available only in scope of [update](./FORMS_Widget.update.html) and [draw](./FORMS_Widget.draw.html) of the
/// [root widget](./FORMS_RootWidget.html), otherwise ends with an error!
///
/// @return {Struct.FORMS_Style} The current UI style.
///
/// @note This is a shorthand for `forms_get_root().Style`.
///
/// @see forms_get_root
/// @see FORMS_RootWidget.Style
function forms_get_style()
{
	gml_pragma("forceinline");
	return forms_get_root().Style;
}

/// @func forms_get_drag_state()
///
/// @desc TODO: Add docs
///
/// Available only in scope of [update](./FORMS_Widget.update.html) and [draw](./FORMS_Widget.draw.html) of the
/// [root widget](./FORMS_RootWidget.html), otherwise ends with an error!
///
/// @return {Real} One of the values from {@link FORMS_EDragState}.
///
/// @note This is a shorthand for `forms_get_root().DragState`.
///
/// @see forms_get_root
/// @see FORMS_RootWidget.DragState
function forms_get_drag_state()
{
	gml_pragma("forceinline");
	return forms_get_root().DragState;
}

/// @func forms_left_click()
///
/// @desc Checks whether left mouse button was clicked.
///
/// Available only in scope of [update](./FORMS_Widget.update.html) and [draw](./FORMS_Widget.draw.html) of the
/// [root widget](./FORMS_RootWidget.html), otherwise ends with an error!
///
/// @return {Bool} Returns `true` one left mouse click.
function forms_left_click()
{
	gml_pragma("forceinline");
	return (forms_mouse_check_button_released(mb_left) && forms_get_drag_state() == FORMS_EDragState.None);
}
