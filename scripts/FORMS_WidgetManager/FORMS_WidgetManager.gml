/// @macro {Struct.FORMS_WidgetManager} The root widget or `undefined` if GUI
/// hasn't been initialized yet.
/// @see FORMS_Init
#macro FORMS_ROOT global.__formsRoot

/// @var {Struct.FORMS_WidgetManager} The root widget or `undefined`.
/// @private
global.__formsRoot = undefined;

/// @macro Shorthand for `FORMS_ROOT.Tooltip`.
/// @see FORMS_WidgetManager.Tooltip
#macro FORMS_TOOLTIP FORMS_ROOT.Tooltip

/// @macro Shorthand for `FORMS_ROOT.Font`.
/// @see FORMS_WidgetManager.Font
#macro FORMS_FONT FORMS_ROOT.Font

/// @macro Shorthand for `FORMS_ROOT.FontBold`.
/// @see FORMS_WidgetManager.FontBold
#macro FORMS_FONT_BOLD FORMS_ROOT.FontBold

/// @macro Shorthand for `FORMS_ROOT.FontHeight`.
/// @see FORMS_WidgetManager.FontHeight
#macro FORMS_FONT_HEIGHT FORMS_ROOT.FontHeight

/// @macro Shorthand for `FORMS_ROOT.FontWidth`.
/// @see FORMS_WidgetManager.FontWidth
#macro FORMS_FONT_WIDTH FORMS_ROOT.FontWidth

/// @macro Shorthand for `FORMS_ROOT.LineHeight`.
/// @see FORMS_WidgetManager.LineHeight
#macro FORMS_LINE_HEIGHT FORMS_ROOT.LineHeight

/// @macro Shorthand for `FORMS_ROOT.Items`.
/// @see FORMS_WidgetManager.Items
#macro FORMS_WIDGETS FORMS_ROOT.Items

/// @macro Shorthand for `FORMS_ROOT.WidgetIdNext`.
/// @see FORMS_WidgetManager.WidgetIdNext
#macro FORMS_WIDGET_ID_NEXT FORMS_ROOT.WidgetIdNext

/// @macro Shorthand for `FORMS_ROOT.WidgetHovered`.
/// @see FORMS_WidgetManager.WidgetHovered
#macro FORMS_WIDGET_HOVERED FORMS_ROOT.WidgetHovered

/// @macro Shorthand for `FORMS_ROOT.WidgetActive`.
/// @see FORMS_WidgetManager.WidgetActive
#macro FORMS_WIDGET_ACTIVE FORMS_ROOT.WidgetActive

/// @macro Shorthand for `FORMS_ROOT.WidgetFilling`.
/// @see FORMS_WidgetManager.WidgetFilling
#macro FORMS_WIDGET_FILLING FORMS_ROOT.WidgetFilling

/// @macro Shorthand for `FORMS_ROOT.WidgetSelected`.
/// @see FORMS_WidgetManager.WidgetSelected
#macro FORMS_WIDGET_SELECTED FORMS_ROOT.WidgetSelected

/// @macro Shorthand for `FORMS_ROOT.MouseX`.
/// @see FORMS_WidgetManager.MouseX
#macro FORMS_MOUSE_X FORMS_ROOT.MouseX

/// @macro Shorthand for `FORMS_ROOT.MouseY`.
/// @see FORMS_WidgetManager.MouseY
#macro FORMS_MOUSE_Y FORMS_ROOT.MouseY

/// @macro Shorthand for `FORMS_ROOT.MousePressX`.
/// @see FORMS_WidgetManager.MousePressX
#macro FORMS_MOUSE_PRESS_X FORMS_ROOT.MousePressX

/// @macro Shorthand for `FORMS_ROOT.MousePressY`.
/// @see FORMS_WidgetManager.MousePressY
#macro FORMS_MOUSE_PRESS_Y FORMS_ROOT.MousePressY

/// @macro Shorthand for `FORMS_ROOT.MouseDisable`.
/// @see FORMS_WidgetManager.MouseDisable
#macro FORMS_MOUSE_DISABLE FORMS_ROOT.MouseDisable

/// @macro Shorthand for `FORMS_ROOT.Cursor`.
/// @see FORMS_WidgetManager.Cursor
#macro FORMS_CURSOR FORMS_ROOT.Cursor

/// @macro Shorthand for `FORMS_ROOT.MatrixStack`.
/// @see FORMS_WidgetManager.MatrixStack
#macro FORMS_MATRIX_STACK FORMS_ROOT.MatrixStack

/// @macro Shorthand for `FORMS_ROOT.DestroyStack`.
/// @see FORMS_WidgetManager.DestroyStack
#macro FORMS_DESTROY_STACK FORMS_ROOT.DestroyStack

/// @macro Shorthand for `FORMS_ROOT.ColorPreview`.
/// @see FORMS_WidgetManager.ColorPreview
#macro FORMS_COLOR_PREVIEW FORMS_ROOT.ColorPreview

/// @macro Shorthand for `FORMS_ROOT.ContextMenu`.
/// @see FORMS_WidgetManager.ContextMenu
#macro FORMS_CONTEXT_MENU FORMS_ROOT.ContextMenu

/// @macro Shorthand for `FORMS_ROOT.KeyLog`.
/// @see FORMS_WidgetManager.KeyLog
#macro FORMS_KEY_LOG FORMS_ROOT.KeyLog

/// @macro Shorthand for `FORMS_ROOT.InputSprite`.
/// @see FORMS_WidgetManager.InputSprite
#macro FORMS_INPUT_SPRITE FORMS_ROOT.InputSprite

/// @macro Shorthand for `FORMS_ROOT.InputSpriteWidth`.
/// @see FORMS_WidgetManager.InputSpriteWidth
#macro FORMS_INPUT_SPRITE_WIDTH FORMS_ROOT.InputSpriteWidth

/// @macro Shorthand for `FORMS_ROOT.InputSpriteHeight`.
/// @see FORMS_WidgetManager.InputSpriteHeight
#macro FORMS_INPUT_SPRITE_HEIGHT FORMS_ROOT.InputSpriteHeight

/// @macro Shorthand for `FORMS_ROOT.InputString`.
/// @see FORMS_WidgetManager.InputString
#macro FORMS_INPUT_STRING FORMS_ROOT.InputString

/// @macro Shorthand for `FORMS_ROOT.InputIndexFrom`.
/// @see FORMS_WidgetManager.InputIndexFrom
#macro FORMS_INPUT_INDEX_FROM FORMS_ROOT.InputIndexFrom

/// @macro Shorthand for `FORMS_ROOT.InputIndexTo`.
/// @see FORMS_WidgetManager.InputIndexTo
#macro FORMS_INPUT_INDEX_TO FORMS_ROOT.InputIndexTo

/// @macro Shorthand for `FORMS_ROOT.InputIndexDrawStart`.
/// @see FORMS_WidgetManager.InputIndexDrawStart
#macro FORMS_INPUT_INDEX_DRAW_START FORMS_ROOT.InputIndexDrawStart

/// @macro Shorthand for `FORMS_ROOT.InputMultitype`.
/// @see FORMS_WidgetManager.InputMultitype
#macro FORMS_INPUT_MULTITYPE FORMS_ROOT.InputMultitype

/// @macro Shorthand for `FORMS_ROOT.InputTimer`.
/// @see FORMS_WidgetManager.InputTimer
#macro FORMS_INPUT_TIMER FORMS_ROOT.InputTimer

/// @macro Shorthand for `FORMS_ROOT.InputActive`.
/// @see FORMS_WidgetManager.InputActive
#macro FORMS_INPUT_ACTIVE FORMS_ROOT.InputActive

/// @macro Shorthand for `FORMS_ROOT.InputParent`.
/// @see FORMS_WidgetManager.InputParent
#macro FORMS_INPUT_PARENT FORMS_ROOT.InputParent

/// @macro Shorthand for `FORMS_ROOT.PopupMessage`.
/// @see FORMS_WidgetManager.PopupMessage
#macro FORMS_POPUP_MESSAGE FORMS_ROOT.PopupMessage

/// @macro Shorthand for `FORMS_ROOT.PopupTimer`.
/// @see FORMS_WidgetManager.PopupTimer
#macro FORMS_POPUP_TIMER FORMS_ROOT.PopupTimer

/// @macro Shorthand for `FORMS_ROOT.PopupDuration`.
/// @see FORMS_WidgetManager.PopupDuration
#macro FORMS_POPUP_DURATION FORMS_ROOT.PopupDuration

/// @func  FORMS_WidgetManager()
///
/// @desc The widget manager.
///
/// @note You should never create new instances of this! To create a new GUI,
/// use the function {@link FORMS_Init} instead!
function FORMS_WidgetManager()
	: FORMS_CompoundWidget() constructor
{
	/// @var {String} The tooltip text to draw. Use an empty string for no tooltip.
	Tooltip = "";

	/// @var {Asset.GMFont} The main font used when rendering the GUI. Must be
	/// monospace! Defaults to `FORMS_FntNormal`.
	Font = FORMS_FntNormal;

	/// @var {Asset.GMFont} The font used when drawing bold text. Must be monospace!
	/// Defaults to `FORMS_FntNormal`.
	FontBold = FORMS_FntBold;

	var _font = draw_get_font();
	draw_set_font(Font);

	/// @var {Real} The font height. Defaults to the height of character Q.
	FontHeight = string_height("Q");

	/// @var {Real} The font width. Defaults to the width of character Q.
	FontWidth = string_width("Q");

	/// @var {Real} The line height. Defaults to the height of sprite `FORMS_SprInput`.
	LineHeight = sprite_get_height(FORMS_SprInput);

	draw_set_font(_font);

	/// @var {Real}
	WidgetIdNext = 0;

	/// @var {Struct.FORMS_Widget}
	WidgetHovered = undefined;

	/// @var {Struct.FORMS_Widget}
	WidgetActive = undefined;

	/// @var {Struct.FORMS_Widget}
	WidgetFilling = undefined;

	/// @var {Struct.FORMS_Widget}
	WidgetSelected = undefined;

	/// @var {Real}
	MouseX = 0;

	/// @var {Real}
	MouseY = 0;

	/// @var {Real}
	MousePressX = 0;

	/// @var {Real}
	MousePressY = 0;

	/// @var {Real}
	MouseDisable = false;

	/// @var {Real}
	Cursor = cr_default;

	/// @var {Id.DsStack<Array>}
	MatrixStack = ds_stack_create();

	/// @var {Id.DsStack<Struct.FORMS_Widget>}
	DestroyStack = ds_stack_create();

	/// @var {Real}
	ColorPreview = -1;

	/// @var {Struct.FORMS_ContextMenu} The currently open context menu or `undefined`.
	ContextMenu = undefined;

	/// @var {Id.DsList<Real>}
	KeyLog = ds_list_create();

	////////////////////////////////////////////////////////////////////////////
	// Input

	/// @var {Asset.GMSprite}
	InputSprite = FORMS_SprInput;

	/// @var {Real}
	InputSpriteWidth = sprite_get_width(InputSprite);

	/// @var {Real}
	InputSpriteHeight = sprite_get_height(InputSprite);

	/// @var {String}
	InputString = "";

	/// @var {Real}
	InputIndexFrom = 1;

	/// @var {Real}
	InputIndexTo = 1;

	/// @var {Real}
	InputIndexDrawStart = 1;

	/// @var {Real}
	InputMultitype = 0;

	/// @var {Real}
	InputTimer = current_time;

	/// @var {Real}
	InputActive = undefined;

	/// @var {Struct.FORMS_Widget}
	InputParent = undefined;

	////////////////////////////////////////////////////////////////////////////
	// Popup message

	/// @var {String}
	PopupMessage = "";

	/// @var {Real}
	PopupTimer = 0;

	/// @var {Real}
	PopupDuration = 0;

	/// @func LogKey(_key)
	///
	/// @desc Adds the key to the key log.
	///
	/// @param {Real} _key The key to be added to the key log.
	static LogKey = function (_key)
	{
		switch (_key)
		{
		case vk_lshift:
		case vk_rshift:
			_key = vk_shift;
			break;

		case vk_lalt:
		case vk_ralt:
			_key = vk_alt;
			break;

		case vk_lcontrol:
		case vk_rcontrol:
			_key = vk_control;
			break;
		}

		ds_list_add(KeyLog, _key);
	};

	/// @func HandleKeyboardShortcuts()
	static HandleKeyboardShortcuts = function ()
	{
		if (keyboard_check_pressed(vk_anykey))
		{
			LogKey(keyboard_key);
		}

		if (mouse_check_button_pressed(mb_any))
		{
			LogKey(mouse_button);
		}

		for (var i = ds_list_size(KeyLog) - 1; i >= 0; --i)
		{
			var _isMouseButton = (KeyLog[| i] == mb_left
				|| KeyLog[| i] == mb_right
				|| KeyLog[| i] == mb_middle);
			if ((!_isMouseButton && !keyboard_check(KeyLog[| i]))
				|| (_isMouseButton && !mouse_check_button(KeyLog[| i])))
			{
				ds_list_delete(KeyLog, i);
				continue;
			}
		}

		// Global
		var _shortcuts = KeyboardShortcuts;

		if (!is_undefined(_shortcuts))
		{
			for (var i = array_length(_shortcuts) - 1; i >= 0; --i)
			{
				_shortcuts[i].Update();
			}
		}

		// Selected widget
		if (FORMS_WidgetExists(WidgetSelected))
		{
			_shortcuts = WidgetSelected.KeyboardShortcuts;
			if (!is_undefined(_shortcuts))
			{
				for (var i = array_length(_shortcuts) - 1; i >= 0; --i)
				{
					_shortcuts[i].Update();
				}
			}
		}
	};

	/// @func UpdateInput()
	static UpdateInput = function (_input)
	{
		if (InputActive == undefined)
		{
			return;
		}

		FORMS_RequestRedraw(InputParent);

		var _inputStringLength = string_length(InputString);

		// Multitype
		InputMultitype = false;

		if (keyboard_check_pressed(vk_anykey))
		{
			InputMultitype = true;
			InputTimer = current_time;
		}

		if (current_time > InputTimer + 300)
		{
			InputMultitype = true;
		}

		// Type
		var _stringToInsert = string_replace_all(keyboard_string, chr(127), "");
		var _keyboardStringLength = string_length(_stringToInsert);

		if (_keyboardStringLength > 0)
		{
			// Delete selected part
			if (InputIndexFrom != InputIndexTo)
			{
				FORMS_InputDeleteSelectedPart();
			}

			// Insert string
			InputString = string_insert(_stringToInsert, InputString, InputIndexFrom);
			InputIndexFrom += _keyboardStringLength;
			InputIndexTo = InputIndexFrom;
			keyboard_string = "";
		}

		// Backspace
		if (keyboard_check(vk_backspace) && InputMultitype)
		{
			if (InputIndexFrom == InputIndexTo)
			{
				InputString = string_delete(InputString, InputIndexFrom - 1, 1);
				InputIndexFrom = max(InputIndexFrom - 1, 1);
				InputIndexTo = InputIndexFrom;
			}
			else
			{
				FORMS_InputDeleteSelectedPart();
			}
		}
		else if (keyboard_check(vk_delete) && InputMultitype)
		{
			// Delete
			if (InputIndexFrom != InputIndexTo)
			{
				FORMS_InputDeleteSelectedPart();
			}
			else
			{
				InputString = string_delete(InputString, InputIndexFrom, 1);
			}
		}

		// Save string length
		_inputStringLength = string_length(InputString);

		// Control
		if (keyboard_check(vk_control))
		{
			if (keyboard_check_pressed(ord("A")))
			{
				FORMS_InputSelectAll();
			}
			else if (keyboard_check_pressed(ord("D")))
			{
				FORMS_InputDelete();
			}
			else if (keyboard_check_pressed(ord("X")))
			{
				FORMS_InputCut();
			}
			else if (keyboard_check_pressed(ord("C")))
			{
				FORMS_InputCopy();
			}
			else if (keyboard_check_pressed(ord("V")))
			{
				FORMS_InputPaste();
				_inputStringLength = string_length(InputString);
			}
		}

		// Arrows
		if (keyboard_check(vk_left) && InputMultitype)
		{
			InputIndexTo = max(InputIndexTo - 1, 1);

			if (!keyboard_check(vk_shift))
			{
				InputIndexFrom = InputIndexTo;
			}
		}
		else if (keyboard_check(vk_right) && InputMultitype)
		{
			InputIndexTo = min(InputIndexTo + 1, _inputStringLength + 1);

			if (!keyboard_check(vk_shift))
			{
				InputIndexFrom = InputIndexTo;
			}
		}

		// Home/end
		if (keyboard_check_pressed(vk_home))
		{
			InputIndexTo = 1;

			if (!keyboard_check(vk_shift))
			{
				InputIndexFrom = InputIndexTo;
			}
		}
		else if (keyboard_check_pressed(vk_end))
		{
			InputIndexTo = _inputStringLength + 1;

			if (!keyboard_check(vk_shift))
			{
				InputIndexFrom = InputIndexTo;
			}
		}
	};

	/// @func Update()
	static Update = function ()
	{
		display_set_gui_maximise();

		Tooltip = "";
		MouseX = window_mouse_get_x();
		MouseY = window_mouse_get_y();
		SetSize(window_get_width(), window_get_height());

		// Find hovered widget
		var _lastHoveredWidget = WidgetHovered;
		if (!FORMS_WidgetExists(_lastHoveredWidget))
		{
			_lastHoveredWidget = undefined;
		}
		WidgetHovered = FORMS_FindWidget(Items, MouseX, MouseY);

		// Redraw last hovered widget
		if (FORMS_WidgetExists(_lastHoveredWidget)
			&& WidgetHovered != _lastHoveredWidget)
		{
			FORMS_RequestRedraw(_lastHoveredWidget);
		}

		// Reset active widget if it does not exist
		if (!FORMS_WidgetExists(WidgetActive))
		{
			WidgetActive = undefined;
		}

		// Reset selected widget if it does not exist
		if (!FORMS_WidgetExists(WidgetSelected))
		{
			WidgetSelected = undefined;
		}

		// Redraw active widget and push mouse coordinates
		if (FORMS_WidgetExists(WidgetActive))
		{
			FORMS_RequestRedraw(WidgetActive);
			FORMS_PushMouseCoordinates(WidgetActive);
		}
		else if (FORMS_WidgetExists(WidgetHovered))
		{
			FORMS_PushMouseCoordinates(WidgetHovered);
		}

		HandleKeyboardShortcuts();
		UpdateInput(InputActive);
	};

	/// @func Draw()
	static Draw = function ()
	{
		ColorPreview = -1;

		gpu_push_state();
		gpu_set_texrepeat(false);
		gpu_set_texfilter(false);
		gpu_set_colorwriteenable(true, true, true, false);
		gpu_set_cullmode(cull_noculling);

		draw_clear(FORMS_GetColor(FORMS_EStyle.Background));

		var _font = draw_get_font();
		draw_set_font(Font);
		var _color = draw_get_color();
		draw_set_colour(c_white);
		var _alpha = draw_get_alpha();
		draw_set_alpha(_alpha);

		var _mouseX = window_mouse_get_x();
		var _mouseY = window_mouse_get_y();
		var _guiWidth = window_get_width();
		var _guiHeight = window_get_height();

		// Draw items
		var _items = Items;
		var _itemCount = ds_list_size(_items);
		for (var i = 0; i < _itemCount; ++i)
		{
			var _item = _items[| i];
			if (FORMS_WidgetExists(_item))
			{
				FORMS_DrawItem(_item);
			}
			else
			{
				ds_list_delete(_items, i--);
			}
		}

		// Draw hovered color
		if (ColorPreview != -1)
		{
			var _w = 64;
			var _h = 64;
			var _x = min(_mouseX + 24, _guiWidth - _w - 8);
			var _y = min(_mouseY + 24, _guiHeight - _h - 8);

			FORMS_DrawRectangle(_x - 8, _y - 8, _w + 16, _h + 16, FORMS_GetColor(FORMS_EStyle.WindowBorder));
			FORMS_DrawRectangle(_x - 7, _y - 7, _w + 14, _h + 14, FORMS_GetColor(FORMS_EStyle.WindowBackground));
			FORMS_DrawRectangle(_x, _y, _w, _h, ColorPreview);
			FORMS_DrawTextShadow(_x, _y, ColorPreview, FORMS_GetColor(FORMS_EStyle.Text), c_black);
		}

		// Popup message
		if (PopupMessage != "")
		{
			if ((current_time - PopupTimer) < PopupDuration)
			{
				FORMS_DrawPopupMessage(
					window_get_width(),
					window_get_height(),
					PopupMessage);
			}
			else
			{
				PopupTimer = 0;
			}
		}

		// Draw tooltip
		if (is_string(Tooltip)
			&& string_length(Tooltip) > 0)
		{
			FORMS_DrawTooltip(_mouseX + 16, _mouseY + 16, Tooltip);
		}

		// Set cursor
		if (_mouseX > 2
			&& _mouseY > 2
			&& _mouseX < window_get_width() - 2
			&& _mouseY < window_get_height() - 2)
		{
			window_set_cursor(Cursor);
		}
		Cursor = cr_default;

		// Handle destroy requests
		while (!ds_stack_empty(DestroyStack))
		{
			var _widget = ds_stack_pop(DestroyStack);
			if (FORMS_WidgetExists(_widget))
			{
				_widget.OnCleanUp();
				if (WidgetActive == _widget)
				{
					WidgetActive = undefined;
				}
			}
		}

		draw_set_font(_font);
		draw_set_color(_color);
		draw_set_alpha(_alpha);

		gpu_pop_state();
	};

	/// @func Destroy()
	///
	/// @return {Undefined}
	static Destroy = function ()
	{
		FORMS_WidgetCleanUp(self);
		ds_stack_destroy(MatrixStack);
		ds_stack_destroy(DestroyStack);
		ds_list_destroy(KeyLog);
		return undefined;
	}; 
}

/// @func FORMS_Init()
///
/// @desc Initializes GUI.
///
/// @return {Struct.FORMS_WidgetManager} The GUI root widget.
///
/// @throws {String} If the GUI was already initialized.
///
/// @see FORMS_Update
/// @see FORMS_Draw
/// @see FORMS_Destory
function FORMS_Init()
{
	gml_pragma("forceinline");
	if (FORMS_ROOT != undefined)
	{
		throw "GUI already initialized!";
	}
	FORMS_ROOT = new FORMS_WidgetManager();
	return FORMS_ROOT;
}

/// @func FORMS_Update()
///
/// @desc Updates GUI.
///
/// @note The GUI must be initialized first using {@link FORMS_Init}!
///
/// @see FORMS_Init
/// @see FORMS_Draw
/// @see FORMS_Destory
function FORMS_Update()
{
	gml_pragma("forceinline");
	FORMS_ROOT.Update();
}

/// @func FORMS_Draw()
///
/// @desc Draws GUI.
///
/// @note The GUI must be initialized first using {@link FORMS_Init}!
///
/// @see FORMS_Init
/// @see FORMS_Update
/// @see FORMS_Destory
function FORMS_Draw()
{
	gml_pragma("forceinline");
	FORMS_ROOT.Draw();
}

/// @func FORMS_Destroy()
///
/// @desc Destroys GUI and frees its used resources from memory.
///
/// @note The GUI must be initialized first using {@link FORMS_Init}!
///
/// @see FORMS_Init
/// @see FORMS_Update
/// @see FORMS_Draw
function FORMS_Destroy()
{
	gml_pragma("forceinline");
	FORMS_ROOT = FORMS_ROOT.Destroy();
}

/// @enum
enum FORMS_EStyle
{
	Background,
	Text,
	TextSelected,
	Input,
	Section,
	WindowBackground,
	WindowBackground2,
	WindowBorder,
	WindowButton,
	Scrollbar,
	Highlight,
	Active,
	Disabled,
	Shadow,
	ShadowAlpha,
	SIZE
};

/// @var {Array<Real>}
/// @private
global._formsColors = array_create(FORMS_EStyle.SIZE, 0);

global._formsColors[@ FORMS_EStyle.Background] = $1E1E1E;
global._formsColors[@ FORMS_EStyle.Text] = $FFFFFF;
global._formsColors[@ FORMS_EStyle.TextSelected] = $FFFFFF;
global._formsColors[@ FORMS_EStyle.Input] = $252525;
global._formsColors[@ FORMS_EStyle.Section] = $2D2D2D;
global._formsColors[@ FORMS_EStyle.WindowBackground] = $2D2D2D;
global._formsColors[@ FORMS_EStyle.WindowBackground2] = $333333;
global._formsColors[@ FORMS_EStyle.WindowBorder] = $3F3F3F;
global._formsColors[@ FORMS_EStyle.WindowButton] = $686868;
global._formsColors[@ FORMS_EStyle.Scrollbar] = $9E9E9E;
global._formsColors[@ FORMS_EStyle.Highlight] = $686868;
global._formsColors[@ FORMS_EStyle.Active] = $A56428;
global._formsColors[@ FORMS_EStyle.Disabled] = c_gray;
global._formsColors[@ FORMS_EStyle.Shadow] = c_black;
global._formsColors[@ FORMS_EStyle.ShadowAlpha] = 1;

/// @func FORMS_GetColor(_style)
///
/// @desc Retrieves color for given style.
///
/// @param {Real} _style Use one of the {@link FORMS_EStyle} values.
///
/// @return {Real} The color for given style.
function FORMS_GetColor(_style)
{
	gml_pragma("forceinline");
	return global._formsColors[_style];
}
