// TODO: Move to FORMS
if (FORMS_WidgetExists(FORMS_CONTEXT_MENU))
{
	FORMS_DestroyWidget(FORMS_CONTEXT_MENU);
	FORMS_CONTEXT_MENU = undefined;
}
