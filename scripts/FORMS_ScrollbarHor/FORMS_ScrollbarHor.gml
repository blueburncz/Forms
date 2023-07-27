/// @func FORMS_ScrollbarHor(_parent)
///
/// @extends FORMS_Scrollbar
///
/// @param {Struct.FORMS_CompoundWidget} _parent The scrollbar's parent.
function FORMS_ScrollbarHor(_parent)
	: FORMS_Scrollbar(_parent) constructor
{
	Sprite = FORMS_SprScrollbarHor;

	SpriteSize = sprite_get_width(Sprite);

	SetHeight(sprite_get_height(Sprite));

	static OnUpdate = function ()
	{
		FORMS_ScrollbarHorUpdate(self);
	};

	static OnDraw = function ()
	{
		FORMS_ScrollbarHorDraw(self);
	};
}

/// @func FORMS_ScrollbarHorUpdate(_scrollbarHor)
///
/// @desc Updates the horizontal scrollbar.
///
/// @param {Struct.FORMS_ScrollbarHor} _scrollbarHor The horizontal scrollbar.
function FORMS_ScrollbarHorUpdate(_scrollbarHor)
{
	var _scrollbar = _scrollbarHor;
	_scrollbar.Size = _scrollbar.Width;

	if (keyboard_check(vk_control))
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
		var _x = _scrollbar.Scroll;

		if (FORMS_WIDGET_HOVERED == _scrollbar
			&& FORMS_MOUSE_X > _x
			&& FORMS_MOUSE_X < _x + _scrollbar.ThumbSize)
		{
			//_scrollbar.MouseOffset = _x - FORMS_MOUSE_X;
			_scrollbar.MouseOffset = window_mouse_get_x();
			FORMS_WIDGET_ACTIVE = _scrollbar;
		}
	}

	// Stop scrolling
	if (mouse_check_button_released(mb_left)
		&& FORMS_WIDGET_ACTIVE == _scrollbar)
	{
		FORMS_WIDGET_ACTIVE = undefined;
	}

	// Handle scrolling
	if (_scrollbar.IsVisible())
	{
		var _scroll = _scrollbar.Scroll;
		if (FORMS_WIDGET_ACTIVE == _scrollbar)
		{
			//_scroll = FORMS_MOUSE_X + _scrollbar.MouseOffset;
			_scroll += window_mouse_get_x() - _scrollbar.MouseOffset;
			_scrollbar.MouseOffset = window_mouse_get_x();
		}
		_scroll = clamp(_scroll, 0, _scrollbar.Width - _scrollbar.ThumbSize);
		_scrollbar.Scroll = _scroll;
	}
}

/// @func FORMS_ScrollbarHorDraw(_scrollbarHor)
///
/// @desc Draws the horizontal scrollbar.
///
/// @param {Struct.FORMS_ScrollbarHor} _scrollbarHor The horizontal scrollbar.
function FORMS_ScrollbarHorDraw(_scrollbarHor)
{
	if (_scrollbarHor.IsVisible())
	{
		// Thumb
		var _x = _scrollbarHor.X + _scrollbarHor.Scroll;
		var _y = _scrollbarHor.Y;
		var _thumbSize = _scrollbarHor.ThumbSize;
		var _sprite = _scrollbarHor.Sprite;
		var _spriteSize = _scrollbarHor.SpriteSize;
		var _alpha = 0.75;
		draw_sprite_ext(_sprite, 0, _x, _y, 1, 1, 0, FORMS_GetColor(FORMS_EStyle.Scrollbar), _alpha);
		draw_sprite_stretched_ext(_sprite, 1, _x + _spriteSize, _y, _thumbSize - _spriteSize * 2, _scrollbarHor.Height, FORMS_GetColor(FORMS_EStyle.Scrollbar), _alpha);
		draw_sprite_ext(_sprite, 2, _x + _thumbSize - _spriteSize, _y, 1, 1, 0, FORMS_GetColor(FORMS_EStyle.Scrollbar), _alpha);
	}
}
