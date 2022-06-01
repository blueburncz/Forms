function FORMS_Question() {}

/// @func forms_question_create(title, text, buttons[, closeable])
/// @param {string} title The question title.
/// @param {string} text The question text.
/// @param {array} buttons Array of buttons in form `[[text, action], ...]`.
/// Use `noone` for no action.
/// @param {bool} [closeable] If `true`, then the question can be closed without
/// selecting an answer. Defaults to `false.`
/// @return {real} The id of the created question widget.
function forms_question_create(title, text, buttons)
{
	var _question = forms_window_create(title);
	_question[? "type"] = FORMS_Question;
	forms_window_set_content(_question, forms_cnt_question);
	_question[? "text"] = text;
	_question[? "buttons"] = buttons;
	_question[? "closeable"] = (argument_count > 3) ? argument[3] : false;
	_question[? "resizable"] = false;
	_question[? "block_input"] = true;
	forms_window_fit_content(_question);
	return _question;
}