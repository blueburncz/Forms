/// @func FORMS_QuestionProps()
///
/// @extends FORMS_WindowProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_Question}.
function FORMS_QuestionProps(): FORMS_WindowProps() constructor
{
	/// @var {String, Undefined} The title of the window or `undefined`.
	Title = undefined;

	/// @var {Array, Undefined} An array of button names or `undefined`.
	Buttons = undefined;
}

/// @func FORMS_Question(_text, _callback[, _props])
///
/// @extends FORMS_Window
///
/// @desc A question widget with default "OK" and "Cancel" buttons.
///
/// @param {String} _text The text to display inside of the question widget.
/// @param {Function} _callback A function to be executed when one of the buttons is clicked. The button text is passed
/// to it as the first argument.
/// @param {Struct.FORMS_QuestionProps, Undefined} [_props] Properties to create the question widget with or `undefined`
/// (default).
function FORMS_Question(_text, _callback, _props = undefined): FORMS_Window(undefined, _props) constructor
{
	/// @var {String} The title of the window. Defaults to "Confirm".
	/// @readonly
	Title = forms_get_prop(_props, "Title") ?? "Confirm";

	/// @var {String} The text displayed inside of the question widget.
	/// @readonly
	Text = _text;

	/// @var {Array<String>} An array of button names. Defaults to "OK" and "Cancel".
	/// @readonly
	Buttons = forms_get_prop(_props, "Buttons") ?? ["OK", "Cancel"];

	/// @var {Function} A function to be executed when one of the buttons is clicked. The button text is passed to it as
	/// the first argument.
	/// @readonly
	Callback = _callback;

	Center = true;

	Closable = false;

	AutoSize = true;

	Resizable = false;

	Blocking = true;

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
}
