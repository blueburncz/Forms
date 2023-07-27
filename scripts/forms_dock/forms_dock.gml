/// @enum Enumeration of widget split types. Used for example in the dock widget.
enum FORMS_ESplit
{
	/// @member Widget is split horizontally.
	Horizontal,
	/// @member Widget is split vertically.
	Vertical,
};

/// @func FORMS_Dock([_x, _y, _width, _height])
///
/// @extends FORMS_CompoundWidget
///
/// @param {Real} [_x] The x position to create the dock at.
/// @param {Real} [_y] The y position to create the dock at.
/// @param {Real} [_width] The width of the dock.
/// @param {Real} [_height] The width of the dock.
function FORMS_Dock(_x, _y, _width, _height)
	: FORMS_CompoundWidget() constructor
{
	static Type = FORMS_EWidgetType.Dock;

	/// @var {Real}
	SplitSize = 0.5;

	/// @var {FORMS_ESplit}
	SplitType = FORMS_ESplit.Horizontal;

	/// @var {Real}
	/// @private
	MouseOffset = 0;

	/// @var {Real}
	Padding = 3;

	static OnUpdate = function ()
	{
		FORMS_DockUpdate(self);
	};

	static OnDraw = function ()
	{
		FORMS_DockDraw(self);
	}

	if (_height != undefined)
	{
		SetRectangle(_x, _y, _width, _height);
	}
}

/// @func FORMS_DockDraw(_dock)
///
/// @desc Draws the dock.
///
/// @param {Struct.FORMS_Dock} _dock The dock.
function FORMS_DockDraw(_dock)
{
	var _x = _dock.X;
	var _y = _dock.Y;
	var _items = FORMS_GetItems(_dock);
	var _itemCount = ds_list_size(_items);

	FORMS_MatrixPush(_x, _y);

	{
		var _width = _dock.Width;
		var _height = _dock.Height;
		var _splitType = _dock.SplitType;
		var _splitSize = _dock.SplitSize;
		var _padding = _dock.Padding;
		var _middle;

		if (_splitType == FORMS_ESplit.Horizontal)
		{
			_middle = round(_width * _splitSize);
			FORMS_DrawRectangle(_middle - _padding, 0, _padding * 2, _height, c_black);
		}
		else
		{
			_middle = round(_height * _splitSize);
			FORMS_DrawRectangle(0, _middle - _padding, _width, _padding * 2, c_black);
		}
	}

	if (_itemCount == 1)
	{
		var _item = _items[| 0];
		_item.SetSize(
			_dock.Width,
			_dock.Height);
		FORMS_DrawItem(_item, 0, 0);
	}
	else if (_itemCount == 2)
	{
		var _width = _dock.Width;
		var _height = _dock.Height;
		var _splitType = _dock.SplitType;
		var _splitSize = _dock.SplitSize;
		var _padding = _dock.Padding;
		var _middle;

		if (_splitType == FORMS_ESplit.Horizontal)
		{
			_middle = round(_width * _splitSize);
		}
		else
		{
			_middle = round(_height * _splitSize);
		}

		// Left
		var _left = _items[| 0];
		if (_splitType == FORMS_ESplit.Horizontal)
		{
			_left.SetSize(
				_middle - _padding,
				_height);
		}
		else
		{
			_left.SetSize(
				_width,
				_middle - _padding);
		}
		FORMS_DrawItem(_left, 0, 0);

		// Right
		var _right = _items[| 1];
		if (_splitType == FORMS_ESplit.Horizontal)
		{
			_right.SetRectangle(
				_middle + _padding,
				0,
				_width - _middle - _padding,
				_height);
		}
		else
		{
			_right.SetRectangle(
				0,
				_middle + _padding,
				_width,
				_height - _middle - _padding);
		}
		FORMS_DrawItem(_right);
	}

	FORMS_MatrixRestore();
}

/// @func FORMS_DockUpdate(_dock)
///
/// @desc Updates the dock.
///
/// @param {Struct.FORMS_Dock} _dock The dock.
function FORMS_DockUpdate(_dock)
{
	FORMS_CompoundWidgetUpdate(_dock);

	// Start resizing
	if (!FORMS_WidgetExists(FORMS_WIDGET_ACTIVE)
		&& _dock.IsHovered())
	{
		var _width = _dock.Width;
		var _height = _dock.Height;
		var _splitType = _dock.SplitType;
		var _splitSize = _dock.SplitSize;
		var _padding = _dock.Padding;
		var _middle;

		if (_splitType == FORMS_ESplit.Horizontal)
		{
			_middle = round(_width * _splitSize);

			// Horizontally
			if (FORMS_MOUSE_X >= _middle - _padding
				&& FORMS_MOUSE_X < _middle + _padding)
			{
				FORMS_CURSOR = cr_size_we;
				if (mouse_check_button_pressed(mb_left))
				{
					FORMS_CONTROL_STATE = FORMS_EControlState.ResizingDock;
					FORMS_WIDGET_ACTIVE = _dock;
					_dock.MouseOffset = _middle - FORMS_MOUSE_X;
				}
			}
		}
		else
		{
			_middle = round(_height * _splitSize);

			// Vertically
			if (FORMS_MOUSE_Y >= _middle - _padding
				&& FORMS_MOUSE_Y < _middle + _padding)
			{
				FORMS_CURSOR = cr_size_ns;
				if (mouse_check_button_pressed(mb_left))
				{
					FORMS_CONTROL_STATE = FORMS_EControlState.ResizingDock;
					FORMS_WIDGET_ACTIVE = _dock;
					_dock.MouseOffset = _middle - FORMS_MOUSE_Y;
				}
			}
		}
	}

	// Resize
	if (FORMS_WIDGET_ACTIVE == _dock)
	{
		if (mouse_check_button(mb_left))
		{
			if (_dock.SplitType == FORMS_ESplit.Horizontal)
			{
				_dock.SplitSize = (FORMS_MOUSE_X + _dock.MouseOffset) / _dock.Width;
				FORMS_CURSOR = cr_size_we;
			}
			else
			{
				_dock.SplitSize = (FORMS_MOUSE_Y + _dock.MouseOffset) / _dock.Height;
				FORMS_CURSOR = cr_size_ns;
			}
			_dock.SplitSize = clamp(_dock.SplitSize, 0.1, 0.9);
		}
		else
		{
			FORMS_CONTROL_STATE = FORMS_EControlState.Default;
			FORMS_WIDGET_ACTIVE = undefined;
		}
	}
}
