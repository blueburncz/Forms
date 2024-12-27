/// @func FORMS_Style()
///
/// @desc A struct that defines colors, fonts and sizes used by UI elements.
function FORMS_Style() constructor
{
	/// @var {Constant.Color} The accent color. Used for example as color of the tick icon in selected checkboxes or
	/// the circle icon in selected radio buttons. Default value is `0x5B9D00` ("GameMaker green").
	Accent = 0x5B9D00;

	/// @var {Asset.GMFont}
	Font = FORMS_FntNormal;

	/// @var {Constant.Color}
	Text = c_white;

	/// @var {Constant.Color}
	TextMuted = c_gray;

	/// @var {Constant.Color}
	TextDisabled = c_gray;

	/// @var {Array<Constant.Color>}
	Background = [
		0x101010,
		0x181818,
		0x272727,
		0x404040,
		0x505050,
		0x606060,
	];

	/// @var {Constant.Color}
	Scrollbar = 0x4D4D4D;

	/// @var {Constant.Color}
	ScrollbarHover = 0x575757;

	/// @var {Constant.Color}
	ScrollbarActive = 0x898989;

	/// @var {Asset.GMSprite}
	ScrollbarSprite = FORMS_SprRound4;

	/// @var {Real}
	ScrollbarSizeMin = 32;

	/// @var {Constant.Color}
	Shadow = c_black;

	/// @var {Real}
	ShadowAlpha = 0.5;

	/// @var {Constant.Color}
	Tooltip = 0xB3DCE9;

	/// @var {Constant.Color}
	TooltipText = c_black;

	/// @var {Asset.GMSprite}
	TooltipSprite = FORMS_SprRound4;

	/// @var {Constant.Color}
	Highlight = 0x766056;

	/// @var {Constant.Color}
	Border = 0x9D9D9D;

	/// @var {Real}
	SplitterSize = 6;
}
