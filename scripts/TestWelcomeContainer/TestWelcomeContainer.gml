function TestWelcomeContainer(): FORMS_Container() constructor
{
	Name = "Welcome";
	BackgroundColor = 0x272727;
	Width.from_string("100%");
	Height.from_string("100%");

	static draw_content = function ()
	{
		Pen.start()
			.text($"Welcome to Forms {FORMS_VERSION_STRING}!").nl(2)
			.text("Forms is a UI library for creating applications in GameMaker!")
			.finish();
		FORMS_CONTENT_UPDATE_SIZE;
		return self;
	}
}
