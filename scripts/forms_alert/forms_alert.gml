function FORMS_Alert() {}

//// @func forms_alert_create(title, text[, ok_action[, cancel_action]])
/// @param {string} title The alert title.
/// @param {string} text The alert text.
/// @param {real} [ok_action] The script executed when the alert is closed with
/// an "ok" button. Use noone for no action. Defaults to noone.
/// @param {real} [cancel_action] The script executed when the alert is closed with
/// a "cancel" button. Use noone for no action. Defaults to noone.
/// @return {real} The id of the created alert.
function forms_alert_create(title, text)
{
	var _alert = forms_question_create(title, text, [
		["Ok", (argument_count > 2) ? argument[2] : noone],
		["Cancel", (argument_count > 3) ? argument[3] : noone]
	], false);
	_alert[? "type"] = FORMS_Alert;
	return _alert;
}