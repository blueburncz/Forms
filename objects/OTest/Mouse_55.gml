var _options = [];
var _option;


array_push(_options, new FORMS_ContextMenuOption("Menu Item 1"));
array_push(_options, new FORMS_ContextMenuOption("Menu Item 2"));
array_push(_options, new FORMS_ContextMenuOption("Menu Item 3"));
var _submenu = new FORMS_ContextMenuOption("Menu Item 4");
array_push(_options, _submenu);

for (var m = 0; m < 3; ++m) 
{
	var _op = -1;
	_submenu.Options = [];
	for (var o = 0; o < 4; ++o) 
	{
		_op = new FORMS_ContextMenuOption(string(m)+": Option "+string(o));
		array_push(_submenu.Options, _op);
	}
	_submenu = _op;
}

var _contextMenu = new FORMS_ContextMenu(_options, {
	X: window_mouse_get_x(),
	Y: window_mouse_get_y(),
});
gui.add_child(_contextMenu);
