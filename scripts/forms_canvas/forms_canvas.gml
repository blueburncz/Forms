/// @func FORMS_Canvas()
///
/// @extends FORMS_CompoundWidget
function FORMS_Canvas()
	: FORMS_CompoundWidget() constructor
{
	static Type = FORMS_EWidgetType.Canvas;

	/// @var {Id.Surface}
	/// @readonly
	Surface = -1;

	/// @var {color}
	Background = FORMS_GetColor(FORMS_EStyle.WindowBackground);

	/// @func BeginFill()
	///
	/// @desc Sets the canvas surface as the render target.
	///
	/// @return {Bool} True if the surface has been set as the render target.
	static BeginFill = function ()
	{
		////////////////////////////////////////////////////////////////////////
		// Check surface
		var _surface = Surface;
		var _width = max(Width, 1);
		var _height = max(Height, 1);

		if (surface_exists(_surface))
		{
			if (surface_get_width(_surface) != _width
				|| surface_get_height(_surface) != _height)
			{
				var _depthDisable = surface_get_depth_disable();
				surface_depth_disable(true);
				surface_resize(_surface, _width, _height);
				surface_depth_disable(_depthDisable);
				FORMS_RequestRedraw(self);
			}
		}
		else
		{
			_surface = surface_create(_width, _height);
			FORMS_RequestRedraw(self);
		}
		Surface = _surface;

		////////////////////////////////////////////////////////////////////////
		// Start filling
		if (Redraw
			&& !FORMS_WIDGET_FILLING)
		{
			Redraw = false;
			var _scrollX = 0;
			var _scrollY = 0;
			var _scrollbarHor = FORMS_GetScrollbarHor(self);
			var _scrollbarVer = FORMS_GetScrollbarVer(self);
			if (!is_undefined(_scrollbarHor))
			{
				_scrollX = _scrollbarHor.GetScroll() * _scrollbarHor.IsVisible();
			}
			if (!is_undefined(_scrollbarVer))
			{
				_scrollY = _scrollbarVer.GetScroll() * _scrollbarVer.IsVisible();
			}
			if (is_nan(_scrollX)) _scrollX = 0;
			if (is_nan(_scrollY)) _scrollY = 0;
			
			surface_set_target(_surface);
			draw_clear(Background);
			FORMS_MatrixSet(-_scrollX, -_scrollY);
			FORMS_WIDGET_FILLING = self;
			FORMS_WIDGET_ID_NEXT = 0;
			return true;
		}
		return false;
	}

	/// @func EndFill()
	///
	/// @desc Finishes drawing into the canvas and resets the render target.
	static EndFill = function ()
	{
		if (FORMS_WIDGET_FILLING == self)
		{
			var _scrollX = 0;
			var _scrollY = 0;
			var _scrollbarHor = FORMS_GetScrollbarHor(self);
			var _scrollbarVer = FORMS_GetScrollbarVer(self);
			var _drawVer = false;
			var _drawHor = false;

			if (!is_undefined(_scrollbarVer))
			{
				_drawVer = _scrollbarVer.IsVisible();
				_scrollY = _scrollbarVer.GetScroll() * _drawVer;
			}
			if (!is_undefined(_scrollbarHor))
			{
				_drawHor = _scrollbarHor.IsVisible();
				_scrollX = _scrollbarHor.GetScroll() * _drawHor;
			}

			if (!is_undefined(_scrollbarVer))
			{
				var _height = Height - _drawHor * _scrollbarHor.Height;
				_scrollbarVer.SetHeight(_height);
				_scrollbarVer.Size = _height;
				_scrollbarVer.CalcJumpAndThumbSize();

				if (_drawVer)
				{
					FORMS_DrawItem(_scrollbarVer,
						_scrollX + Width - _scrollbarVer.Width, _scrollY);
				}
			}

			if (!is_undefined(_scrollbarHor))
			{
				var _width = Width - _drawVer * _scrollbarVer.Width;
				_scrollbarHor.SetWidth(_width);
				_scrollbarHor.Size = _width;
				_scrollbarHor.CalcJumpAndThumbSize();

				if (_drawHor)
				{
					FORMS_DrawItem(_scrollbarHor,
						_scrollX, _scrollY + Height - _scrollbarHor.Height);
				}
			}

			FORMS_MatrixRestore();
			surface_reset_target();
			FORMS_WIDGET_FILLING = undefined;
		}
	}

	static OnDraw = function ()
	{
		FORMS_CanvasDraw(self);
	};

	static OnCleanUp = function ()
	{
		FORMS_CanvasCleanUp(self);
	};
}

/// @func FORMS_CanvasCleanUp(_canvas)
///
/// @desc Frees canvas resources from memory.
///
/// @param {Struct.FORMS_Canvas} _canvas The canvas.
function FORMS_CanvasCleanUp(_canvas)
{
	var _surface = _canvas.Surface;
	if (surface_exists(_surface))
	{
		surface_free(_surface);
	}
	FORMS_CompoundWidgetCleanUp(_canvas);
}

/// @func FORMS_CanvasDraw(_canvas)
///
/// @desc Draws the canvas.
///
/// @param {Struct.FORMS_Canvas} The canvas.
function FORMS_CanvasDraw(_canvas)
{
	var _surface = _canvas.Surface;
	if (surface_exists(_surface))
	{
		draw_surface(_surface, _canvas.X, _canvas.Y);
	}
}


/// @func FORMS_GetDrawPositionAbsolute(_x, _y)
///
/// @desc Retrieves an absolute position of a point drawn into a canvas.
///
/// @param {Real} _x The x coordinate.
/// @param {Real} _y The y coordinate.
///
/// @return {Array<Real>} An array `[x, y]` with the absolute coordinates on the
/// screen.
///
/// @note This works only after {@link BBMOD_Canvas.BeginFill} and before
/// {@link BBMOD_Canvas.EndFill}!
function FORMS_GetDrawPositionAbsolute(_x, _y)
{
	var _position = FORMS_WIDGET_FILLING.GetPositionAbsolute();
	var _scrollbarHor = FORMS_WIDGET_FILLING.ScrollbarHor;
	var _scrollbarVer = FORMS_WIDGET_FILLING.ScrollbarVer;
	if (_scrollbarHor != undefined)
	{
		if (_scrollbarHor.IsVisible())
		{
			_x -= _scrollbarHor.GetScroll();
		}
		if (_scrollbarVer.IsVisible())
		{
			_y -= _scrollbarVer.GetScroll();
		}
	}
	return [_position[0] + _x, _position[1] + _y];
}
