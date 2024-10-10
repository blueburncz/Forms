/// @func FORMS_CompoundWidgetProps()
///
/// @extends FORMS_WidgetProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_CompoundWidget}.
function FORMS_CompoundWidgetProps(): FORMS_WidgetProps() constructor {}

/// @func FORMS_CompoundWidget([_props[, _children]])
///
/// @extends FORMS_Widget
///
/// @desc Base struct for widgets that have an array of child widgets.
///
/// @param {Struct.FORMS_CompoundWidgetProps, Undefined} [_props] Properties to
/// create the compound widget with or `undefined` (default).
/// @param {Array<Struct.FORMS_Widget>, Undefined} [_children] An array of child
/// widgets to add to the compund widget or `undefined` (default).
function FORMS_CompoundWidget(_props = undefined, _children = undefined): FORMS_Widget(_props) constructor
{
	static Widget_update = update;
	static Widget_destroy = destroy;

	/// @var {Array<Struct.FORMS_Widget>} An array of child widgets.
	/// @readonly
	/// @see FORMS_CompoundWidget.add_child
	/// @see FORMS_CompoundWidget.has_child
	/// @see FORMS_CompoundWidget.remove_child
	Children = [];

	if (is_array(_children))
	{
		var _count = array_length(_children);
		for (var i = 0; i < _count; ++i)
		{
			add_child(_children[i]);
		}
	}

	/// @func add_child(_child)
	///
	/// @desc Adds a child to this widget.
	///
	/// @param {Struct.FORMS_Widget} _child The child widget to be added. Must
	/// not have a [parent](./FORMS_Widget.Parent)!
	///
	/// @return {Struct.FORMS_CompoundWidget} Returns `self`.
	static add_child = function (_child)
	{
		forms_assert(_child.Parent == undefined, "Widget already has a parent!");
		array_push(Children, _child);
		_child.Parent = self;
		return self;
	}

	/// @func has_child(_child)
	///
	/// @desc Checks whether given widget is a child of this widget.
	///
	/// @param {Struct.FORMS_Widget} _child The widget to check.
	///
	/// @return {Bool} Returns `true` if this widget is the parent of given
	/// child widget.
	static has_child = function (_child)
	{
		gml_pragma("forceinline");
		return (_child.Parent == self);
	}

	static remove_child = function (_child)
	{
		forms_assert(_child.Parent == self, "Widget not a child of this parent!");
		for (var i = array_length(Children) - 1; i >= 0; --i)
		{
			var _widget = Children[i];
			if (_widget == _child)
			{
				array_delete(Children, i, 1);
				_widget.Parent = undefined;
				_widget.Root = undefined;
				break;
			}
		}
		return self;
	}

	static find_widget = function (_id)
	{
		if (Id == _id)
		{
			return self;
		}

		var _count = array_length(Children);
		for (var i = 0; i < _count; ++i)
		{
			var _found = Children[i].find_widget(_id);
			if (_found != undefined)
			{
				return _found;
			}
		}

		return undefined;
	}

	static layout = function ()
	{
		FORMS_LAYOUT_GENERATED;

		var _parentX = __realX;
		var _parentY = __realY;
		var _parentWidth = __realWidth;
		var _parentHeight = __realHeight;
		var _count = array_length(Children);

		for (var i = 0; i < _count; ++i)
		{
			with(Children[i])
			{
				var _autoWidth = get_auto_width();
				var _autoHeight = get_auto_height();

				__realWidth = floor(Width.get_absolute(_parentWidth, _autoWidth));
				__realHeight = floor(Height.get_absolute(_parentHeight, _autoHeight));
				__realX = floor(_parentX + X.get_absolute(_parentWidth, _autoWidth));
				__realY = floor(_parentY + Y.get_absolute(_parentHeight, _autoHeight));

				layout();
			}
		}

		return self;
	}

	static update = function (_deltaTime)
	{
		Widget_update(_deltaTime);
		var _count = array_length(Children);
		for (var i = 0; i < _count; ++i)
		{
			Children[i].update(_deltaTime);
		}
		return self;
	}

	static draw = function ()
	{
		var _count = array_length(Children);
		for (var i = 0; i < _count; ++i)
		{
			Children[i].draw();
		}
		return self;
	}

	static destroy = function ()
	{
		Widget_destroy();

		for (var i = array_length(Children) - 1; i >= 0; --i)
		{
			Children[i].destroy();
		}
		Children = undefined;

		return undefined;
	}
}
