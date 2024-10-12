// @func FORMS_ColorPickerProps()
///
/// @extends FORMS_WindowProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_ColorPicker}.
function FORMS_ColorPickerProps(): FORMS_WindowProps() constructor {}

/// @func FORMS_ColorPicker(_id, _color[, _props])
///
/// @extends FORMS_Window
///
/// @desc A floating window used to mix colors. Opened by clicking on a
/// [color input](./FORMS_Pen.color.html).
///
/// @param {String} _id The ID of the color input that opened this widget.
/// @param {Struct.FORMS_Color} _color A {@link FORMS_Color} color.
/// @param {Struct.FORMS_ColorPickerProps, Undefined} [_props] Properties to
/// create the color picker with or `undefined`.
function FORMS_ColorPicker(_id, _color, _props = undefined): FORMS_Window(undefined, _props) constructor
{
	static Window_update = update;
	static Window_destroy = destroy;

	/// @var {String} The ID of the color input that opened the color picker
	/// widget.
	/// @readonly
	ControlId = _id;

	/// @var {Bool} Whether the color picker has a close button. Defaults to
	/// `false`.
	Closable = false;

	/// @var {Bool} Whether the color picker is resizable. Defaults to `false`.
	Resizable = false;

	/// @var {Struct.FORMS_Color} The original color when opening the picker.
	/// @readonly
	OriginalColor = _color;

	/// @var {Struct.FORMS_Color} The current color.
	Color = new FORMS_Color(_color);

	/// @var {Struct.FORMS_Color} The new color.
	ColorNew = new FORMS_Color(_color);

	/// @var {Bool}
	/// @private
	__hidden = false;

	/// @var {Real}
	/// @private
	__windowPrevX = 0;

	/// @var {Struct.FORMS_Widget} Eyedropper widget for selecting a color from 
	/// the screen at the current mouse position.
	/// @private
	__eyeDropperWidget = new(function (): FORMS_Widget() constructor
	{
		Icon = FA_ESolid.EyeDropper;
		Width.Value = 32;
		Height.Value = 32;
		Visible = false;
		ColorPicker = other;

		static update = function ()
		{
			if (!Visible) { return; }

			if (forms_mouse_check_button_pressed(mb_left))
			{
				Visible = false;
				with(ColorPicker)
				{
					__hide_window(false);
					Color.set(draw_getpixel(forms_mouse_get_x(), forms_mouse_get_y()), 1);
					Widget.__update_wheel_from_color();
					forms_return_result(ControlId, Color);
				}
			}
		}

		static draw = function ()
		{
			if (!Visible) { return; }
			forms_set_cursor(cr_none);
			draw_set_valign(fa_bottom);
			draw_set_color(c_white);
			var _mx = forms_mouse_get_x();
			var _my = forms_mouse_get_y();
			var _pixel_color = draw_getpixel(_mx, _my);
			var _pixel_color2 = draw_getpixel(_mx + 2, _my + 1);
			var _icon_color = merge_color(_pixel_color, _pixel_color2, 0.5);
			_icon_color = color_get_value(_icon_color) > 160 ? c_black : c_white;

			fa_draw(IconFont, Icon, _mx + 3, _my - 2, c_white, 1);
			draw_set_valign(fa_top);
			draw_sprite_ext(FORMS_SprEyeDropper, 0, _mx, _my, 1, 1, 0, _icon_color, 1);
			gpu_set_blendmode(bm_normal);
			draw_sprite_ext(FORMS_SprColorPickerCircle, 1, _mx + 32, _my, 0.75, 0.75, 0, _pixel_color,
				1);
			draw_sprite_ext(FORMS_SprColorPickerCircle, 0, _mx + 32, _my, 0.75, 0.75, 0, c_white, 1);
		}
	})();

	forms_get_root().add_child(__eyeDropperWidget);

	set_widget(new(function (): FORMS_Container() constructor
	{
		static Container_destroy = destroy;

		Name = "Color Picker";
		Width.from_string("100%");
		Height.from_string("100%");

		PickerMode = "init";

		PickerHue = 0; // 0..360
		PickerSaturation = 0; // 0..100
		PickerValue = 255; // 0..100
		PickerAlpha = 1.0; // 0..1

		PickerCursorSize = 0.5; //animate the picker circle

		WheelSelected = false;
		ValueSliderSelected = false;
		__colorWheelSurface = -1;

		static __update_wheel_from_color = function ()
		{
			var _hsva = Parent.Color.get_hsva();
			PickerHue = _hsva[0] * 360;
			PickerSaturation = _hsva[1] * 100;
			PickerValue = _hsva[2] * 100;
			PickerAlpha = _hsva[3];
		}

		static __render_color_wheel = function (_x, _y)
		{
			var _colorWheelSize = Pen.Width - 32;
			var _doRender = false;
			if (!surface_exists(__colorWheelSurface))
			{
				__colorWheelSurface = surface_create(_colorWheelSize, _colorWheelSize);
				_doRender = true;
			}
			else if (surface_get_width(__colorWheelSurface) != _colorWheelSize)
			{
				surface_resize(__colorWheelSurface, _colorWheelSize, _colorWheelSize);
				_doRender = true;
			}

			if (_doRender)
			{
				surface_set_target(__colorWheelSurface);
				draw_clear_alpha(c_black, 0);
				gpu_set_blendenable(false);
				shader_set(FORMS_ShColorWheel);
				draw_primitive_begin(pr_trianglestrip);
				draw_vertex_texture(0, 0, 0, 0);
				draw_vertex_texture(_colorWheelSize, 0, 1, 0);
				draw_vertex_texture(0, _colorWheelSize, 0, 1);
				draw_vertex_texture(_colorWheelSize, _colorWheelSize, 1, 1);
				draw_primitive_end()
				shader_reset();
				gpu_set_blendenable(true);
				surface_reset_target();
			}

			draw_surface_ext(__colorWheelSurface, _x, _y, 1, 1, 0, merge_color(c_black, c_white,
				PickerValue / 100), 1);
		}

		static __draw_color_wheel = function ()
		{
			// Draw color wheel
			var _colorWheelX = Pen.X + 4;
			var _colorWheelY = Pen.Y;
			var _colorWheelSize = Pen.Width - 32;
			var _colorWheelRadius = _colorWheelSize / 2;
			__render_color_wheel(_colorWheelX, _colorWheelY);

			// Interact with color wheel
			var _mousePadding = 8; //makes it easier for user to select the wheel on edges
			var _mouseOver = Pen.is_mouse_over(_colorWheelX - _mousePadding, _colorWheelY
				- _mousePadding, _colorWheelSize + _mousePadding * 2, _colorWheelSize
				+ _mousePadding * 2);
			WheelSelected = (WheelSelected && forms_mouse_check_button(mb_left)) || (_mouseOver
				&& forms_mouse_check_button_pressed(mb_left));

			if (WheelSelected)
			{
				var _mx = forms_mouse_get_x();
				var _my = forms_mouse_get_y();
				var _mdir = point_direction(_colorWheelX + _colorWheelRadius, _colorWheelY
					+ _colorWheelRadius, _mx, _my);
				var _mdist = point_distance(_colorWheelX + _colorWheelRadius, _colorWheelY
					+ _colorWheelRadius, _mx, _my);
				PickerHue = _mdir;
				PickerSaturation = floor((clamp(_mdist, 0, _colorWheelRadius) / _colorWheelRadius)
					* 100);
				PickerCursorSize = lerp(PickerCursorSize, 0.75, 0.25); // animate cursor
				Parent.Color.set_from_hsva(PickerHue / 360, PickerSaturation / 100, PickerValue
					/ 100, PickerAlpha);
				forms_return_result(Parent.ControlId, Parent.Color);
			}
			else
			{
				PickerCursorSize = lerp(PickerCursorSize, 0.5, 0.25); // animate cursor
			}

			// Draw color wheel cursor
			var _colorWheelCursorX = round(_colorWheelX + _colorWheelRadius + lengthdir_x((
				PickerSaturation / 100) * (_colorWheelRadius - 2), PickerHue));
			var _colorWheelCursorY = round(_colorWheelY + _colorWheelRadius + lengthdir_y((
				PickerSaturation / 100) * (_colorWheelRadius - 2), PickerHue));
			draw_sprite_ext(FORMS_SprColorPickerCircle, 1, _colorWheelCursorX, _colorWheelCursorY,
				PickerCursorSize, PickerCursorSize, 0, Parent.Color.get(), 1);
			draw_sprite_ext(FORMS_SprColorPickerCircle, 0, _colorWheelCursorX, _colorWheelCursorY,
				PickerCursorSize, PickerCursorSize, 0, c_white, 1);

			// Draw value slider
			var _valueSliderX = _colorWheelX + Pen.Width - 20;
			var _valueSliderY = _colorWheelY;
			var _valueSliderW = 16;
			var _valueSliderH = _colorWheelSize;

			// Mask the area of the slider
			gpu_set_blendenable(false);
			gpu_set_colorwriteenable(false, false, false, true);
			forms_draw_rectangle(_valueSliderX, _valueSliderY, _valueSliderW + 1, _colorWheelSize
				+ 1, c_black, 0);
			forms_draw_roundrect(_valueSliderX, _valueSliderY, _valueSliderW, _colorWheelSize,
				c_black, 1);
			gpu_set_blendenable(true);
			gpu_set_colorwriteenable(true, true, true, true);

			// Draw gradient on slider
			gpu_set_blendmode_ext_sepalpha(bm_dest_alpha, bm_inv_dest_alpha, bm_one, bm_zero);
			gpu_set_alphatestenable(true);
			draw_rectangle_color(_valueSliderX, _valueSliderY, _valueSliderX + _valueSliderW,
				_valueSliderY + _valueSliderH, c_white, c_white, c_black, c_black, false);
			gpu_set_alphatestenable(false);
			gpu_set_blendmode(bm_normal);

			// Interact with value slider
			_mouseOver = Pen.is_mouse_over(_valueSliderX - 2, _valueSliderY - 4, _valueSliderW + 2,
				_valueSliderH + 8);
			ValueSliderSelected = (ValueSliderSelected && forms_mouse_check_button(mb_left)) || (
				_mouseOver && forms_mouse_check_button_pressed(mb_left));

			if (ValueSliderSelected)
			{
				PickerValue = floor((1.0 - (clamp((forms_mouse_get_y() - _valueSliderY), 0,
					_valueSliderH) / _valueSliderH)) * 100);
				Parent.Color.set_from_hsva(PickerHue / 360, PickerSaturation / 100, PickerValue
					/ 100, PickerAlpha);
				forms_return_result(Parent.ControlId, Parent.Color);
			}

			var _valueSliderHandleX = _valueSliderX - 2;
			var _valueSliderHandleY = _valueSliderY - 4 + (1.0 - (PickerValue / 100))
				* _valueSliderH;
			forms_draw_roundrect(_valueSliderHandleX, _valueSliderHandleY, _valueSliderW + 4, 8, 4,
				c_white, 1);

			// Manually Update Pen Y offset
			Pen.Y += __realWidth - 32 - 8;

			var _colorWidth = floor((Pen.Width - 30) / 2);

			Pen.color("original-color", Parent.OriginalColor,
			{
				Width: _colorWidth,
				Disabled: true
			})
			Pen.move(2);
			Pen.color("new-color", Parent.ColorNew, { Width: _colorWidth, Disabled: true })
			Pen.nl();

			with(Pen)
			{
				__columnCurrent = 0;
				set_x(ColumnX1);
				MaxY = max(MaxY, Y);
			}
		}

		static destroy = function ()
		{
			surface_free(__colorWheelSurface);
			return Container_destroy();
		}

		static draw_content = function ()
		{
			if (Parent.__hidden) { return false; }
			if (PickerMode == "init")
			{
				__update_wheel_from_color();
				PickerMode = "HSV";
			}

			Pen.start(FORMS_EPenLayout.Column2);

			__draw_color_wheel();

			var _buttonWidth = floor((Pen.Width - 30) / 3);

			if (Pen.button("RGB", { Width: _buttonWidth }))
			{
				PickerMode = "RGB";
			}
			Pen.move(2);
			if (Pen.button("HSV", { Width: _buttonWidth }))
			{
				PickerMode = "HSV";
			}
			Pen.move(2);
			if (Pen.button("HEX", { Width: _buttonWidth }))
			{
				PickerMode = "HEX";
			}
			Pen.move(2);
			if (Pen.icon_solid(FA_ESolid.EyeDropper, { Width: 24 }))
			{
				Parent.__hide_window(true);
				Parent.__eyeDropperWidget.Visible = true;
			}

			Pen.nl();

			switch (PickerMode)
			{
				case "RGB":

					var _red = Parent.Color.get_red();
					Pen.text("Red").next();
					if (Pen.slider("slider-red", _red, 0, 255, { Integers: true }))
					{
						_red = Pen.get_result();
					}
					Pen.next();

					var _green = Parent.Color.get_green();
					Pen.text("Green").next();
					if (Pen.slider("slider-green", _green, 0, 255, { Integers: true }))
					{
						_green = Pen.get_result();
					}
					Pen.next();

					var _blue = Parent.Color.get_blue();
					Pen.text("Blue").next();
					if (Pen.slider("slider-blue", _blue, 0, 255, { Integers: true }))
					{
						_blue = Pen.get_result();
					}
					Pen.next();

					Pen.text("Alpha").next();
					if (Pen.slider("slider-alpha", PickerAlpha, 0.0, 1.0))
					{
						PickerAlpha = Pen.get_result();
					}
					Pen.next();

					Parent.ColorNew.set_from_rgba(_red / 255, _green / 255, _blue / 255,
						PickerAlpha);

					if (!Parent.ColorNew.equal_to(Parent.Color))
					{
						Parent.Color.set(Parent.ColorNew);
						forms_return_result(Parent.ControlId, Parent.Color);
						__update_wheel_from_color();
					}
					break;

				case "HSV":

					Pen.text("Hue °").next();
					if (Pen.slider("slider-hue", PickerHue, 0, 360, { Integers: false }))
					{
						PickerHue = Pen.get_result();
					}
					Pen.next();

					Pen.text("Saturation %").next();
					if (Pen.slider("slider-saturation", PickerSaturation, 0,
							100, { Integers: false }))
					{
						PickerSaturation = Pen.get_result();
					}
					Pen.next();

					Pen.text("Value %").next();
					if (Pen.slider("slider-value", PickerValue, 0, 100, { Integers: false }))
					{
						PickerValue = Pen.get_result();
					}
					Pen.next();

					Pen.text("Alpha").next();
					if (Pen.slider("slider-alpha", PickerAlpha, 0.0, 1.0))
					{
						PickerAlpha = Pen.get_result();
					}
					Pen.next();

					Parent.ColorNew.set_from_hsva(PickerHue / 360, PickerSaturation / 100,
						PickerValue / 100, PickerAlpha);

					if (!Parent.ColorNew.equal_to(Parent.Color))
					{
						Parent.Color.set(Parent.ColorNew);
						forms_return_result(Parent.ControlId, Parent.Color);
					}
					break;

				case "HEX":

					Pen.text("Hex").next();
					if (Pen.input("input-hex", Parent.Color.toString()))
					{
						var _hex = Pen.get_result();
						var _valid_hex = Parent.ColorNew.set_from_hex(_hex);
						if (!Parent.ColorNew.equal_to(Parent.Color))
						{
							Parent.Color.set(Parent.ColorNew);
							forms_return_result(Parent.ControlId, Parent.Color);
							__update_wheel_from_color();
						}
					}

					Pen.next().nl(2);

					Pen.text("Alpha").next();
					if (Pen.slider("slider-alpha", PickerAlpha, 0.0, 1.0))
					{
						PickerAlpha = Pen.get_result();
						Parent.ColorNew.set_from_hsva(PickerHue / 360, PickerSaturation / 100,
							PickerValue / 100, PickerAlpha);
						if (!Parent.ColorNew.equal_to(Parent.Color))
						{
							Parent.Color.set(Parent.ColorNew);
							forms_return_result(Parent.ControlId, Parent.Color);
						}
					}

					Pen.next();
					break;
			}

			_buttonWidth = Pen.get_control_width() - 8 / 2;
			if (Pen.button("OK", { Width: _buttonWidth }))
			{
				Parent.remove_self().destroy_later();
			}
			Pen.move(8);
			if (Pen.button("Cancel", { Width: _buttonWidth }))
			{
				Parent.remove_self().destroy_later();
				forms_return_result(Parent.ControlId, Parent.OriginalColor);
			}

			Pen.finish();
			FORMS_CONTENT_UPDATE_SIZE
			return self;
		}

	})());

	static update = function (_deltaTime)
	{
		Window_update();
		if (__hidden)
		{
			X.Value = -__realWidth - 10000; // hide window off screen
		}
	}

	static destroy = function ()
	{
		__eyeDropperWidget.destroy_later();
		return Window_destroy();
	}

	/// @function __hide_window(_hide)
	///
	/// @desc Toggle the window's visiblity.
	///
	/// @param {Bool} _hide Whether to hide (`true`) or show (`false`).
	///
	/// @private
	static __hide_window = function (_hide)
	{
		if (__hidden == _hide) { return; }
		if (_hide)
		{
			__windowPrevX = X.Value; //store old x position
		}
		else
		{
			X.Value = __windowPrevX; //restore window position
		}
		__hidden = _hide;
	}
}
