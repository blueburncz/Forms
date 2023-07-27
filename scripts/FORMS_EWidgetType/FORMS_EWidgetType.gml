/// @enum Enumeration of widget types.
enum FORMS_EWidgetType
{
	/// @member A black widget. Used in the base widget struct.
	Blank,
	/// @member A widget with child widgets.
	Compound,
	/// @member A compound widget with surface.
	Canvas,
	/// @member A dock widget.
	Dock,
	/// @member A viewport widget.
	Viewport,
	/// @member A canvas widget with a content script.
	Container,
	/// @member A scrollbar widget.
	Scrollbar,
	/// @member A toolbar widget.
	Toolbar,
	/// @member A toolbar button widget.
	ToolbarButton,
	/// @member A toolbar switch widget.
	ToolbarSwitch,
	/// @member A widget with titlebar and scrollable content.
	Panel,
	/// @member A floating window widget.
	Window,
	/// @member A context menu widget.
	ContextMenu,
	/// @member An item in a context menu.
	ContextMenuItem,
	/// @member A menu bar widget.
	MenuBar,
	/// @member An item in a menu bar.
	MenuBarItem,
	/// @member A manager of all widgets.
	Manager,
	/// @member Total number of members of this enum.
	SIZE
};
