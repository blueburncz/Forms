/// @func FORMS_AssetBrowserEntry(_id, _name, _type)
///
/// @desc Represents a single game asset entry in a {@link FORMS_AssetBrowser}.
///
/// @param {Asset} _id The asset ID.
/// @param {String} _name The asset name.
/// @param {Constant.AssetType} _type The asset type.
function FORMS_AssetBrowserEntry(_id, _name, _type) constructor
{
	/// @var {Asset} The asset ID.
	Id = _id;

	/// @var {String} The asset name.
	Name = _name;

	/// @var {Constant.AssetType} The asset type.
	Type = _type;

	/// @var {Bool} Whether this entry is selected.
	Selected = false;
}

/// @func FORMS_AssetBrowserThumbnailProvider()
///
/// @desc Base class for asset thumbnail providers. Subclass to draw custom previews for specific asset types.
///
/// @example
/// ```gml
/// function MySpritePreview(): FORMS_AssetBrowserThumbnailProvider() constructor
/// {
///     static can_provide = function (_entry) { return _entry.Type == asset_sprite; }
///     static draw_thumbnail = function (_entry, _x, _y, _size)
///     {
///         draw_sprite_stretched(_entry.Id, 0, _x, _y, _size, _size);
///     }
/// }
/// browser.add_thumbnail_provider(new MySpritePreview());
/// ```
function FORMS_AssetBrowserThumbnailProvider() constructor
{
	/// @func can_provide(_entry)
	///
	/// @param {Struct.FORMS_AssetBrowserEntry} _entry
	///
	/// @return {Bool}
	static can_provide = function (_entry) { return false; }

	/// @func draw_thumbnail(_entry, _x, _y, _size)
	///
	/// @param {Struct.FORMS_AssetBrowserEntry} _entry
	/// @param {Real} _x, _y, _size
	static draw_thumbnail = function (_entry, _x, _y, _size) {}
}

/// @func FORMS_AssetThumbnailProviderSprite()
///
/// @extends FORMS_AssetBrowserThumbnailProvider
///
/// @desc Built-in thumbnail provider that draws sprite previews.
function FORMS_AssetThumbnailProviderSprite(): FORMS_AssetBrowserThumbnailProvider() constructor
{
	static can_provide = function (_entry)
	{
		return _entry.Type == asset_sprite;
	}

	static draw_thumbnail = function (_entry, _x, _y, _size)
	{
		if (sprite_exists(_entry.Id))
		{
			var _w = sprite_get_width(_entry.Id);
			var _h = sprite_get_height(_entry.Id);
			var _scale = min(_size / max(_w, 1), _size / max(_h, 1));
			var _drawW = _w * _scale;
			var _drawH = _h * _scale;
			draw_sprite_ext(_entry.Id, 0,
				_x + floor((_size - _drawW) / 2) + sprite_get_xoffset(_entry.Id) * _scale,
				_y + floor((_size - _drawH) / 2) + sprite_get_yoffset(_entry.Id) * _scale,
				_scale, _scale, 0, c_white, 1.0);
		}
	}
}

/// @func FORMS_AssetThumbnailProviderDefault()
///
/// @extends FORMS_AssetBrowserThumbnailProvider
///
/// @desc Built-in thumbnail provider that draws Font Awesome icons based on asset type.
function FORMS_AssetThumbnailProviderDefault(): FORMS_AssetBrowserThumbnailProvider() constructor
{
	static can_provide = function (_entry) { return true; }

	static draw_thumbnail = function (_entry, _x, _y, _size)
	{
		var _style = forms_get_style();
		var _icon;

		switch (_entry.Type)
		{
			case asset_sprite:
				_icon = FA_ESolid.Image;
				break;
			case asset_sound:
				_icon = FA_ESolid.VolumeHigh;
				break;
			case asset_font:
				_icon = FA_ESolid.Font;
				break;
			case asset_object:
				_icon = FA_ESolid.Cube;
				break;
			case asset_room:
				_icon = FA_ESolid.DoorOpen;
				break;
			case asset_script:
				_icon = FA_ESolid.FileCode;
				break;
			case asset_path:
				_icon = FA_ESolid.BezierCurve;
				break;
			case asset_shader:
				_icon = FA_ESolid.WandMagicSparkles;
				break;
			case asset_tiles:
				_icon = FA_ESolid.TableCells;
				break;
			case asset_timeline:
				_icon = FA_ESolid.Timeline;
				break;
			case asset_animationcurve:
				_icon = FA_ESolid.ChartLine;
				break;
			case asset_sequence:
				_icon = FA_ESolid.Film;
				break;
			case asset_particlesystem:
				_icon = FA_ESolid.Burst;
				break;
			default:
				_icon = FA_ESolid.File;
				break;
		}

		fa_draw(FA_FntSolid12, _icon,
			_x + floor((_size - 12) / 2),
			_y + floor((_size - 12) / 2),
			_style.TextMuted.get());
	}
}

/// @func FORMS_AssetDragPayload(_entries)
///
/// @desc Payload carried during an asset drag operation from a {@link FORMS_AssetBrowser}.
///
/// @param {Array<Struct.FORMS_AssetBrowserEntry>} _entries The entries being dragged.
function FORMS_AssetDragPayload(_entries) constructor
{
	/// @var {Array<Struct.FORMS_AssetBrowserEntry>} The entries being dragged.
	Entries = _entries;

	/// @var {String} The primary asset name.
	Name = (array_length(_entries) > 0) ? _entries[0].Name : "";

	/// @func draw_drag_target(_x, _y)
	///
	/// @desc Called by RootWidget to draw the drag visual.
	static draw_drag_target = function (_x, _y)
	{
		var _style = forms_get_style();
		var _text = (array_length(Entries) == 1)
			? Entries[0].Name
			: $"{array_length(Entries)} assets";

		draw_set_font(_style.Font);
		var _width = string_width(_text) + 28;
		var _height = string_height(_text) + 8;

		draw_sprite_stretched_ext(FORMS_SprRound4, 0,
			_x, _y, _width, _height,
			_style.Background[2].get(), 0.9);

		fa_draw(FA_FntSolid12, FA_ESolid.Cube, _x + 4, _y + 4, _style.Text.get());
		forms_draw_text(_x + 22, _y + 4, _text, _style.Text.get());
	}
}

/// @func FORMS_AssetBrowserContextMenuProvider()
///
/// @desc Base class for asset browser context menu providers.
function FORMS_AssetBrowserContextMenuProvider() constructor
{
	/// @func can_provide(_entry)
	///
	/// @param {Struct.FORMS_AssetBrowserEntry} _entry
	///
	/// @return {Bool}
	static can_provide = function (_entry) { return false; }

	/// @func get_options(_entry, _browser)
	///
	/// @param {Struct.FORMS_AssetBrowserEntry} _entry
	/// @param {Struct.FORMS_AssetBrowser} _browser
	///
	/// @return {Array<Struct.FORMS_ContextMenuItem>}
	static get_options = function (_entry, _browser) { return []; }
}

/// @func FORMS_AssetContextMenuProviderDefault()
///
/// @extends FORMS_AssetBrowserContextMenuProvider
///
/// @desc Built-in context menu with common asset operations.
function FORMS_AssetContextMenuProviderDefault(): FORMS_AssetBrowserContextMenuProvider() constructor
{
	static can_provide = function (_entry) { return true; }

	static get_options = function (_entry, _browser)
	{
		var _options = [];

		var _opt = new FORMS_ContextMenuOption("Copy Name");
		_opt.Icon = FA_ESolid.Copy;
		_opt.Action = method({ entry: _entry }, function ()
		{
			clipboard_set_text(entry.Name);
		});
		array_push(_options, _opt);

		return _options;
	}
}

// =========================================================================
// Asset Browser Widget
// =========================================================================

/// @func FORMS_AssetBrowserProps()
///
/// @extends FORMS_CompoundWidgetProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_AssetBrowser}.
function FORMS_AssetBrowserProps(): FORMS_CompoundWidgetProps() constructor
{
	/// @var {Real, Undefined} Thumbnail size for grid view.
	ThumbnailSize = undefined;

	/// @var {Real, Undefined} View mode from {@link FORMS_EFileBrowserView}.
	ViewMode = undefined;

	/// @var {Array<String>, Undefined} Substrings to exclude from asset listing (case-insensitive).
	IgnoreFilters = undefined;
}

/// @func FORMS_AssetBrowser([_props])
///
/// @extends FORMS_CompoundWidget
///
/// @desc An asset browser widget that lists all game assets by type with thumbnails and filtering.
///
/// @param {Struct.FORMS_AssetBrowserProps, Undefined} [_props]
function FORMS_AssetBrowser(_props = undefined): FORMS_CompoundWidget(_props) constructor
{
	/// @var {Real} Thumbnail size for grid view. Defaults to 64.
	ThumbnailSize = forms_get_prop(_props, "ThumbnailSize") ?? 64;

	/// @var {Real} View mode. Defaults to {@link FORMS_EFileBrowserView.Grid}.
	ViewMode = forms_get_prop(_props, "ViewMode") ?? FORMS_EFileBrowserView.Grid;

	/// @var {Array<String>} Substrings to exclude from asset listing (case-insensitive). Defaults to empty.
	IgnoreFilters = forms_get_prop(_props, "IgnoreFilters") ?? [];

	/// @var {Array<Struct.FORMS_AssetBrowserThumbnailProvider>} Thumbnail providers (checked in order).
	/// @private
	__thumbnailProviders = [
		new FORMS_AssetThumbnailProviderSprite(),
		new FORMS_AssetThumbnailProviderDefault(),
	];

	/// @var {Array<Struct.FORMS_AssetBrowserContextMenuProvider>} Context menu providers.
	/// @private
	__contextMenuProviders = [
		new FORMS_AssetContextMenuProviderDefault(),
	];

	/// @var {String} Search filter text.
	/// @private
	__searchFilter = "";

	/// @var {Real} Currently selected asset type filter. -1 = all types.
	/// @private
	__typeFilter = -1;

	/// @var {Array<Struct.FORMS_AssetBrowserEntry>} Cached asset entries for the current filter.
	/// @private
	__entries = [];

	/// @var {Bool} Whether the entries need to be refreshed.
	/// @private
	__dirty = true;

	/// @var {Array} Asset type filter options: [name, icon, asset_type constant].
	/// @private
	__assetTypes = [
		["All", FA_ESolid.LayerGroup, -1],
		["Anim Curves", FA_ESolid.ChartLine, asset_animationcurve],
		["Fonts", FA_ESolid.Font, asset_font],
		["Objects", FA_ESolid.Cube, asset_object],
		["Paths", FA_ESolid.BezierCurve, asset_path],
		["Rooms", FA_ESolid.DoorOpen, asset_room],
		["Scripts", FA_ESolid.FileCode, asset_script],
		["Shaders", FA_ESolid.WandMagicSparkles, asset_shader],
		["Sounds", FA_ESolid.VolumeHigh, asset_sound],
		["Sprites", FA_ESolid.Image, asset_sprite],
		["Tile Sets", FA_ESolid.TableCells, asset_tiles],
		["Timelines", FA_ESolid.Timeline, asset_timeline],
		["Sequences", FA_ESolid.Film, asset_sequence],
		["Particle Systems", FA_ESolid.Burst, asset_particlesystem],
	];

	// =====================================================================
	// Provider APIs
	// =====================================================================

	/// @func add_thumbnail_provider(_provider)
	static add_thumbnail_provider = function (_provider)
	{
		array_insert(__thumbnailProviders, 0, _provider);
		return self;
	}

	/// @func add_context_menu_provider(_provider)
	static add_context_menu_provider = function (_provider)
	{
		array_insert(__contextMenuProviders, 0, _provider);
		return self;
	}

	/// @func draw_entry_thumbnail(_entry, _x, _y, _size)
	static draw_entry_thumbnail = function (_entry, _x, _y, _size)
	{
		for (var i = 0; i < array_length(__thumbnailProviders); ++i)
		{
			if (__thumbnailProviders[i].can_provide(_entry))
			{
				__thumbnailProviders[i].draw_thumbnail(_entry, _x, _y, _size);
				return;
			}
		}
	}

	/// @func open_context_menu(_entry)
	static open_context_menu = function (_entry)
	{
		var _options = [];
		for (var i = 0; i < array_length(__contextMenuProviders); ++i)
		{
			var _provider = __contextMenuProviders[i];
			if (_provider.can_provide(_entry))
			{
				var _providerOptions = _provider.get_options(_entry, self);
				for (var j = 0; j < array_length(_providerOptions); ++j)
				{
					array_push(_options, _providerOptions[j]);
				}
			}
		}
		if (array_length(_options) > 0)
		{
			var _last = _options[array_length(_options) - 1];
			if (instanceof(_last) == "FORMS_ContextMenuSeparator")
			{
				array_pop(_options);
			}
			draw_set_font(forms_get_style().Font);
			var _contextMenu = new FORMS_ContextMenu(_options,
			{
				X: window_mouse_get_x(),
				Y: window_mouse_get_y(),
			});
			forms_get_root().add_child(_contextMenu);
		}
	}

	/// @func get_selected_entries()
	static get_selected_entries = function ()
	{
		var _selected = [];
		for (var i = 0; i < array_length(__entries); ++i)
		{
			if (__entries[i].Selected) array_push(_selected, __entries[i]);
		}
		return _selected;
	}

	// =====================================================================
	// Internal
	// =====================================================================

	/// @private
	static __refresh_entries = function ()
	{
		__entries = [];

		if (__typeFilter == -1)
		{
			// All types
			for (var t = 0; t < array_length(__assetTypes); ++t)
			{
				var _assetType = __assetTypes[t][2];
				if (_assetType == -1) continue;
				__collect_assets_of_type(_assetType);
			}
		}
		else
		{
			__collect_assets_of_type(__typeFilter);
		}

		// Sort alphabetically
		array_sort(__entries, function (_a, _b)
		{
			var _na = string_lower(_a.Name);
			var _nb = string_lower(_b.Name);
			return (_na < _nb) ? -1 : ((_na > _nb) ? 1 : 0);
		});

		__dirty = false;
	}

	/// @private
	static __collect_assets_of_type = function (_assetType)
	{
		var _ids = asset_get_ids(_assetType);
		var _getName = __get_name_func(_assetType);

		for (var i = 0; i < array_length(_ids); ++i)
		{
			var _id = _ids[i];
			var _name = _getName(_id);
			if (_name == "" || string_char_at(_name, 1) == "<") continue;

			// Check ignore filters
			var _ignored = false;
			var _nameLower = string_lower(_name);
			for (var j = 0; j < array_length(IgnoreFilters); ++j)
			{
				if (string_pos(string_lower(IgnoreFilters[j]), _nameLower) > 0)
				{
					_ignored = true;
					break;
				}
			}
			if (_ignored) continue;

			array_push(__entries, new FORMS_AssetBrowserEntry(_id, _name, _assetType));
		}
	}

	/// @private
	static __get_name_func = function (_assetType)
	{
		switch (_assetType)
		{
			case asset_sprite:
				return sprite_get_name;
			case asset_sound:
				return audio_get_name;
			case asset_font:
				return font_get_name;
			case asset_object:
				return object_get_name;
			case asset_room:
				return room_get_name;
			case asset_script:
				return script_get_name;
			case asset_path:
				return path_get_name;
			case asset_shader:
				return shader_get_name;
			case asset_tiles:
				return tileset_get_name;
			case asset_timeline:
				return timeline_get_name;
			default:
				return function (_id) { return string(_id); };
		}
	}

	/// @private
	static __get_filtered_entries = function ()
	{
		if (__dirty) __refresh_entries();
		if (__searchFilter == "") return __entries;
		var _filter = string_lower(__searchFilter);
		var _result = [];
		for (var i = 0; i < array_length(__entries); ++i)
		{
			if (string_pos(_filter, string_lower(__entries[i].Name)) > 0)
			{
				array_push(_result, __entries[i]);
			}
		}
		return _result;
	}

	/// @private
	static __get_type_name = function (_assetType)
	{
		for (var i = 0; i < array_length(__assetTypes); ++i)
		{
			if (__assetTypes[i][2] == _assetType) return __assetTypes[i][0];
		}
		return "Unknown";
	}

	// =====================================================================
	// UI Construction
	// =====================================================================

	FlexBox = new FORMS_FlexBox({ Width: "100%", Height: "100%", IsHorizontal: false });
	add_child(FlexBox);

	var _self = self;

	// Toolbar (search only)
	Toolbar = new(function (_ab): FORMS_Container() constructor
	{
		AssetBrowser = _ab;
		Width.from_string("100%");
		Height.from_string("28px");
		Pen.SpacingX = 2;

		static draw_content = function ()
		{
			var _style = forms_get_style();
			var _ab = AssetBrowser;
			Pen.start();

			// Search input
			var _padX = Pen.PaddingX ?? _style.Padding;
			var _hasSearch = (_ab.__searchFilter != "");
			var _clearBtnWidth = _hasSearch ? 20 : 0;
			if (Pen.input("ab-search", _ab.__searchFilter,
				{
					Width: __realWidth - Pen.X - _padX - _clearBtnWidth,
					Placeholder: "Search assets...",
				}))
			{
				_ab.__searchFilter = Pen.get_result();
			}
			if (_hasSearch)
			{
				if (Pen.icon_solid(FA_ESolid.Xmark,
					{
						Width: 20,
						Muted: true,
						Tooltip: "Clear search"
					}))
				{
					_ab.__searchFilter = "";
				}
			}

			Pen.finish();
			FORMS_CONTENT_UPDATE_SIZE;
			return self;
		}
	})(_self);
	FlexBox.add_child(Toolbar);

	// Dock: left = asset type list, right = asset view
	Dock = new FORMS_Dock({ Width: "100%", Flex: 1 });
	FlexBox.add_child(Dock);

	// Asset type list (left panel)
	TypeList = new(function (_ab): FORMS_ScrollPane() constructor
	{
		AssetBrowser = _ab;
		Pen.PaddingX = 4;
		Pen.PaddingY = 4;
		BackgroundColorIndex = 0;

		static draw_content = function ()
		{
			var _style = forms_get_style();
			var _ab = AssetBrowser;
			var _types = _ab.__assetTypes;
			var _lineH = Pen.__lineHeight;

			Pen.start();

			for (var i = 0; i < array_length(_types); ++i)
			{
				var _typeName = _types[i][0];
				var _typeIcon = _types[i][1];
				var _typeConst = _types[i][2];
				var _isSelected = (_ab.__typeFilter == _typeConst);

				// Selection highlight
				if (_isSelected)
				{
					forms_draw_rectangle(Pen.X, Pen.Y, Pen.Width, _lineH, _style.Highlight.get());
				}

				// Hover + click on full row
				var _mouseOver = Pen.is_mouse_over(Pen.X, Pen.Y, Pen.Width, _lineH);
				if (_mouseOver)
				{
					if (!_isSelected)
					{
						forms_draw_rectangle(Pen.X, Pen.Y, Pen.Width, _lineH, _style.Background[3]
							.get(), 0.5);
					}
					if (forms_left_click())
					{
						_ab.__typeFilter = _typeConst;
						_ab.__dirty = true;
					}
				}

				// Icon
				fa_draw(FA_FntSolid12, _typeIcon, Pen.X, Pen.Y, _isSelected ? _style.Text.get() : _style
					.TextMuted.get());
				Pen.move(20);

				// Name
				Pen.text(_typeName, { Muted: !_isSelected });

				Pen.nl();
			}

			Pen.finish();
			FORMS_CONTENT_UPDATE_SIZE;
			return self;
		}
	})(_self);

	// Asset grid/list view (right panel)
	AssetView = new(function (_ab): FORMS_ScrollPane() constructor
	{
		AssetBrowser = _ab;
		Pen.PaddingX = 4;
		Pen.PaddingY = 4;
		BackgroundColorIndex = 0;

		/// @private
		__dragPressIndex = -1;
		__dragPressX = 0;
		__dragPressY = 0;

		static draw_content = function ()
		{
			var _style = forms_get_style();
			var _ab = AssetBrowser;
			var _entries = _ab.__get_filtered_entries();
			var _entryCount = array_length(_entries);

			Pen.start();

			if (_ab.ViewMode == FORMS_EFileBrowserView.Grid)
			{
				__draw_grid(_entries, _entryCount, _style, _ab);
			}
			else
			{
				__draw_list(_entries, _entryCount, _style, _ab);
			}

			if (_entryCount == 0)
			{
				Pen.text("No assets found", { Muted: true });
			}

			Pen.finish();
			FORMS_CONTENT_UPDATE_SIZE;
			return self;
		}

		/// @private
		static __draw_grid = function (_entries, _entryCount, _style, _ab)
		{
			var _thumbSize = _ab.ThumbnailSize;
			var _cellWidth = _thumbSize + 8;
			var _cellHeight = _thumbSize + 20;
			var _cols = max(floor((Pen.Width) / _cellWidth), 1);
			var _totalRows = ceil(_entryCount / _cols);

			// Virtual scrolling
			var _visibleTop = ScrollY;
			var _visibleBottom = ScrollY + __realHeight;
			var _firstRow = max(floor(_visibleTop / _cellHeight), 0);
			var _lastRow = min(ceil(_visibleBottom / _cellHeight), _totalRows - 1);
			var _firstIndex = _firstRow * _cols;
			var _lastIndex = min((_lastRow + 1) * _cols - 1, _entryCount - 1);

			for (var i = _firstIndex; i <= _lastIndex; ++i)
			{
				var _entry = _entries[i];
				var _col = i mod _cols;
				var _row = i div _cols;
				var _x = Pen.StartX + _col * _cellWidth;
				var _y = Pen.StartY + _row * _cellHeight;

				if (_entry.Selected)
				{
					forms_draw_roundrect(_x, _y, _cellWidth - 2, _cellHeight - 2, 4,
						_style.Highlight.get(), 1.0);
				}

				var _mouseOver = Pen.is_mouse_over(_x, _y, _cellWidth - 2, _cellHeight - 2);
				if (_mouseOver)
				{
					if (!_entry.Selected)
					{
						forms_draw_roundrect(_x, _y, _cellWidth - 2, _cellHeight - 2, 4,
							_style.Background[3].get(), 0.5);
					}

					if (forms_left_click())
					{
						if (!keyboard_check(vk_control))
						{
							for (var j = 0; j < _entryCount; ++j) _entries[j].Selected = false;
						}
						_entry.Selected = !_entry.Selected;
					}

					if (mouse_check_button_pressed(mb_right))
					{
						if (!_entry.Selected)
						{
							for (var j = 0; j < _entryCount; ++j) _entries[j].Selected = false;
							_entry.Selected = true;
						}
						_ab.open_context_menu(_entry);
					}

					if (mouse_check_button_pressed(mb_left))
					{
						__dragPressIndex = i;
						__dragPressX = forms_mouse_get_x();
						__dragPressY = forms_mouse_get_y();
					}

					forms_set_tooltip(_entry.Name);
				}

				_ab.draw_entry_thumbnail(_entry, _x + 4, _y + 2, _thumbSize);

				var _labelY = _y + _thumbSize + 4;
				draw_set_font(_style.Font);
				var _labelText = _entry.Name;
				while (string_width(_labelText) > _cellWidth - 6 && string_length(_labelText) > 1)
				{
					_labelText = string_copy(_labelText, 1, string_length(_labelText) - 1);
				}
				forms_draw_text(_x + 2, _labelY, _labelText,
					_entry.Selected ? _style.Text.get() : _style.TextMuted.get());
			}

			Pen.MaxY = max(Pen.MaxY, Pen.StartY + _totalRows * _cellHeight);
			Pen.MaxX = max(Pen.MaxX, Pen.StartX + _cols * _cellWidth);

			__handle_drag(_entries, _entryCount, _ab);
		}

		/// @private
		static __draw_list = function (_entries, _entryCount, _style, _ab)
		{
			var _lineH = Pen.__lineHeight;

			var _visibleTop = ScrollY;
			var _visibleBottom = ScrollY + __realHeight;
			var _firstVisible = max(floor(_visibleTop / _lineH), 0);
			var _lastVisible = min(ceil(_visibleBottom / _lineH), _entryCount - 1);

			Pen.Y = Pen.StartY + _firstVisible * _lineH;

			for (var i = _firstVisible; i <= _lastVisible; ++i)
			{
				var _entry = _entries[i];

				if (_entry.Selected)
				{
					forms_draw_rectangle(Pen.X, Pen.Y, Pen.Width, _lineH, _style.Highlight.get());
				}

				var _mouseOver = Pen.is_mouse_over(Pen.X, Pen.Y, Pen.Width, _lineH);
				if (_mouseOver)
				{
					if (!_entry.Selected)
					{
						forms_draw_rectangle(Pen.X, Pen.Y, Pen.Width, _lineH, _style.Background[3]
							.get(), 0.5);
					}

					if (forms_left_click())
					{
						if (!keyboard_check(vk_control))
						{
							for (var j = 0; j < _entryCount; ++j) _entries[j].Selected = false;
						}
						_entry.Selected = !_entry.Selected;
					}

					if (mouse_check_button_pressed(mb_right))
					{
						if (!_entry.Selected)
						{
							for (var j = 0; j < _entryCount; ++j) _entries[j].Selected = false;
							_entry.Selected = true;
						}
						_ab.open_context_menu(_entry);
					}

					if (mouse_check_button_pressed(mb_left))
					{
						__dragPressIndex = i;
						__dragPressX = forms_mouse_get_x();
						__dragPressY = forms_mouse_get_y();
					}
				}

				// Type icon
				_ab.draw_entry_thumbnail(_entry, Pen.X, Pen.Y, _lineH);
				Pen.move(20);

				// Name
				Pen.text(_entry.Name, { Muted: !_entry.Selected });

				// Type label (right-aligned)
				var _typeName = _ab.__get_type_name(_entry.Type);
				var _typeWidth = string_width(_typeName);
				forms_draw_text(Pen.StartX + Pen.Width - _typeWidth, Pen.Y,
					_typeName, _style.TextMuted.get());

				Pen.nl();
			}

			Pen.MaxY = max(Pen.MaxY, Pen.StartY + _entryCount * _lineH);

			__handle_drag(_entries, _entryCount, _ab);
		}

		/// @private
		static __handle_drag = function (_entries, _entryCount, _ab)
		{
			if (__dragPressIndex < 0) return;

			var _root = forms_get_root();

			if (mouse_check_button(mb_left))
			{
				var _dist = point_distance(
					forms_mouse_get_x(), forms_mouse_get_y(),
					__dragPressX, __dragPressY);

				if (_dist > 8 && _root.DragTarget == undefined)
				{
					if (__dragPressIndex < _entryCount && !_entries[__dragPressIndex].Selected)
					{
						for (var j = 0; j < _entryCount; ++j) _entries[j].Selected = false;
						_entries[__dragPressIndex].Selected = true;
					}

					var _selected = _ab.get_selected_entries();
					if (array_length(_selected) > 0)
					{
						_root.DragTarget = new FORMS_AssetDragPayload(_selected);
					}
					__dragPressIndex = -1;
				}
			}
			else
			{
				__dragPressIndex = -1;
			}
		}
	})(_self);

	Dock.split_left(0.3);

	var _dockLeft = Dock.get_first();
	_dockLeft.ShowTabs = false;
	_dockLeft.set_tabs([TypeList]);

	var _dockRight = Dock.get_second();
	_dockRight.ShowTabs = false;
	_dockRight.set_tabs([AssetView]);

	// Initial load
	__refresh_entries();
}
