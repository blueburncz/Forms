/// @func FORMS_BoxProps()
///
/// @extends FORMS_WidgetProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_Box}.
function FORMS_BoxProps(): FORMS_WidgetProps() constructor
{
	/// @var {Real, String, Undefined} Spacing between individual children.
	Spacing = undefined;

	/// @var {Real, Undefined} The type of units to use for
	/// {@link FORMS_BoxProps.Spacing} (when its type is `Real`). Use values
	/// from {@link FORMS_EUnit}.
	SpacingUnit = undefined;
}

/// @func FORMS_Box([_props[, _children]])
///
/// @extends FORMS_CompoundWidget
///
/// @desc Base struct for "box" widgets. These draw their children in a linear
/// (horizontal or vertical) layout.
///
/// @param {Struct.FORMS_BoxProps, Undefined} [_props] Properties to create the
/// box with or `undefined` (default).
/// @param {Array<Struct.FORMS_Widget>, Undefined} [_children] An array of child
/// widgets to add to the box or `undefined` (default).
function FORMS_Box(_props = undefined, _children = undefined): FORMS_CompoundWidget(_props, _children) constructor
{
	/// @var {Struct.FORMS_UnitValue} Spacing between individual children.
	/// Defaults to 0px.
	Spacing = new FORMS_UnitValue().from_props(_props, "Spacing");

	/// @var {Struct.FORMS_UnitValue} The width of the box. Defaults to
	/// "auto".
	Width = Width.from_props(_props, "Width", 0, FORMS_EUnit.Auto);

	/// @var {Struct.FORMS_UnitValue} The height of the box. Defaults to
	/// "auto".
	Height = Height.from_props(_props, "Height", 0, FORMS_EUnit.Auto);

	static get_auto_width = function () { return 0; }

	static get_auto_height = function () { return 0; }
}

/// @func FORMS_VBoxProps()
///
/// @extends FORMS_BoxProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_VBox}.
function FORMS_VBoxProps(): FORMS_BoxProps() constructor {}

/// @func FORMS_VBox([_props[, _children]])
///
/// @extends FORMS_Box
///
/// @desc A vertical box widget.
///
/// @param {Struct.FORMS_VBoxProps, Undefined} [_props] Properties to create the
/// vertical box widget with or `undefined` (default).
/// @param {Array<Struct.FORMS_Widget>, Undefined} [_children] An array of child
/// widgets to add to the vertical box or `undefined` (default).
function FORMS_VBox(_props = undefined, _children = undefined): FORMS_Box(_props, _children) constructor
{
	static layout = function ()
	{
		FORMS_LAYOUT_GENERATED;

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
			with(Children[i])
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
	}
}

/// @func FORMS_HBoxProps()
///
/// @extends FORMS_BoxProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_HBox}.
function FORMS_HBoxProps(): FORMS_BoxProps() constructor {}

/// @func FORMS_HBox([_props[, _children]])
///
/// @extends FORMS_Box
///
/// @desc A horizontal box widget.
///
/// @param {Struct.FORMS_HBoxProps, Undefined} [_props] Properties to create the
/// horizontal box with or `undefined` (default).
/// @param {Array<Struct.FORMS_Widget>, Undefined} [_children] An array of child
/// widgets to add to the horizontal box or `undefined` (default).
function FORMS_HBox(_props = undefined, _children = undefined): FORMS_Box(_props, _children) constructor
{
	static layout = function ()
	{
		FORMS_LAYOUT_GENERATED;

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
			with(Children[i])
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
	}
}

/// @func FORMS_FlexBoxProps()
///
/// @extends FORMS_BoxProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_FlexBox}.
function FORMS_FlexBoxProps(): FORMS_BoxProps() constructor
{
	/// @var {Bool, Undefined} Whether the flex box is horizontal (`true`) or
	/// vertical (`false`).
	IsHorizontal = undefined;

	/// @var {Real, String, Undefined} Padding around child widgets on the X
	/// axis.
	PaddingX = undefined;

	/// @var {Real, Undefined} The type of units used by
	/// {@link FORMS_FlexBoxProps.PaddingX} (if its type is `Real`). Use values
	/// from {@link FORMS_EUnit}.
	PaddingXUnit = undefined;

	/// @var {Real, String, Undefined} Padding around child widgets on the Y
	/// axis.
	PaddingY = undefined;

	/// @var {Real, Undefined} The type of units used by
	/// {@link FORMS_FlexBoxProps.PaddingY} (if its type is `Real`). Use values
	/// from {@link FORMS_EUnit}.
	PaddingYUnit = undefined;
}

/// @func FORMS_FlexBox([_props[, _children]])
///
/// @extends FORMS_Box
///
/// @desc A box that supports both horizontal and vertical layout. Its child
/// widgets automatically grow in size based on their {@link FORMS_Widget.Flex}
/// property (the greater the value the more space they take).
///
/// @param {Struct.FORMS_FlexBoxProps, Undefined} [_props] Properties to create
/// the flex box with or `undefined` (default).
/// @param {Array<Struct.FORMS_Widget>, Undefined} [_children] An array of child
/// widgets to add to the flex box or `undefined` (default).
function FORMS_FlexBox(_props = undefined, _children = undefined): FORMS_Box(_props, _children) constructor
{
	/// @var {Bool} Whether the flex box is horizontal (`true`) or vertical
	/// (`false`).
	IsHorizontal = forms_get_prop(_props, "IsHorizontal") ?? true;

	/// @var {Struct.FORMS_UnitValue} Padding around children on the X
	/// axis. Defaults to 0px.
	PaddingX = new FORMS_UnitValue().from_props(_props, "PaddingX");

	/// @var {Struct.FORMS_UnitValue} Padding around children on the Y
	/// axis. Defaults to 0px.
	PaddingY = new FORMS_UnitValue().from_props(_props, "PaddingY");

	static layout = function ()
	{
		FORMS_LAYOUT_GENERATED;

		var _isHorizontal = IsHorizontal;
		var _paddingX = PaddingX.get_absolute(__realWidth);
		var _paddingY = PaddingY.get_absolute(__realHeight);
		var _spacing = Spacing.get_absolute(_isHorizontal ? __realWidth : __realHeight);
		var _parentX = __realX + _paddingX;
		var _parentY = __realY + _paddingY;
		var _parentWidth = __realWidth - _paddingX * 2;
		var _parentHeight = __realHeight - _paddingY * 2;
		var _count = array_length(Children);

		// First pass
		var _flexSize = (_isHorizontal ? _parentWidth : _parentHeight) - (max(_count - 1, 0) * _spacing);
		var _flexCount = 0;
		var _staticSize = 0;
		var _flexSum = 0;
		for (var i = 0; i < _count; ++i)
		{
			with(Children[i])
			{
				var _autoWidth = get_auto_width();
				var _autoHeight = get_auto_height();

				if (Flex > 0)
				{
					++_flexCount;
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
					_staticSize += _isHorizontal ? __realWidth : __realHeight;
				}
			}
		}
		var _flexPos = _isHorizontal ? _parentX : _parentY;

		// Adjust sizes if there's not enough space
		if (_flexSize < 0)
		{
			var _adjustTotal = -_flexSize - _spacing * _flexCount;

			for (var i = 0; i < _count; ++i)
			{
				with(Children[i])
				{
					if (Flex <= 0)
					{
						var _adjustSize = _adjustTotal * (_isHorizontal ? (__realWidth / _staticSize) : (
							__realHeight / _staticSize));

						if (_isHorizontal)
						{
							__realWidth -= _adjustSize;
						}
						else
						{
							__realHeight -= _adjustSize;
						}

						_flexSize += _adjustSize;
					}
				}
			}
		}

		// Positions and flex sizes
		for (var i = 0; i < _count; ++i)
		{
			with(Children[i])
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
	}
}
