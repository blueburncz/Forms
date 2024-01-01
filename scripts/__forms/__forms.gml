/// @func forms_assert(_expr, _message)
///
/// @desc
///
/// @param {Bool} _expr
/// @param {String} _message
function forms_assert(_expr, _message)
{
	gml_pragma("forceinline");
	if (!_expr)
	{
		show_error(_message, true);
	}
}
