function FORMS_ContextMenuDelimiter() {}

function forms_context_menu_delimiter_create()
{
	var _delimiter = forms_context_menu_item_create("", noone);
	_delimiter[? "type"] = FORMS_ContextMenuDelimiter;
	_delimiter[? "scr_draw"] = forms_context_menu_delimiter_draw;
	return _delimiter;
}

function forms_context_menu_delimiter_draw(_delimiter)
{
	var _context_menu = forms_widget_get_delegate(_delimiter);
	var _x = forms_widget_get_x(_delimiter);
	var _y = forms_widget_get_y(_delimiter);
	var _width = forms_widget_get_width(_context_menu);
	var _height = round(forms_line_height * 0.5);
	ce_draw_rectangle(_x, _y + floor(_height * 0.5), _width, 1, $3E3E3E);
}