global.ksPreferences = new FORMS_KeyboardShortcut(
	[vk_control, vk_shift, ord("P")], undefined,
	function ()
	{
		if (global.testPreferencesWindow.Parent == undefined)
		{
			forms_get_root().add_child(global.testPreferencesWindow);
		}
	});

/// @func __test_find_first_leaf_dock(_widget)
///
/// @desc Walks a widget tree to find the first leaf dock (a dock with tabs, not split).
///
/// @param {Struct} _widget Widget to search from.
///
/// @return {Struct.FORMS_Dock, Undefined}
function __test_find_first_leaf_dock(_widget)
{
	// If this is a dock
	if (variable_struct_exists(_widget, "__tabs") && variable_struct_exists(_widget, "__left"))
	{
		// Leaf dock
		if (_widget.__left == undefined)
		{
			return _widget;
		}
		// Branch - search children
		var _found = __test_find_first_leaf_dock(_widget.__left);
		if (_found != undefined) return _found;
		return __test_find_first_leaf_dock(_widget.__right);
	}

	// CompoundWidget children
	if (variable_struct_exists(_widget, "Children"))
	{
		for (var i = 0; i < array_length(_widget.Children); ++i)
		{
			var _found = __test_find_first_leaf_dock(_widget.Children[i]);
			if (_found != undefined) return _found;
		}
	}

	// Workspace / widget with tabs (traverse current tab)
	if (variable_struct_exists(_widget, "__tabs") && variable_struct_exists(_widget, "__tabCurrent"))
	{
		var _tabCurrent = _widget.__tabCurrent;
		if (_tabCurrent >= 0 && _tabCurrent < array_length(_widget.__tabs))
		{
			var _found = __test_find_first_leaf_dock(_widget.__tabs[_tabCurrent]);
			if (_found != undefined) return _found;
		}
	}

	// Window widget
	if (variable_struct_exists(_widget, "Widget") && _widget.Widget != undefined)
	{
		var _found = __test_find_first_leaf_dock(_widget.Widget);
		if (_found != undefined) return _found;
	}

	return undefined;
}

// =========================================================================
// Scene Hierarchy Panel
// =========================================================================

/// @func TestSceneNode(_name[, _icon[, _children]])
function TestSceneNode(_name, _icon = FA_ESolid.Cube, _children = undefined) constructor
{
	Name = _name;
	Icon = _icon;
	Children = _children;
	Expanded = false;
	Selected = false;
	Visible = true;
	Depth = 0;
}

/// @func TestSceneHierarchy([_props])
function TestSceneHierarchy(_props = undefined): FORMS_ScrollPane(_props) constructor
{
	Name = "Scene Hierarchy";
	Icon = FA_ESolid.Sitemap;
	Pen.PaddingX = 4;
	Pen.PaddingY = 4;
	BackgroundColorIndex = 2;

	/// @var {Array<Struct.TestSceneNode>} Root nodes.
	Nodes = [];

	/// @var {Struct.TestSceneNode, Undefined} Currently selected node.
	SelectedNode = undefined;

	/// @var {String} Search filter.
	SearchFilter = "";

	/// @var {Array<Struct.TestSceneNode>} Flattened visible node list (rebuilt when tree changes).
	/// @private
	__flatList = [];

	/// @var {Bool}
	/// @private
	__dirty = true;

	/// @func add_node(_node[, _parent])
	static add_node = function (_node, _parent = undefined)
	{
		if (_parent == undefined)
		{
			array_push(Nodes, _node);
		}
		else
		{
			_parent.Children ??= [];
			array_push(_parent.Children, _node);
		}
		__dirty = true;
		return self;
	}

	/// @private
	static __rebuild_flat_list = function ()
	{
		__flatList = [];
		var _filter = string_lower(SearchFilter);
		for (var i = 0; i < array_length(Nodes); ++i)
		{
			__flatten_node(Nodes[i], 0, _filter);
		}
		__dirty = false;
	}

	/// @private
	static __flatten_node = function (_node, _depth, _filter)
	{
		_node.Depth = _depth;

		if (_filter != "")
		{
			// When filtering, show all matching nodes regardless of expand state
			var _matches = (string_pos(_filter, string_lower(_node.Name)) > 0);
			var _childMatches = false;

			if (is_array(_node.Children))
			{
				for (var i = 0; i < array_length(_node.Children); ++i)
				{
					if (__node_matches_filter(_node.Children[i], _filter))
					{
						_childMatches = true;
						break;
					}
				}
			}

			if (_matches || _childMatches)
			{
				array_push(__flatList, _node);
				if (is_array(_node.Children))
				{
					for (var i = 0; i < array_length(_node.Children); ++i)
					{
						__flatten_node(_node.Children[i], _depth + 1, _filter);
					}
				}
			}
		}
		else
		{
			array_push(__flatList, _node);
			if (_node.Expanded && is_array(_node.Children))
			{
				for (var i = 0; i < array_length(_node.Children); ++i)
				{
					__flatten_node(_node.Children[i], _depth + 1, _filter);
				}
			}
		}
	}

	/// @private
	static __node_matches_filter = function (_node, _filter)
	{
		if (string_pos(_filter, string_lower(_node.Name)) > 0) return true;
		if (is_array(_node.Children))
		{
			for (var i = 0; i < array_length(_node.Children); ++i)
			{
				if (__node_matches_filter(_node.Children[i], _filter)) return true;
			}
		}
		return false;
	}

	static draw_content = function ()
	{
		var _style = forms_get_style();
		if (__dirty) __rebuild_flat_list();

		var _lineH = string_height("M");
		var _indent = 16;
		var _nodeCount = array_length(__flatList);

		Pen.start();

		// Search bar
		var _padX = Pen.PaddingX ?? _style.Padding;
		var _hasSearch = (SearchFilter != "");
		var _clearW = _hasSearch ? 20 : 0;
		if (Pen.input("scene-search", SearchFilter,
			{
				Width: Pen.Width - _clearW,
				Placeholder: "Search hierarchy..."
			}))
		{
			SearchFilter = Pen.get_result();
			__dirty = true;
		}
		if (_hasSearch)
		{
			if (Pen.icon_solid(FA_ESolid.Xmark, { Width: 20, Muted: true }))
			{
				SearchFilter = "";
				__dirty = true;
			}
		}
		Pen.nl();

		// Virtual scrolling
		var _listStartY = Pen.Y;
		var _visibleTop = ScrollY;
		var _visibleBottom = ScrollY + __realHeight;
		var _firstVisible = max(floor((_visibleTop - _listStartY) / _lineH), 0);
		var _lastVisible = min(ceil((_visibleBottom - _listStartY) / _lineH), _nodeCount - 1);

		Pen.Y = _listStartY + _firstVisible * _lineH;

		for (var i = _firstVisible; i <= _lastVisible; ++i)
		{
			var _node = __flatList[i];
			var _x = Pen.X + _node.Depth * _indent;
			var _hasChildren = (is_array(_node.Children) && array_length(_node.Children) > 0);

			// Selection highlight
			if (_node.Selected)
			{
				forms_draw_rectangle(Pen.X, Pen.Y, Pen.Width, _lineH, _style.Highlight.get());
			}

			// Hover
			var _mouseOver = Pen.is_mouse_over(Pen.X, Pen.Y, Pen.Width, _lineH);
			if (_mouseOver)
			{
				if (!_node.Selected)
				{
					forms_draw_rectangle(Pen.X, Pen.Y, Pen.Width, _lineH, _style.Background[3].get(), 0.5);
				}

				if (forms_left_click())
				{
					// Deselect previous
					if (SelectedNode != undefined) SelectedNode.Selected = false;
					_node.Selected = true;
					SelectedNode = _node;
				}
			}

			// Expand caret
			if (_hasChildren)
			{
				var _caretIcon = _node.Expanded ? FA_ESolid.CaretDown : FA_ESolid.CaretRight;
				var _caretOver = Pen.is_mouse_over(_x, Pen.Y, 12, _lineH);
				fa_draw(FA_FntSolid12, _caretIcon, _x, Pen.Y,
					_caretOver ? _style.Text.get() : _style.TextMuted.get());
				if (_caretOver && forms_left_click())
				{
					_node.Expanded = !_node.Expanded;
					__dirty = true;
				}
			}

			// Visibility toggle
			var _visIcon = _node.Visible ? FA_ESolid.Eye : FA_ESolid.EyeSlash;
			var _visX = Pen.X + Pen.Width - 16;
			var _visOver = Pen.is_mouse_over(_visX, Pen.Y, 16, _lineH);
			fa_draw(FA_FntSolid12, _visIcon, _visX, Pen.Y,
				_node.Visible ? _style.TextMuted.get() : _style.Background[3].get());
			if (_visOver && forms_left_click())
			{
				_node.Visible = !_node.Visible;
			}

			// Icon + name
			var _iconX = _x + 14;
			fa_draw(FA_FntSolid12, _node.Icon, _iconX, Pen.Y,
				_node.Selected ? _style.Text.get() : _style.TextMuted.get());
			forms_draw_text(_iconX + 18, Pen.Y, _node.Name,
				_node.Selected ? _style.Text.get() : _style.TextMuted.get());

			Pen.Y += _lineH;
		}

		// Total content size
		Pen.MaxY = max(Pen.MaxY, _listStartY + _nodeCount * _lineH);

		Pen.finish();
		FORMS_CONTENT_UPDATE_SIZE;
		return self;
	}
}

// =========================================================================
// Details / Properties Panel
// =========================================================================

/// @func TestDetailsPanel([_props])
function TestDetailsPanel(_props = undefined): FORMS_ScrollPane(_props) constructor
{
	Name = "Details";
	Icon = FA_ESolid.CircleInfo;
	Pen.PaddingX = 8;
	Pen.PaddingY = 8;
	BackgroundColorIndex = 2;

	/// @var {Struct.TestSceneHierarchy, Undefined} Linked scene hierarchy to read selection from.
	SceneHierarchy = undefined;

	// Transform
	PositionX = 0;
	PositionY = 0;
	PositionZ = 0;
	RotationX = 0;
	RotationY = 0;
	RotationZ = 0;
	ScaleX = 1;
	ScaleY = 1;
	ScaleZ = 1;

	// Mesh Renderer
	MeshCastShadows = true;
	MeshReceiveShadows = true;
	MeshMaterial = "Default-Material";
	MeshSortingOrder = 0;

	// Rigidbody
	RbMass = 1.0;
	RbDrag = 0.0;
	RbAngularDrag = 0.05;
	RbUseGravity = true;
	RbIsKinematic = false;
	RbInterpolation = "None";
	RbCollisionDetection = "Discrete";

	// Collider
	ColliderType = "Box";
	ColliderIsTrigger = false;
	ColliderCenterX = 0;
	ColliderCenterY = 0;
	ColliderCenterZ = 0;
	ColliderSizeX = 1;
	ColliderSizeY = 1;
	ColliderSizeZ = 1;

	// Audio Source
	AudioClip = "(none)";
	AudioVolume = 1.0;
	AudioPitch = 1.0;
	AudioSpatialBlend = 0.0;
	AudioLoop = false;
	AudioPlayOnAwake = true;

	// Light
	LightType = "Directional";
	LightColorR = 255;
	LightColorG = 244;
	LightColorB = 214;
	LightIntensity = 1.0;
	LightRange = 10.0;
	LightCastShadows = true;

	static draw_content = function ()
	{
		var _style = forms_get_style();
		Pen.start();

		var _node = (SceneHierarchy != undefined) ? SceneHierarchy.SelectedNode : undefined;

		if (_node == undefined)
		{
			Pen.text("No object selected", { Muted: true }).nl();
			Pen.finish();
			FORMS_CONTENT_UPDATE_SIZE;
			return self;
		}

		// Header
		fa_draw(FA_FntSolid12, _node.Icon, Pen.X, Pen.Y, _style.Text.get());
		Pen.move(20);
		Pen.text(_node.Name).nl();
		Pen.nl();

		// Transform section
		if (Pen.section("Transform"))
		{
			var _colR = 0x3333DD; // Red (BGR)
			var _colG = 0x33DD33; // Green (BGR)
			var _colB = 0xDD5533; // Blue (BGR)

			Pen.set_layout(FORMS_EPenLayout.Column2);
			var _gap = 2;
			var _availW = Pen.Width + Pen.StartX - Pen.ColumnX2;
			var _inputW = floor((_availW - _gap * 2) / 3);

			Pen.text("Position", { Muted: true });
			Pen.next();
			if (Pen.input("pos-x", PositionX, { Ribbon: _colR, Width: _inputW }))
			{
				PositionX = Pen
					.get_result();
			}
			Pen.move(_gap);
			if (Pen.input("pos-y", PositionY, { Ribbon: _colG, Width: _inputW }))
			{
				PositionY = Pen
					.get_result();
			}
			Pen.move(_gap);
			if (Pen.input("pos-z", PositionZ, { Ribbon: _colB, Width: _inputW }))
			{
				PositionZ = Pen
					.get_result();
			}
			Pen.next();

			Pen.text("Rotation", { Muted: true });
			Pen.next();
			if (Pen.input("rot-x", RotationX, { Ribbon: _colR, Width: _inputW }))
			{
				RotationX = Pen
					.get_result();
			}
			Pen.move(_gap);
			if (Pen.input("rot-y", RotationY, { Ribbon: _colG, Width: _inputW }))
			{
				RotationY = Pen
					.get_result();
			}
			Pen.move(_gap);
			if (Pen.input("rot-z", RotationZ, { Ribbon: _colB, Width: _inputW }))
			{
				RotationZ = Pen
					.get_result();
			}
			Pen.next();

			Pen.text("Scale", { Muted: true });
			Pen.next();
			if (Pen.input("scl-x", ScaleX, { Ribbon: _colR, Width: _inputW })) { ScaleX = Pen.get_result(); }
			Pen.move(_gap);
			if (Pen.input("scl-y", ScaleY, { Ribbon: _colG, Width: _inputW })) { ScaleY = Pen.get_result(); }
			Pen.move(_gap);
			if (Pen.input("scl-z", ScaleZ, { Ribbon: _colB, Width: _inputW })) { ScaleZ = Pen.get_result(); }
			Pen.next();

			Pen.end_section();
		}

		// Mesh Renderer
		if (Pen.section("Mesh Renderer"))
		{
			Pen.set_layout(FORMS_EPenLayout.Column2);

			Pen.text("Material", { Muted: true });
			Pen.next();
			if (Pen.input("mesh-mat", MeshMaterial)) { MeshMaterial = Pen.get_result(); }
			Pen.next();

			Pen.text("Cast Shadows", { Muted: true });
			Pen.next();
			if (Pen.checkbox(MeshCastShadows)) { MeshCastShadows = !MeshCastShadows; }
			Pen.next();

			Pen.text("Receive Shadows", { Muted: true });
			Pen.next();
			if (Pen.checkbox(MeshReceiveShadows)) { MeshReceiveShadows = !MeshReceiveShadows; }
			Pen.next();

			Pen.text("Sorting Order", { Muted: true });
			Pen.next();
			if (Pen.input("mesh-sort", MeshSortingOrder)) { MeshSortingOrder = Pen.get_result(); }
			Pen.next();

			Pen.end_section();
		}

		// Rigidbody
		if (Pen.section("Rigidbody"))
		{
			Pen.set_layout(FORMS_EPenLayout.Column2);

			Pen.text("Mass", { Muted: true });
			Pen.next();
			if (Pen.input("rb-mass", RbMass)) { RbMass = Pen.get_result(); }
			Pen.next();

			Pen.text("Drag", { Muted: true });
			Pen.next();
			if (Pen.input("rb-drag", RbDrag)) { RbDrag = Pen.get_result(); }
			Pen.next();

			Pen.text("Angular Drag", { Muted: true });
			Pen.next();
			if (Pen.input("rb-angdrag", RbAngularDrag)) { RbAngularDrag = Pen.get_result(); }
			Pen.next();

			Pen.text("Use Gravity", { Muted: true });
			Pen.next();
			if (Pen.checkbox(RbUseGravity)) { RbUseGravity = !RbUseGravity; }
			Pen.next();

			Pen.text("Is Kinematic", { Muted: true });
			Pen.next();
			if (Pen.checkbox(RbIsKinematic)) { RbIsKinematic = !RbIsKinematic; }
			Pen.next();

			Pen.text("Interpolation", { Muted: true });
			Pen.next();
			if (Pen.dropdown("rb-interp", RbInterpolation, ["None", "Interpolate",
					"Extrapolate"
				])) { RbInterpolation = Pen.get_result(); }
			Pen.next();

			Pen.text("Collision", { Muted: true });
			Pen.next();
			if (Pen.dropdown("rb-collision", RbCollisionDetection, ["Discrete", "Continuous",
					"Continuous Dynamic"
				])) { RbCollisionDetection = Pen.get_result(); }
			Pen.next();

			Pen.end_section();
		}

		// Collider
		if (Pen.section("Box Collider"))
		{
			var _colR = 0x3333DD;
			var _colG = 0x33DD33;
			var _colB = 0xDD5533;
			var _gap = 2;
			Pen.set_layout(FORMS_EPenLayout.Column2);
			var _availW = Pen.Width + Pen.StartX - Pen.ColumnX2;
			var _inputW = floor((_availW - _gap * 2) / 3);

			Pen.text("Is Trigger", { Muted: true });
			Pen.next();
			if (Pen.checkbox(ColliderIsTrigger)) { ColliderIsTrigger = !ColliderIsTrigger; }
			Pen.next();

			Pen.text("Center", { Muted: true });
			Pen.next();
			if (Pen.input("col-cx", ColliderCenterX, { Ribbon: _colR, Width: _inputW }))
			{
				ColliderCenterX = Pen
					.get_result();
			}
			Pen.move(_gap);
			if (Pen.input("col-cy", ColliderCenterY, { Ribbon: _colG, Width: _inputW }))
			{
				ColliderCenterY = Pen
					.get_result();
			}
			Pen.move(_gap);
			if (Pen.input("col-cz", ColliderCenterZ, { Ribbon: _colB, Width: _inputW }))
			{
				ColliderCenterZ = Pen
					.get_result();
			}
			Pen.next();

			Pen.text("Size", { Muted: true });
			Pen.next();
			if (Pen.input("col-sx", ColliderSizeX, { Ribbon: _colR, Width: _inputW }))
			{
				ColliderSizeX = Pen
					.get_result();
			}
			Pen.move(_gap);
			if (Pen.input("col-sy", ColliderSizeY, { Ribbon: _colG, Width: _inputW }))
			{
				ColliderSizeY = Pen
					.get_result();
			}
			Pen.move(_gap);
			if (Pen.input("col-sz", ColliderSizeZ, { Ribbon: _colB, Width: _inputW }))
			{
				ColliderSizeZ = Pen
					.get_result();
			}
			Pen.next();

			Pen.end_section();
		}

		// Audio Source
		if (Pen.section("Audio Source"))
		{
			Pen.set_layout(FORMS_EPenLayout.Column2);

			Pen.text("Clip", { Muted: true });
			Pen.next();
			if (Pen.input("audio-clip", AudioClip)) { AudioClip = Pen.get_result(); }
			Pen.next();

			Pen.text("Volume", { Muted: true });
			Pen.next();
			if (Pen.slider("audio-vol", AudioVolume, 0, 1)) { AudioVolume = Pen.get_result(); }
			Pen.next();

			Pen.text("Pitch", { Muted: true });
			Pen.next();
			if (Pen.slider("audio-pitch", AudioPitch, -3, 3)) { AudioPitch = Pen.get_result(); }
			Pen.next();

			Pen.text("Spatial Blend", { Muted: true });
			Pen.next();
			if (Pen.slider("audio-spatial", AudioSpatialBlend, 0, 1,
				{
					Pre: "2D ",
					Post: " 3D"
				})) { AudioSpatialBlend = Pen.get_result(); }
			Pen.next();

			Pen.text("Loop", { Muted: true });
			Pen.next();
			if (Pen.checkbox(AudioLoop)) { AudioLoop = !AudioLoop; }
			Pen.next();

			Pen.text("Play On Awake", { Muted: true });
			Pen.next();
			if (Pen.checkbox(AudioPlayOnAwake)) { AudioPlayOnAwake = !AudioPlayOnAwake; }
			Pen.next();

			Pen.end_section();
		}

		// Light
		if (Pen.section("Light"))
		{
			Pen.set_layout(FORMS_EPenLayout.Column2);

			Pen.text("Type", { Muted: true });
			Pen.next();
			if (Pen.dropdown("light-type", LightType, ["Directional", "Point", "Spot", "Area"]))
			{
				LightType =
					Pen.get_result();
			}
			Pen.next();

			Pen.text("Color", { Muted: true });
			Pen.next();
			var _lightColor = new FORMS_Color(make_color_rgb(LightColorR, LightColorG, LightColorB));
			if (Pen.color("light-color", _lightColor))
			{
				var _result = Pen.get_result();
				LightColorR = colour_get_red(_result.get());
				LightColorG = colour_get_green(_result.get());
				LightColorB = colour_get_blue(_result.get());
			}
			Pen.next();

			Pen.text("Intensity", { Muted: true });
			Pen.next();
			if (Pen.slider("light-intensity", LightIntensity, 0, 10)) { LightIntensity = Pen.get_result(); }
			Pen.next();

			Pen.text("Range", { Muted: true });
			Pen.next();
			if (Pen.input("light-range", LightRange)) { LightRange = Pen.get_result(); }
			Pen.next();

			Pen.text("Cast Shadows", { Muted: true });
			Pen.next();
			if (Pen.checkbox(LightCastShadows)) { LightCastShadows = !LightCastShadows; }
			Pen.next();

			Pen.end_section();
		}

		// Rendering
		if (Pen.section("Rendering"))
		{
			Pen.set_layout(FORMS_EPenLayout.Column2);

			Pen.text("Visible", { Muted: true });
			Pen.next();
			if (Pen.checkbox(_node.Visible))
			{
				_node.Visible = !_node.Visible;
			}
			Pen.next();

			Pen.end_section();
		}

		Pen.finish();
		FORMS_CONTENT_UPDATE_SIZE;
		return self;
	}
}

function TestWindowContextMenu(): FORMS_ContextMenu() constructor
{
	var _options = Options;

	var _option = new FORMS_ContextMenuOption("Controls Test");
	_option.Icon = FA_ESolid.List;
	_option.Action = function ()
	{
		var _tab = new TestControlsScrollPane();
		var _dock = new FORMS_Dock({ ShowTabs: false });
		_dock.__tabs = [_tab];
		_tab.Parent = _dock;
		var _window = new FORMS_Window(_dock,
		{
			Center: true,
			Width: 600,
			Height: 400,
		});
		forms_get_root().add_child(_window);
	};
	array_push(_options, _option);

	_option = new FORMS_ContextMenuOption("Viewport");
	_option.Icon = FA_ESolid.Camera;
	_option.Action = function ()
	{
		forms_open_single_instance("viewport", function ()
		{
			return new FORMS_ApplicationSurface(
			{
				Name: "Viewport",
				Icon: FA_ESolid.Camera,
				Width: "100%",
				Height: "100%",
			});
		});
	};
	array_push(_options, _option);

	array_push(_options, new FORMS_ContextMenuSeparator());

	_option = new FORMS_ContextMenuOption("Preferences");
	_option.KeyboardShortcut = global.ksPreferences;
	_option.Action = function ()
	{
		if (global.testPreferencesWindow.Parent == undefined)
		{
			forms_get_root().add_child(global.testPreferencesWindow);
		}
	};
	array_push(_options, _option);
}

function TestWorkspace(): FORMS_FlexBox() constructor
{
	Name = "Test Workspace";
	Icon = FA_ESolid.WindowMaximize;
	Width.from_string("100%");
	Height.from_string("100%");
	Flex = 1;
	Spacing.Value = 1;
	IsHorizontal = false;
	KeyboardShortcuts = [global.ksPreferences];

	var _menu = new FORMS_MenuBar([
		new FORMS_MenuBarItem("File", FileContextMenu),
		new FORMS_MenuBarItem("Edit", EditContextMenu),
		new FORMS_MenuBarItem("Window", TestWindowContextMenu),
		new FORMS_MenuBarItem("Help"),
	]);
	add_child(_menu);

	var _toolbar = new(function (): FORMS_Toolbar() constructor
	{
		static draw_content = function ()
		{
			Pen.start();
			Pen.icon_solid(FA_ESolid.House, { Tooltip: "Close Project" });
			Pen.vsep();
			Pen.icon_solid(FA_ESolid.File, { Tooltip: "New Project" });
			Pen.icon_solid(FA_ESolid.FolderOpen, { Tooltip: "Open Project" });
			Pen.icon_solid(FA_ESolid.FloppyDisk, { Tooltip: "Save Project" });
			Pen.vsep();
			Pen.icon_solid(FA_ESolid.Download, { Tooltip: "Create Executable" });
			Pen.vsep();
			Pen.icon_solid(FA_ESolid.Bug, { Tooltip: "Debug" });
			Pen.icon_solid(FA_ESolid.Play, { Tooltip: "Run" });
			Pen.icon_solid(FA_ESolid.Stop, { Tooltip: "Stop" });
			Pen.icon_solid(FA_ESolid.Brush, { Tooltip: "Clean" });
			Pen.vsep();
			Pen.icon_solid(FA_ESolid.Gear, { Tooltip: "Game Options" });
			Pen.icon_solid(FA_ESolid.CircleQuestion, { Tooltip: "Help" });
			Pen.vsep();
			Pen.icon_solid(FA_ESolid.MagnifyingGlassMinus, { Tooltip: "Zoom Out" });
			Pen.icon_solid(FA_ESolid.MagnifyingGlass, { Tooltip: "Zoom Reset" });
			Pen.icon_solid(FA_ESolid.MagnifyingGlassPlus, { Tooltip: "Zoom In" });
			Pen.icon_solid(FA_ESolid.Expand, { Tooltip: "Collapse/Expand" });
			Pen.vsep();
			Pen.icon_solid(FA_ESolid.Computer, { Tooltip: "Laptop Mode" });
			Pen.icon_solid(FA_ESolid.Robot, { Tooltip: "AI Assistant" });
			Pen.finish();
			FORMS_CONTENT_UPDATE_SIZE;
			return self;
		}
	})();
	add_child(_toolbar);

	var _dock = new FORMS_Dock(
	{
		Width: "100%",
		Height: "100%",
		Flex: 1,
	});
	add_child(_dock);

	// Build a sample scene hierarchy
	var _sceneView = new TestSceneHierarchy();

	// Populate with example scene data
	var _rootNode = new TestSceneNode("World", FA_ESolid.Globe);
	_rootNode.Expanded = true;
	_sceneView.add_node(_rootNode);

	var _envNode = new TestSceneNode("Environment", FA_ESolid.Tree);
	_envNode.Expanded = true;
	_sceneView.add_node(_envNode, _rootNode);

	_sceneView.add_node(new TestSceneNode("Directional Light", FA_ESolid.Sun), _envNode);
	_sceneView.add_node(new TestSceneNode("Sky Dome", FA_ESolid.Cloud), _envNode);
	_sceneView.add_node(new TestSceneNode("Terrain", FA_ESolid.Mountain), _envNode);

	var _playerNode = new TestSceneNode("Player", FA_ESolid.Person);
	_playerNode.Expanded = true;
	_sceneView.add_node(_playerNode, _rootNode);

	_sceneView.add_node(new TestSceneNode("Camera", FA_ESolid.Camera), _playerNode);
	_sceneView.add_node(new TestSceneNode("Mesh", FA_ESolid.Cube), _playerNode);
	_sceneView.add_node(new TestSceneNode("Collider", FA_ESolid.VectorSquare), _playerNode);

	var _enemiesNode = new TestSceneNode("Enemies", FA_ESolid.SkullCrossbones);
	_enemiesNode.Expanded = false;
	_sceneView.add_node(_enemiesNode, _rootNode);

	for (var _ei = 0; _ei < 50; ++_ei)
	{
		var _enemy = new TestSceneNode($"Enemy_{_ei}", FA_ESolid.Robot);
		_sceneView.add_node(_enemy, _enemiesNode);
		_sceneView.add_node(new TestSceneNode("AI Controller", FA_ESolid.Brain), _enemy);
		_sceneView.add_node(new TestSceneNode("Mesh", FA_ESolid.Cube), _enemy);
		_sceneView.add_node(new TestSceneNode("Health Bar", FA_ESolid.Heart), _enemy);
	}

	var _uiNode = new TestSceneNode("UI", FA_ESolid.Display);
	_uiNode.Expanded = false;
	_sceneView.add_node(_uiNode, _rootNode);

	_sceneView.add_node(new TestSceneNode("HUD Canvas", FA_ESolid.Tv), _uiNode);
	_sceneView.add_node(new TestSceneNode("Minimap", FA_ESolid.Map), _uiNode);
	_sceneView.add_node(new TestSceneNode("Inventory", FA_ESolid.Toolbox), _uiNode);
	_sceneView.add_node(new TestSceneNode("Pause Menu", FA_ESolid.Bars), _uiNode);

	// Details panel linked to scene hierarchy
	var _detailsPanel = new TestDetailsPanel();
	_detailsPanel.SceneHierarchy = _sceneView;

	// Layout: Left (Scene + Details) | Center (Viewport) | Bottom (Browsers)
	_dock.set_tabs([
		_sceneView,
	]);

	_dock.split_left(0.2);

	var _viewport = new FORMS_ApplicationSurface(
	{
		Name: "Viewport",
		Icon: FA_ESolid.Camera,
		Width: "100%",
		Height: "100%",
		// Resize: true
	});
	forms_register_single_instance("viewport", _viewport);

	// Tool selection toolbar (top-left)
	var _toolBar = new(function (): FORMS_FloatingToolbar(
	{
		PositionX: 0.0,
		PositionY: 0.0,
	}) constructor
	{
		Tool = 0;

		static draw_content = function ()
		{
			Pen.start();
			if (Pen.icon_solid(FA_ESolid.ArrowPointer,
				{
					Width: 24,
					Tooltip: "Select",
					Active: (Tool
						== 0)
				}))
			{
				Tool = 0;
			}
			Pen.vsep();
			if (Pen.icon_solid(FA_ESolid.ArrowsUpDownLeftRight,
				{
					Width: 24,
					Tooltip: "Move",
					Active: (
						Tool == 1)
				}))
			{
				Tool = 1;
			}
			if (Pen.icon_solid(FA_ESolid.ArrowsRotate,
				{
					Width: 24,
					Tooltip: "Rotate",
					Active: (Tool
						== 2)
				}))
			{
				Tool = 2;
			}
			if (Pen.icon_solid(FA_ESolid.UpRightAndDownLeftFromCenter,
				{
					Width: 24,
					Tooltip: "Scale",
					Active: (Tool == 3)
				}))
			{
				Tool = 3;
			}
			Pen.finish();
			FORMS_CONTENT_UPDATE_SIZE;
			return self;
		}
	})();
	_viewport.add_child(_toolBar);

	// Rendering options toolbar (top-right)
	var _renderBar = new(function (): FORMS_FloatingToolbar(
	{
		PositionX: 1.0,
		PositionY: 0.0,
	}) constructor
	{
		ShowGrid = true;
		ShowGizmos = true;

		static draw_content = function ()
		{
			Pen.start();
			if (Pen.checkbox(ShowGrid) | Pen.link(" Grid"))
			{
				ShowGrid = !ShowGrid;
			}
			Pen.space(2);
			if (Pen.checkbox(ShowGizmos) | Pen.link(" Gizmos"))
			{
				ShowGizmos = !ShowGizmos;
			}
			Pen.finish();
			FORMS_CONTENT_UPDATE_SIZE;
			return self;
		}
	})();
	_viewport.add_child(_renderBar);

	// FPS counter (bottom-right)
	var _fpsBar = new(function (): FORMS_FloatingToolbar(
	{
		PositionX: 1.0,
		PositionY: 1.0,
		BackgroundAlpha: 0.6,
		Draggable: false,
	}) constructor
	{
		static draw_content = function ()
		{
			Pen.start();
			Pen.text($"{fps} FPS", { Muted: true });
			Pen.finish();
			FORMS_CONTENT_UPDATE_SIZE;
			return self;
		}
	})();
	_viewport.add_child(_fpsBar);

	// Right side: split into center (viewport) and right (details)
	var _dockRight = _dock.get_second();
	_dockRight.set_tabs([
		_viewport,
		new TestControlsScrollPane(),
	]);

	// Split: existing tabs go left (center), new empty dock on right (details)
	_dockRight.split_left(0.8);
	_dockRight.get_second().set_tabs([
		_detailsPanel,
	]);

	// Split center area: viewport top, browsers bottom
	_dockRight.get_first().split_up(0.65);
	_dockRight.get_first().get_second().set_tabs([
		new FORMS_FileBrowser(
		{
			Name: "File Browser",
			Icon: FA_ESolid.FolderOpen,
			Width: "100%",
			Height: "100%"
		}),
		new FORMS_AssetBrowser(
		{
			Name: "Asset Browser",
			Icon: FA_ESolid.BoxesStacked,
			Width: "100%",
			Height: "100%",
			IgnoreFilters: ["forms", "fa_", "test", "__"]
		}),
	]);
}
