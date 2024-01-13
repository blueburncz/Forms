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
/// @param {Struct.FORMS_BoxProps, Undefined} [_props]
/// @param {Array<Struct.FORMS_Widget>, Undefined} [_children]
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
/// @param {Struct.FORMS_BoxProps, Undefined} [_props]
/// @param {Array<Struct.FORMS_Widget>, Undefined} [_children]
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

		if (forms_mouse_in_rectangle(__realX, __realY, __realWidth, __realHeight))
		{
			forms_get_root().WidgetHovered = self;
		}

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
/// @param {Struct.FORMS_FlexBoxProps, Undefined} [_props]
/// @param {Array<Struct.FORMS_Widget>, Undefined} [_children]
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

		if (forms_mouse_in_rectangle(__realX, __realY, __realWidth, __realHeight))
		{
			forms_get_root().WidgetHovered = self;
		}

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

/// @func FORMS_FlexBoxProps()
///
/// @extends FORMS_BoxProps
///
/// @desc
function FORMS_FlexBoxProps()
	: FORMS_BoxProps() constructor
{
	/// @var {Bool, Undefined}
	IsHorizontal = undefined;
}

/// @func FORMS_FlexBox([_props[, _children]])
///
/// @extends FORMS_Box
///
/// @desc
///
/// @param {Struct.FORMS_WidgetProps, Undefined} [_props]
/// @param {Array<Struct.FORMS_FlexBoxProps>, Undefined} [_children]
function FORMS_FlexBox(_props=undefined, _children=undefined)
	: FORMS_Box(_props, _children) constructor
{
	//static Box_layout = layout;

	/// @var {Bool}
	IsHorizontal = forms_get_prop(_props, "IsHorizontal") ?? true;

	static layout = function ()
	{
		var _parentX = __realX;
		var _parentY = __realY;
		var _parentWidth = __realWidth;
		var _parentHeight = __realHeight;
		var _isHorizontal = IsHorizontal;
		var _spacing = Spacing.get_absolute(_isHorizontal ? __realWidth : __realHeight);
		var _count = array_length(Children);

		if (forms_mouse_in_rectangle(__realX, __realY, __realWidth, __realHeight))
		{
			forms_get_root().WidgetHovered = self;
		}

		var _flexSize = (_isHorizontal ? __realWidth : __realHeight) - (max(_count - 1, 0) * _spacing);
		var _flexSum = 0;
		for (var i = 0; i < _count; ++i)
		{
			with (Children[i])
			{
				var _autoWidth = get_auto_width();
				var _autoHeight = get_auto_height();

				if (Flex > 0)
				{
					_flexSum += Flex;

					if (_isHorizontal)
					{
						__realHeight = floor(Height.get_absolute(_parentHeight, _autoHeight));
					}
					else
					{
						__realWidth = floor(Width.get_absolute(_parentWidth, _autoWidth));
					}
				}
				else
				{
					__realWidth = floor(Width.get_absolute(_parentWidth, _autoWidth));
					__realHeight = floor(Height.get_absolute(_parentHeight, _autoHeight));

					_flexSize -= _isHorizontal ? __realWidth : __realHeight;
				}
			}
		}
		var _flexPos = _isHorizontal ? _parentX : _parentY;

		for (var i = 0; i < _count; ++i)
		{
			with (Children[i])
			{
				var _autoWidth = get_auto_width();
				var _autoHeight = get_auto_height();

				if (_isHorizontal)
				{
					if (Flex > 0)
					{
						__realWidth = _flexSize * (Flex / _flexSum);
					}
					__realX = floor(_flexPos);
					__realY = floor(_parentY + Y.get_absolute(_parentHeight, _autoHeight));
				}
				else
				{
					if (Flex > 0)
					{
						__realHeight = _flexSize * (Flex / _flexSum);
					}
					__realX = floor(_parentX + X.get_absolute(_parentWidth, _autoWidth));
					__realY = floor(_flexPos);
				}

				layout();

				_flexPos += (_isHorizontal ? __realWidth : __realHeight) + _spacing;
			}
		}

		return self;
	};
}
