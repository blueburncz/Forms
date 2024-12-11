/// @func FORMS_ScrollPaneProps()
///
/// @extends FORMS_ContainerProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_ScrollPane}.
function FORMS_ScrollPaneProps(): FORMS_ContainerProps() constructor
{
	/// @var {Struct.FORMS_HScrollbarProps, Undefined} Properties to create the scroll pane's horizontal scrollbar with.
	HScrollbarProps = undefined;

	/// @var {Struct.FORMS_VScrollbarProps, Undefined} Properties to create the scroll pane's vertical scrollbar with.
	VScrollbarProps = undefined;
}

/// @func FORMS_ScrollPane([_props])
///
/// @extends FORMS_Container
///
/// @desc A widget that consists of a container and two scrollbars.
///
/// @param {Struct.FORMS_ScrollPaneProps, Undefined} [_props] Properties to create the scroll pane with or `undefined`
/// (default).
function FORMS_ScrollPane(_props = undefined): FORMS_Container(_props) constructor
{
	//static Container_layout = layout;
	static Container_update = update;
	static Container_draw = draw;
	static Container_destroy = destroy;

	/// @var {Struct.FORMS_HScrollbar} The scroll pane's horizontal scrollbar.
	/// @readonly
	HScrollbar = new FORMS_HScrollbar(self, forms_get_prop(_props, "HScrollbarProps"));
	HScrollbar.Parent = self;

	/// @var {Struct.FORMS_VScrollbar} The scroll pane's vertical scrollbar.
	/// @readonly
	VScrollbar = new FORMS_VScrollbar(self, forms_get_prop(_props, "VScrollbarProps"));
	VScrollbar.Parent = self;

	static find_widget = function (_id)
	{
		if (Id == _id)
		{
			return self;
		}
		if (HScrollbar.Id = _id)
		{
			return HScrollbar;
		}
		if (VScrollbar.Id = _id)
		{
			return VScrollbar;
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
		//var _count = array_length(Children);
		var _container = self;
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

		_scrollbarH.layout();
		_scrollbarV.layout();

		return self;
	}

	static update = function (_deltaTime)
	{
		Container_update(_deltaTime);
		HScrollbar.update(_deltaTime);
		VScrollbar.update(_deltaTime);
	}

	static draw = function ()
	{
		Container_draw();
		HScrollbar.draw();
		VScrollbar.draw();
	}

	static destroy = function ()
	{
		Container_destroy();
		HScrollbar = HScrollbar.destroy();
		VScrollbar = VScrollbar.destroy();
		return undefined;
	}
}
