/// @func FORMS_BoxProps()
///
/// @extends FORMS_WidgetProps
///
/// @desc
function FORMS_BoxProps()
	: FORMS_WidgetProps() constructor
{
	/// @var {Real, Undefined}
	Spacing = undefined;

	/// @var {Real, Undefined} Use values from {@link FORMS_EUnit}.
	SpacingUnit = undefined;
}

/// @func FORMS_Box([_props[, _children]])
///
/// @extends FORMS_CompoundWidget
///
/// @desc
///
/// @param {Struct.FORMS_WidgetProps, Undefined} [_props]
/// @param {Array<Struct.FORMS_BoxProps>, Undefined} [_children]
function FORMS_Box(_props=undefined, _children=undefined)
	: FORMS_CompoundWidget(_props, _children) constructor
{
	Width.from_props(_props, "Width", 0, FORMS_EUnit.Auto);
	Height.from_props(_props, "Height", 0, FORMS_EUnit.Auto);

	/// @var {Struct.FORMS_WidgetUnitValue}
	Spacing = new FORMS_WidgetUnitValue().from_props(_props, "Spacing");

	static get_auto_width = function () { return 0; };

	static get_auto_height = function () { return 0; };
}

/// @func FORMS_VBox([_props[, _children]])
///
/// @extends FORMS_Box
///
/// @desc
///
/// @param {Struct.FORMS_WidgetProps, Undefined} [_props]
/// @param {Array<Struct.FORMS_BoxProps>, Undefined} [_children]
function FORMS_VBox(_props=undefined, _children=undefined)
	: FORMS_Box(_props, _children) constructor
{
	static layout = function ()
	{
		var _parentX = __realX;
		var _parentY = __realY;
		var _parentWidth = __realWidth;
		var _parentHeight = __realHeight;
		var _currentY = _parentY;
		var _spacing = Spacing.get_absolute(Parent.get_height());
		var _autoWidth = 0;
		var _count = array_length(Children);

		for (var i = 0; i < _count; ++i)
		{
			with (Children[i])
			{
				var _childAutoWidth = get_auto_width();
				var _childAutoHeight = get_auto_height();

				__realWidth = floor(Width.get_absolute(_parentWidth, _childAutoWidth));
				__realHeight = floor(Height.get_absolute(_parentHeight, _childAutoHeight));
				__realX = floor(_parentX + X.get_absolute(_parentWidth, _childAutoWidth));
				__realY = floor(_currentY + Y.get_absolute(_parentHeight, _childAutoHeight));

				layout();

				_autoWidth = max(__realWidth, _autoWidth);
				_currentY += __realHeight + _spacing;
			}
		}

		var _autoHeight = _currentY - ((_count > 0) ? _spacing : 0) - _parentY;

		__realWidth = Width.get_absolute(Parent.get_width(), _autoWidth);
		__realHeight = Height.get_absolute(Parent.get_height(), _autoHeight);

		return self;
	};
}

/// @func FORMS_HBox([_props[, _children]])
///
/// @extends FORMS_Box
///
/// @desc
///
/// @param {Struct.FORMS_WidgetProps, Undefined} [_props]
/// @param {Array<Struct.FORMS_BoxProps>, Undefined} [_children]
function FORMS_HBox(_props=undefined, _children=undefined)
	: FORMS_Box(_props, _children) constructor
{
	static layout = function ()
	{
		var _parentX = __realX;
		var _parentY = __realY;
		var _parentWidth = __realWidth;
		var _parentHeight = __realHeight;
		var _currentX = _parentX;
		var _spacing = Spacing.get_absolute(Parent.get_width());
		var _autoHeight = 0;
		var _count = array_length(Children);

		for (var i = 0; i < _count; ++i)
		{
			with (Children[i])
			{
				var _childAutoWidth = get_auto_width();
				var _childAutoHeight = get_auto_height();

				__realWidth = floor(Width.get_absolute(_parentWidth, _childAutoWidth));
				__realHeight = floor(Height.get_absolute(_parentHeight, _childAutoHeight));
				__realX = floor(_currentX + X.get_absolute(_parentWidth, _childAutoWidth));
				__realY = floor(_parentY + Y.get_absolute(_parentHeight, _childAutoHeight));

				layout();

				_autoHeight = max(__realHeight, _autoHeight);
				_currentX += __realWidth + _spacing;
			}
		}

		var _autoWidth = _currentX - ((_count > 0) ? _spacing : 0) - _parentX;

		__realWidth = Width.get_absolute(Parent.get_width(), _autoWidth);
		__realHeight = Height.get_absolute(Parent.get_height(), _autoHeight);

		return self;
	};
}
