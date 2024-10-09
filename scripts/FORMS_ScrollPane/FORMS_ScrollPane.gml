/// @func FORMS_ScrollPaneProps()
///
/// @extends FORMS_CompoundWidgetProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_ScrollPane}.
function FORMS_ScrollPaneProps(): FORMS_CompoundWidgetProps() constructor
{
	/// @var {Struct.FORMS_HScrollbarProps, Undefined} Properties to create the
	/// scroll pane's horizontal scrollbar with.
	HScrollbarProps = undefined;

	/// @var {Struct.FORMS_VScrollbarProps, Undefined} Properties to create the
	/// scroll pane's vertical scrollbar with.
	VScrollbarProps = undefined;
}

/// @func FORMS_ScrollPane(_container[, _props])
///
/// @extends FORMS_CompoundWidget
///
/// @desc A widget that consists of a container and two scrollbars.
///
/// @param {Struct.FORMS_Container} _container The container inside of the
/// scroll pane.
/// @param {Struct.FORMS_ScrollPaneProps, Undefined} [_props] Properties to
/// create the scroll pane with or `undefined` (default).
function FORMS_ScrollPane(_container, _props = undefined): FORMS_CompoundWidget(_props, undefined) constructor
{
	//static CompoundWidget_layout = layout;

	/// @var {Struct.FORMS_Container} The scroll pane's container.
	/// @readonly
	Container = _container;

	/// @var {Struct.FORMS_HScrollbar} The scroll pane's horizontal scrollbar.
	/// @readonly
	HScrollbar = new FORMS_HScrollbar(Container, forms_get_prop(_props, "HScrollbarProps"));

	/// @var {Struct.FORMS_VScrollbar} The scroll pane's vertical scrollbar.
	/// @readonly
	VScrollbar = new FORMS_VScrollbar(Container, forms_get_prop(_props, "VScrollbarProps"));

	add_child(Container);
	add_child(HScrollbar);
	add_child(VScrollbar);

	static layout = function ()
	{
		FORMS_LAYOUT_GENERATED;

		var _parentX = __realX;
		var _parentY = __realY;
		var _parentWidth = __realWidth;
		var _parentHeight = __realHeight;
		var _count = array_length(Children);
		var _container = Container;
		var _scrollbarH = HScrollbar;
		var _scrollbarV = VScrollbar;

		_scrollbarV.__realWidth = (_container.ContentHeight > __realHeight)
			? _scrollbarV.Width.get_absolute(_parentWidth, _scrollbarV.get_auto_width()) : 0;
		_scrollbarV.__realX = __realX + __realWidth - _scrollbarV.__realWidth;
		_scrollbarV.__realY = __realY;

		_scrollbarH.__realHeight = (_container.ContentWidth > __realWidth)
			? _scrollbarH.Height.get_absolute(_parentHeight, _scrollbarH.get_auto_height()) : 0;
		_scrollbarH.__realX = __realX;
		_scrollbarH.__realY = __realY + __realHeight - _scrollbarH.__realHeight;

		_container.__realX = __realX;
		_container.__realY = __realY;
		_container.__realWidth = __realWidth - _scrollbarV.__realWidth;
		_container.__realHeight = __realHeight - _scrollbarH.__realHeight;

		_scrollbarV.__realHeight = _container.__realHeight;
		_scrollbarH.__realWidth = _container.__realWidth;

		for (var i = 0; i < _count; ++i)
		{
			with(Children[i])
			{
				if (self != _container && self != _scrollbarH && self != _scrollbarV)
				{
					var _autoWidth = get_auto_width();
					var _autoHeight = get_auto_height();

					__realWidth = floor(Width.get_absolute(_parentWidth, _autoWidth));
					__realHeight = floor(Height.get_absolute(_parentHeight, _autoHeight));
					__realX = floor(_parentX + X.get_absolute(_parentWidth, _autoWidth));
					__realY = floor(_parentY + Y.get_absolute(_parentHeight, _autoHeight));
				}

				layout();
			}
		}

		return self;
	}
}
