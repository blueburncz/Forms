// In case application surface is resized, adapt the currently active camera to
// match to avoid squash and pull

var _width = surface_get_width(application_surface);
var _height = surface_get_height(application_surface);

camera_set_view_size(camera_get_active(), _width, _height);

// Apply the changes to the viewport
camera_apply(camera_get_active());

// Draw anything here
draw_sprite(SprSponzaBBMOD, 0, 0, 0);
