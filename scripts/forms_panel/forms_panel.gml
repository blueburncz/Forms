/// @func FORMS_Panel(_title)
///
/// @extends FORMS_CompoundWidget
///
/// @param {String} _title The name of the panel.
function FORMS_Panel(_title)
	: FORMS_CompoundWidget() constructor
{
	static Type = FORMS_EWidgetType.Panel;

	/// @var {Struct.FORMS_Container}
	/// @readonly
	TitleBar = new FORMS_Container();
	TitleBar.Title = _title;
	TitleBar.SetContent(new FORMS_TitleBarContent());
	TitleBar.Background = FORMS_GetColor(FORMS_EStyle.WindowBorder);
	AddItem(TitleBar);

	/// @var {Struct.FORMS_Container}
	/// @readonly
	Container = new FORMS_Container();
	AddItem(Container);

	static OnDraw = function ()
	{
		FORMS_PanelDraw(self);
	};
}

/// @func FORMS_PanelDraw(_panel)
///
/// @desc Draws the panel.
///
/// @param {Struct.FORMS_Panel} _panel The panel.
function FORMS_PanelDraw(_panel)
{
	var _panelW = _panel.Width;
	var _panelH = _panel.Height;
	var _titleBar = _panel.TitleBar;
	var _container = _panel.Container;

	FORMS_MatrixPush(_panel.X, _panel.Y);

	_titleBar.SetWidth(_panelW);
	FORMS_DrawItem(_titleBar, 0, 0);
	_titleBar.SetHeight(
		clamp(_titleBar.GetContentHeight(), 1, _panelH - 1));

	var _border = 1;
	var _titleBarHeight = _titleBar.Height;
	_container.SetSize(
		_panelW - _border * 2,
		max(_panelH - _titleBarHeight - _border, 1));

	var _selectedWidget = FORMS_WIDGET_SELECTED;
	var _colourBorder = FORMS_GetColor(FORMS_EStyle.WindowBorder);
	if (_selectedWidget == _panel
		|| _panel.IsAncestor(_selectedWidget))
	{
		_colourBorder = FORMS_GetColor(FORMS_EStyle.Active);
	}
	FORMS_DrawRectangle(0, _titleBarHeight, _panelW, _panelH - _titleBarHeight, _colourBorder);
	FORMS_DrawItem(_container, _border, _titleBarHeight);

	FORMS_MatrixRestore();
}

/// @func FORMS_PanelSetContent(_panel, _content)
///
/// @desc Sets the content of the panel.
///
/// @param {Struct.FORMS_Panel} _panel The panel.
/// @param {Struct.FORMS_Content} _content The new content.
function FORMS_PanelSetContent(_panel, _content)
{
	gml_pragma("forceinline");
	_panel.Container.SetContent(_content);
}

/// @func FORMS_PanelSetTitleBar(panel, content)
///
/// @desc Sets the title bar of the panel.
///
/// @param {Struct.FORMS_Panel} _panel The panel.
/// @param {Struct.FORMS_Content} _content The new content of the panels title bar.
function FORMS_PanelSetTitleBar(_panel, _content)
{
	gml_pragma("forceinline");
	_panel.TitleBar.SetContent(_content);
}
