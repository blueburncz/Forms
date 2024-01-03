/// @enum
enum FORMS_EUnit
{
	/// @member
	Pixel,
	/// @member
	Percent,
	/// @member Value is computed automatically. Using this in unsupported
	/// places results into errors!
	Auto,
	/// @member Total number of members of this enum.
	SIZE
};

/// @func FORMS_WidgetUnitValue([_value[, _unit]])
///
/// @desc
///
/// @param {Real} [_value]
/// @param {Real} [_unit] Use values from {@link FORMS_EUnit.Pixel}.
function FORMS_WidgetUnitValue(_value=0, _unit=FORMS_EUnit.Pixel) constructor
{
	/// @var {Real}
	Value = _value;

	/// @var {Real}
	/// @see FORMS_EUnit
	Unit = _unit;

	/// @func from_string(_string)
	///
	/// @desc
	///
	/// @param {String} _string
	///
	/// @return {Struct.FORMS_WidgetUnitValue} Returns `self`.
	static from_string = function (_string)
	{
		return self;
	};

	/// @func from_props(_props, _name[, _valueDefault[, _unitDefault]])
	///
	/// @desc
	///
	/// @param {Struct.FORMS_WidgetProps, undefined} _props
	/// @param {String} _name
	/// @param {Real} [_valueDefault]
	/// @param {Real} [_unitDefault]
	///
	/// @return {Struct.FORMS_WidgetUnitValue} Returns `self`.
	static from_props = function (_props, _name, _valueDefault=0, _unitDefault=FORMS_EUnit.Pixel)
	{
		if (_props == undefined)
		{
			Value = _valueDefault;
			Unit = _unitDefault;
		}
		else
		{
			Value = _props[$ _name] ?? _valueDefault;
			Unit = _props[$ _name + "Unit"] ?? _unitDefault;
		}
		return self;
	};

	/// @func get_absolute(_relativeTo[, _autoSize])
	///
	/// @desc
	///
	/// @param {Real} _relativeTo
	/// @param {Real, Undefined} [_autoSize]
	///
	/// @return {Real}
	static get_absolute = function (_relativeTo, _autoSize=undefined)
	{
		gml_pragma("forceinline");
		switch (Unit)
		{
		case FORMS_EUnit.Pixel:
			return Value;
		case FORMS_EUnit.Percent:
			return (_relativeTo * Value * 0.01);
		case FORMS_EUnit.Auto:
			forms_assert(_autoSize != undefined, "Auto size not defined!");
			return _autoSize;
		default:
			forms_assert(false, "Invalid unit!");
		}
	};
}

/// @func FORMS_WidgetProps()
///
/// @desc
function FORMS_WidgetProps() constructor
{
	/// @var {String, Undefined} A unique identifier of the widget.
	Id = undefined;

	/// @var {Real, Undefined} The widget's X position relative to its parent.
	X = undefined;

	/// @var {Real, Undefined} Use values from {@link FORMS_EUnit.Pixel}.
	XUnit = undefined;

	/// @var {Real, Undefined} The widget's Y position relative to its parent.
	Y = undefined;

	/// @var {Real, Undefined} Use values from {@link FORMS_EUnit.Pixel}.
	YUnit = undefined;

	/// @var {Real, Undefined} The widget's width.
	Width = undefined;

	/// @var {Real, Undefined} Use values from {@link FORMS_EUnit.Pixel}.
	WidthUnit = undefined;

	/// @var {Real, Undefined} The widget's height.
	Height = undefined;

	/// @var {Real, Undefined} Use values from {@link FORMS_EUnit.Pixel}.
	HeightUnit = undefined;
}

/// @func forms_get_prop(_props, _name)
///
/// @desc
///
/// @param {Struct, Undefined} _props
/// @param {String} _name
///
/// @return {Any}
function forms_get_prop(_props, _name)
{
	gml_pragma("forceinline");
	return ((_props != undefined) ? _props[$ _name] : undefined);
}

/// @func FORMS_Widget([_props])
///
/// @desc
///
/// @param {Struct.FORMS_WidgetProps, Undefined} [_props]
function FORMS_Widget(_props=undefined) constructor
{
	static __idNext = 0;

	/// @var {String} A unique identifier of the widget.
	Id = forms_get_prop(_props, "Id") ?? $"Widget{__idNext++}";

	/// @var {Struct.FORMS_CompoundWidget, Undefined}
	/// @readonly
	Parent = undefined;

	/// @var {Struct.FORMS_WidgetUnitValue} The widget's X position relative to
	/// its parent widget.
	X = new FORMS_WidgetUnitValue().from_props(_props, "X");

	/// @var {Real} The widget's actual X position.
	/// @private
	__realX = 0;

	/// @var {Struct.FORMS_WidgetUnitValue} The widget's Y position relative to
	/// its parent widget.
	Y = new FORMS_WidgetUnitValue().from_props(_props, "Y");

	/// @var {Real} The widget's actual Y position.
	/// @private
	__realY = 0;

	/// @var {Struct.FORMS_WidgetUnitValue} The widget's width.
	Width = new FORMS_WidgetUnitValue().from_props(_props, "Width");

	/// @var {Real} The widget's actual width.
	/// @private
	__realWidth = 0;

	/// @var {Struct.FORMS_WidgetUnitValue} The widget's height.
	Height = new FORMS_WidgetUnitValue().from_props(_props, "Height");

	/// @var {Real} The widget's actual height.
	/// @private
	__realHeight = 0;

	/// @var {Bool}
	/// @private
	__toDestroy = false;

	/// @func get_x()
	///
	/// @desc
	///
	/// @return {Real}
	static get_x = function ()
	{
		gml_pragma("forceinline");
		return __realX;
	};

	/// @func get_y()
	///
	/// @desc
	///
	/// @return {Real}
	static get_y = function ()
	{
		gml_pragma("forceinline");
		return __realY;
	};

	/// @func get_width()
	///
	/// @desc
	///
	/// @return {Real}
	static get_width = function ()
	{
		gml_pragma("forceinline");
		return __realWidth;
	};

	/// @func get_height()
	///
	/// @desc
	///
	/// @return {Real}
	static get_height = function ()
	{
		gml_pragma("forceinline");
		return __realHeight;
	};

	/// @func has_parent()
	///
	/// @desc
	///
	/// @return {Bool}
	static has_parent = function ()
	{
		gml_pragma("forceinline");
		return (Parent != undefined);
	};

	/// @func remove_self()
	///
	/// @desc
	///
	/// @return {Struct.FORMS_Widget} Returns `self`.
	static remove_self = function ()
	{
		forms_assert(Parent != undefined, "Widget does not have a parent!");
		Parent.remove_child(self);
		return self;
	};

	/// @func find_widget(_id)
	///
	/// @desc
	///
	/// @param {String} _id
	///
	/// @return {Struct.FORMS_Widget, Undefined}
	static find_widget = function (_id)
	{
		gml_pragma("forceinline");
		return (Id == _id) ? self : undefined;
	};

	/// @func get_auto_width()
	///
	/// @desc
	///
	/// @return {Real, Undefined}
	static get_auto_width = function () { return undefined; };

	/// @func get_auto_height()
	///
	/// @desc
	///
	/// @return {Real, Undefined}
	static get_auto_height = function () { return undefined; };

	/// @func layout()
	///
	/// @desc
	///
	/// @return {Struct.FORMS_Widget} Returns `self`.
	static layout = function ()
	{
		if (forms_mouse_in_rectangle(__realX, __realY, __realWidth, __realHeight))
		{
			forms_get_root().WidgetHovered = self;
		}
		return self;
	};

	/// @func is_mouse_over()
	///
	/// @desc
	///
	/// @return {Bool}
	static is_mouse_over = function ()
	{
		return forms_get_root().WidgetHovered == self;
	};

	/// @func update(_deltaTime)
	///
	/// @desc
	///
	/// @param {Real} _deltaTime
	///
	/// @return {Struct.FORMS_Widget} Returns `self`.
	static update = function (_deltaTime)
	{
		return self;
	};

	/// @func draw()
	///
	/// @desc
	///
	/// @return {Struct.FORMS_Widget} Returns `self`.
	static draw = function ()
	{
		return self;
	};

	/// @func destroy_later()
	///
	/// @desc
	///
	/// @return {Undefined}
	static destroy_later = function ()
	{
		if (!__toDestroy)
		{
			array_push(forms_get_root().__widgetsToDestroy, self);
			__toDestroy = true;
		}
		return undefined;
	};

	/// @func destroy()
	///
	/// @desc
	///
	/// @return {Undefined}
	static destroy = function ()
	{
		return undefined;
	};
}
