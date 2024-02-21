/// @func FORMS_Tree([_children])
///
/// @desc
///
/// @param {Array<Struct.FORMS_TreeItem>} [_children]
function FORMS_Tree(_children=[]) constructor
{
	/// @var {Array<Struct.FORMS_TreeItem>}
	/// @readonly
	Children = _children;

	{
		for (var i = array_length(Children) - 1; i >= 0; --i)
		{
			var _child = Children[i];
			forms_assert(_child.Parent == undefined, "Tree child already has a parent!");
			_child.Parent = self;
		}
	}

	/// @func draw(_pen)
	///
	/// @desc
	///
	/// @param {Struct.FORMS_Pen} _pen
	///
	/// @return {Struct.FORMS_Tree} Returns `self`.
	static draw = function (_pen)
	{
		var i = 0;
		repeat (array_length(Children))
		{
			Children[i++].draw(_pen);
		}
		return self;
	};
}

/// @func FORMS_TreeItemProps()
///
/// @desc
function FORMS_TreeItemProps() constructor
{
	/// @var {Real, Undefined}
	Icon = undefined;

	/// @var {Asset.GMFont, Undefined}
	IconFont = undefined;

	/// @var {Real, Undefined}
	IconCollapsed = undefined;

	/// @var {Asset.GMFont, Undefined}
	IconCollapsedFont = undefined;

	/// @var {Constant.Color, Undefined}
	IconColor = undefined;

	/// @var {Real, Undefined}
	IconAlpha = undefined;

	/// @var {Constant.Color, Undefined}
	CaretColor = undefined;

	/// @var {Real, Undefined}
	CaretAlpha = undefined;

	/// @var {Bool, Undefined}
	Collapsed = undefined;
}

/// @func FORMS_TreeItem(_text[, _props[, _children]])
///
/// @desc
///
/// @param {String} _text
/// @param {Struct.FORMS_TreeItemProps, Undefined} [_props]
/// @param {Array<Struct.FORMS_TreeItem>} [_children]
function FORMS_TreeItem(_text, _props=undefined, _children=[]) constructor
{
	/// @var {String}
	Text = _text;

	/// @var {Real, Undefined}
	Icon = forms_get_prop(_props, "Icon");

	/// @var {Asset.GMFont}
	IconFont = forms_get_prop(_props, "IconFont") ?? FA_FntRegular12;

	/// @var {Real, Undefined}
	IconCollapsed = forms_get_prop(_props, "IconCollapsed");

	/// @var {Asset.GMFont, Undefined}
	IconCollapsedFont = forms_get_prop(_props, "IconCollapsedFont");

	/// @var {Constant.Color}
	IconColor = forms_get_prop(_props, "IconColor") ?? c_white;

	/// @var {Real}
	IconAlpha = forms_get_prop(_props, "IconAlpha") ?? 1.0;

	/// @var {Constant.Color}
	CaretColor = forms_get_prop(_props, "CaretColor") ?? c_white;

	/// @var {Real}
	CaretAlpha = forms_get_prop(_props, "CaretAlpha") ?? 1.0;

	/// @var {Bool}
	Collapsed = forms_get_prop(_props, "Collapsed") ?? false;

	/// @var {Struct.FORMS_TreeItem, Undefined}
	/// @readonly
	Parent = undefined;

	/// @var {Array<Struct.FORMS_TreeItem>}
	/// @readonly
	Children = _children;

	{
		for (var i = array_length(Children) - 1; i >= 0; --i)
		{
			var _child = Children[i];
			forms_assert(_child.Parent == undefined, "Tree child already has a parent!");
			_child.Parent = self;
		}
	}

	/// @func draw(_pen)
	///
	/// @desc
	///
	/// @param {Struct.FORMS_Pen} _pen
	///
	/// @return {Struct.FORMS_TreeItem} Returns `self`.
	static draw = function (_pen)
	{
		var _iconWidth = 20;
		var _penX = _pen.X;

		// Caret
		if (array_length(Children) > 0)
		{
			if (_pen.icon_solid(Collapsed ? FA_ESolid.CaretRight : FA_ESolid.CaretDown, { Color: CaretColor, Alpha: CaretAlpha }))
			{
				Collapsed = !Collapsed;
			}
		}
		_pen.set_x(_penX + _iconWidth);

		// Icon
		var _icon = Collapsed ? (IconCollapsed ?? Icon) : Icon;
		if (_icon != undefined)
		{
			var _iconFont = Collapsed ? (IconCollapsedFont ?? IconFont) : IconFont;
			fa_draw(_iconFont, _icon, _pen.X, _pen.Y, IconColor, IconAlpha);
			_pen.set_x(_pen.X + _iconWidth);
		}

		// Text
		_pen.link(Text);
		_pen.nl();

		// Children
		if (!Collapsed)
		{
			_pen.move(_iconWidth);
			var _columnX = _pen.ColumnX;
			_pen.ColumnX = _pen.X;
			var i = 0;
			repeat (array_length(Children))
			{
				Children[i++].draw(_pen);
			}
			_pen.ColumnX = _columnX;
		}

		_pen.set_x(_penX);
		return self;
	};
}
