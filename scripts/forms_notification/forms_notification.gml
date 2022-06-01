function FORMS_Notification() {}

function forms_notification_create()
{
	var _notification = forms_canvas_create(FORMS_Notification);
	_notification[? "title"] = "";
	_notification[? "text"] = "";
	_notification[? "progress_text"] = "";
	_notification[? "closeable"] = true;
	_notification[? "progress"] = undefined;
	_notification[? "progress_max"] = undefined;
	_notification[? "scr_draw"] = forms_notification_draw;
	_notification[? "duration"] = undefined;
	forms_widget_set_depth(_notification, $FFFFFC);
	return _notification;
}

function forms_notification_draw(_notification)
{
	if (forms_begin_fill(_notification))
	{
		var _pen = forms_pen_create(8, 8);
		var _title = _notification[? "title"];
		var _text = _notification[? "text"];
		var _progress_text = _notification[? "progress_text"];
		var _progress = _notification[? "progress"];
		var _progress_max = _notification[? "progress_max"];

		if (_title != "")
		{
			forms_draw_text_bold(_pen, _title);
			forms_pen_newline(_pen);
		}

		if (_text != "")
		{
			forms_draw_text(_pen, _text);
			forms_pen_newline(_pen);
		}

		if (_progress != undefined)
		{
			if (_progress_max != undefined)
			{
				forms_progressbar(_pen, _progress, _progress_max, { text: _progress_text });
				forms_pen_newline(_pen);
			}
		}

		var _size = forms_pen_get_max_coordinates(_pen);
		ce_vec2_add(_size, [8, 8]);
		forms_widget_set_size(_notification, _size[0], _size[1]);

		forms_end_fill(_notification);
	}

	var _x = forms_widget_get_x(_notification);
	var _y = forms_widget_get_y(_notification);
	var _width = forms_widget_get_width(_notification);
	var _height = forms_widget_get_height(_notification);

	forms_draw_shadow(_x, _y, _width, _height);
	ce_draw_rectangle(_x - 1, _y - 1, _width + 2, _height + 2, $3E3E3E, 1);
	forms_canvas_draw(_notification);

	if (_notification[? "duration"] != undefined)
	{
		_notification[? "duration"] -= delta_time * 0.001;
		if (_notification[? "duration"] <= 0)
		{
			forms_widget_destroy(_notification);
		}
	}
}