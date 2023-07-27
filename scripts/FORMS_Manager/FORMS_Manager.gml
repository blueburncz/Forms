/// @func FORMS_Manager()
///
/// @extends FORMS_CompoundWidget()
function FORMS_Manager()
	: FORMS_CompoundWidget() constructor
{
	static Type = FORMS_EWidgetType.Manager;

	static OnUpdate = function ()
	{
		FORMS_ManagerUpdate(self);
	};

	static OnDraw = function ()
	{
		FORMS_ManagerDraw(self);
	};
}

/// @func FORMS_ManagerUpdate(_manager)
///
/// @param {Struct.FORMS_Manager} _manager
function FORMS_ManagerUpdate(_manager)
{
}

/// @func FORMS_ManagerDraw(_manager)
///
/// @param {Struct.FORMS_Manager} _manager
function FORMS_ManagerDraw(_manager)
{
}
