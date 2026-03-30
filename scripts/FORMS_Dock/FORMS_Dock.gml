/// @enum Enumeration of possible split direction of {@link FORMS_Dock}.
enum FORMS_EDockSplit
{
	/// @member Dock is split horizontally, i.e. it has one widget on the left and one on the right.
	Horizontal,
	/// @member Dock is split vertically, i.e. it has one widget at the top and one at the bottom.
	Vertical,
};

/// @enum Drop zone types for tab docking.
enum FORMS_EDropZone
{
	/// @member Drop as new tab in this dock.
	Center,
	/// @member Split and dock to the left.
	Left,
	/// @member Split and dock to the right.
	Right,
	/// @member Split and dock to the top.
	Top,
	/// @member Split and dock to the bottom.
	Bottom,
	/// @member Reorder within same dock's tab bar.
	TabInsert,
};

/// @func FORMS_DropZone(_type, _dock, _x, _y, _width, _height[, _data])
///
/// @desc Represents a valid drop target for tab dragging.
///
/// @param {Real} _type Value from {@link FORMS_EDropZone}.
/// @param {Struct.FORMS_Dock} _dock The dock this zone belongs to.
/// @param {Real} _x The X position of the zone.
/// @param {Real} _y The Y position of the zone.
/// @param {Real} _width The width of the zone.
/// @param {Real} _height The height of the zone.
/// @param {Struct, Undefined} [_data] Extra data (e.g., insert index for reorder).
function FORMS_DropZone(_type, _dock, _x, _y, _width, _height, _data = undefined) constructor
{
	Type = _type;
	Dock = _dock;
	X = _x;
	Y = _y;
	Width = _width;
	Height = _height;
	Data = _data;

	/// @func contains(_mouseX, _mouseY)
	///
	/// @desc Check if point is inside drop zone.
	///
	/// @param {Real} _mouseX X coordinate.
	/// @param {Real} _mouseY Y coordinate.
	///
	/// @return {Bool}
	static contains = function (_mouseX, _mouseY)
	{
		return (_mouseX >= X && _mouseX < X + Width
			&& _mouseY >= Y && _mouseY < Y + Height);
	}

	/// @func get_preview_rect()
	///
	/// @desc Returns the rectangle where a tab would land if dropped on this zone.
	///
	/// @return {Array<Real>} [x, y, width, height]
	static get_preview_rect = function ()
	{
		var _dock = Dock;
		switch (Type)
		{
			case FORMS_EDropZone.Left:
				return [_dock.__realX, _dock.__realY, _dock.__realWidth * 0.5, _dock.__realHeight];

			case FORMS_EDropZone.Right:
				var _halfW = _dock.__realWidth * 0.5;
				return [_dock.__realX + _halfW, _dock.__realY, _halfW, _dock.__realHeight];

			case FORMS_EDropZone.Top:
				return [_dock.__realX, _dock.__realY, _dock.__realWidth, _dock.__realHeight * 0.5];

			case FORMS_EDropZone.Bottom:
				var _halfH = _dock.__realHeight * 0.5;
				return [_dock.__realX, _dock.__realY + _halfH, _dock.__realWidth, _halfH];

			case FORMS_EDropZone.Center:
			case FORMS_EDropZone.TabInsert:
			default:
				return [_dock.__realX, _dock.__realY, _dock.__realWidth, _dock.__realHeight];
		}
	}
}

// =========================================================================
// Tab Drag & Drop
// =========================================================================

/// @var {Struct.FORMS_TabDrag, Undefined}
/// @private
global.__formsTabDrag = undefined;

/// @func forms_get_tab_drag()
///
/// @desc Retrieves the global tab drag state.
///
/// @return {Struct.FORMS_TabDrag}
function forms_get_tab_drag()
{
	global.__formsTabDrag ??= new FORMS_TabDrag();
	return global.__formsTabDrag;
}

/// @func FORMS_TabDrag()
///
/// @desc Global state manager for tab drag & drop operations.
function FORMS_TabDrag() constructor
{
	/// @var {Bool} Whether a tab drag is currently active.
	Active = false;

	/// @var {Struct.FORMS_Widget, Undefined} The widget being dragged.
	Tab = undefined;

	/// @var {Real} Index of the tab in the source dock.
	TabIndex = 0;

	/// @var {Struct.FORMS_Dock, Undefined} The dock the tab was dragged from.
	SourceDock = undefined;

	/// @var {Real} Mouse X offset from tab origin at drag start.
	DragOffsetX = 0;

	/// @var {Real} Mouse Y offset from tab origin at drag start.
	DragOffsetY = 0;

	/// @var {Real} Width of the dragged tab visual.
	TabWidth = 100;

	/// @var {String} Name text for drawing.
	TabName = "";

	/// @var {Constant.FontAwesome, Undefined} Icon for drawing.
	TabIcon = undefined;

	/// @var {Asset.GMFont, Undefined} Icon font for drawing.
	TabIconFont = undefined;

	/// @var {Struct.FORMS_DropZone, Undefined} Currently hovered drop zone.
	HoveredZone = undefined;

	/// @var {Real} Preview overlay alpha (for fade animation).
	PreviewAlpha = 0;

	/// @func start(_tab, _tabIndex, _dock, _tabX, _tabWidth)
	///
	/// @desc Begin dragging a tab.
	///
	/// @param {Struct.FORMS_Widget} _tab The tab widget.
	/// @param {Real} _tabIndex The index of the tab in the dock.
	/// @param {Struct.FORMS_Dock} _dock The source dock.
	/// @param {Real} _tabX The absolute X of the tab in the tab bar.
	/// @param {Real} _tabWidth The width of the tab.
	///
	/// @return {Struct.FORMS_TabDrag} Returns `self`.
	static start = function (_tab, _tabIndex, _dock, _tabX, _tabWidth)
	{
		Active = true;
		Tab = _tab;
		TabIndex = _tabIndex;
		SourceDock = _dock;
		DragOffsetX = window_mouse_get_x() - _tabX;
		DragOffsetY = window_mouse_get_y() - _dock.__tabContainer.__tabHitY;
		TabWidth = _tabWidth;
		TabName = _tab.Name;
		TabIcon = _tab.Icon;
		TabIconFont = _tab.IconFont;
		HoveredZone = undefined;
		PreviewAlpha = 0;

		return self;
	}

	/// @func cancel()
	///
	/// @desc Cancel the current drag operation.
	///
	/// @return {Struct.FORMS_TabDrag} Returns `self`.
	static cancel = function ()
	{
		Active = false;
		Tab = undefined;
		SourceDock = undefined;
		HoveredZone = undefined;
		PreviewAlpha = 0;
		return self;
	}

	/// @func drop()
	///
	/// @desc Execute the drop if hovering a valid zone.
	///
	/// @return {Bool} `true` if drop was executed, `false` if cancelled.
	static drop = function ()
	{
		if (!Active) return false;

		if (HoveredZone != undefined)
		{
			var _zone = HoveredZone;
			var _targetDock = _zone.Dock;
			var _sourceDock = SourceDock;
			var _tab = Tab;
			var _tabIndex = TabIndex;

			// Remove tab from source dock (defer collapse until after drop)
			if (_sourceDock != undefined)
			{
				array_delete(_sourceDock.__tabs, _tabIndex, 1);
				_tab.Parent = undefined;
				_sourceDock.__tabCurrent = clamp(_sourceDock.__tabCurrent, 0, max(array_length(_sourceDock.__tabs) - 1, 0));
			}

			// Execute drop based on zone type
			switch (_zone.Type)
			{
				case FORMS_EDropZone.Center:
					array_push(_targetDock.__tabs, _tab);
					_tab.Parent = _targetDock;
					_targetDock.__tabCurrent = array_length(_targetDock.__tabs) - 1;
					break;

				case FORMS_EDropZone.Left:
					_targetDock.__split(FORMS_EDockSplit.Horizontal);
					_targetDock.SplitSize = 0.5;
					_targetDock.__right.set_tabs(_targetDock.__tabs);
					_targetDock.__tabs = [];
					_targetDock.__left.__tabs = [_tab];
					_tab.Parent = _targetDock.__left;
					break;

				case FORMS_EDropZone.Right:
					_targetDock.__split(FORMS_EDockSplit.Horizontal);
					_targetDock.SplitSize = 0.5;
					_targetDock.__left.set_tabs(_targetDock.__tabs);
					_targetDock.__tabs = [];
					_targetDock.__right.__tabs = [_tab];
					_tab.Parent = _targetDock.__right;
					break;

				case FORMS_EDropZone.Top:
					_targetDock.__split(FORMS_EDockSplit.Vertical);
					_targetDock.SplitSize = 0.5;
					_targetDock.__right.set_tabs(_targetDock.__tabs);
					_targetDock.__tabs = [];
					_targetDock.__left.__tabs = [_tab];
					_tab.Parent = _targetDock.__left;
					break;

				case FORMS_EDropZone.Bottom:
					_targetDock.__split(FORMS_EDockSplit.Vertical);
					_targetDock.SplitSize = 0.5;
					_targetDock.__left.set_tabs(_targetDock.__tabs);
					_targetDock.__tabs = [];
					_targetDock.__right.__tabs = [_tab];
					_tab.Parent = _targetDock.__right;
					break;

				case FORMS_EDropZone.TabInsert:
					var _insertIndex = _zone.Data.insertIndex;
					if (_sourceDock == _targetDock && _tabIndex < _insertIndex)
					{
						_insertIndex--;
					}
					array_insert(_targetDock.__tabs, _insertIndex, _tab);
					_tab.Parent = _targetDock;
					_targetDock.__tabCurrent = _insertIndex;
					break;
			}

			__cleanup_source(_sourceDock, _targetDock);

			cancel();
			return true;
		}

		// No drop zone hovered - pop out into floating window
		var _sourceDock = SourceDock;
		var _tab = Tab;
		var _tabIndex = TabIndex;

		// Remove tab from source dock
		if (_sourceDock != undefined)
		{
			array_delete(_sourceDock.__tabs, _tabIndex, 1);
			_tab.Parent = undefined;
			_sourceDock.__tabCurrent = clamp(_sourceDock.__tabCurrent, 0, max(array_length(_sourceDock.__tabs) - 1, 0));
		}

		// Create a dock inside a window (ShowTabs false = tabs render in window title bar)
		var _dock = new FORMS_Dock({ ShowTabs: false });
		_dock.__tabs = [_tab];
		_tab.Parent = _dock;

		var _mouseX = window_mouse_get_x();
		var _mouseY = window_mouse_get_y();
		var _window = new FORMS_Window(_dock, {
			X: _mouseX - DragOffsetX,
			Y: _mouseY - DragOffsetY,
			Width: max(TabWidth + 32, 400),
			Height: 300,
		});

		forms_get_root().add_child(_window);

		// Register window with the parent workspace (if any) for tab-scoped visibility
		var _workspace = __find_workspace(_sourceDock);
		if (_workspace != undefined)
		{
			_workspace.register_window(_window);
		}

		__cleanup_source(_sourceDock, undefined);

		cancel();
		return true;
	}

	/// @private
	static __find_workspace = function (_widget)
	{
		var _current = _widget;
		while (_current != undefined)
		{
			if (_current.Parent != undefined
				&& variable_struct_exists(_current.Parent, "register_window"))
			{
				return _current.Parent;
			}
			_current = _current.Parent;
		}
		return undefined;
	}

	/// @private
	static __cleanup_source = function (_sourceDock, _targetDock)
	{
		if (_sourceDock == undefined) return;

		// Walk up to find the root dock in the source tree
		var _cleanupStart = _sourceDock;
		while (_cleanupStart.Parent != undefined
			&& variable_struct_exists(_cleanupStart.Parent, "__left"))
		{
			_cleanupStart = _cleanupStart.Parent;
		}

		// Also clean up the target dock tree if different
		if (_targetDock != undefined)
		{
			var _targetRoot = _targetDock;
			while (_targetRoot.Parent != undefined
				&& variable_struct_exists(_targetRoot.Parent, "__left"))
			{
				_targetRoot = _targetRoot.Parent;
			}
			__cleanup_empty_docks(_targetRoot);

			if (_targetRoot != _cleanupStart)
			{
				__cleanup_empty_docks(_cleanupStart);
			}
		}
		else
		{
			__cleanup_empty_docks(_cleanupStart);
		}

		// If the source root dock is inside a window and now empty, close the window
		if (array_length(_cleanupStart.__tabs) == 0
			&& _cleanupStart.__left == undefined
			&& _cleanupStart.Parent != undefined
			&& variable_struct_exists(_cleanupStart.Parent, "Widget")
			&& _cleanupStart.Parent.Widget == _cleanupStart)
		{
			_cleanupStart.Parent.destroy_later();
		}
	}

	/// @func draw()
	///
	/// @desc Draw the dragged tab and preview overlay.
	static draw = function ()
	{
		if (!Active) return;

		var _style = forms_get_style();
		var _mouseX = window_mouse_get_x();
		var _mouseY = window_mouse_get_y();
		var _x = _mouseX - DragOffsetX;
		var _y = _mouseY - DragOffsetY;
		var _tabHeight = 24;

		// Draw preview overlay
		if (HoveredZone != undefined)
		{
			PreviewAlpha = min(1.0, PreviewAlpha + 0.08);
			var _rect = HoveredZone.get_preview_rect();
			forms_draw_rectangle(_rect[0], _rect[1], _rect[2], _rect[3], _style.Accent.get(), 0.25 * PreviewAlpha);
			// Border
			forms_draw_rectangle(_rect[0], _rect[1], _rect[2], 2, _style.Accent.get(), 0.8 * PreviewAlpha);
			forms_draw_rectangle(_rect[0], _rect[1], 2, _rect[3], _style.Accent.get(), 0.8 * PreviewAlpha);
			forms_draw_rectangle(_rect[0] + _rect[2] - 2, _rect[1], 2, _rect[3], _style.Accent.get(), 0.8 * PreviewAlpha);
			forms_draw_rectangle(_rect[0], _rect[1] + _rect[3] - 2, _rect[2], 2, _style.Accent.get(), 0.8 * PreviewAlpha);
		}
		else
		{
			PreviewAlpha = max(0.0, PreviewAlpha - 0.12);
		}

		// Draw shadow under dragged tab
		draw_sprite_stretched_ext(
			FORMS_SprShadow, 0,
			_x - 8, _y - 8,
			TabWidth + 16, _tabHeight + 16,
			_style.Shadow.get(), _style.Shadow.get_alpha() * 0.6);

		// Draw tab background
		draw_sprite_stretched_ext(
			FORMS_SprTab, 0,
			_x, _y,
			TabWidth, _tabHeight,
			_style.Background[2].get(), 0.95);

		// Draw icon
		var _textX = _x + _style.Padding;
		if (TabIcon != undefined)
		{
			fa_draw(TabIconFont, TabIcon, _textX, _y + 3, _style.Text.get());
			_textX += 24;
		}

		// Draw name
		draw_set_font(_style.Font);
		forms_draw_text(_textX, _y + 3, TabName, _style.Text.get());
	}

	/// @func __cleanup_empty_docks(_dock)
	///
	/// @desc Recursively collapses empty leaf docks from the tree, bottom-up.
	///
	/// @param {Struct.FORMS_Dock} _dock The dock to clean up.
	///
	/// @return {Bool} `true` if this dock is empty and should be collapsed by its parent.
	///
	/// @private
	static __cleanup_empty_docks = function (_dock)
	{
		// Recurse into split children first (bottom-up)
		if (_dock.__left != undefined && _dock.__right != undefined)
		{
			var _leftEmpty = __cleanup_empty_docks(_dock.__left);
			var _rightEmpty = __cleanup_empty_docks(_dock.__right);

			if (_leftEmpty && _rightEmpty)
			{
				// Both empty - this dock becomes an empty leaf
				_dock.__left = undefined;
				_dock.__right = undefined;
				_dock.__tabs = [];
				return true;
			}
			else if (_leftEmpty)
			{
				// Left empty - adopt right's content
				var _sibling = _dock.__right;
				if (_sibling.__left != undefined && _sibling.__right != undefined)
				{
					_dock.SplitType = _sibling.SplitType;
					_dock.SplitSize = _sibling.SplitSize;
					_dock.__left = _sibling.__left;
					_dock.__right = _sibling.__right;
					_dock.__left.Parent = _dock;
					_dock.__right.Parent = _dock;
				}
				else
				{
					_dock.__left = undefined;
					_dock.__right = undefined;
					_dock.__tabs = _sibling.__tabs;
					_dock.__tabCurrent = _sibling.__tabCurrent;
					for (var i = 0; i < array_length(_dock.__tabs); ++i)
					{
						_dock.__tabs[i].Parent = _dock;
					}
				}
				return false;
			}
			else if (_rightEmpty)
			{
				// Right empty - adopt left's content
				var _sibling = _dock.__left;
				if (_sibling.__left != undefined && _sibling.__right != undefined)
				{
					_dock.SplitType = _sibling.SplitType;
					_dock.SplitSize = _sibling.SplitSize;
					_dock.__left = _sibling.__left;
					_dock.__right = _sibling.__right;
					_dock.__left.Parent = _dock;
					_dock.__right.Parent = _dock;
				}
				else
				{
					_dock.__left = undefined;
					_dock.__right = undefined;
					_dock.__tabs = _sibling.__tabs;
					_dock.__tabCurrent = _sibling.__tabCurrent;
					for (var i = 0; i < array_length(_dock.__tabs); ++i)
					{
						_dock.__tabs[i].Parent = _dock;
					}
				}
				return false;
			}

			return false;
		}

		// Leaf node - empty if no tabs
		return (array_length(_dock.__tabs) == 0);
	}
}

/// @func FORMS_DockProps()
///
/// @extends FORMS_WidgetProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_Dock}.
function FORMS_DockProps(): FORMS_WidgetProps() constructor
{
	/// @var {Real, Undefined} Whether the dock is split horizontally or vertically. Use values from
	/// {@link FORMS_EDockSplit}.
	SplitType = undefined;

	/// @var {Real, Undefined} The size of the split in range 0..1.
	SplitSize = undefined;

	/// @var {Bool, Undefined} Whether to show tabs (`true`) or not (`false`).
	ShowTabs = undefined;
}

/// @func FORMS_Dock([_props])
///
/// @extends FORMS_Widget
///
/// @desc A dock is a recursive structure that can be either split horizontally or vertically or host widgets as its
/// tabs.
///
/// @param {Struct.FORMS_DockProps, Undefined} [_props] Properties to create the dock with or `undefined` (default).
function FORMS_Dock(_props = undefined): FORMS_Widget(_props) constructor
{
	static Widget_update = update;

	/// @var {Real} Whether the dock is split horizontally or vertically. Use values from {@link FORMS_EDockSplit}.
	/// Default is {@link FORMS_EDockSplit.Horizontal}.
	SplitType = forms_get_prop(_props, "SplitType") ?? FORMS_EDockSplit.Horizontal;

	/// @var {Real} The split size of the dock. Defaults to 0.5.
	SplitSize = forms_get_prop(_props, "SplitSize") ?? 0.5;

	/// @var {Bool, Undefined} Whether to show tabs (`true`, default) or not (`false`).
	ShowTabs = forms_get_prop(_props, "ShowTabs") ?? true;

	/// @var {Struct.FORMS_DockTabs}
	/// @private
	__tabContainer = new FORMS_DockTabs();

	__tabContainer.Parent = self;

	/// @var {Array<Struct.FORMS_Widget>}
	/// @private
	__tabs = [];

	/// @var {Real}
	/// @private
	__tabCurrent = 0;

	/// @var {Struct.FORMS_Dock, Undefined}
	/// @private
	__left = undefined;

	/// @var {Struct.FORMS_Dock, Undefined}
	/// @private
	__right = undefined;

	/// @var {Bool}
	/// @private
	__resize = false;

	/// @var {Real}
	/// @private
	__mouseOffset = 0;

	/// @var {Real}
	/// @private
	__splitterPos = 0;

	/// @var {Bool}
	/// @private
	__splitterIsHovered = false;

	/// @func get_first()
	///
	/// @desc Retrieves the first child (left or top, based on the dock's split type) of the dock.
	///
	/// @return {Struct.FORMS_Dock, Undefined} The first child of the dock or `undefined`.
	static get_first = function () { return __left; }

	/// @func get_second()
	///
	/// @desc Retrieves the second child (right or bottom, based on the dock's split type) of the dock.
	///
	/// @return {Struct.FORMS_Dock, Undefined} The second child of the dock or `undefined`.
	static get_second = function () { return __right; }

	/// @func set_tab(_tabs)
	///
	/// @desc Changes the array of widgets tabbed to the dock.
	///
	/// @param {Array<Struct.FORMS_Widget>} _tabs The new array tabbed widgets.
	///
	/// @return {Struct.FORMS_Dock} Returns `self`.
	static set_tabs = function (_tabs)
	{
		forms_assert(array_length(__tabs) == 0, "Dock already has tabs!"); // TODO: Why is this here? :thinking:
		__tabs = _tabs;
		var i = 0;
		repeat(array_length(__tabs))
		{
			__tabs[i++].Parent = self;
		}
		return self;
	}

	/// @func add_tab(_widget)
	///
	/// @desc Tabs a new widget to the dock.
	///
	/// @param {Struct.FORMS_Widget} _widget The widget to add to the dock's tabs.
	///
	/// @return {Struct.FORMS_Dock} Returns `self`.
	static add_tab = function (_widget)
	{
		forms_assert(_widget.Parent == undefined, "Widget already has a parent!");
		forms_assert(__left == undefined && __right == undefined, "Cannot add tabs to a dock that is split!");
		array_push(__tabs, _widget);
		_widget.Parent = self;
		return self;
	}

	/// @private
	static __split = function (_type)
	{
		forms_assert(__left == undefined && __right == undefined, "Dock is already split!");

		SplitType = _type;

		__left = new FORMS_Dock();
		__left.Parent = self;

		__right = new FORMS_Dock();
		__right.Parent = self;
	}

	/// @func split_left([_splitSize])
	///
	/// @desc Splits the dock horizontally, moving itself to the left and creating a new dock on the right.
	///
	/// @param {Real, Undefined} [_splitSize] New split size of the dock or `undefined` to keep the current value
	/// (default).
	///
	/// @return {Struct.FORMS_Dock} Returns `self`.
	static split_left = function (_splitSize = undefined)
	{
		__split(FORMS_EDockSplit.Horizontal);
		SplitSize = _splitSize ?? SplitSize;
		__left.set_tabs(__tabs);
		__tabs = [];
		return self;
	}

	/// @func split_right([_splitSize])
	///
	/// @desc Splits the dock horizontally, moving itself to the right and creating a new dock on the left.
	///
	/// @param {Real, Undefined} [_splitSize] New split size of the dock or `undefined` to keep the current value
	/// (default).
	///
	/// @return {Struct.FORMS_Dock} Returns `self`.
	static split_right = function (_splitSize = undefined)
	{
		__split(FORMS_EDockSplit.Horizontal);
		SplitSize = _splitSize ?? SplitSize;
		__right.set_tabs(__tabs);
		__tabs = [];
		return self;
	}

	/// @func split_up([_splitSize])
	///
	/// @desc Splits the dock vertically, moving itself to the top and creating a new dock at the bottom.
	///
	/// @param {Real, Undefined} [_splitSize] New split size of the dock or `undefined` to keep the current value
	/// (default).
	///
	/// @return {Struct.FORMS_Dock} Returns `self`.
	static split_up = function (_splitSize = undefined)
	{
		__split(FORMS_EDockSplit.Vertical);
		SplitSize = _splitSize ?? SplitSize;
		__left.set_tabs(__tabs);
		__tabs = [];
		return self;
	}

	/// @func split_down([_splitSize])
	///
	/// @desc Splits the dock vertically, moving itself to the bottom and creating a new dock at the top.
	///
	/// @param {Real, Undefined} [_splitSize] New split size of the dock or `undefined` to keep the current value
	/// (default).
	///
	/// @return {Struct.FORMS_Dock} Returns `self`.
	static split_down = function (_splitSize = undefined)
	{
		__split(FORMS_EDockSplit.Vertical);
		SplitSize = _splitSize ?? SplitSize;
		__right.set_tabs(__tabs);
		__tabs = [];
		return self;
	}

	/// @func get_drop_zones([_zones])
	///
	/// @desc Recursively collects all valid drop zones for this dock and its children.
	///
	/// @param {Array<Struct.FORMS_DropZone>, Undefined} [_zones] Array to append to (created if undefined).
	///
	/// @return {Array<Struct.FORMS_DropZone>}
	static get_drop_zones = function (_zones = undefined)
	{
		_zones ??= [];

		// Branch node - recurse into children
		if (__left != undefined && __right != undefined)
		{
			__left.get_drop_zones(_zones);
			__right.get_drop_zones(_zones);
			return _zones;
		}

		// Leaf node - generate edge and tab bar zones
		var _edgeRatio = 0.25;
		var _edgeW = max(__realWidth * _edgeRatio, 30);
		var _edgeH = max(__realHeight * _edgeRatio, 30);

		// Left edge
		array_push(_zones, new FORMS_DropZone(
			FORMS_EDropZone.Left, self,
			__realX, __realY,
			_edgeW, __realHeight));

		// Right edge
		array_push(_zones, new FORMS_DropZone(
			FORMS_EDropZone.Right, self,
			__realX + __realWidth - _edgeW, __realY,
			_edgeW, __realHeight));

		// Top edge
		array_push(_zones, new FORMS_DropZone(
			FORMS_EDropZone.Top, self,
			__realX, __realY,
			__realWidth, _edgeH));

		// Bottom edge
		array_push(_zones, new FORMS_DropZone(
			FORMS_EDropZone.Bottom, self,
			__realX, __realY + __realHeight - _edgeH,
			__realWidth, _edgeH));

		// Tab bar zones (drop onto tab bar to add as tab)
		var _tc = __tabContainer;
		var _tabBarY = _tc.__tabHitY;
		var _tabBarH = _tc.__tabHitHeight;

		if (_tabBarH > 0)
		{
			// Tab insert zones (between tabs for specific positioning - smaller, higher priority)
			if (array_length(__tabs) > 0)
			{
				for (var i = 0; i <= array_length(__tabs); ++i)
				{
					var _insertX;
					if (i < array_length(_tc.__tabXPositions))
					{
						_insertX = _tc.__tabXPositions[i];
					}
					else if (i > 0 && i - 1 < array_length(_tc.__tabXPositions))
					{
						_insertX = _tc.__tabXPositions[i - 1] + _tc.__tabWidths[i - 1];
					}
					else
					{
						_insertX = __realX;
					}

					array_push(_zones, new FORMS_DropZone(
						FORMS_EDropZone.TabInsert, self,
						_insertX - 8, _tabBarY,
						16, _tabBarH,
						{ insertIndex: i }));
				}
			}

			// Full tab bar zone (add as last tab - larger, lower priority than insert zones)
			array_push(_zones, new FORMS_DropZone(
				FORMS_EDropZone.Center, self,
				__realX, _tabBarY,
				__realWidth, _tabBarH));
		}

		return _zones;
	}

	static find_widget = function (_id)
	{
		if (Id == _id)
		{
			return self;
		}

		var _found = __tabContainer.find_widget(_id);
		if (_found != undefined)
		{
			return _found;
		}

		if (__left != undefined)
		{
			_found = __left.find_widget(_id);
			if (_found != undefined)
			{
				return _found;
			}
		}

		if (__right != undefined)
		{
			_found = __right.find_widget(_id);
			if (_found != undefined)
			{
				return _found;
			}
		}

		for (var i = array_length(__tabs) - 1; i >= 0; --i)
		{
			_found = __tabs[i].find_widget(_id);
			if (_found != undefined)
			{
				return _found;
			}
		}

		return undefined;
	}

	static layout = function ()
	{
		FORMS_LAYOUT_GENERATED;

		var _style = forms_get_style();
		var _parentX = __realX;
		var _parentY = __realY;
		var _parentWidth = __realWidth;
		var _parentHeight = __realHeight;

		if (SplitType == FORMS_EDockSplit.Horizontal)
		{
			if (__resize)
			{
				SplitSize = (forms_mouse_get_x() - __realX + __mouseOffset) / __realWidth;
			}

			SplitSize = clamp(SplitSize, 0.1, 0.9);
			__splitterPos = round(__realX + __realWidth * SplitSize - _style.SplitterSize * 0.5);
		}
		else
		{
			if (__resize)
			{
				SplitSize = (forms_mouse_get_y() - __realY + __mouseOffset) / __realHeight;
			}

			SplitSize = clamp(SplitSize, 0.1, 0.9);
			__splitterPos = round(__realY + __realHeight * SplitSize - _style.SplitterSize * 0.5);
		}

		if (__resize && !mouse_check_button(mb_left))
		{
			forms_get_root().DragTarget = undefined;
			__resize = false;
		}

		if (__left == undefined && __right == undefined)
		{
			with(__tabContainer)
			{
				var _autoWidth = get_auto_width();
				var _autoHeight = get_auto_height();

				__realWidth = floor(Width.get_absolute(_parentWidth, _autoWidth));
				__realHeight = other.ShowTabs ? floor(Height.get_absolute(_parentHeight, _autoHeight)) : 0;
				__realX = floor(_parentX + X.get_absolute(_parentWidth, _autoWidth));
				__realY = floor(_parentY + Y.get_absolute(_parentHeight, _autoHeight));

				// Update hit-test region when dock renders its own tabs
				if (other.ShowTabs)
				{
					__tabHitY = __realY;
					__tabHitHeight = __realHeight;
				}
				// When ShowTabs is false (e.g., pop-out window), __tabHitY/Height are
				// set by WindowTitle.draw_content() and must NOT be overwritten here.

				layout();
			}

			if (__tabCurrent >= 0 && __tabCurrent < array_length(__tabs))
			{
				var _tab = __tabs[__tabCurrent];
				_tab.__realX = _parentX;
				_tab.__realY = _parentY + __tabContainer.__realHeight;
				_tab.__realWidth = _parentWidth;
				_tab.__realHeight = _parentHeight - __tabContainer.__realHeight;
				_tab.layout();
			}
		}
		else
		{
			if (__left != undefined)
			{
				if (__right == undefined)
				{
					__left.__realX = __realX;
					__left.__realY = __realY;
					__left.__realWidth = __realWidth;
					__left.__realHeight = __realHeight;
				}
				else if (SplitType == FORMS_EDockSplit.Horizontal)
				{
					__left.__realX = __realX;
					__left.__realY = __realY;
					__left.__realWidth = __splitterPos - __realX;
					__left.__realHeight = __realHeight;
				}
				else
				{
					__left.__realX = __realX;
					__left.__realY = __realY;
					__left.__realWidth = __realWidth;
					__left.__realHeight = __splitterPos - __realY;
				}

				__left.layout();
			}

			if (__right != undefined)
			{
				if (__left == undefined)
				{
					__right.__realX = __realX;
					__right.__realY = __realY;
					__right.__realWidth = __realWidth;
					__right.__realHeight = __realHeight;
				}
				else if (SplitType == FORMS_EDockSplit.Horizontal)
				{
					__right.__realX = __splitterPos + _style.SplitterSize;
					__right.__realY = __realY;
					__right.__realWidth = __realWidth - __right.__realX + __realX;
					__right.__realHeight = __realHeight;
				}
				else
				{
					__right.__realX = __realX;
					__right.__realY = __splitterPos + _style.SplitterSize;
					__right.__realWidth = __realWidth;
					__right.__realHeight = __realHeight - __right.__realY + __realY;
				}

				__right.layout();
			}
		}

		return self;
	}

	static update = function (_deltaTime)
	{
		Widget_update(_deltaTime);

		var _root = forms_get_root();
		var _style = _root.Style;
		var _mousePos = (SplitType == FORMS_EDockSplit.Horizontal)
			? forms_mouse_get_x() : forms_mouse_get_y();

		__splitterIsHovered = (__left != undefined
			&& __right != undefined
			&& is_mouse_over()
			&& _root.DragTarget == undefined
			&& _mousePos > __splitterPos
			&& _mousePos < __splitterPos + _style.SplitterSize);

		var _resize = __resize;

		if (__splitterIsHovered)
		{
			_resize = true;

			if (forms_mouse_check_button_pressed(mb_left))
			{
				__mouseOffset = __splitterPos + _style.SplitterSize * 0.5 - _mousePos;
				_root.DragTarget = self;
				__resize = true;
			}
		}

		if (_resize)
		{
			forms_set_cursor((SplitType == FORMS_EDockSplit.Horizontal) ? cr_size_we : cr_size_ns);
		}

		if (__left == undefined && __right == undefined)
		{
			// Tab drag detection (using absolute coordinates from previous frame's draw)
			var _tabDrag = forms_get_tab_drag();
			if (!_tabDrag.Active && _root.DragTarget == undefined)
			{
				var _tc = __tabContainer;
				var _mx = window_mouse_get_x();
				var _my = window_mouse_get_y();
				var _dragState = _root.DragState;

				// Detect mouse press on a tab (non-consuming raw check)
				if (mouse_check_button_pressed(mb_left)
					&& array_length(_tc.__tabXPositions) > 0
					&& _tc.__tabHitHeight > 0)
				{
					for (var _ti = 0; _ti < array_length(_tc.__tabXPositions); ++_ti)
					{
						if (_mx >= _tc.__tabXPositions[_ti]
							&& _mx < _tc.__tabXPositions[_ti] + _tc.__tabWidths[_ti]
							&& _my >= _tc.__tabHitY
							&& _my < _tc.__tabHitY + _tc.__tabHitHeight)
						{
							_tc.__pressedTabIndex = _ti;
							_tc.__pressedMouseX = _mx;
							_tc.__pressedMouseY = _my;
							break;
						}
					}
				}

				// When threshold exceeded, decide: reorder (within tab bar) or full drag (outside)
				if (_tc.__pressedTabIndex >= 0 && mouse_check_button(mb_left))
				{
					var _dist = point_distance(_mx, _my, _tc.__pressedMouseX, _tc.__pressedMouseY);
					var _inTabBar = (_my >= _tc.__tabHitY && _my < _tc.__tabHitY + _tc.__tabHitHeight);

					if (_dist > 8)
					{
						if (!_inTabBar)
						{
							// Mouse left tab bar vertically → full drag
							var _pi = _tc.__pressedTabIndex;
							if (_pi < array_length(__tabs))
							{
								_tabDrag.start(__tabs[_pi], _pi, self,
									_tc.__tabXPositions[_pi], _tc.__tabWidths[_pi]);
								_root.DragTarget = _tabDrag;
							}
							_tc.__pressedTabIndex = -1;
							_tc.__reorderActive = false;
						}
						else
						{
							// Mouse still in tab bar → reorder mode
							_tc.__reorderActive = true;
							var _pi = _tc.__pressedTabIndex;
							if (_pi < array_length(__tabs) && _pi < array_length(_tc.__tabXPositions))
							{
								// Visual offset: mouse position relative to tab's normal position
								_tc.__reorderOffsetX = _mx - (_tc.__tabXPositions[_pi] + _tc.__tabWidths[_pi] * 0.5);

								// Find which tab position the mouse is over
								for (var _ri = 0; _ri < array_length(_tc.__tabXPositions); ++_ri)
								{
									var _tabMid = _tc.__tabXPositions[_ri] + _tc.__tabWidths[_ri] * 0.5;
									var _swapped = false;
									if (_mx < _tabMid && _ri < _pi)
									{
										// Move tab left
										var _moving = __tabs[_pi];
										array_delete(__tabs, _pi, 1);
										array_insert(__tabs, _ri, _moving);
										__tabCurrent = _ri;
										_tc.__pressedTabIndex = _ri;
										_swapped = true;
									}
									else if (_mx >= _tabMid && _ri > _pi)
									{
										// Move tab right
										var _moving = __tabs[_pi];
										array_delete(__tabs, _pi, 1);
										array_insert(__tabs, _ri, _moving);
										__tabCurrent = _ri;
										_tc.__pressedTabIndex = _ri;
										_swapped = true;
									}

									if (_swapped)
									{
										// Recalculate positions immediately to prevent 1-frame jump
										var _movingW = _tc.__tabWidths[_pi];
										array_delete(_tc.__tabWidths, _pi, 1);
										array_insert(_tc.__tabWidths, _ri, _movingW);
										for (var _qi = 1; _qi < array_length(_tc.__tabXPositions); ++_qi)
										{
											_tc.__tabXPositions[_qi] = _tc.__tabXPositions[_qi - 1] + _tc.__tabWidths[_qi - 1];
										}
										// Recalculate visual offset with updated position
										_tc.__reorderOffsetX = _mx - (_tc.__tabXPositions[_ri] + _tc.__tabWidths[_ri] * 0.5);
										break;
									}
								}
							}
						}
					}
				}

				// Reset when mouse released
				if (!mouse_check_button(mb_left))
				{
					_tc.__pressedTabIndex = -1;
					_tc.__reorderActive = false;
				}
			}

			__tabContainer.update(_deltaTime);

			if (__tabCurrent >= 0 && __tabCurrent < array_length(__tabs))
			{
				var _tab = __tabs[__tabCurrent];
				_tab.update(_deltaTime);
			}
		}
		else
		{
			if (__left != undefined)
			{
				__left.update(_deltaTime);
			}

			if (__right != undefined)
			{
				__right.update(_deltaTime);
			}
		}

		return self;
	}

	static draw = function ()
	{
		var _root = forms_get_root();
		var _style = _root.Style;
		var _color = (_root.DragTarget == self) ? _style.Accent.get()
			: (__splitterIsHovered ? _style.Background[3].get() : _style.Background[1].get());

		forms_draw_rectangle(__realX, __realY, __realWidth, __realHeight, _style.Background[1].get());

		if (__left != undefined && __right != undefined)
		{
			if (SplitType == FORMS_EDockSplit.Horizontal)
			{
				forms_draw_rectangle(__splitterPos, __realY, _style.SplitterSize, __realHeight, _color);
			}
			else
			{
				forms_draw_rectangle(__realX, __splitterPos, __realWidth, _style.SplitterSize, _color);
			}
		}

		if (__left == undefined && __right == undefined)
		{
			var _tabCurrent = __tabCurrent; // Backup before it changes!
			__tabContainer.draw();

			// Draw reordering tab as overlay (outside surface to avoid alpha issues)
			var _tc = __tabContainer;
			if (_tc.__reorderActive && _tc.__pressedTabIndex >= 0
				&& _tc.__pressedTabIndex < array_length(__tabs))
			{
				var _pi = _tc.__pressedTabIndex;
				var _tab = __tabs[_pi];
				var _tabPadding = _style.Padding + 1;
				var _iconSpace = (_tab.Icon != undefined) ? 24 : 0;
				var _tabWidth = (_pi < array_length(_tc.__tabWidths)) ? _tc.__tabWidths[_pi] : 100;
				var _tabX = _tc.__tabXPositions[_pi] + _tc.__reorderOffsetX;
				var _tabY = _tc.__tabHitY;
				var _tabH = _tc.__tabHitHeight;

				draw_sprite_stretched_ext(
					FORMS_SprTab, 0,
					_tabX, _tabY,
					_tabWidth, _tabH,
					_style.Background[2].get(), 1.0);

				var _contentX = _tabX + _tabPadding;
				var _contentY = _tabY + 3;
				if (_tab.Icon != undefined)
				{
					fa_draw(_tab.IconFont, _tab.Icon, _contentX, _contentY, _style.Text.get());
					_contentX += _iconSpace;
				}
				draw_set_font(_style.Font);
				forms_draw_text(_contentX, _contentY, _tab.Name, _style.Text.get());
			}

			if (_tabCurrent >= 0 && _tabCurrent < array_length(__tabs))
			{
				__tabs[_tabCurrent].draw();
			}
		}
		else
		{
			if (__left != undefined)
			{
				__left.draw();
			}

			if (__right != undefined)
			{
				__right.draw();
			}
		}

		return self;
	}
}

/// @func FORMS_DockTabsProps()
///
/// @extends FORMS_ContainerProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_DockTabs}.
function FORMS_DockTabsProps(): FORMS_ContainerProps() constructor {}

/// @func FORMS_DockTabs([_props])
///
/// @extends FORMS_Container
///
/// @desc A container for tabs added to a {@link FORMS_Dock}.
///
/// @params {Struct.FORMS_DockTabsProps, Undefined} [_props]
function FORMS_DockTabs(_props = undefined): FORMS_Container(_props) constructor
{
	/// @var {Struct.FORMS_UnitValue} The containers's width. Defaults to
	/// 100%.
	Width = Width.from_props(_props, "Width", 100, FORMS_EUnit.Percent);

	/// @var {Struct.FORMS_UnitValue} The container's height. Defaults to
	/// 24px.
	Height = Height.from_props(_props, "Height", 24);

	/// @var {Real}
	BackgroundColorIndex = 1;

	/// @var {Bool} Whether the default scrolling direction of the container is vertical (`true`) or horizontal
	/// (`false`). Defaults to `false`.
	IsDefaultScrollVertical = forms_get_prop(_props, "IsDefaultScrollVertical") ?? false;

	/// @var {Array<Real>} Absolute X positions of each tab (for drag detection).
	/// @private
	__tabXPositions = [];

	/// @var {Array<Real>} Widths of each tab (for drag detection).
	/// @private
	__tabWidths = [];

	/// @var {Real} Tab index that was under mouse when pressed, or -1.
	/// @private
	__pressedTabIndex = -1;

	/// @var {Real} Mouse X when tab was pressed (for drag threshold).
	/// @private
	__pressedMouseX = 0;

	/// @var {Real} Mouse Y when tab was pressed (for drag threshold).
	/// @private
	__pressedMouseY = 0;

	/// @var {Bool} Whether a tab is currently being reordered by dragging within the tab bar.
	/// @private
	__reorderActive = false;

	/// @var {Real} The horizontal offset to apply to the reordered tab's draw position.
	/// @private
	__reorderOffsetX = 0;

	/// @var {Real} Absolute Y of the tab hit-test region (may differ from __realY when tabs render in a window title bar).
	/// @private
	__tabHitY = 0;

	/// @var {Real} Height of the tab hit-test region.
	/// @private
	__tabHitHeight = 0;

	static draw_content = function ()
	{
		var _style = forms_get_style();
		var _dock = Parent;
		var _tabs = _dock.__tabs;
		var _tabCount = array_length(_tabs);
		var _tabCurrent = _dock.__tabCurrent;
		var _tabIndex = 0;
		var _tabDrag = forms_get_tab_drag();

		var _tabPadding = _style.Padding + 1;
		Pen.PaddingX = 0;
		Pen.PaddingY = 3;
		Pen.start();

		// Resize position tracking arrays
		array_resize(__tabXPositions, _tabCount);
		array_resize(__tabWidths, _tabCount);

		repeat(_tabCount)
		{
			var _tab = _tabs[_tabIndex];
			var _iconSpace = ((_tab.Icon != undefined) ? 24 : 0);
			var _tabStartX = Pen.X;

			// Compute tab visual width
			var _tabWidth = _tabPadding
				+ _iconSpace
				+ string_width(_tab.Name) + 4 + 16
				+ _tabPadding;

			// Store absolute position for drag detection in Dock.update()
			__tabXPositions[_tabIndex] = __realX + _tabStartX - ScrollX;
			__tabWidths[_tabIndex] = _tabWidth;

			// Skip drawing tabs that are being dragged or reordered (drawn as overlay instead)
			if ((_tabDrag.Active && _tabDrag.SourceDock == _dock && _tabDrag.TabIndex == _tabIndex)
				|| (__reorderActive && _tabIndex == __pressedTabIndex))
			{
				Pen.move(_tabWidth);
				++_tabIndex;
				continue;
			}

			if (_tabCurrent == _tabIndex)
			{
				draw_sprite_stretched_ext(
					FORMS_SprTab, 0,
					Pen.X, 0,
					_tabWidth,
					__realHeight,
					_style.Background[2].get(), 1.0);
			}
			Pen.move(_tabPadding);
			if (_tab.Icon != undefined)
			{
				fa_draw(_tab.IconFont, _tab.Icon, Pen.X, Pen.Y, (_tabIndex == _tabCurrent) ? _style.Text
					.get()
					: _style.TextMuted.get());
				Pen.move(_iconSpace);
			}
			if (Pen.link(_tab.Name, { Muted: (_tabIndex != _tabCurrent) }))
			{
				_tabCurrent = _tabIndex;
				_dock.__tabCurrent = _tabCurrent;
			}
			Pen.move(4);
			if (Pen.icon_solid(FA_ESolid.Xmark, { Width: 16, Muted: true }))
			{
				_tab.Parent = undefined;
				_tab.destroy();

				array_delete(_tabs, _tabIndex--, 1);
				--_tabCount;

				_tabCurrent = clamp(_tabCurrent, 0, _tabCount - 1);
				_dock.__tabCurrent = _tabCurrent;

				// If dock is now empty, clean up
				if (_tabCount == 0)
				{
					forms_get_tab_drag().__cleanup_source(_dock, undefined);
				}
			}
			Pen.move(_tabPadding);
			++_tabIndex;
		}

		Pen.finish();
		ContentWidth = Pen.get_max_x();
		return self;
	}
}
