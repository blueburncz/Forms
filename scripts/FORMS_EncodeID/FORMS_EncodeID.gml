/// @func FORMS_EncodeID(_parent, _number)
///
/// @desc Makes an ID for a dynamic widget.
///
/// @param {Struct.FORMS_Widget} _parent The parent widget.
/// @param {Real} _number The unique number of the dynamic widget.
///
/// @return {Real} The created ID.
function FORMS_EncodeID(_parent, _number)
{
	gml_pragma("forceinline");
	return ((_parent.Id + 1) * 100000 + _number);
}
