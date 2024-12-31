/// @func FORMS_Style()
///
/// @desc A struct that defines colors, fonts and sizes used by UI elements.
function FORMS_Style() constructor
{
	/// @var {Struct.FORMS_Color} The accent color. Used for example as color of the tick icon in selected checkboxes or
	/// the circle icon in selected radio buttons. Default value is `0x5B9D00` ("GameMaker green").
	Accent = new FORMS_Color(0x5B9D00, 1.0);

	/// @var {Asset.GMFont} TODO: Add docs
	Font = FORMS_FntNormal;

	/// @var {Struct.FORMS_Color} TODO: Add docs
	Text = new FORMS_Color(c_white, 1.0);

	/// @var {Struct.FORMS_Color} TODO: Add docs
	TextMuted = new FORMS_Color(c_gray, 1.0);

	/// @var {Struct.FORMS_Color} TODO: Add docs
	TextDisabled = new FORMS_Color(c_gray, 1.0);

	/// @var {Array<Struct.FORMS_Color>} TODO: Add docs
	Background = [
		new FORMS_Color(0x101010, 1.0),
		new FORMS_Color(0x181818, 1.0),
		new FORMS_Color(0x272727, 1.0),
		new FORMS_Color(0x404040, 1.0),
		new FORMS_Color(0x505050, 1.0),
		new FORMS_Color(0x606060, 1.0),
	];

	/// @var {Struct.FORMS_Color} TODO: Add docs
	Scrollbar = new FORMS_Color(0x4D4D4D, 1.0);

	/// @var {Struct.FORMS_Color} TODO: Add docs
	ScrollbarHover = new FORMS_Color(0x575757, 1.0);

	/// @var {Struct.FORMS_Color} TODO: Add docs
	ScrollbarActive = new FORMS_Color(0x898989, 1.0);

	/// @var {Asset.GMSprite} TODO: Add docs
	ScrollbarSprite = FORMS_SprRound4;

	/// @var {Real} TODO: Use & add docs
	ScrollbarSizeMin = 32;

	/// @var {Struct.FORMS_Color} TODO: Add docs
	Shadow = new FORMS_Color(c_black, 0.58);

	/// @var {Struct.FORMS_Color} TODO: Add docs
	Tooltip = new FORMS_Color(0xB3DCE9, 1.0);

	/// @var {Struct.FORMS_Color} TODO: Add docs
	TooltipText = new FORMS_Color(c_black, 1.0);

	/// @var {Asset.GMSprite} TODO: Add docs
	TooltipSprite = FORMS_SprRound4;

	/// @var {Struct.FORMS_Color} TODO: Add docs
	Highlight = new FORMS_Color(0x766056, 1.0);

	/// @var {Struct.FORMS_Color} TODO: Add docs
	Border = new FORMS_Color(0x9D9D9D, 1.0);

	/// @var {Real} TODO: Add docs
	SplitterSize = 6;
}
