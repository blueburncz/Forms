/// @func FORMS_QuestionProps()
///
/// @extends FORMS_WindowProps
///
/// @desc TODO
function FORMS_QuestionProps(): FORMS_WindowProps() constructor
{
	/// @var {String, Undefined}
	Title = undefined;

	/// @var {Array, Undefined}
	Buttons = undefined;
}

/// @func FORMS_Question(_text, _callback[, _props])
///
/// @extends FORMS_Window
///
/// @desc TODO
///
/// @param {String} _text TODO
/// @param {Function} _callback TODO
/// @param {Struct.FORMS_QuestionProps, Undefined} _props TODO
function FORMS_Question(_text, _callback, _props = undefined): FORMS_Window(undefined, _props) constructor
{
	static Window_layout = layout;
	static Window_draw = draw;

	/// @var {String}
	/// @readonly
	Title = forms_get_prop(_props, "Title") ?? "Confirm";

	/// @var {String}
	/// @readonly
	Text = _text;

	/// @var {Array<String>} TODO
	/// @readonly
	Buttons = forms_get_prop(_props, "Buttons") ?? ["OK", "Cancel"];

	/// @var {Function} TODO
	/// @readonly
	Callback = _callback;

	Center = true;

	Closable = false;

	AutoSize = true;

	Resizable = false;

	set_widget(new(function (_title): FORMS_Container() constructor
	{
		Name = _title;
		Icon = FA_ESolid.CircleQuestion;
		ContentFit = true;

		static draw_content = function ()
		{
			Pen.start();
			Pen.text(Parent.Text).nl();
			var _index = 0;
			repeat(array_length(Parent.Buttons))
			{
				var _buttonText = Parent.Buttons[_index++];
				if (Pen.button(_buttonText))
				{
					Parent.Callback(_buttonText);
					Parent.destroy_later();
				}
				Pen.move(4);
			}
			Pen.nl();
			Pen.finish();
			FORMS_CONTENT_UPDATE_SIZE;
			return self;
		}
	})(Title));

	static layout = function ()
	{
		forms_get_root().WidgetHovered = undefined;
		Window_layout();
		return self;
	}

	static draw = function ()
	{
		with(forms_get_root())
		{
			forms_draw_rectangle(__realX, __realY, __realWidth, __realHeight, c_black, 0.25);
		}
		Window_draw();
		return self;
	}
}
