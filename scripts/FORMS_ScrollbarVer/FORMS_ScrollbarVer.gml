/// @func FORMS_ScrollbarVer(_parent)
///
/// @extends FORMS_Scrollbar
///
/// @param {Struct.FORMS_CompoundWidget} _parent The scrollbar's parent.
function FORMS_ScrollbarVer(_parent)
	: FORMS_Scrollbar(_parent) constructor
{
	Sprite = FORMS_SprScrollbarVer;

	SpriteSize = sprite_get_height(Sprite);

	SetWidth(sprite_get_width(Sprite));

	static OnUpdate = function ()
	{
		FORMS_ScrollbarVerUpdate(self);
	};

	static OnDraw = function ()
	{
		FORMS_ScrollbarVerDraw(self);
	};
}

/// @func FORMS_ScrollbarVerUpdate(_scrollbarVer)
///
/// @desc Updates the vertical scrollbar.
///
/// @param {Struct.FORMS_ScrollbarVer} _scrollbarVer The vertical scrollbar.
function FORMS_ScrollbarVerUpdate(_scrollbarVer)
{
	var _scrollbar = _scrollbarVer;

	_scrollbar.Size = _scrollbar.Height;
	if (!keyboard_check(vk_control))
	{
		FORMS_ScrollbarUpdate(_scrollbar);
	}
	else
	{
		FORMS_WidgetUpdate(_scrollbar);
	}

	// Start scrolling with mouse click
	// TODO: Fix scrollbars so that the commented code works
	if (FORMS_WIDGET_HOVERED == _scrollbar
		&& mouse_check_button_pressed(mb_left))
	{
		var _y = _scrollbar.Scroll;

		if (FORMS_WIDGET_HOVERED == _scrollbar
			&& FORMS_MOUSE_Y > _y
			&& FORMS_MOUSE_Y < _y + _scrollbar.ThumbSize)
		{
			//_scrollbar.MouseOffset = _y - FORMS_MOUSE_Y;
			_scrollbar.MouseOffset = window_mouse_get_y();
			FORMS_CONTROL_STATE = FORMS_EControlState.Scrolling;
			FORMS_WIDGET_ACTIVE = _scrollbar;
		}
	}

	// Stop scrolling
	if (mouse_check_button_released(mb_left)
		&& FORMS_WIDGET_ACTIVE == _scrollbar)
	{
		FORMS_CONTROL_STATE = FORMS_EControlState.Default;
		FORMS_WIDGET_ACTIVE = undefined;
	}

	// Handle scrolling
	if (_scrollbar.IsVisible())
	{
		var _scroll = _scrollbar.Scroll;
		if (FORMS_WIDGET_ACTIVE == _scrollbar)
		{
			//_scroll = FORMS_MOUSE_Y + _scrollbar.MouseOffset;
			_scroll += window_mouse_get_y() - _scrollbar.MouseOffset;
			_scrollbar.MouseOffset = window_mouse_get_y();
		}
		_scroll = clamp(_scroll, 0, _scrollbar.Height - _scrollbar.ThumbSize);
		_scrollbar.Scroll = _scroll;
	}
}

/// @func FORMS_ScrollbarVerDraw(_scrollbarVer)
///
/// @desc Draws the vertical scrollbar.
///
/// @param {Struct.FORMS_ScrollbarVer} _scrollbarVer The vertical scrollbar.
function FORMS_ScrollbarVerDraw(_scrollbarVer)
{
	if (_scrollbarVer.IsVisible())
	{
		// Thumb
		var _x = _scrollbarVer.X;
		var _y = _scrollbarVer.Y + _scrollbarVer.Scroll;
		var _thumbSize = _scrollbarVer.ThumbSize;
		var _sprite = _scrollbarVer.Sprite;
		var _spriteSize = _scrollbarVer.SpriteSize;
		var _alpha = 0.75;
		draw_sprite_ext(_sprite, 0, _x, _y, 1, 1, 0, FORMS_GetColor(FORMS_EStyle.Scrollbar), _alpha);
		draw_sprite_stretched_ext(_sprite, 1, _x, _y + _spriteSize, _scrollbarVer.Width, _thumbSize - _spriteSize * 2, FORMS_GetColor(FORMS_EStyle.Scrollbar), _alpha);
		draw_sprite_ext(_sprite, 2, _x, _y + _thumbSize - _spriteSize, 1, 1, 0, FORMS_GetColor(FORMS_EStyle.Scrollbar), _alpha);
	}
}
