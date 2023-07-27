/// @func FORMS_WindowTitleBarContent()
///
/// @extends FORMS_TitleBarContent
///
/// @desc Content of a Window Title Bar container.
function FORMS_WindowTitleBarContent()
	: FORMS_TitleBarContent() constructor
{
	static Draw = function ()
	{
		var _container = Container;
		var _containerWidth = _container.Width;
		var _parent = _container.Parent;
		var _content = _parent.Container.Content;
		var _x = 4;
		var _y = 4;

		if (_content)
		{
			var _title = _content.Title;
			FORMS_DrawTextBold(_x, _y + round((FORMS_LINE_HEIGHT - FORMS_FONT_HEIGHT) * 0.5), _title);
		}
		
		if (FORMS_DrawSpriteClickable(FORMS_SprWindowCross, 0, _containerWidth - FORMS_LINE_HEIGHT - 4, _y + 4, FORMS_GetColor(FORMS_EStyle.WindowButton)))
		{
			FORMS_DestroyWidget(_parent);
		}
		_y += FORMS_LINE_HEIGHT + 4;

		SetSize(_containerWidth, _y);

		return self;
	};
}
