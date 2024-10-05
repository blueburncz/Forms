// @func FORMS_ColorPickerProps()
///
/// @extends FORMS_WindowProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_ColorPicker}.
function FORMS_ColorPickerProps()
	: FORMS_WindowProps() constructor
{
}

function FORMS_Color(_color=c_white) constructor
{
	/// @var {Real} 32bit (8bit per channel) ABGR-encoded color.
	__color = c_white;

	/// @var {Real} Red component of the color, 0 - 1.
	__red = 0;
	
	/// @var {Real} Green component of the color, 0 - 1.
	__green = 0;
	
	/// @var {Real} Blue component of the color, 0 - 1.
	__blue = 0;
	
	/// @var {Real} Alpha component of the color, 0 - 1.
	__alpha = 1;
	
	self.set(_color);
	
	/// @func __calculate_color()
	/// @desc Update the ABGR "__color" variable with the current component values
	static __calculate_color = function() {
		__color = ((__red * 255)) | ((__green * 255) << 8) | ((__blue * 255) << 16) | ((__alpha * 255) << 24);
	}
	
	/// @func set(_color)
	/// @desc Sets the color
	/// @param {Color.Constant, Struct.FORMS_Color} _color Can either be a ABGR color, BGR color or FORMS_Color
	/// @param {Real} _alpha Optional alpha value (if _color is BGR) with value between 0 - 1
	static set = function(_color, _alpha = undefined) 
	{
		__red = is_struct(_color) ? _color.__red : (color_get_red(_color) / 255);
		__green = is_struct(_color) ? _color.__green : (color_get_green(_color) / 255);
		__blue = is_struct(_color) ? _color.__blue : (color_get_blue(_color) / 255);
		__alpha = is_struct(_color) ? _color.__alpha : clamp(_alpha ?? (((_color >> 24) & 0xFF) / 255), 0, 1);
		__calculate_color();
	}
	
	/// @func set_from_rgba(_red, _green, _blue, _alpha)
	/// @desc Sets the color from RGBA components
	/// @param {Real} _red Red value between 0 - 1
	/// @param {Real} _green Green value between 0 - 1
	/// @param {Real} _blue Blue value between 0 - 1
	/// @param {Real} _alpha Alpha value between 0 - 1
	static set_from_rgba = function(_red, _green, _blue, _alpha)
	{
		__red = clamp(_red, 0, 1);
		__green = clamp(_green, 0, 1);
		__blue = clamp(_blue, 0, 1);
		__alpha = clamp(_alpha, 0, 1);
		__calculate_color();
	}
	
	/// @func set_from_hsva(_hue, _saturation, _value, _alpha)
	/// @desc Sets the color from HSVA components
	/// @param {Real} _hue The hue component, 0 - 1
	/// @param {Real} _saturation The saturation component, 0 - 1
	/// @param {Real} _value The value component, 0 - 1
	/// @param {Real} _alpha The alpha component, 0 - 1
	static set_from_hsva = function(_hue, _saturation, _value, _alpha)
	{
		var _r, _g, _b;
	    var _i = floor(_hue * 6);
	    var _f = _hue * 6 - _i;
	    var _p = _value * (1 - _saturation);
	    var _q = _value * (1 - _f * _saturation);
	    var _t = _value * (1 - (1 - _f) * _saturation);
	    switch (_i) {
	        case 0: _r = _value;		_g = _t;			_b = _p;			break;
	        case 1: _r = _q;			_g = _value;		_b = _p;			break;
	        case 2: _r = _p;			_g = _value;		_b = _t;			break;
	        case 3: _r = _p;			_g = _q;			_b = _value;		break;
	        case 4: _r = _t;			_g = _p;			_b = _value;		break;
	        case 5: _r = _value;		_g = _p;			_b = _q;			break;
	    }
		__red = clamp(_r, 0, 1);
		__green = clamp(_g, 0, 1);
		__blue = clamp(_b, 0, 1);
		__alpha = clamp(_alpha, 0, 1);
		__calculate_color();
	}
	
	/// @func set_from_hex(_hue, _saturation, _value, _alpha)
	/// @desc Sets the color from a HEX string with format RGBA or RGB, can be preceded by # or 0x
	/// @param {String} _hex_str The hex encoded color string
	static set_from_hex = function(_hex_str) {
		static __valid_chars = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"];
		_hex_str = string_replace(string_replace(string_upper(_hex_str), "#", ""), "0X", "");
		var _l = string_length(_hex_str);
		// Validate Hex
		if ((_l != 6) && (_l != 8)) { return false; }
		for (var c = 1; c <= _l; ++c) 
		{
			if (!array_contains(__valid_chars, string_char_at(_hex_str, c))) { return undefined; }
		}
		// Convert to color components
		__red = real("0x"+string_copy(_hex_str, 1, 2)) / 255;
		__green = real("0x"+string_copy(_hex_str, 3, 2)) / 255;
		__blue = real("0x"+string_copy(_hex_str, 5, 2)) / 255;
		__alpha = (_l == 8) ? (real("0x"+string_copy(_hex_str, 7, 2)) / 255) : 1;
		return true;
	}
	
	/// @func get()
	/// @desc Gets the color (ABGR)
	/// @return Returns a ABGR color
	static get = function()
	{
		__calculate_color();
		return __color;
	}
	
	/// @func get_alpha()
	/// @desc Gets the alpha value
	/// @return {Real} Returns alpha value between 0 - 1
	static get_alpha = function()
	{
		return __alpha;
	}
	
	/// @func get_hsva()
	/// @return {Array} Returns array with format [H,S,V,A] with values between 0 - 1
	static get_hsva = function() 
	{
	    var _max = max(__red, __green, __blue);
		var _min = min(__red, __green, __blue);
		var d = _max - _min;
		var _h;
		var _s = (_max == 0 ? 0 : d / _max);
		var _v = _max;
		switch (_max) {
			case _min: _h = 0; break;
			case __red: _h = (__green - __blue) + d * (__green < __blue ? 6: 0); _h /= 6 * d; break;
			case __green: _h = (__blue - __red) + d * 2; _h /= 6 * d; break;
			case __blue: _h = (__red - __green) + d * 4; _h /= 6 * d; break;
		}
		return [_h, _s, _v, __alpha];
	}
	
	/// @func equal_to(_color, [_precise])
	/// @param {Struct.FORMS_Color, Color.Constant} _color The color to compare to
	/// @param {Bool} _precise Whether to compare colors more precisely (only when comparing to another FORMS_Color)
	/// @return {Bool} Whether colors are equal
	static equal_to = function(_color, _precise = true)
	{
		if (is_struct(_color) && _precise)
		{
			return (__red == _color.__red) && (__green == _color.__green) && (__blue == _color.__blue) && (__alpha == _color.__alpha);
		}
		else 
		{
			return __color == (is_struct(_color) ? _color.__color : _color);
		}
	}
	
	static __byte_to_hex_string = function(_byte) 
	{
		var _high = _byte >> 4;
		var _low = _byte & 0x0F;
		return chr(_high + ((_high < 10) ? 48 : 55)) + chr(_low + ((_low < 10) ? 48 : 55));
	}
	
	/// @func toString()
	/// @desc Returns #RGBA hex string
	static toString = function()
	{
		return "#" + __byte_to_hex_string(color_get_red(__color)) + __byte_to_hex_string(color_get_green(__color)) + __byte_to_hex_string(color_get_blue(__color)) + __byte_to_hex_string((__color >> 24) & 0xFF);
	}
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
				Color.set(draw_getpixel(forms_mouse_get_x(), forms_mouse_get_y()), 1);
				__update_wheel_from_color();
				forms_return_result(Id, Color);
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
/// @param {Struct.FORMS_Color} _color A instance of FORMS_Color
function FORMS_ColorPickerContent(_id, _color, _window)
	: FORMS_Content() constructor
{
	/// @var {String} The ID of the color input that opened the color picker
	/// widget.
	/// @readonly
	Id = _id;

	/// @var {Struct.FORMS_Color} The original color when opening the picker.
	/// @readonly
	OriginalColor = _color;

	/// @var {Struct.FORMS_Color} The current color.
	/// @readonly
	Color = new FORMS_Color(_color);
	
	/// @var {Struct.FORMS_Color} The new color.
	/// @readonly
	ColorNew = new FORMS_Color(_color);
	
	Hidden = false;

	PickerMode = "HSV";

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
	
	static __update_wheel_from_color = function() {
		var _hsva = Color.get_hsva();
		PickerHue = _hsva[0] * 360;
		PickerSaturation = _hsva[1] * 100;
		PickerValue = _hsva[2] * 100;
		PickerAlpha = _hsva[3];
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
			Color.set_from_hsva(PickerHue / 360, PickerSaturation / 100, PickerValue / 100, PickerAlpha);
			forms_return_result(Id, Color);
		}
		else 
		{
			PickerCursorSize = lerp(PickerCursorSize, 0.5, 0.25); // animate cursor
		}
		
		// Draw color wheel cursor
		var _colorWheelCursorX = round(_colorWheelX + _colorWheelRadius + lengthdir_x((PickerSaturation / 100) * (_colorWheelRadius - 2), PickerHue));
		var _colorWheelCursorY = round(_colorWheelY + _colorWheelRadius + lengthdir_y((PickerSaturation / 100) * (_colorWheelRadius - 2), PickerHue));
		draw_sprite_ext(FORMS_SprColorPickerCircle, 1, _colorWheelCursorX, _colorWheelCursorY, PickerCursorSize, PickerCursorSize, 0, Color.get(), 1);
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
			Color.set_from_hsva(PickerHue / 360, PickerSaturation / 100, PickerValue / 100, PickerAlpha);
			forms_return_result(Id, Color);
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
		
		switch (PickerMode) 
		{
			
			case "RGB":
			
				var _red = Color.__red * 255;
				Pen.text("Red").next();
				if (Pen.slider("slider-red", _red, 0, 255, { Integers: true }))
				{
					_red = Pen.get_result();
				}
				Pen.next();

				var _green = Color.__green * 255;
				Pen.text("Green").next();
				if (Pen.slider("slider-green", _green, 0, 255, { Integers: true }))
				{
					_green = Pen.get_result();
				}
				Pen.next();

				var _blue = Color.__blue * 255;
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
				
				ColorNew.set_from_rgba(_red / 255, _green / 255, _blue / 255, PickerAlpha);

				if (!ColorNew.equal_to(Color))
				{
					Color.set(ColorNew);
					forms_return_result(Id, Color);
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
				
				ColorNew.set_from_hsva(PickerHue / 360, PickerSaturation / 100, PickerValue / 100, PickerAlpha);

				if (!ColorNew.equal_to(Color))
				{
					Color.set(ColorNew);
					forms_return_result(Id, ColorNew);
				}
				
			break;
			
			case "HEX":
				Pen.text("Hex").next();
				if (Pen.input("slider-hex", Color.toString()))
				{
					var _hex = Pen.get_result();
					var _valid_hex = ColorNew.set_from_hex(_hex);
					if (!ColorNew.equal_to(Color))
					{
						Color.set(ColorNew);
						forms_return_result(Id, Color);
						__update_wheel_from_color();
					}
				}
				Pen.next();
				
				Pen.nl(2);
				
				Pen.text("Alpha").next();
				if (Pen.slider("slider-alpha", PickerAlpha, 0.0, 1.0))
				{
					PickerAlpha = Pen.get_result();
					ColorNew.set_from_hsva(PickerHue / 360, PickerSaturation / 100, PickerValue / 100, PickerAlpha);
					if (!ColorNew.equal_to(Color))
					{
						Color.set(ColorNew);
						forms_return_result(Id, Color);
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
			forms_return_result(Id, OriginalColor);
		}

		Pen.finish();
		Width = Pen.get_max_x();
		Height = Pen.get_max_y();

		return self;
	};
	
	
}
