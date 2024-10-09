function TestStatusBar(): FORMS_Container() constructor
{
	Width.from_string("100%");
	Height.Value = 32;

	static draw_content = function ()
	{
		Pen.start()
		Pen.text("Mouse X: ").input("input-mouse-x", window_mouse_get_x(), { Disabled: true, Width: 100 });
		Pen.text(" Y: ").input("input-mouse-y", window_mouse_get_y(), { Disabled: true, Width: 100 });
		Pen.finish();
		FORMS_CONTENT_UPDATE_SIZE;
		return self;
	}
}
