// @func FORMS_ColorPickerProps()
///
/// @extends FORMS_WindowProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_ColorPicker}.
function FORMS_ColorPickerProps()
	: FORMS_WindowProps() constructor
{
}

/// @func FORMS_ColorPicker(_id, _color[, _props])
///
/// @extends FORMS_Window
///
/// @desc A floating window used to mix colors. Opened by clicking on a
/// [color input](./FORMS_Pen.color.html).
///
/// @param {String} _id The ID of the color input that opened this widget.
/// @param {Real} _color An ABGR-encoded color to mix.
/// @param {Struct.FORMS_ColorPickerProps, Undefined} [_props] Properties to
/// create the color picker with or `undefined`.
function FORMS_ColorPicker(_id, _color, _props=undefined)
	: FORMS_Window(undefined, _props) constructor
{
	/// @var {Bool} Whether the color picker has a close button. Defaults to
	/// `false`.
	Closable = false;

	/// @var {Bool} Whether the color picker is resizable. Defaults to `false`.
	Resizable = false;
	
	set_widget(new FORMS_ScrollPane(new FORMS_ColorPickerContent(_id, _color, self), {
		Name: "Color Picker",
		Width: "100%",
		Height: "100%",
	}));
}

function FORMS_ColorPickerEyeDropper() 
	: FORMS_Widget({Icon: FA_ESolid.EyeDropper, Width: 32, Height: 32}) constructor
{
	Show = false;
	ColorPicker = undefined;
		
	static update = function() 
	{			
		if (!Show) { return; }
		
		if (forms_mouse_check_button_pressed(mb_left)) 
		{
			forms_mouse_set_button_status(mb_left, FORMS_EMouseButton.Off); //prevent interaction with other widgets
			Show = false;
			with (ColorPicker)
			{
				__hide_window(false);
				ColorNew =  draw_getpixel(forms_mouse_get_x(), forms_mouse_get_y()) | (255 << 24);
				__update_wheel_from_color();
				forms_return_result(Id, ColorNew);
			}
		}
	}
		
	static draw = function() 
	{
		if (!Show) { return; } 
		forms_set_cursor(cr_none);
		draw_set_valign(fa_bottom);
		draw_set_color(c_white);
		var _mx = forms_mouse_get_x();
		var _my = forms_mouse_get_y();	
		var _pixel_color = draw_getpixel(_mx, _my);	
		var _pixel_color2 = draw_getpixel(_mx+2, _my+1);	
		var _icon_color = merge_color(_pixel_color, _pixel_color2, 0.5);
		_icon_color = color_get_value(_icon_color) > 160 ? c_black : c_white;

		fa_draw(IconFont, Icon, _mx + 3, _my - 2, c_white, 1);
		draw_set_valign(fa_top);
		draw_sprite_ext(FORMS_SprEyeDropper, 0, _mx, _my, 1, 1, 0, _icon_color, 1);
		gpu_set_blendmode(bm_normal);
		draw_sprite_ext(FORMS_SprColorPickerCircle, 1, _mx+32, _my, 0.75, 0.75, 0, _pixel_color, 1);
		draw_sprite_ext(FORMS_SprColorPickerCircle, 0, _mx+32, _my, 0.75, 0.75, 0, c_white, 1);
	}
}

/// @func FORMS_ColorPickerContent(_id, _color)
///
/// @extends FORMS_Content
///
/// @desc Content of the {@link FORMS_ColorPicker} widget. Draws control using
/// which you can mix a new color.
///
/// @param {String} _id The ID of the color input that opened the color picker
/// widget.
/// @param {Real} _color An ABGR-encoded color to mix.
function FORMS_ColorPickerContent(_id, _color, _window)
	: FORMS_Content() constructor
{
	/// @var {String} The ID of the color input that opened the color picker
	/// widget.
	/// @readonly
	Id = _id;

	/// @var {Real} An ABGR-encoded color to mix.
	/// @readonly
	Color = _color;

	/// @var {Real} The new mixed color (ABGR-encoded).
	/// @readonly
	ColorNew = _color;
	
	Hidden = false;

	PickerMode = "RGB";

	PickerHue = 0; //0 - 360
	PickerSaturation = 0; // 0 - 100
	PickerValue = 255; // 0 - 100
	PickerAlpha = 1.0; // 0 - 1
	
	PickerCursorSize = 0.5; //animate the picker circle

	WheelSelected = false;
	ValueSliderSelected = false;
	EyeDropperMode = false;
	EyeDropperWindowX = 0;
	EyeDropperWidget = new FORMS_ColorPickerEyeDropper();
	EyeDropperWidget.ColorPicker = self;
	forms_get_root().add_child(EyeDropperWidget);
	
	Window = _window;

	__ColorWheelSurface = -1;
			
	__update_wheel_from_color();
	
	static __alpha_from_abgr = function(_abgr_color) {
		return ((_abgr_color >> 24) & 0xFF) / 255.0;
	}
	
	static __hsva_to_abgr_color = function(_hue, _sat, _val, _alpha) {
		return make_color_hsv((_hue / 360) * 255, _sat * 2.55, _val * 2.55) | ((_alpha * 255) << 24);
	}
	
	static __rgba_to_abgr_color = function(_red, _green, _blue, _alpha) {
		return make_color_rgb(_red, _green, _blue) | ((_alpha * 255) << 24);
	}
	
	static __abgr_to_hex_string = function(_abgr_color) {
		return __byte_to_hex_string(color_get_red(_abgr_color)) + __byte_to_hex_string(color_get_green(_abgr_color)) + __byte_to_hex_string(color_get_blue(_abgr_color)) + __byte_to_hex_string((_abgr_color >> 24) & 0xFF);	
	}
	
	static __byte_to_hex_string = function(_byte) {
		var _high = _byte >> 4;
		var _low = _byte & 0x0F;
		return chr(_high + ((_high < 10) ? 48 : 55)) + chr(_low + ((_low < 10) ? 48 : 55));
	}
	
	static __hex_string_to_abgr_color = function(_hex_str) {
		static __valid_chars = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"];
		var _l = string_length(_hex_str);
		_hex_str = string_upper(_hex_str);
		// Validate Hex
		if ((_l != 6) && (_l != 8)) { return undefined; }
		for (var c = 1; c <= _l; ++c) 
		{
			if (!array_contains(__valid_chars, string_char_at(_hex_str, c))) 
			{
				return undefined;
			}
		}
		var _red = real("0x"+string_copy(_hex_str, 1, 2));
		var _green = real("0x"+string_copy(_hex_str, 3, 2));
		var _blue = real("0x"+string_copy(_hex_str, 5, 2));
		var _alpha = (_l == 8) ? (real("0x"+string_copy(_hex_str, 7, 2)) / 255) : PickerAlpha;
		return __rgba_to_abgr_color(_red, _green, _blue, _alpha);
	}
	
	static __update_wheel_from_color = function() {
		PickerHue = (color_get_hue(ColorNew) / 255) * 360;
		PickerSaturation = (color_get_saturation(ColorNew) / 255) * 100;
		PickerValue = (color_get_value(ColorNew) / 255) * 100;
		PickerAlpha = __alpha_from_abgr(ColorNew);
	}
	
	static __render_color_wheel = function(_x, _y) {
		
		var _colorWheelSize = Pen.Width - 32;
		var _doRender = false;
		if (!surface_exists(__ColorWheelSurface)) 
		{
			__ColorWheelSurface = surface_create(_colorWheelSize, _colorWheelSize);
			_doRender = true;
		}
		else if (surface_get_width(__ColorWheelSurface) != _colorWheelSize)
		{
			surface_resize(__ColorWheelSurface, _colorWheelSize, _colorWheelSize);
			_doRender = true;
		}
		
		if (_doRender) {
			surface_set_target(__ColorWheelSurface);
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
		
		draw_surface_ext(__ColorWheelSurface, _x, _y, 1, 1, 0, merge_color(c_black, c_white, PickerValue / 100), 1);
	}

	static __draw_color_wheel = function()
	{
		// Draw color wheel
		var _colorWheelX = Pen.X+4;
		var _colorWheelY = Pen.Y;
		var _colorWheelSize = Pen.Width - 32;
		var _colorWheelRadius = _colorWheelSize / 2;
		__render_color_wheel(_colorWheelX, _colorWheelY);

		// Interact with color wheel
		var _mousePadding = 8; //makes it easier for user to select the wheel on edges
		var _mouseOver = Pen.is_mouse_over(_colorWheelX - _mousePadding, _colorWheelY - _mousePadding, _colorWheelSize + _mousePadding * 2, _colorWheelSize + _mousePadding * 2);
		WheelSelected = (WheelSelected && forms_mouse_check_button(mb_left)) || (_mouseOver && forms_mouse_check_button_pressed(mb_left));	

		if (WheelSelected) {
			var _mx = forms_mouse_get_x();	
			var _my = forms_mouse_get_y();	
			var _mdir = point_direction(_colorWheelX + _colorWheelRadius, _colorWheelY + _colorWheelRadius, _mx, _my);
			var _mdist = point_distance(_colorWheelX + _colorWheelRadius, _colorWheelY + _colorWheelRadius, _mx, _my);
			PickerHue = _mdir;
			PickerSaturation = floor((clamp(_mdist, 0, _colorWheelRadius) / _colorWheelRadius) * 100); 
			PickerCursorSize = lerp(PickerCursorSize, 0.75, 0.25); // animate cursor
			ColorNew = __hsva_to_abgr_color(PickerHue, PickerSaturation, PickerValue, PickerAlpha);
			forms_return_result(Id, ColorNew);
		}
		else 
		{
			PickerCursorSize = lerp(PickerCursorSize, 0.5, 0.25); // animate cursor
		}
		
		// Draw color wheel cursor
		var _colorWheelCursorX = round(_colorWheelX + _colorWheelRadius + lengthdir_x((PickerSaturation / 100) * (_colorWheelRadius - 2), PickerHue));
		var _colorWheelCursorY = round(_colorWheelY + _colorWheelRadius + lengthdir_y((PickerSaturation / 100) * (_colorWheelRadius - 2), PickerHue));
		draw_sprite_ext(FORMS_SprColorPickerCircle, 1, _colorWheelCursorX, _colorWheelCursorY, PickerCursorSize, PickerCursorSize, 0, ColorNew, 1);
		draw_sprite_ext(FORMS_SprColorPickerCircle, 0, _colorWheelCursorX, _colorWheelCursorY, PickerCursorSize, PickerCursorSize, 0, c_white, 1);
		
		// Draw value slider
		var _valueSliderX = _colorWheelX + Pen.Width - 20;
		var _valueSliderY = _colorWheelY;
		var _valueSliderW = 16;
		var _valueSliderH = _colorWheelSize;
		
		// Mask the area of the slider
		gpu_set_blendenable(false);
		gpu_set_colorwriteenable(false,false,false,true);
		forms_draw_rectangle(_valueSliderX, _valueSliderY, _valueSliderW+1, _colorWheelSize+1, c_black, 0);
		forms_draw_roundrect(_valueSliderX, _valueSliderY, _valueSliderW, _colorWheelSize, c_black, 1);
		gpu_set_blendenable(true);
		gpu_set_colorwriteenable(true,true,true,true);
		
		// Draw gradient on slider
		gpu_set_blendmode_ext_sepalpha(bm_dest_alpha, bm_inv_dest_alpha, bm_one, bm_zero);
		gpu_set_alphatestenable(true);
		draw_rectangle_color(_valueSliderX, _valueSliderY, _valueSliderX + _valueSliderW, _valueSliderY + _valueSliderH, c_white, c_white, c_black, c_black, false);
		gpu_set_alphatestenable(false);
		gpu_set_blendmode(bm_normal);
		
		// Interact with value slider
		_mouseOver = Pen.is_mouse_over(_valueSliderX - 2, _valueSliderY - 4, _valueSliderW + 2, _valueSliderH + 8);
		ValueSliderSelected = (ValueSliderSelected && forms_mouse_check_button(mb_left)) || (_mouseOver && forms_mouse_check_button_pressed(mb_left));			
		
		if (ValueSliderSelected) 
		{
			PickerValue = floor((1.0 - (clamp((forms_mouse_get_y() - _valueSliderY), 0, _valueSliderH) / _valueSliderH)) * 100);
			ColorNew = __hsva_to_abgr_color(PickerHue, PickerSaturation, PickerValue, PickerAlpha);
			forms_return_result(Id, ColorNew);
		}
		
		var _valueSliderHandleX = _valueSliderX - 2;
		var _valueSliderHandleY = _valueSliderY - 4 + (1.0 - (PickerValue / 100)) * _valueSliderH;
		forms_draw_roundrect(_valueSliderHandleX, _valueSliderHandleY, _valueSliderW + 4, 8, 4, c_white, 1);
		
		// Manually Update Pen Y offset
		Pen.Y += Width - 32;
		with (Pen) 
		{
			__columnCurrent = 0;
			set_x(ColumnX1);
			MaxY = max(MaxY, Y);
		}
	}
	
	static __hide_window = function(_hide) 
	{
		if (Hidden == _hide) { return; }
		if (_hide)
		{
			EyeDropperWindowX = Window.X.Value; //store old x position
		} 
		else 
		{
			Window.X.Value = EyeDropperWindowX; //restore window position
		}
		Hidden = _hide;
	}

	static draw = function ()
	{				
		if (Hidden) 
		{
			Window.X.Value = -Window.__realWidth - 10000; // hide window off screen
			return false;
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
			__hide_window(true);
			EyeDropperWidget.Show = true;
		}
		
		Pen.nl();
		
		var _colorNew = ColorNew;
		
		switch (PickerMode) 
		{
			
			case "RGB":
			
				var _red = ColorNew & 0xFF;
				Pen.text("Red").next();
				if (Pen.slider("slider-red", _red, 0, 255, { Integers: true }))
				{
					_red = Pen.get_result();
				}
				Pen.next();

				var _green = (ColorNew >> 8) & 0xFF;
				Pen.text("Green").next();
				if (Pen.slider("slider-green", _green, 0, 255, { Integers: true }))
				{
					_green = Pen.get_result();
				}
				Pen.next();

				var _blue = (ColorNew >> 16) & 0xFF;
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
				
				_colorNew = __rgba_to_abgr_color(_red, _green, _blue, PickerAlpha);
				if (ColorNew != _colorNew)
				{
					ColorNew = _colorNew;
					forms_return_result(Id, ColorNew);
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
				if (Pen.slider("slider-saturation", PickerSaturation, 0, 100, { Integers: false }))
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
				
				_colorNew = __hsva_to_abgr_color(PickerHue, PickerSaturation, PickerValue, PickerAlpha);
				if (ColorNew != _colorNew)
				{
					ColorNew = _colorNew;
					forms_return_result(Id, ColorNew);
				}
				
				//Update values to valid ABGR color on release (to keep color as close to desired as possible)
				if (forms_mouse_check_button_released(mb_left)) {
					__update_wheel_from_color();
				}
				
			break;
			
			case "HEX":
				Pen.text("Hex").next();
				if (Pen.input("slider-hex", __abgr_to_hex_string(ColorNew)))
				{
					var _hex = Pen.get_result();
					_colorNew = __hex_string_to_abgr_color(_hex) ?? _colorNew;
					if (ColorNew != _colorNew)
					{
						ColorNew = _colorNew;
						forms_return_result(Id, ColorNew);
						__update_wheel_from_color();
					}
				}
				Pen.next();
				
				Pen.text("Alpha").next();
				if (Pen.slider("slider-alpha", PickerAlpha, 0.0, 1.0))
				{
					PickerAlpha = Pen.get_result();
					_colorNew = __hsva_to_abgr_color(PickerHue, PickerSaturation, PickerValue, PickerAlpha);
					if (ColorNew != _colorNew)
					{
						ColorNew = _colorNew;
						forms_return_result(Id, ColorNew);
					}
				}
				Pen.next();
				
			break;
		}

		var _buttonWidth = Pen.get_control_width() - 8 / 2;
		if (Pen.button("OK", { Width: _buttonWidth }))
		{
			surface_free(__ColorWheelSurface);
			Window.remove_self().destroy_later();
		}
		Pen.move(8);
		if (Pen.button("Cancel", { Width: _buttonWidth }))
		{
			surface_free(__ColorWheelSurface);
			Window.remove_self().destroy_later();
			forms_return_result(Id, Color);
		}

		Pen.finish();
		Width = Pen.get_max_x();
		Height = Pen.get_max_y();

		return self;
	};
	
	
}
