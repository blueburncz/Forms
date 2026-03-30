/// @func FORMS_Style()
///
/// @desc A struct that defines colors, fonts, sprites, and sizes used by UI elements.
function FORMS_Style() constructor
{
	// ========================================
	// Accent & Interactive Colors
	// ========================================

	/// @var {Struct.FORMS_Color} The primary accent color. Used for selection indicators, checkmarks in checkboxes,
	/// radio button selections, input carets, text selection highlights, and active splitters. Default value is
	/// `0x5B9D00` ("GameMaker green").
	Accent = new FORMS_Color(0x5B9D00, 1.0);

	/// @var {Struct.FORMS_Color} The focus indicator color. Used for borders of focused inputs, buttons, and other
	/// interactive elements to indicate keyboard focus. Default value is `0x7AB800` (lighter green).
	Focus = new FORMS_Color(0x7AB800, 1.0);

	// ========================================
	// Text Colors
	// ========================================

	/// @var {Struct.FORMS_Color} The primary text color. Used for all standard text content, active tab labels,
	/// button text, and icon colors. Default value is `c_white`.
	Text = new FORMS_Color(c_white, 1.0);

	/// @var {Struct.FORMS_Color} The muted/secondary text color. Used for inactive tab labels, disabled icon states,
	/// placeholder text, dropdown carets, and other de-emphasized text. Default value is `c_gray`.
	TextMuted = new FORMS_Color(c_gray, 1.0);

	/// @var {Struct.FORMS_Color} The disabled text color. Used for text in disabled controls and non-interactive
	/// states. Default value is `c_gray`.
	TextDisabled = new FORMS_Color(c_gray, 1.0);

	/// @var {Struct.FORMS_Color} The link/clickable text color. Used for hyperlinks and interactive text elements.
	/// Default value is `0x5B9D00` (accent color).
	Link = new FORMS_Color(0x5B9D00, 1.0);

	/// @var {Struct.FORMS_Color} The error text color. Used for error messages and validation feedback. Default
	/// value is `0x4444DD` (red in BGR format).
	Error = new FORMS_Color(0x4444DD, 1.0);

	/// @var {Struct.FORMS_Color} The warning text color. Used for warning messages and cautionary feedback. Default
	/// value is `0x44AADD` (orange in BGR format).
	Warning = new FORMS_Color(0x44AADD, 1.0);

	/// @var {Struct.FORMS_Color} The success text color. Used for success messages and positive feedback. Default
	/// value is `0x44DD44` (green in BGR format).
	Success = new FORMS_Color(0x44DD44, 1.0);

	/// @var {Struct.FORMS_Color} The info text color. Used for informational messages and neutral feedback. Default
	/// value is `0xDDAAAA` (light blue in BGR format).
	Info = new FORMS_Color(0xDDAAAA, 1.0);

	// ========================================
	// Background Colors
	// ========================================

	/// @var {Array<Struct.FORMS_Color>} An array of background colors with increasing brightness, used to create
	/// visual depth and layering. Indexed from darkest (0) to lightest (5).
	/// - [0]: Darkest, used for application surface backgrounds and deepest layers
	/// - [1]: Base UI background for root widgets, docks, and main containers
	/// - [2]: Elevated surfaces like window content areas, scrollbar tracks, and context menu separators
	/// - [3]: Interactive element backgrounds like buttons, dropdowns, and splitters
	/// - [4]: Hover states for buttons, icons, dropdowns, and context menu options
	/// - [5]: Reserved for highest emphasis states
	Background = [
		new FORMS_Color(0x101010, 1.0), // Level 0 - Darkest
		new FORMS_Color(0x181818, 1.0), // Level 1 - Base
		new FORMS_Color(0x272727, 1.0), // Level 2 - Elevated
		new FORMS_Color(0x404040, 1.0), // Level 3 - Interactive
		new FORMS_Color(0x505050, 1.0), // Level 4 - Hover
		new FORMS_Color(0x606060, 1.0), // Level 5 - Highest
	];

	// ========================================
	// Scrollbar
	// ========================================

	/// @var {Struct.FORMS_Color} The default scrollbar thumb color. Default value is `0x4D4D4D` (medium gray).
	Scrollbar = new FORMS_Color(0x4D4D4D, 1.0);

	/// @var {Struct.FORMS_Color} The scrollbar thumb color when hovered. Default value is `0x575757` (slightly
	/// lighter gray).
	ScrollbarHover = new FORMS_Color(0x575757, 1.0);

	/// @var {Struct.FORMS_Color} The scrollbar thumb color when being dragged. Default value is `0x898989`
	/// (light gray).
	ScrollbarActive = new FORMS_Color(0x898989, 1.0);

	/// @var {Asset.GMSprite} The sprite used for scrollbar thumbs. Stretched to fit the scrollbar dimensions.
	/// Default value is `FORMS_SprRound4`.
	ScrollbarSprite = FORMS_SprRound4;

	/// @var {Real} The minimum size of scrollbar thumbs in pixels, ensuring they remain grabbable even for very
	/// large content. Default value is `32`.
	ScrollbarSizeMin = 32;

	// ========================================
	// Shadows & Overlays
	// ========================================

	/// @var {Struct.FORMS_Color} The shadow color used for drop shadows on windows, tooltips, context menus, and
	/// dropdowns. Default value is `c_black` with `0.58` alpha.
	Shadow = new FORMS_Color(c_black, 0.58);

	/// @var {Struct.FORMS_Color} The modal overlay color used when blocking windows are displayed. Default value is
	/// `c_black` with `0.25` alpha.
	ModalOverlay = new FORMS_Color(c_black, 0.25);

	// ========================================
	// Tooltips
	// ========================================

	/// @var {Struct.FORMS_Color} The tooltip background color. Default value is `0xB3DCE9` (light blue).
	Tooltip = new FORMS_Color(0xB3DCE9, 1.0);

	/// @var {Struct.FORMS_Color} The tooltip text color. Default value is `c_black`.
	TooltipText = new FORMS_Color(c_black, 1.0);

	/// @var {Asset.GMSprite} The sprite used for tooltip backgrounds. Stretched to fit the tooltip dimensions.
	/// Default value is `FORMS_SprRound4`.
	TooltipSprite = FORMS_SprRound4;

	// ========================================
	// Selection & Borders
	// ========================================

	/// @var {Struct.FORMS_Color} The highlight/selection color. Used for selected items in tree views, dropdowns,
	/// and other list-based controls. Default value is `0x766056` (brownish gray).
	Highlight = new FORMS_Color(0x766056, 1.0);

	/// @var {Struct.FORMS_Color} The border color. Used for borders on focused inputs, checkbox borders on hover,
	/// and radio button borders. Default value is `0x9D9D9D` (light gray).
	Border = new FORMS_Color(0x9D9D9D, 1.0);

	// ========================================
	// Spacing & Layout
	// ========================================

	/// @var {Real} The size of dock splitters in pixels. Default value is `6`.
	SplitterSize = 6;

	/// @var {Real} The standard padding size for UI elements in pixels. Used for consistent spacing throughout the
	/// interface. Default value is `8`.
	Padding = 8;

	/// @var {Real} The standard spacing between UI elements in pixels. Default value is `4`.
	Spacing = 4;

	// ========================================
	// Floating Toolbar
	// ========================================

	/// @var {Struct.FORMS_Color} The background color of floating toolbars. Default value is near-black.
	FloatingToolbarBackground = new FORMS_Color(0x0A0A0A, 1.0);

	/// @var {Real} The background alpha of floating toolbars (0 = fully transparent, 1 = opaque). Default value is `0.75`.
	FloatingToolbarAlpha = 0.75;

	// ========================================
	// Typography
	// ========================================

	/// @var {Asset.GMFont} The default font for all text rendering. Used by pens and text elements unless overridden.
	/// Default value is `FORMS_FntNormal`.
	Font = FORMS_FntNormal;

	/// @var {Asset.GMFont} The heading font for titles and emphasized text. Default value is `FORMS_FntNormal`.
	FontHeading = FORMS_FntNormal;

	/// @var {Asset.GMFont} The monospace font for code and fixed-width text. Default value is `FORMS_FntNormal`.
	FontMonospace = FORMS_FntNormal;
}
