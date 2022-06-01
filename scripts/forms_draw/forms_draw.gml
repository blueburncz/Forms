function forms_widget_get_pos_total(_widget)
{
	var _x = 0;
	var _y = 0;
	while (_widget != noone)
	{
		_x += forms_widget_get_x(_widget);
		_y += forms_widget_get_y(_widget);
		_widget = forms_widget_get_delegate(_widget);
	}
	return [_x, _y];
}

function forms_get_draw_position_absolute(_x, _y)
{
	var _position = forms_widget_get_pos_total(forms_widget_filling);
	var _scrollbar_hor = forms_widget_filling[? "scrollbar_hor"];
	var _scrollbar_ver = forms_widget_filling[? "scrollbar_ver"];
	if (_scrollbar_hor != undefined)
	{
		if (forms_scrollbar_is_visible(_scrollbar_hor))
		{
			_x -= forms_scrollbar_get_scroll(_scrollbar_hor);
		}
		if (forms_scrollbar_is_visible(_scrollbar_ver))
		{
			_y -= forms_scrollbar_get_scroll(_scrollbar_ver);
		}
	}
	return [_position[0] + _x, _position[1] + _y];
}

/// @func forms_color_minibox(_pen, _argb)
/// @param {FORMS_EPen} _pen
/// @param {int} _argb
/// @param {struct} [_props]
/// @return {bool}
function forms_color_minibox(_pen, _argb)
{
	var _props = (argument_count > 2) ? argument[2] : {};
	var _id = ce_struct_get(_props, "id", forms_make_id());

	var _x = forms_pen_get_x(_pen);
	var _y = forms_pen_get_y(_pen);
	var _width = sprite_get_width(FORMS_SprColorInput);
	var _height = sprite_get_height(FORMS_SprColorInput);
	var _mouse_over = forms_mouse_over_rectangle(_x, _y, _width, _height, _id);
	var _color = ce_color_from_argb(_argb);
	var _alpha = ce_color_argb_to_alpha(_argb);
	var _y_inline = forms_pen_get_y_inline(_pen, _height);

	draw_sprite(FORMS_SprColorInput, 0, _x, _y_inline);
	draw_sprite_ext(FORMS_SprColorInput, 1, _x, _y_inline, 1, 1, 0, _color, _alpha);
	draw_sprite(FORMS_SprColorInput, 2, _x, _y_inline);

	if (ce_struct_get(_props, "selected", false))
	{
		draw_sprite(FORMS_SprColorInput, 3, _x, _y_inline);
	}

	forms_pen_move(_pen, _width);

	if (_mouse_over)
	{
		if (mouse_check_button_pressed(mb_left))
		{
			forms_steal_mouse_input(_id);
		}
		forms_tooltip_str = ce_struct_get(_props, "tooltip", "");
	}

	return (forms_mouse_lost_input == _id);
}

/// @func forms_draw_color_input(_pen, _argb, _id)
/// @desc Draws a color input.
/// @param {array} _pen A Pen structure. 
/// @param {real} _argb The current ARGB color.
/// @param {string} _id A unique identifier of this color input.
/// @return {bool} True if the color has changed. The new color can be read from
/// `FORMS_VALUE`.
/// @see FORMS_EPen
/// @see FORMS_VALUE
function forms_draw_color_input(_pen, _argb, _id)
{
	var _container = forms_widget_filling;

	if (!forms_widget_exists(forms_color_picker))
	{
		forms_color_picker = noone;
	}

	if (forms_color_minibox(_pen, _argb))
	{
		var _is_noone = (forms_color_picker == noone);
		if (_is_noone)
		{
			forms_color_picker = forms_window_create("Color Picker");
			forms_color_picker[? "resizable"] = false;

			forms_widget_set_position(forms_color_picker,
				round((forms_window_width- forms_widget_get_width(forms_color_picker)) * 0.5),
				round((forms_window_height - forms_widget_get_height(forms_color_picker)) * 0.5));
			forms_window_set_content(forms_color_picker, forms_cnt_color_picker);
			forms_show_window(forms_color_picker);
		}

		forms_color_picker_target = _id;

		var _color_picker_container = forms_window_get_container(forms_color_picker);
		_color_picker_container[? "argb"] = _argb;
		_color_picker_container[? "argb_original"] = _argb;
		_color_picker_container[? "redraw_container"] = _container;

		if (_is_noone)
		{
			forms_window_fit_content(forms_color_picker);
		}

		forms_request_redraw(_color_picker_container);
	}

	if (forms_color_picker != noone && forms_color_picker_target == _id)
	{
		var _color_picker_container = forms_window_get_container(forms_color_picker);
		var _picker_argb = _color_picker_container[? "argb"];

		if (_argb != _picker_argb)
		{
			FORMS_VALUE = _picker_argb;
			return true;
		}
	}

	return false;
}

/// @func forms_draw_shadow(_x, _y, _width, _height)
/// @desc Draws a shadow.
/// @param {real} _x The x position of the shadow.
/// @param {real} _y The y position of the shadow.
/// @param {real} _width The width of the shadow.
/// @param {real} _height The height of the shadow.
function forms_draw_shadow(_x, _y, _width, _height)
{
	gml_pragma("forceinline");
	ce_draw_sprite_nine_slice(FORMS_SprShadow, 0, _x, _y, _width + 4, _height + 4, false, c_black);
}

/// @func forms_draw_sprite(_sprite, _subimg, _x, _y[, _color])
/// @desc Draws a clickable sprite at the given position.
/// @param {real} _sprite The id of the sprite.
/// @param {real} _subimg The subimage of the sprite.
/// @param {real} _x The x position to draw the sprite at.
/// @param {real} _y The y position to draw the sprite at.
/// @param {real} [_color] The color to blend the sprite with.
/// @return {bool} True if the sprite is clicked.
function forms_draw_sprite(_sprite, _subimg, _x, _y)
{
	var _color = (argument_count > 4) ? argument[4] : c_white;
	var _width = sprite_get_width(_sprite);
	var _height = sprite_get_height(_sprite);
	var _mouse_over = forms_mouse_over_rectangle(_x, _y, _width, _height);
	draw_sprite_ext(_sprite, _subimg, _x, _y, 1, 1, 0, _color, 1);
	return (_mouse_over && mouse_check_button_pressed(mb_left));
}

function forms_draw_rectangle_color(_x, _y, _width, _height, _argb0, _argb1, _argb2, _argb3)
{
	var _c0 = ce_color_from_argb(_argb0);
	var _c1 = ce_color_from_argb(_argb1);
	var _c2 = ce_color_from_argb(_argb2);
	var _c3 = ce_color_from_argb(_argb3);
	var _a0 = ce_color_argb_to_alpha(_argb0);
	var _a1 = ce_color_argb_to_alpha(_argb1);
	var _a2 = ce_color_argb_to_alpha(_argb2);
	var _a3 = ce_color_argb_to_alpha(_argb3);
	shader_set(FORMS_ShRectangleColor);
	shader_set_uniform_f(shader_get_uniform(FORMS_ShRectangleColor, "u_vTopLeft"),
		color_get_red(_c0) / 255,
		color_get_green(_c0) / 255,
		color_get_blue(_c0) / 255,
		_a0);
	shader_set_uniform_f(shader_get_uniform(FORMS_ShRectangleColor, "u_vTopRight"),
		color_get_red(_c1) / 255,
		color_get_green(_c1) / 255,
		color_get_blue(_c1) / 255,
		_a1);
	shader_set_uniform_f(shader_get_uniform(FORMS_ShRectangleColor, "u_vBottomRight"),
		color_get_red(_c2) / 255,
		color_get_green(_c2) / 255,
		color_get_blue(_c2) / 255,
		_a2);
	shader_set_uniform_f(shader_get_uniform(FORMS_ShRectangleColor, "u_vBottomLeft"),
		color_get_red(_c3) / 255,
		color_get_green(_c3) / 255,
		color_get_blue(_c3) / 255,
		_a3);
	draw_sprite_stretched(FORMS_SprTexture, 0, _x, _y, _width, _height);
	shader_reset();
}

vertex_format_begin();
vertex_format_add_position();
vertex_format_add_color();
vertex_format_add_texcoord();
global.__forms_vformat_checkerboard = vertex_format_end();

function forms_draw_checkerboard(_x, _y, _width, _height)
{
	static _spr_size = sprite_get_width(FORMS_SprCheckerboard);
	var _repx = _width / _spr_size;
	var _repy = _height / _spr_size;

	var _vbuff = vertex_create_buffer();
	vertex_begin(_vbuff, global.__forms_vformat_checkerboard);

	vertex_position(_vbuff, _x, _y);
	vertex_color(_vbuff, c_white, 1);
	vertex_texcoord(_vbuff, 0, 0);

	vertex_position(_vbuff, _x + _width, _y);
	vertex_color(_vbuff, c_white, 1);
	vertex_texcoord(_vbuff, _repx, 0);

	vertex_position(_vbuff, _x, _y + _height);
	vertex_color(_vbuff, c_white, 1);
	vertex_texcoord(_vbuff, 0, _repy);

	vertex_position(_vbuff, _x + _width, _y + _height);
	vertex_color(_vbuff, c_white, 1);
	vertex_texcoord(_vbuff, _repx, _repy);

	vertex_end(_vbuff);

	gpu_push_state();
	gpu_set_texrepeat(true);
	vertex_submit(_vbuff, pr_trianglestrip, sprite_get_texture(FORMS_SprCheckerboard, 0));
	gpu_pop_state();

	vertex_delete_buffer(_vbuff);
}