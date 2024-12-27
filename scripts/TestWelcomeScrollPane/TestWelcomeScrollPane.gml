function TestWelcomeScrollPane(): FORMS_ScrollPane() constructor
{
	Name = "Welcome";
	Icon = FA_ESolid.CircleInfo;
	Width.from_string("100%");
	Height.from_string("100%");
	ContentFit = true;

	static draw_content = function ()
	{
		Pen.start()
			.text($"Welcome to Forms {FORMS_VERSION_STRING}!").nl(2)
			.text("Forms is a UI library for creating applications in GameMaker!").nl()
			.finish();
		FORMS_CONTENT_UPDATE_SIZE;
		return self;
	}
}
