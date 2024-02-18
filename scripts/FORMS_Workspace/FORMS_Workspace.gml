function FORMS_WorkspaceProps()
	: FORMS_WidgetProps() constructor
{
	/// @var {Constant.Color, Undefined}
	BackgroundColor = undefined;

	/// @var {Real, Undefined}
	BackgroundAlpha = undefined;
}

/// @func FORMS_Workspace([_props])
///
/// @extends FORMS_Widget
///
/// @desc
///
/// @param {Struct.FORMS_WorkspaceProps, Undefined} [_props]
function FORMS_Workspace(_props=undefined)
	: FORMS_Widget(_props) constructor
{
	static Widget_update = update;

	/// @var {Constant.Color}
	BackgroundColor = forms_get_prop(_props, "BackgroundColor") ?? 0x202020;

	/// @var {Real}
	BackgroundAlpha = forms_get_prop(_props, "BackgroundAlpha") ?? 1.0;

	/// @var {Struct.FORMS_WorkspaceTabs}
	/// @private
	__tabContainer = new FORMS_WorkspaceTabs();
	__tabContainer.Parent = self;

	/// @var {Array<Struct.FORMS_Widget>}
	/// @private
	__tabs = [];

	/// @var {Real}
	/// @private
	__tabCurrent = 0;

	/// @func set_tab(_tabs)
	///
	/// @desc
	///
	/// @param {Array<Struct.FORMS_Widget>} _tabs
	///
	/// @return {Struct.FORMS_Workspace} Returns `self`.
	static set_tabs = function (_tabs)
	{
		forms_assert(array_length(__tabs) == 0, "Dock already has tabs!");
		__tabs = _tabs;
		var i = 0;
		repeat (array_length(__tabs))
		{
			__tabs[i++].Parent = self;
		}
		return self;
	};

	/// @func add_tab(_widget)
	///
	/// @desc
	///
	/// @param {Struct.FORMS_Widget} _widget
	///
	/// @return {Struct.FORMS_Workspace} Returns `self`.
	static add_tab = function (_widget)
	{
		forms_assert(_widget.Parent == undefined, "Widget already has a parent!");
		array_push(__tabs, _widget);
		_widget.Parent = self;
		return self;
	};

	static layout = function ()
	{
		FORMS_LAYOUT_GENERATED;

		var _parentX = __realX;
		var _parentY = __realY;
		var _parentWidth = __realWidth;
		var _parentHeight = __realHeight;

		with (__tabContainer)
		{
			var _autoWidth = get_auto_width();
			var _autoHeight = get_auto_height();

			__realWidth = floor(Width.get_absolute(_parentWidth, _autoWidth));
			__realHeight = floor(Height.get_absolute(_parentHeight, _autoHeight));
			__realX = floor(_parentX + X.get_absolute(_parentWidth, _autoWidth));
			__realY = floor(_parentY + Y.get_absolute(_parentHeight, _autoHeight));

			layout();
		}

		if (__tabCurrent < array_length(__tabs))
		{
			var _tab = __tabs[__tabCurrent];
			_tab.__realX = _parentX;
			_tab.__realY = _parentY + __tabContainer.__realHeight;
			_tab.__realWidth = _parentWidth;
			_tab.__realHeight = _parentHeight - __tabContainer.__realHeight;
			_tab.layout();
		}

		return self;
	};

	static update = function (_deltaTime)
	{
		Widget_update(_deltaTime);

		__tabContainer.update(_deltaTime);

		if (__tabCurrent < array_length(__tabs))
		{
			var _tab = __tabs[__tabCurrent];
			_tab.update(_deltaTime);
		}

		return self;
	};

	static draw = function ()
	{
		forms_draw_rectangle(__realX, __realY, __realWidth, __realHeight, BackgroundColor, BackgroundAlpha);

		var _tabCurrent = __tabCurrent; // Backup before it changes!

		__tabContainer.draw();

		if (__tabCurrent < array_length(__tabs))
		{
			__tabs[_tabCurrent].draw();
		}

		return self;
	};
}

/// @func FORMS_WorkspaceTabs([_props])
///
/// @extends FORMS_Container
///
/// @desc
///
/// @params {Struct.FORMS_ContainerProps, Undefined} [_props]
function FORMS_WorkspaceTabs(_props=undefined)
	: FORMS_Container(undefined, _props) constructor
{
	Width.from_props(_props, "Width", 100, FORMS_EUnit.Percent);
	Height.from_props(_props, "Height", 32);

	set_content(new FORMS_WorkspaceTabsContent());
}

/// @func FORMS_WorkspaceTabsContent()
///
/// @extends FORMS_Content
///
/// @desc
function FORMS_WorkspaceTabsContent()
	: FORMS_Content() constructor
{
	static draw = function ()
	{
		var _workspace = Container.Parent;
		var _tabs = _workspace.__tabs;
		var _tabCurrent = _workspace.__tabCurrent;
		var _tabIndex = 0;

		Pen.start(10, 8);

		repeat (array_length(_tabs))
		{
			var _tab = _tabs[_tabIndex];
			if (Pen.link(_tab.Name, { Color: (_tabIndex == _tabCurrent) ? c_orange : c_silver }))
			{
				_tabCurrent = _tabIndex;
				_workspace.__tabCurrent = _tabCurrent;
			}
			Pen.move(10);
			++_tabIndex;
		}

		Pen.finish();

		Width = Pen.MaxX;

		return self;
	};
}
