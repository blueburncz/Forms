/// @func forms_file_input(_pen, _width, _path)
/// @param {array} _pen
/// @param {real} _width
/// @param {string} _path
/// @return {bool}
function forms_file_input(_pen, _width, _path)
{
	var _props = (argument_count > 3) ? argument[3] : {};
	forms_input(_pen, _width, _path, { disabled: true });
	if (forms_icon_button(_pen, FORMS_EIcon.FolderOpen, _props))
	{
		FORMS_VALUE = get_open_filename(
			ce_struct_get(_props, "filter", ""),
			ce_struct_get(_props, "fname", ""));
		return true;
	}
	return false;
}

/// @func forms_file_output(_pen, _width, _path)
/// @param {array} _pen
/// @param {real} _width
/// @param {string} _path
/// @return {bool}
function forms_file_output(_pen, _width, _path)
{
	var _props = (argument_count > 3) ? argument[3] : {};
	forms_input(_pen, _width, _path, { disabled: true });
	if (forms_icon_button(_pen, FORMS_EIcon.FolderOpen, _props))
	{
		FORMS_VALUE = get_save_filename(
			ce_struct_get(_props, "filter", ""),
			ce_struct_get(_props, "fname", ""));
		return true;
	}
	return false;
}