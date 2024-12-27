/// @func FORMS_Tree([_children])
///
/// @desc A hierarchy of collapsible, selectable items.
///
/// @param {Array<Struct.FORMS_TreeItem>} [_children] An array of items to add to the tree. Defaults to an empty array.
function FORMS_Tree(_children = []) constructor
{
	/// @var {Array<Struct.FORMS_TreeItem>} An array of items added to the tree.
	/// @readonly
	Children = _children;

	/// @var {Struct.FORMS_TreeItem, Undefined} The currently selected item in the tree or `undefined`.
	Selected = undefined;

	for (var i = array_length(Children) - 1; i >= 0; --i)
	{
		var _child = Children[i];
		forms_assert(_child.Tree == undefined, "Item already added to a tree!");
		_child.Tree = self;
	}

	/// @func draw(_pen)
	///
	/// @desc Draws the tree using given {@link FORMS_Pen}.
	///
	/// @param {Struct.FORMS_Pen} _pen The pen to use to draw the tree.
	///
	/// @return {Struct.FORMS_Tree} Returns `self`.
	static draw = function (_pen)
	{
		var i = 0;
		repeat(array_length(Children))
		{
			Children[i++].draw(_pen);
		}
		return self;
	}
}

/// @func FORMS_TreeItemProps()
///
/// @desc Properties accepted by the constructor of {@link FORMS_TreeItem}.
function FORMS_TreeItemProps() constructor
{
	/// @var {Real, Undefined} A Font Awesome icon drawn next to the tree item or `undefined`. Use values from
	/// {@link FA_ESolid}, {@link FA_ERegular} or {@link FA_EBrands}.
	Icon = undefined;

	/// @var {Asset.GMFont, Undefined} The font used to draw the icon next to the tree item.
	IconFont = undefined;

	/// @var {Real, Undefined} A Font Awesome icon drawn next to the tree item when it's collapsed or `undefined`, in
	/// which case the same icon is used. Use values from {@link FA_ESolid}, {@link FA_ERegular} or {@link FA_EBrands}.
	IconCollapsed = undefined;

	/// @var {Asset.GMFont, Undefined} The font used to draw the icon next to the tree item when it's collapsed or
	/// `undefined`, in which case the same font is used.
	IconCollapsedFont = undefined;

	/// @var {Bool, Undefined} Whether the tree item is collapsed (`true`) or not (`false`). Child items are not drawn
	/// when collapsed.
	Collapsed = undefined;

	/// @var {Any} Data associated with the tree item.
	Data = undefined;

	/// @var {Function, Undefined} A function executed when the tree item is
	/// selected or `undefined`.
	OnSelect = undefined;
}

/// @func FORMS_TreeItem(_textOrGetter[, _props[, _children]])
///
/// @desc An item of a {@link FORMS_Tree}.
///
/// @param {String, Function} _textOrGetter The name of the tree item or a function that returns it.
/// @param {Struct.FORMS_TreeItemProps, Undefined} [_props] Properties to create the tree item with or `undefined`
/// (default).
/// @param {Array<Struct.FORMS_TreeItem>, Undefined} [_children] An array of child tree items or `undefined` (default).
function FORMS_TreeItem(_textOrGetter, _props = undefined, _children = undefined) constructor
{
	/// @var {String, Undefined} The name of the tree item or `undefined`.
	/// @note Either this or {@link FORMS_TreeItem.Getter} must be defined!
	Text = is_string(_textOrGetter) ? _textOrGetter : undefined;

	/// @var {Function, Undefined} A function that returns the name of the tree item, or `undefined`.
	/// @note Either this or {@link FORMS_TreeItem.Text} must be defined!
	Getter = is_method(_textOrGetter) ? _textOrGetter : undefined;

	/// @var {Real, Undefined} A Font Awesome icon drawn next to the tree item or `undefined`. Use values from
	/// {@link FA_ESolid}, {@link FA_ERegular} or {@link FA_EBrands}.
	Icon = forms_get_prop(_props, "Icon");

	/// @var {Asset.GMFont} The font used to draw the icon next to the tree item. Defaults to `FA_FntRegular12`.
	IconFont = forms_get_prop(_props, "IconFont") ?? FA_FntRegular12;

	/// @var {Real, Undefined} A Font Awesome icon drawn next to the tree item when it's collapsed or `undefined`
	/// (default), in which case the same icon is used. Use values from {@link FA_ESolid}, {@link FA_ERegular} or
	/// {@link FA_EBrands}.
	/// @see FORMS_TreeItem.Icon
	/// @see FORMS_TreeItem.Collapsed
	IconCollapsed = forms_get_prop(_props, "IconCollapsed");

	/// @var {Asset.GMFont, Undefined} The font used to draw the icon next to the tree item when it's collapsed or
	/// `undefined` (default), in which case the same font is used.
	/// @see FORMS_TreeItem.IconFont
	/// @see FORMS_TreeItem.Collapsed
	IconCollapsedFont = forms_get_prop(_props, "IconCollapsedFont");

	/// @var {Bool} Whether the tree item is collapsed (`true`) or not (`false`, default). Child items are not drawn
	/// when collapsed.
	Collapsed = forms_get_prop(_props, "Collapsed") ?? false;

	/// @var {Any} Data associated with the tree item. Defaults to `undefined`.
	Data = forms_get_prop(_props, "Data");

	/// @var {Function, Undefined} A function executed when the tree item is selected or `undefined` (default).
	OnSelect = forms_get_prop(_props, "OnSelect");

	/// @var {Struct.FORMS_Tree, Undefined} The tree to which this item belongs or `undefined` (default).
	/// @readonly
	Tree = undefined;

	/// @var {Struct.FORMS_TreeItem, Undefined} The parent of this item or `undefined` (default).
	/// @readonly
	Parent = undefined;

	/// @var {Array<Struct.FORMS_TreeItem>, Undefined} An array of child tree items or `undefined` (default).
	/// @readonly
	Children = _children;

	if (is_array(Children))
	{
		for (var i = array_length(Children) - 1; i >= 0; --i)
		{
			var _child = Children[i];
			forms_assert(_child.Parent == undefined, "Item already added to a tree!");
			_child.Parent = self;
		}
	}

	/// @func draw(_pen)
	///
	/// @desc Draws the tree item using given {@link FORMS_Pen}.
	///
	/// @param {Struct.FORMS_Pen} _pen The pen to use to draw the tree item.
	///
	/// @return {Struct.FORMS_TreeItem} Returns `self`.
	static draw = function (_pen)
	{
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

		// Draw self
		var _iconWidth = 24;
		var _penX = _pen.X;
		var _text = is_string(Text) ? Text : Getter(self);
		var _selected = (Tree.Selected == self);
		var _hasChildren = (is_array(Children) && array_length(Children) > 0);

		var _action = _pen.tree_item(_text,
		{
			IconWidth: _iconWidth,
			Icon,
			IconFont,
			IconCollapsed,
			IconCollapsedFont,
			Collapsed,
			Selected: _selected,
			HasChildren: _hasChildren,
		});
		_pen.nl();

		if (_action == FORMS_EControlAction.Click)
		{
			Tree.Selected = self;
			if (OnSelect)
			{
				OnSelect(self);
			}
		}
		else if (_action == FORMS_EControlAction.CaretClick)
		{
			Collapsed = !Collapsed;
		}

		// Children
		if (is_array(Children))
		{
			if (!Collapsed)
			{
				_pen.move(_iconWidth);
				var _startX = _pen.ColumnX1;
				_pen.ColumnX1 = _pen.X;
				var i = 0;
				repeat(array_length(Children))
				{
					var _child = Children[i++];
					_child.Tree = Tree;
					_child.draw(_pen);
				}
				_pen.ColumnX1 = _startX;
			}
		}

		_pen.set_x(_penX);
		return self;
	}
}
