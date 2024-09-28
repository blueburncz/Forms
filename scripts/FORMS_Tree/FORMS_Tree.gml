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

	/// @var {Struct.FORMS_TreeItem, Undefined}
	Selected = undefined;

	{
		for (var i = array_length(Children) - 1; i >= 0; --i)
		{
			var _child = Children[i];
			forms_assert(_child.Tree == undefined, "Item already added to a tree!");
			_child.Tree = self;
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

	/// @var {Any}
	Data = undefined;

	/// @var {Function, Undefined}
	OnSelect = undefined;
}

/// @func FORMS_TreeItem(_textOrGetter[, _props[, _children]])
///
/// @desc
///
/// @param {String, Function} _textOrGetter
/// @param {Struct.FORMS_TreeItemProps, Undefined} [_props]
/// @param {Array<Struct.FORMS_TreeItem>, Undefined} [_children]
function FORMS_TreeItem(_textOrGetter, _props=undefined, _children=undefined) constructor
{
	/// @var {String, Undefined}
	Text = is_string(_textOrGetter) ? _textOrGetter : undefined;

	/// @var {Function, Undefined}
	Getter = is_method(_textOrGetter) ? _textOrGetter : undefined;

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

	/// @var {Any}
	Data = forms_get_prop(_props, "Data");

	/// @var {Function, Undefined}
	OnSelect = forms_get_prop(_props, "OnSelect");

	/// @var {Struct.FORMS_Tree, Undefined}
	/// @readonly
	Tree = undefined;

	/// @var {Struct.FORMS_TreeItem, Undefined}
	/// @readonly
	Parent = undefined;

	/// @var {Array<Struct.FORMS_TreeItem>, Undefined}
	/// @readonly
	Children = _children;

	{
		if (is_array(Children))
		{
			for (var i = array_length(Children) - 1; i >= 0; --i)
			{
				var _child = Children[i];
				forms_assert(_child.Parent == undefined, "Item already added to a tree!");
				_child.Parent = self;
			}
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
		var _iconWidth = 24;
		var _penX = _pen.X;

		// Highlight selected
		if (Tree == undefined)
		{
			var _current = Parent;
			while (_current != undefined)
			{
				if (_current.Tree != undefined)
				{
					Tree = _current.Tree;
					break;
				}
				_current = _current.Parent;
			}
		}

		if (Tree.Selected == self)
		{
			var _spacingY = floor(_pen.SpacingY / 2);
			forms_draw_rectangle(
				_pen.Content.Container.ScrollX,
				_pen.Y - _spacingY,
				_pen.Width,
				_pen.__lineHeight + _spacingY * 2,
				0x766056, 1.0);
		}

		// Caret
		if (is_array(Children))
		{
			var _iconProps = {
				Color: CaretColor,
				Alpha: CaretAlpha,
				Width: _iconWidth,
			};
			if (_pen.icon_solid(Collapsed ? FA_ESolid.CaretRight : FA_ESolid.CaretDown, _iconProps))
			{
				Collapsed = !Collapsed;
			}
		}

		// Icon
		var _icon = Collapsed ? (IconCollapsed ?? Icon) : Icon;
		if (_icon != undefined)
		{
			var _iconFont = Collapsed ? (IconCollapsedFont ?? IconFont) : IconFont;
			_pen.icon(_icon, _iconFont, { Color: IconColor, Alpha: IconAlpha, Width: _iconWidth });
		}

		// Text
		var _text = is_string(Text) ? Text : Getter(self);

		if (_pen.link(_text))
		{
			Tree.Selected = self;
			if (OnSelect)
			{
				OnSelect(self);
			}
		}
		_pen.nl();

		// Children
		if (is_array(Children))
		{
			if (!Collapsed)
			{
				_pen.move(_iconWidth);
				var _startX = _pen.StartX;
				_pen.StartX = _pen.X;
				var i = 0;
				repeat (array_length(Children))
				{
					var _child = Children[i++];
					_child.Tree = Tree;
					_child.draw(_pen);
				}
				_pen.StartX = _startX;
			}
		}

		_pen.set_x(_penX);
		return self;
	};
}
