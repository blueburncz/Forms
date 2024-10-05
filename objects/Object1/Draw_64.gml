//draw_text(0, 0, gui.WidgetHovered);
/*
shader_set(FORMS_ShColorWheel);
var _uniform = shader_get_uniform(FORMS_ShColorWheel, "u_Position");
shader_set_uniform_f(_uniform, mouse_x, mouse_y);

var _xx = 500;
var _yy = 400;
var _size = 200;
var _radius = _size / 2;

draw_primitive_begin(pr_trianglestrip);
	draw_vertex_texture(_xx, _yy, 0, 0);
	draw_vertex_texture(_xx+_size, _yy, 1, 0);
	draw_vertex_texture(_xx, _yy+_size, 0, 1);
	draw_vertex_texture(_xx+_size, _yy+_size, 1, 1);
draw_primitive_end()
shader_reset();

if (mouse_check_button(mb_left)) {
	cx = mouse_x;
	cy = mouse_y;
}

var _c_dir = point_direction(_xx + _radius, _yy + _radius, cx, cy);
var _c_dist = point_distance(_xx + _radius, _yy + _radius, cx, cy);
_c_dist = clamp(_c_dist, 0, _radius-2);

var _hue = (_c_dir / 360) * 255;
var _sat = (_c_dist / _radius) * 255;
var _val = 255;

var _col = make_color_hsv(_hue, _sat, _val);
var _hex = color_get_hex(_col);
var _col2 = hex_to_color("0x"+_hex);

draw_circle_color(_xx + _size + 100, _yy + 20, 20, _col, _col, false);
draw_text(_xx + _size + 140, _yy, _col);
draw_text(_xx + _size + 280, _yy, _col2);
draw_text(_xx + _size + 140, _yy+20, "hex: "+_hex);
draw_text(_xx + _size + 140, _yy+30, "r: "+string(color_get_red(_col)));
draw_text(_xx + _size + 140, _yy+40, "g: "+string(color_get_green(_col)));
draw_text(_xx + _size + 140, _yy+50, "b: "+string(color_get_blue(_col)));



/*
_col = draw_getpixel(_xx + _radius + lengthdir_x(_c_dist, _c_dir), _yy + _radius + lengthdir_y(_c_dist, _c_dir));
draw_circle_color(_xx + _size + 100, _yy + 70, 20, _col, _col, false);
draw_text(_xx + _size + 140, _yy + 50, _col);
var _hex = color_get_hex(_col);
draw_text(_xx + _size + 140, _yy+70, "hex: "+_hex);*/



//draw_circle_color(_xx + _radius + lengthdir_x(_c_dist, _c_dir), _yy + _radius + lengthdir_y(_c_dist, _c_dir), 10, c_white, c_white, true);