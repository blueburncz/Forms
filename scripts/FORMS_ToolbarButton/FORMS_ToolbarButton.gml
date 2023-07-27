/// @func FORMS_ToolbarButton(_name, _sprite, _subimg, _tooltip, _action)
///
/// @extends FORMS_Widget
///
/// @param {String} _name The name of the button.
/// @param {Real} _sprite The button sprite.
/// @param {Real} _subimg The sprite subimage.
/// @param {String} _tooltip The tooltip text.
/// @param {Function} _action The function that will be executed on click
/// or `undefined`.
function FORMS_ToolbarButton(_name, _sprite, _subimg, _tooltip, _action)
	: FORMS_Widget() constructor
{
	static Type = FORMS_EWidgetType.ToolbarButton;

	Name = _name;

	Sprite = _sprite;

	Subimage = _subimg;

	Tooltip = _tooltip;

	Highlight = false;

	OnAction = _action;

	static OnUpdate = function ()
	{
		FORMS_ToolbarButtonUpdate(self);
	}

	static OnDraw = function ()
	{
		FORMS_ToolbarButtonDraw(self);
	}

	SetSize(sprite_get_width(Sprite), sprite_get_height(Sprite));
}

/// @func FORMS_ToolbarButtonDraw(_toolbarButton)
///
/// @desc Draws the toolbar button.
///
/// @param {Real} _toolbarButton The toolbar button.
function FORMS_ToolbarButtonDraw(_toolbarButton)
{
	var _button = _toolbarButton;
	var _x = _button.X;
	var _y = _button.Y;
	var _width = _button.Width;
	var _height = _button.Height;
	var _backgroundColour = FORMS_GetColor(FORMS_EStyle.WindowBackground);

	if (_button.IsHovered())
	{
		_backgroundColour = FORMS_GetColor(FORMS_EStyle.Highlight);
	}
	FORMS_DrawRectangle(_x, _y, _width, _height, _backgroundColour);

	if (_button.Highlight)
	{
		FORMS_DrawRectangle(_x, _y + _height - 4, _width, 4, FORMS_GetColor(FORMS_EStyle.Active));
	}

	draw_sprite(_button.Sprite, _button.Subimage, _x, _y);
}

/// @func FORMS_ToolbarButtonUpdate(_toolbarButton)
///
/// @desc Updates the toolbar button.
///
/// @param {Real} _toolbarButton The toolbar button.
function FORMS_ToolbarButtonUpdate(_toolbarButton)
{
	FORMS_WidgetUpdate(_toolbarButton);

	if (_toolbarButton.IsHovered()
		&& mouse_check_button_pressed(mb_left))
	{
		var _scrAction = _toolbarButton.OnAction;
		if (_scrAction != undefined)
		{
			_scrAction();
		}
	}
}
