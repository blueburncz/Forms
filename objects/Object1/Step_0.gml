var _windowWidth = max(window_get_width(), 1);
var _windowHeight = max(window_get_height(), 1);

guiMenu.SetWidth(_windowWidth);
guiDock.SetRectangle(0, guiMenu.Height, _windowWidth, _windowHeight - guiMenu.Height);

FORMS_Update();
