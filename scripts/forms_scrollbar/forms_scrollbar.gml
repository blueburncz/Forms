/// @func FORMS_Scrollbar(_parent)
///
/// @extends FORMS_Widget
///
/// @param {Struct.FORMS_CompoundWidget} _parent The scrollbar's parent.
function FORMS_Scrollbar(_parent)
	: FORMS_Widget() constructor
{
	static Type = FORMS_EWidgetType.Scrollbar;

	Depth = 16777216;

	Sprite = noone;

	SpriteSize = 1;

	ContentSize = 0.1;

	Size = 1;

	Scroll = 0;

	ScrollJump = 1;

	MouseOffset = 0;

	MinThumbSize = 12;

	ThumbSize = MinThumbSize;

	/// @func CalcJumpAndThumbSize()
	///
	/// @desc Calculates the jump value and thumb size of the scrollbar.
	static CalcJumpAndThumbSize = function ()
	{
		var _size = Size;
		var _contentSize = ContentSize;
		var _minThumbSize = MinThumbSize;

		var _viewableRatio = _size / _contentSize;
		var _scrollBarArea = _size;
		var _thumbSize = max(_minThumbSize, _scrollBarArea * _viewableRatio);
		ThumbSize = _thumbSize;

		var _scrollTrackSpace = _contentSize - _size;
		var _scrollThumbSpace = _size - _thumbSize;
		ScrollJump = _scrollTrackSpace / _scrollThumbSpace;
	};

	/// @func IsVisible()
	///
	/// @desc Finds out whether the scrollbar is visible.
	///
	/// @return {Bool} True if the scrollbar is visible.
	static IsVisible = function ()
	{
		if (Parent.ScrollbarHor == self)
		{
			if (ContentSize > Parent.Width)
			{
				return true;
			}
		}
		if (Parent.ScrollbarVer == self)
		{
			if (ContentSize > Parent.Height)
			{
				return true;
			}
		}
		return false;
	};

	/// @func GetScroll()
	///
	/// @desc Gets the scroll of the given scrollbar.
	///
	/// @return {Real} The content scroll.
	static GetScroll = function ()
	{
		gml_pragma("forceinline");
		return round(Scroll * ScrollJump);
	};

	/// @func SetScroll(_scroll)
	///
	/// @desc Sets scrollbar's scroll to the given value.
	///
	/// @param {Real} scroll The new scroll value.
	static SetScroll = function (_scroll)
	{
		gml_pragma("forceinline");
		Scroll = _scroll / ScrollJump;
	};

	static OnUpdate = function ()
	{
		FORMS_ScrollbarUpdate(self);
	};

	Parent = _parent;
}

/// @func FORMS_ScrollbarUpdate(_scrollbar)
///
/// @desc Updates the scrollbar.
///
/// @param {Struct.FORMS_Scrollbar} _scrollbarThe scrollbar.
function FORMS_ScrollbarUpdate(_scrollbar)
{
	FORMS_WidgetUpdate(_scrollbar);
	_scrollbar.CalcJumpAndThumbSize();

	var _parent = _scrollbar.Parent;

	if (_scrollbar.IsHovered()
		|| (FORMS_WidgetExists(_parent)
		&& (_parent.IsHovered()
		|| _parent.IsAncestor(FORMS_WIDGET_HOVERED))))
	{
		var _wheel = (mouse_wheel_down() - mouse_wheel_up()) * 2 * FORMS_FONT_HEIGHT / _scrollbar.ScrollJump;
		if (_wheel != 0)
		{
			_scrollbar.Scroll = clamp(_scrollbar.Scroll + _wheel, 0, _scrollbar.Size - _scrollbar.ThumbSize);
			FORMS_RequestRedraw(_scrollbar);
		}
	}
}
