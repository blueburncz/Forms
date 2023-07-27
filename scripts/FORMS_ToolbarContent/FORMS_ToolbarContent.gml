/// @func FORMS_ToolbarContent()
///
/// @extends FORMS_Content
///
/// @desc Content of a Toolbar container.
function FORMS_ToolbarContent()
	: FORMS_Content() constructor
{
	static Draw = function ()
	{
		var _container = Container;

		var _items = FORMS_GetItems(_container);
		var _itemCount = ds_list_size(_items);
		var _padding = 1;
		var _x = _padding;
		var _y = _padding;

		for (var i = 0; i < _itemCount; ++i)
		{
			var _item = _items[| i];
			FORMS_DrawItem(_item, _x, _y);
			_x += _item.Width;
		}

		SetSize(_x + _padding, _container.Height);
		return self;
	};
}
