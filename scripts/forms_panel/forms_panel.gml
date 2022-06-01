function FORMS_Panel() {}

/// @func forms_panel_create(_title[, _icon])
/// @desc Creates a new panel.
/// @param {string} _title The name of the panel.
/// @param {FORMS_EIcon/undefined} [icon] The panel icon. Defaults to `FORMS_EIcon.ListAlt`.
/// @return {real} The id of the created panel.
function forms_panel_create(_title)
{
	var _panel = forms_widgetset_create(FORMS_Panel);
	var _titlebar = forms_titlebar_create(_title, (argument_count > 1) ? argument[1] : FORMS_EIcon.ListAlt);
	_panel[? "titlebar"] = _titlebar;
	var _container = forms_container_create();
	_panel[? "container"] = _container;
	forms_add_item(_panel, _titlebar);
	forms_add_item(_panel, _container);
	_panel[? "scr_draw"] = forms_panel_draw;
	return _panel;
}

/// @func forms_panel_draw(_panel)
/// @desc Draws the panel.
/// @param {real} _panel The id of the panel.
function forms_panel_draw(_panel)
{
	var _panel_w = forms_widget_get_width(_panel);
	var _panel_h = forms_widget_get_height(_panel);
	var _titlebar = forms_panel_get_titlebar(_panel);
	var _container = forms_panel_get_container(_panel);

	forms_matrix_push(forms_widget_get_x(_panel), forms_widget_get_y(_panel));

	forms_widget_set_width(_titlebar, _panel_w);
	forms_draw_item(_titlebar, 0, 0);
	forms_widget_set_height(_titlebar,
		clamp(forms_container_get_content_height(_titlebar), 1, _panel_h - 1));

	var _border = 1;
	var _titlebar_height = forms_widget_get_height(_titlebar);
	forms_widget_set_size(_container,
		_panel_w - _border * 2,
		max(_panel_h - _titlebar_height - _border, 1));

	var _selected_shape = forms_get_selected_widget();
	var _color_border = FORMS_C_WINDOW_BORDER;
	ce_draw_rectangle(0, _titlebar_height, _panel_w, _panel_h - _titlebar_height, _color_border);
	forms_draw_item(_container, _border, _titlebar_height);

	forms_matrix_restore();
}

/// @func forms_panel_get_container(panel)
/// @desc Gets the container of the panel.
/// @param {real} panel The id of the panel.
/// @return {real} The container of the panel.
function forms_panel_get_container(panel)
{
	gml_pragma("forceinline");
	return panel[? "container"];
}

/// @func forms_panel_get_titlebar(panel)
/// @desc Gets the title bar of the panel.
/// @param {real} panel The id of the panel.
/// @return {real} The title bar of the panel.
function forms_panel_get_titlebar(panel)
{
	gml_pragma("forceinline");
	return panel[? "titlebar"];
}

/// @func forms_panel_set_content(panel, content)
/// @desc Sets the content of the panel.
/// @param {real} panel The id of the panel.
/// @param {real} content The new content script.
function forms_panel_set_content(panel, content)
{
	var _container = panel[? "container"];
	_container[? "content"] = content;
}

/// @func forms_panel_set_titlebar(panel, content)
/// @desc Sets the title bar of the panel.
/// @param {real} panel The id of the panel.
/// @param {real} content The new content script of the panels title bar.
function forms_panel_set_titlebar(panel, content)
{
	var _titlebar = panel[? "titlebar"];
	_titlebar[? "content"] = content;
}