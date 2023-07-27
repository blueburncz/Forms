/// @func FORMS_TitleBarContent()
///
/// @extends FORMS_Content
///
/// @desc Content of a Title Bar container.
function FORMS_TitleBarContent()
	: FORMS_Content() constructor
{
	static Draw = function ()
	{
		var _container = Container;
		var _containerWidth = _container.Width;

		var _parent = _container.Parent;
		var _selectedWidget = FORMS_WIDGET_SELECTED;
		if (_selectedWidget == _parent
			|| _parent.IsAncestor(_selectedWidget))
		{
			draw_clear(FORMS_GetColor(FORMS_EStyle.Active));
		}

		var _x = 4;
		var _y = 4;
		var _containerContent = _parent.Container.Content;

		if (_containerContent)
		{
			var _title = _containerContent.Title;

			if (_containerContent.Icon != undefined)
			{
				draw_sprite(_containerContent.Icon, _containerContent.IconSubimage, _x, _y);
				_x += FORMS_LINE_HEIGHT + 4;
			}

			FORMS_DrawTextBold(
				_x,
				_y + round((FORMS_LINE_HEIGHT - FORMS_FONT_HEIGHT) * 0.5),
				_title);
			_y += FORMS_LINE_HEIGHT + 4;
		}

		SetSize(_containerWidth, _y);
		return self;
	};
}
