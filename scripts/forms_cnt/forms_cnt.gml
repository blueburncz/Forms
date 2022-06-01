/// @func forms_cnt_color_picker(_container)
/// @desc Draws the content of a Color Picker to the container.
/// @param {real} _container The id of the container.
/// @return {array} The content size.
function forms_cnt_color_picker(_container)
{
	var _changed = false;
	var _pen = forms_pen_create(8, 8);

	var _argb_backup = _container[? "argb"];
	var _argb_original = _container[? "argb_original"];
	if (forms_draw_color_mix(_pen, _argb_backup, _argb_original))
	{
		_container[? "argb"] = FORMS_VALUE;
		_changed = true;
	}

	if (_changed && ds_map_exists(_container, "redraw_container"))
	{
		forms_request_redraw(_container[? "redraw_container"]);
	}

	var _content_size = forms_pen_get_max_coordinates(_pen);
	ce_vec2_add(_content_size, ce_vec2_create(8, 6));
	return _content_size;
}

/// @func forms_cnt_question(_container)
/// @desc Draws content of a question.
/// @param {real} _container The id of the container.
/// @return {array} The content size.
function forms_cnt_question(_container)
{
	var _delegate = forms_widget_get_delegate(_container);
	var _spacing = 8;
	var _pen = forms_pen_create(_spacing, _spacing);
	//forms_pen_set_margin(_pen, _spacing);
	var _text = _delegate[? "text"];
	var _buttons = _delegate[? "buttons"];
	var _button_count = array_length(_buttons);

	// Text
	forms_draw_text(_pen, _text);
	forms_pen_set_x(_pen, _spacing);
	forms_pen_move(_pen, 0, string_height(_text) + _spacing);

	// Buttons
	forms_pen_set_marginh(_pen, _spacing);

	var i = 0;
	repeat (_button_count)
	{
		var _btn = _buttons[i++];
		if (forms_button(_pen, _btn[0]))
		{
			var _action = _btn[1];
			if (_action != noone)
			{
				_action();
			}
			forms_widget_destroy(_delegate);
		}
	}

	forms_pen_newline(_pen);

	var _content_size = forms_pen_get_max_coordinates(_pen);
	ce_vec2_add(_content_size, [_spacing, _spacing]);
	return _content_size;
}