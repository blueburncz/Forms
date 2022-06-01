function FORMS_Widget() {}

/// @func forms_widget_create([type])
/// @desc Creates a new widget.
/// @param {FORMS_EShape} [type] The type of the widget.
/// @return {real} The id of the created widget.
function forms_widget_create()
{
	static _id = 0;

	var _widget = ds_map_create();
	if (argument_count == 1)
	{
		forms_widget_set_type(_widget, argument[0]);
	}
	else
	{
		forms_widget_set_type(_widget, FORMS_Widget);
	}
	forms_widget_set_depth(_widget, noone);
	forms_widget_set_delegate(_widget, noone);
	forms_widget_set_x(_widget, 0);
	forms_widget_set_y(_widget, 0);
	forms_widget_set_width(_widget, 1);
	forms_widget_set_height(_widget, 1);
	forms_widget_set_depth(_widget, 0);

	_widget[? "id"] = "widget" + string(_id++);
	_widget[? "redraw"] = true;

	_widget[? "scr_update"] = forms_widget_update;
	_widget[? "scr_draw"] = noone;
	_widget[? "scr_cleanup"] = forms_widget_cleanup;

	_widget[? "scr_on_redraw"] = noone;

	_widget[? "reference"] = undefined;

	return _widget;
}

/// @func forms_widget_cleanup(_widget)
/// @desc Frees resources used by the widget from memory.
/// @param {real} _widget The id of the widget.
function forms_widget_cleanup(_widget)
{
	if (forms_widget_exists(_widget))
	{
		// Remove from delegate
		var _delegate = forms_widget_get_delegate(_widget);
		if (forms_widget_exists(_delegate))
		{
			var _items = forms_widgetset_get_items(_delegate);
			var _pos = ds_list_find_index(_items, _widget);
			if (_pos >= 0)
			{
				ds_list_delete(_items, _pos);
			}
		}

		var _reference = _widget[? "reference"];
		if (!is_undefined(_reference))
		{
			variable_instance_set(id, _reference, noone);
		}

		// Destroy self
		ds_map_destroy(_widget);
	}
}

/// @func forms_widget_delegates_recursive(widget, item)
/// @desc Finds out whether the widget delegates the item.
/// @param {real} widget The id of the widget.
/// @param {real} item The id of the widget.
/// @return {bool} True if the widget delegates the item.
/// @note If the widget is not the delegate of the item, this
/// function is called recursively for the item's delegate,
/// until the widget is found or the item does not have delegate.
/// This way you can check for chained delegation. Wtf?!
function forms_widget_delegates_recursive(widget, item)
{
	if (!forms_widget_exists(item))
	{
		return false;
	}
	var _delegate = forms_widget_get_delegate(item);
	if (!forms_widget_exists(_delegate))
	{
		return false;
	}
	if (_delegate == widget)
	{
		return true;
	}
	return forms_widget_delegates_recursive(widget, _delegate);
}

/// @func forms_widget_destroy(widget)
/// @desc Destroys the widget.
/// @param {real} widget The id of the widget.
function forms_widget_destroy(widget)
{
	gml_pragma("forceinline");
	if (forms_widget_exists(widget))
	{
		ds_stack_push(forms_destroy_stack, widget);
	}
}

/// @func forms_widget_exists(widget)
/// @desc Finds out whether the widget exists.
/// @param {real} widget The id of the widget.
/// @return {bool} True if the widget does exist.
function forms_widget_exists(widget)
{
	if (!is_real(widget))
	{
		return false;
	}
	return ds_exists(widget, ds_type_map);
}

/// @func forms_widget_get_delegate(widget)
/// @desc Gets the delegate of the widget.
/// @param {real} widget The id of the widget.
/// @return {real} The id of the delegate or noone.
function forms_widget_get_delegate(widget)
{
	gml_pragma("forceinline");
	return widget[? "delegate"];
}

/// @func forms_widget_get_depth(widget)
/// @desc Gets the depth of the widget.
/// @param {real} widget The id of the widget.
/// @return {real} The depth of the widget.
function forms_widget_get_depth(widget)
{
	gml_pragma("forceinline");
	return widget[? "depth"];
}

/// @func forms_widget_get_height(widget)
/// @desc Gets the height of the widget.
/// @param {real} widget The id of the widget.
/// @return {real} The height of the widget.
function forms_widget_get_height(widget)
{
	gml_pragma("forceinline");
	return widget[? "height"];
}

/// @func forms_widget_get_redraw(widget)
/// @desc Gets the redraw state of the widget.
/// @param {real} widget The id of the widget.
/// @return {bool} The redraw state of the widget.
function forms_widget_get_redraw(widget)
{
	gml_pragma("forceinline");
	return widget[? "redraw"];
}

/// @func forms_widget_get_tooltip(widget)
/// @desc Gets the tooltip of the widget.
/// @param {real} widget The id of the widget.
/// @return {string} The widget tooltip or an empty string if it does not have any.
function forms_widget_get_tooltip(widget)
{
	var _tooltip = widget[? "tooltip"];
	if (is_undefined(_tooltip))
	{
		return "";
	}
	return _tooltip;
}

/// @func forms_widget_get_type(widget)
/// @desc Gets the type of the widget.
/// @param {real} widget The id of the widget.
/// @return {real} The type of the widget.
function forms_widget_get_type(widget)
{
	gml_pragma("forceinline");
	return widget[? "type"];
}

/// @func forms_widget_get_width(widget)
/// @desc Gets the width of the widget.
/// @param {real} widget The id of the widget.
/// @return {real} The width of the widget.
function forms_widget_get_width(widget)
{
	gml_pragma("forceinline");
	return widget[? "width"];
}

/// @func forms_widget_get_x(widget)
/// @desc Gets the x position of the widget.
/// @param {real} widget The id of the widget.
/// @return {real} The x position of the widget relative to it's delegate.
function forms_widget_get_x(widget)
{
	gml_pragma("forceinline");
	return widget[? "x"];
}

/// @func forms_widget_get_y(widget)
/// @desc Gets the y position of the widget.
/// @param {real} widget The id of the widget.
/// @return {real} The y position of the widget relative to it's delegate.
function forms_widget_get_y(widget)
{
	gml_pragma("forceinline");
	return widget[? "y"];
}

/// @func forms_widget_is_active(widget)
/// @desc Gets whether the widget is active.
/// @param {real} widget The id of the widget.
/// @return {bool} True if the widget is active.
function forms_widget_is_active(widget)
{
	gml_pragma("forceinline");
	return (forms_widget_active == widget);
}

/// @func forms_widget_is_hovered(widget)
/// @desc Gets whether the widget is hovered.
/// @param {real} widget The id of the widget.
/// @return {bool} True if the widget is hovered.
function forms_widget_is_hovered(widget)
{
	gml_pragma("forceinline");
	return (forms_widget_hovered == widget
		&& (forms_mouse_input_widget == widget
		|| !forms_widget_exists(forms_mouse_input_widget))
		&& (forms_widget_active == widget
		|| !forms_widget_exists(forms_widget_active)));
}

/// @func forms_widget_is_selected(widget)
/// @desc Gets whether the widget is selected.
/// @param {real} widget The id of the widget.
/// @return {bool} True if the widget is selected.
function forms_widget_is_selected(widget)
{
	gml_pragma("forceinline");
	return (forms_widget_selected == widget);
}

/// @func forms_widget_set_delegate(widget, delegate)
/// @desc Sets the delegate of the widget.
/// @param {real} widget The id of the widget.
/// @param {real} delegate The id of the delegate or noone.
function forms_widget_set_delegate(widget, delegate)
{
	gml_pragma("forceinline");
	widget[? "delegate"] = delegate;
}

/// @func forms_widget_set_depth(_widget, _depth)
/// @desc Sets the depth of the widget.
/// @param {real} _widget The id of the widget.
/// @param {real} _depth The new depth.
function forms_widget_set_depth(_widget, _depth)
{
	gml_pragma("forceinline");
	_widget[? "depth"] = _depth;
}

/// @func forms_widget_set_height(widget, height)
/// @desc Sets the width of the widget.
/// @param {real} widget The id of the widget.
/// @param {real} height The new height.
function forms_widget_set_height(widget, height)
{
	gml_pragma("forceinline");
	widget[? "height"] = max(height, 1);
}

/// @func forms_widget_set_position(_widget, _x, _y)
/// @desc Sets the x and y position of the widget relative to it's delegate.
/// @param {real} _widget The id of the widget.
/// @param {real} _x The new x position.
/// @param {real} _y The new y position.
function forms_widget_set_position(widget, _x, _y)
{
	gml_pragma("forceinline");
	forms_widget_set_x(widget, _x);
	forms_widget_set_y(widget, _y);
}

/// @func forms_widget_set_rectangle(_widget, _x, _y, _width, _height)
/// @desc Sets the x and y position of the widget relative to it's delegate and it's size.
/// @param {real} _widget The id of the widget.
/// @param {real} _x The new x position.
/// @param {real} _y The new y position.
/// @param {real} _width The new width.
/// @param {real} _height The new height.
function forms_widget_set_rectangle(_widget, _x, _y, _width, _height)
{
	gml_pragma("forceinline");
	forms_widget_set_x(_widget, _x);
	forms_widget_set_y(_widget, _y);
	forms_widget_set_width(_widget, _width);
	forms_widget_set_height(_widget, _height);
}

/// @func forms_widget_set_redraw(widget, redraw)
/// @desc Sets the redraw state of the widget.
/// @param {real} widget The id of the widget.
/// @param {bool} redraw The new redraw state.
function forms_widget_set_redraw(widget, redraw)
{
	gml_pragma("forceinline");
	widget[? "redraw"] = redraw;
	if (redraw)
	{
		var _on_redraw = widget[? "scr_on_redraw"];
		if (_on_redraw != noone)
		{
			_on_redraw(widget);
		}
	}
}

/// @func forms_widget_set_size(widget, width, height)
/// @desc Sets the width and height of the widget.
/// @param {real} widget The id of the widget.
/// @param {real} width The new width.
/// @param {real} height The new height.
function forms_widget_set_size(widget, width, height)
{
	gml_pragma("forceinline");
	forms_widget_set_width(widget, width);
	forms_widget_set_height(widget, height);
}

/// @func forms_widget_set_tooltip(widget, text)
/// @desc Sets the tooltip of the widget.
/// @param {real} widget The id of the widget.
/// @param {string} text The tooltip text.
function forms_widget_set_tooltip(widget, text)
{
	gml_pragma("forceinline");
	widget[? "tooltip"] = text;
}

/// @func forms_widget_set_type(widget, type)
/// @desc Sets the type of the widget.
/// @param {real} widget The id of the widget.
/// @param {real} type The new type.
function forms_widget_set_type(widget, type)
{
	gml_pragma("forceinline");
	widget[? "type"] = type;
}

/// @func forms_widget_set_width(widget, width)
/// @desc Sets the width of the widget.
/// @param {real} widget The id of the widget.
/// @param {real} width The new width.
function forms_widget_set_width(widget, width)
{
	gml_pragma("forceinline");
	widget[? "width"] = max(width, 1);
}

/// @func forms_widget_set_x(_widget, _x)
/// @desc Sets the x position of the widget relative to it's delegate.
/// @param {real} _widget The id of the widget.
/// @param {real} _x The new x position.
function forms_widget_set_x(_widget, _x)
{
	gml_pragma("forceinline");
	_widget[? "x"] = _x;
}

/// @func forms_widget_set_y(_widget, _y)
/// @desc Sets the y position of the widget relative to it's delegate.
/// @param {real} _widget The id of the widget.
/// @param {real} _y The new y position.
function forms_widget_set_y(_widget, _y)
{
	gml_pragma("forceinline");
	_widget[? "y"] = _y;
}

/// @func forms_widget_update(_widget)
/// @desc Updates the widget.
/// @param {real} _widget The id of the widget.
function forms_widget_update(_widget)
{
	//forms_widget_set_size(_widget, forms_widget_get_width(_widget), forms_widget_get_height(_widget));

	if (forms_widget_is_hovered(_widget))
	{
		// Set tooltip on mouse over
		var _tooltip = forms_widget_get_tooltip(_widget);
		if (_tooltip != "")
		{
			forms_tooltip_str = _tooltip;
		}

		// Select widget
		if (mouse_check_button_pressed(mb_any))
		{
			var _exists = forms_widget_exists(forms_widget_selected);
			if ((_exists && forms_widget_selected != _widget)
				|| !_exists)
			{
				forms_request_redraw_all(forms_root);
			}
			forms_widget_selected = _widget;
		}
	}
}