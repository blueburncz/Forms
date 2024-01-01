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

/// @func FORMS_RootWidget([_props[, _children]])
///
/// @extends FORMS_CompoundWidget
///
/// @desc
///
/// @param {Struct.FORMS_WidgetProps, Undefined} [_props]
/// @param {Array<Struct.FORMS_Widget>, Undefined} [_children]
function FORMS_RootWidget(_props=undefined, _children=undefined)
	: FORMS_CompoundWidget(_props, _children) constructor
{
	static CompoundWidget_layout = layout;
	static CompoundWidget_update = update;
	static CompoundWidget_draw = draw;

	Width.from_props(_props, "Width", 100, FORMS_EUnit.Percent);
	Height.from_props(_props, "Height", 100, FORMS_EUnit.Percent);

	/// @var {Real}
	/// @readonly
	MouseX = 0;

	/// @var {Real}
	/// @readonly
	MouseY = 0;

	__tooltip = undefined;
	__tooltipLast = undefined;
	__tooltipTimer = 0;

	__cursor = cr_default;
	__cursorLast = __cursor;

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
		layout();
		MouseX = window_mouse_get_x();
		MouseY = window_mouse_get_y();
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
		MouseX = window_mouse_get_x();
		MouseY = window_mouse_get_y();
		__tooltip = undefined;
		__cursor = cr_default;

		CompoundWidget_draw();

		if (__tooltip != undefined/* && __widgetActive == undefined*/)
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
				var _tooltipX = forms_mouse_get_x() + 16;
				var _tooltipY = forms_mouse_get_y() + 16;
				var _tooltipAlpha = min((__tooltipTimer - 500) / 100, 1);
				var _a = draw_get_alpha();
				draw_set_alpha(_tooltipAlpha);
				draw_rectangle_color(
					_tooltipX,
					_tooltipY,
					_tooltipX + string_width(__tooltip) - 1,
					_tooltipY + string_height(__tooltip) - 1,
					c_black, c_black, c_black, c_black,
					false);
				draw_set_alpha(_a);
				draw_text_color(
					_tooltipX,
					_tooltipY,
					__tooltip,
					c_white, c_white, c_white, c_white,
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
function forms_get_cursor(_cursor)
{
	gml_pragma("forceinline");
	return forms_get_root().get_cursor();
}
