/// @func FORMS_ColorPickerProps()
///
/// @extends FORMS_WindowProps
///
/// @desc
function FORMS_ColorPickerProps()
	: FORMS_WindowProps() constructor
{
}

/// @func FORMS_ColorPicker(_id, _color[, _props])
///
/// @extends FORMS_Window
///
/// @desc
///
/// @param {String} _id
/// @param {Real} _color ABGR encoded color.
/// @param {Struct.FORMS_ColorPickerProps, Undefined} [_props]
function FORMS_ColorPicker(_id, _color, _props=undefined)
	: FORMS_Window(undefined, _props) constructor
{
	{
		Closable = false;
		Resizable = false;
		set_widget(new FORMS_ScrollPane(new FORMS_ColorPickerContent(_id, _color), {
			Name: "Color Picker",
			Width: "100%",
			Height: "100%",
		}));
	}
}

/// @func FORMS_ColorPickerContent(_id, _color)
///
/// @extends FORMS_Content
///
/// @desc
///
/// @param {String} _id
/// @param {Real} _color ABGR encoded color.
function FORMS_ColorPickerContent(_id, _color)
	: FORMS_Content() constructor
{
	/// @var {String}
	/// @readonly
	Id = _id;

	/// @var {Real}
	/// @readonly
	Color = _color;

	/// @var {Real}
	/// @readonly
	ColorNew = _color;

	static draw = function ()
	{
		Pen.start(FORMS_EPenLayout.Column2);

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

		var _alpha = ((ColorNew >> 24) & 0xFF) / 255.0;
		Pen.text("Alpha").next();
		if (Pen.slider("slider-alpha", _alpha, 0.0, 1.0))
		{
			_alpha = Pen.get_result();
		}
		Pen.next();

		var _window = Container.Parent.Parent;
		var _buttonWidth = Pen.get_control_width() - 8 / 2;
		if (Pen.button("OK", { Width: _buttonWidth }))
		{
			_window.remove_self().destroy_later();
		}
		Pen.move(8);
		if (Pen.button("Cancel", { Width: _buttonWidth }))
		{
			_window.remove_self().destroy_later();
			forms_return_result(Id, Color);
		}
		Pen.nl();

		var _colorNew = _red | (_green << 8) | (_blue << 16) | ((_alpha * 255.0 ) << 24);
		if (ColorNew != _colorNew)
		{
			ColorNew = _colorNew;
			forms_return_result(Id, ColorNew);
		}

		Pen.finish();
		Width = Pen.get_max_x();
		Height = Pen.get_max_y();

		return self;
	};
}
