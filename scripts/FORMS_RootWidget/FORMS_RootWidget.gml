/// @var {Struct.FORMS_RootWidget, Undefined}
/// @private
global.__formsRoot = undefined;

/// @func forms_get_root()
///
/// @desc
///
/// @return {Struct.FORMS_RootWidget}
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
/// @desc
function FORMS_RootWidgetProps()
	: FORMS_CompoundWidget() constructor
{
}

/// @func FORMS_RootWidget([_props[, _children]])
///
/// @extends FORMS_CompoundWidget
///
/// @desc
///
/// @param {Struct.FORMS_RootWidgetProps, Undefined} [_props]
/// @param {Array<Struct.FORMS_Widget>, Undefined} [_children]
function FORMS_RootWidget(_props=undefined, _children=undefined)
	: FORMS_CompoundWidget(_props, _children) constructor
{
	static CompoundWidget_layout = layout;
	static CompoundWidget_update = update;
	static CompoundWidget_draw = draw;

	/// @var {Real}
	/// @readonly
	MouseX = 0;

	/// @var {Real}
	/// @readonly
	MouseY = 0;

	/// @var {Struct.FORMS_Widget, Undefined}
	/// @readonly
	WidgetHovered = undefined;

	/// @var {Struct.FORMS_Widget, String, Undefined}
	/// @readonly
	WidgetActive = undefined;

	__mousePressed = {};

	__tooltip = undefined;
	__tooltipLast = undefined;
	__tooltipTimer = 0;

	__cursor = cr_default;
	__cursorLast = __cursor;

	__results = {};

	__widgetsToDestroy = [];

	{
		Width.from_props(_props, "Width", 100, FORMS_EUnit.Percent);
		Height.from_props(_props, "Height", 100, FORMS_EUnit.Percent);
	}

	/// @func return_result(_id, _value)
	///
	/// @desc
	///
	/// @param {String} _id
	/// @param {Any} _value
	///
	/// @return {Struct.FORMS_RootWidget} Returns `self`.
	static return_result = function (_id, _value)
	{
		__results[$ _id] = _value;
		return self;
	}

	/// @func has_result(_id)
	///
	/// @desc
	///
	/// @param {String} _id
	///
	/// @return {Bool}
	static has_result = function (_id)
	{
		return variable_struct_exists(__results, _id);
	};

	/// @func peek_result(_id)
	///
	/// @desc
	///
	/// @param {String} _id
	///
	/// @return {Any}
	static peek_result = function (_id)
	{
		return __results[$ _id];
	};

	/// @func get_result(_id)
	///
	/// @desc
	///
	/// @param {String} _id
	///
	/// @return {Any}
	static get_result = function (_id)
	{
		var _result = __results[$ _id];
		variable_struct_remove(__results, _id);
		return _result;
	};

	/// @func layout()
	///
	/// @desc
	///
	/// @return {Struct.FORMS_RootWidget} Returns `self`.
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
	};

	/// @func update(_deltaTime)
	///
	/// @desc
	///
	/// @param {Real} _deltaTime
	///
	/// @return {Struct.FORMS_RootWidget} Returns `self`.
	static update = function (_deltaTime)
	{
		global.__formsRoot = self;
		MouseX = window_mouse_get_x();
		MouseY = window_mouse_get_y();
		__mousePressed = {};
		__tooltip = undefined;
		__cursor = cr_default;
		layout();
		CompoundWidget_update(_deltaTime);
		global.__formsRoot = undefined;
		return self;
	};

	/// @func draw()
	///
	/// @desc
	///
	/// @return {Struct.FORMS_RootWidget} Returns `self`.
	static draw = function ()
	{
		global.__formsRoot = self;

		gpu_push_state();
		gpu_set_tex_filter(true);
		gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);

		CompoundWidget_draw();

		gpu_pop_state();

		if (__tooltip != undefined && WidgetActive == undefined)
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
					c_black, 0.5);

				draw_sprite_stretched_ext(
					FORMS_SprRound4,
					0,
					_tooltipX,
					_tooltipY,
					_tooltipWidth,
					_tooltipHeight,
					0xB3DCE9,
					_tooltipAlpha);
				draw_text_color(
					_tooltipX + _tooltipPaddingX,
					_tooltipY + _tooltipPaddingY,
					__tooltip,
					c_black, c_black, c_black, c_black,
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

		for (var i = array_length(__widgetsToDestroy) - 1; i >= 0; --i)
		{
			with (__widgetsToDestroy[i])
			{
				if (has_parent())
				{
					remove_self();
				}
				destroy();
			}
		}
		__widgetsToDestroy = [];

		global.__formsRoot = undefined;
		return self;
	};

	/// @func push_mouse_coordinates(_x, _y)
	///
	/// @desc
	///
	/// @param {Real} _x
	/// @param {Real} _y
	///
	/// @return {Struct.FORMS_RootWidget} Returns `self`.
	static push_mouse_coordinates = function (_x, _y)
	{
		MouseX -= _x;
		MouseY -= _y;
		return self;
	};

	/// @func set_tooltip(_tooltip)
	///
	/// @desc
	///
	/// @param {String, Undefined} _tooltip
	///
	/// @return {Struct.FORMS_RootWidget} Returns `self`.
	static set_tooltip = function (_tooltip)
	{
		__tooltip = _tooltip;
		return self;
	};

	/// @func set_cursor(_cursor)
	///
	/// @desc
	///
	/// @param {Constant.Cursor} _cursor
	///
	/// @return {Struct.FORMS_RootWidget} Returns `self`.
	static set_cursor = function (_cursor)
	{
		__cursor = _cursor;
		return self;
	};

	/// @func get_cursor()
	///
	/// @desc
	///
	/// @return {Constant.Cursor}
	static get_cursor = function ()
	{
		return __cursor;
	};

	/// @func check_mouse_pressed(_button)
	///
	/// @desc
	///
	/// @param {Constant.MouseButton} _button
	///
	/// @return {Bool}
	static check_mouse_pressed = function (_button)
	{
		if (mouse_check_button_pressed(_button))
		{
			var _pressed = __mousePressed[$ _button] ?? true;
			__mousePressed[$ _button] = false;
			return _pressed;
		}
		return false;
	};
}

/// forms_push_mouse_coordinates(_x, _y)
///
/// @desc
///
/// @param {Real} _x
/// @param {Real} _y
function forms_push_mouse_coordinates(_x, _y)
{
	gml_pragma("forceinline");
	forms_get_root().push_mouse_coordinates(_x, _y);
}

/// forms_mouse_get_x()
///
/// @desc
///
/// @return {Real}
function forms_mouse_get_x()
{
	gml_pragma("forceinline");
	return forms_get_root().MouseX;
}

/// forms_mouse_get_y()
///
/// @desc
///
/// @return {Real}
function forms_mouse_get_y()
{
	gml_pragma("forceinline");
	return forms_get_root().MouseY;
}

/// forms_mouse_in_rectangle(_x, _y, _width, _height)
///
/// @desc
///
/// @param {Real} _x
/// @param {Real} _y
/// @param {Real} _width
/// @param {Real} _height
///
/// @return {Bool}
function forms_mouse_in_rectangle(_x, _y, _width, _height)
{
	var _mouseX = forms_mouse_get_x();
	var _mouseY = forms_mouse_get_y();
	return (_mouseX >= _x && _mouseX < _x + _width
		&& _mouseY >= _y && _mouseY < _y + _height);
}

/// @func forms_mouse_check_button_pressed(_button)
///
/// @desc
///
/// @param {Constant.MouseButton} _button
///
/// @return {Bool}
function forms_mouse_check_button_pressed(_button)
{
	gml_pragma("forceinline");
	return forms_get_root().check_mouse_pressed(_button);
}

/// @func forms_set_tooltip(_tooltip)
///
/// @desc
///
/// @param {String, Undefined} _tooltip
function forms_set_tooltip(_tooltip)
{
	gml_pragma("forceinline");
	forms_get_root().set_tooltip(_tooltip);
}

/// @func forms_set_cursor(_cursor)
///
/// @desc
///
/// @param {Constant.Cursor} _cursor
function forms_set_cursor(_cursor)
{
	gml_pragma("forceinline");
	forms_get_root().set_cursor(_cursor);
}

/// @func forms_get_cursor()
///
/// @desc
///
/// @return {Constant.Cursor}
function forms_get_cursor()
{
	gml_pragma("forceinline");
	return forms_get_root().get_cursor();
}

/// @func forms_return_result(_id, _value)
///
/// @desc
///
/// @param {String} _id
/// @param {Any} _value
function forms_return_result(_id, _value)
{
	gml_pragma("forceinline");
	forms_get_root().return_result(_id, _value);
}

/// @func forms_has_result(_id)
///
/// @desc
///
/// @param {String} _id
///
/// @return {Bool}
function forms_has_result(_id)
{
	gml_pragma("forceinline");
	return forms_get_root().has_result(_id);
}

/// @func forms_get_result(_id)
///
/// @desc
///
/// @param {String} _id
///
/// @return {Any}
function forms_get_result(_id)
{
	gml_pragma("forceinline");
	return forms_get_root().get_result(_id);
}

/// @func forms_peek_result(_id)
///
/// @desc
///
/// @param {String} _id
///
/// @return {Any}
function forms_peek_result(_id)
{
	gml_pragma("forceinline");
	return forms_get_root().peek_result(_id);
}
