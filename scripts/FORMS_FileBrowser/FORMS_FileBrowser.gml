/// @enum File browser view modes.
enum FORMS_EFileBrowserView
{
	/// @member Thumbnail grid with labels.
	Grid,
	/// @member Detailed list with columns.
	List,
};

/// @func FORMS_FileBrowserEntry(_path, _isDirectory)
///
/// @desc Represents a single file or directory entry in a {@link FORMS_FileBrowser}.
///
/// @param {String} _path Full absolute path.
/// @param {Bool} _isDirectory Whether this entry is a directory.
function FORMS_FileBrowserEntry(_path, _isDirectory) constructor
{
	/// @var {String} Full absolute path.
	Path = _path;

	/// @var {String} Display name (filename without path).
	Name = filename_name(_path);

	/// @var {String} File extension (lowercase, with dot).
	Extension = string_lower(filename_ext(_path));

	/// @var {Bool} Whether this entry is a directory.
	IsDirectory = _isDirectory;

	/// @var {Bool} Whether this entry is selected.
	Selected = false;

	/// @var {Asset.GMSprite, Undefined} Cached thumbnail sprite.
	Thumbnail = undefined;

	/// @var {Bool} Whether the thumbnail is currently being loaded.
	ThumbnailLoading = false;
}

/// @func FORMS_FileBrowserThumbnailProvider()
///
/// @desc Base class for thumbnail providers. Subclass to add custom thumbnail rendering for specific file types.
///
/// @example
/// ```gml
/// function MyMaterialProvider(): FORMS_FileBrowserThumbnailProvider() constructor
/// {
///     static can_provide = function (_entry) { return _entry.Extension == ".mat"; }
///     static draw_thumbnail = function (_entry, _x, _y, _size)
///     {
///         // Render material preview...
///     }
/// }
/// browser.add_thumbnail_provider(new MyMaterialProvider());
/// ```
function FORMS_FileBrowserThumbnailProvider() constructor
{
	/// @func can_provide(_entry)
	///
	/// @desc Returns whether this provider can generate a thumbnail for the given entry.
	///
	/// @param {Struct.FORMS_FileBrowserEntry} _entry
	///
	/// @return {Bool}
	static can_provide = function (_entry) { return false; }

	/// @func draw_thumbnail(_entry, _x, _y, _size)
	///
	/// @desc Draws a thumbnail for the given entry.
	///
	/// @param {Struct.FORMS_FileBrowserEntry} _entry
	/// @param {Real} _x X position.
	/// @param {Real} _y Y position.
	/// @param {Real} _size Thumbnail size in pixels.
	static draw_thumbnail = function (_entry, _x, _y, _size) {}
}

/// @func FORMS_ThumbnailProviderImage()
///
/// @extends FORMS_FileBrowserThumbnailProvider
///
/// @desc Thumbnail provider for image files (PNG, JPG, GIF). Loads thumbnails asynchronously.
function FORMS_ThumbnailProviderImage(): FORMS_FileBrowserThumbnailProvider() constructor
{
	static can_provide = function (_entry)
	{
		return !_entry.IsDirectory
			&& (_entry.Extension == ".png"
				|| _entry.Extension == ".jpg"
				|| _entry.Extension == ".jpeg"
				|| _entry.Extension == ".gif"
				|| _entry.Extension == ".bmp");
	}

	static draw_thumbnail = function (_entry, _x, _y, _size)
	{
		if (_entry.Thumbnail != undefined && sprite_exists(_entry.Thumbnail))
		{
			draw_sprite_stretched(_entry.Thumbnail, 0, _x, _y, _size, _size);
			return;
		}

		if (!_entry.ThumbnailLoading)
		{
			_entry.ThumbnailLoading = true;
			try
			{
				_entry.Thumbnail = sprite_add(_entry.Path, 1, false, true, 0, 0);
			}
			catch (_e)
			{
				_entry.Thumbnail = undefined;
			}
			_entry.ThumbnailLoading = false;
		}

		// Fallback icon while loading
		__draw_icon(_entry, _x, _y, _size);
	}

	/// @private
	static __draw_icon = function (_entry, _x, _y, _size)
	{
		var _style = forms_get_style();
		fa_draw(FA_FntSolid12, FA_ESolid.FileImage,
			_x + floor((_size - 12) / 2),
			_y + floor((_size - 12) / 2),
			_style.TextMuted.get());
	}
}

/// @func FORMS_ThumbnailProviderDefault()
///
/// @extends FORMS_FileBrowserThumbnailProvider
///
/// @desc Default thumbnail provider that draws Font Awesome icons based on file extension.
function FORMS_ThumbnailProviderDefault(): FORMS_FileBrowserThumbnailProvider() constructor
{
	static can_provide = function (_entry) { return true; }

	static draw_thumbnail = function (_entry, _x, _y, _size)
	{
		var _style = forms_get_style();
		var _icon, _color;

		if (_entry.IsDirectory)
		{
			_icon = FA_ESolid.Folder;
			_color = 0x41C0EB; // Yellowish folder color (BGR)
		}
		else
		{
			switch (_entry.Extension)
			{
				case ".gml":
				case ".js":
				case ".py":
				case ".cs":
				case ".cpp":
				case ".h":
					_icon = FA_ESolid.FileCode;
					break;
				case ".json":
				case ".xml":
				case ".txt":
				case ".md":
				case ".log":
				case ".csv":
				case ".ini":
					_icon = FA_ESolid.FileLines;
					break;
				case ".png":
				case ".jpg":
				case ".jpeg":
				case ".gif":
				case ".bmp":
				case ".tga":
					_icon = FA_ESolid.FileImage;
					break;
				case ".wav":
				case ".ogg":
				case ".mp3":
				case ".flac":
					_icon = FA_ESolid.FileAudio;
					break;
				case ".mp4":
				case ".avi":
				case ".mov":
				case ".webm":
					_icon = FA_ESolid.FileVideo;
					break;
				case ".zip":
				case ".rar":
				case ".7z":
				case ".gz":
				case ".tar":
					_icon = FA_ESolid.FileZipper;
					break;
				case ".pdf":
					_icon = FA_ESolid.FilePdf;
					break;
				default:
					_icon = FA_ESolid.File;
					break;
			}
			_color = _style.TextMuted.get();
		}

		fa_draw(FA_FntSolid12, _icon,
			_x + floor((_size - 12) / 2),
			_y + floor((_size - 12) / 2),
			_color);
	}
}

/// @func FORMS_FileDragPayload(_entries)
///
/// @desc Payload carried during a file drag operation from a {@link FORMS_FileBrowser}.
///
/// @param {Array<Struct.FORMS_FileBrowserEntry>} _entries The entries being dragged.
function FORMS_FileDragPayload(_entries) constructor
{
	/// @var {Array<Struct.FORMS_FileBrowserEntry>} The entries being dragged.
	Entries = _entries;

	/// @var {String} The primary path (first entry).
	Path = (array_length(_entries) > 0) ? _entries[0].Path : "";

	/// @func draw_drag_target(_x, _y)
	///
	/// @desc Called by RootWidget to draw the drag visual.
	static draw_drag_target = function (_x, _y)
	{
		var _style = forms_get_style();
		var _text = (array_length(Entries) == 1)
			? Entries[0].Name
			: $"{array_length(Entries)} items";

		draw_set_font(_style.Font);
		var _width = string_width(_text) + 28;
		var _height = string_height(_text) + 8;

		draw_sprite_stretched_ext(FORMS_SprRound4, 0,
			_x, _y, _width, _height,
			_style.Background[2].get(), 0.9);

		var _icon = (array_length(Entries) == 1 && Entries[0].IsDirectory)
			? FA_ESolid.Folder : FA_ESolid.File;
		fa_draw(FA_FntSolid12, _icon, _x + 4, _y + 4, _style.Text.get());
		forms_draw_text(_x + 22, _y + 4, _text, _style.Text.get());
	}
}

/// @func FORMS_FileBrowserContextMenuProvider()
///
/// @desc Base class for file browser context menu providers. Subclass to add custom context menu options
/// for specific file types.
///
/// @example
/// ```gml
/// function MyScriptContextMenu(): FORMS_FileBrowserContextMenuProvider() constructor
/// {
///     static can_provide = function (_entry) { return _entry.Extension == ".gml"; }
///     static get_options = function (_entry, _browser)
///     {
///         return [
///             new FORMS_ContextMenuOption({ Text: "Run Script", Action: function() { /* ... */ } }),
///         ];
///     }
/// }
/// browser.add_context_menu_provider(new MyScriptContextMenu());
/// ```
function FORMS_FileBrowserContextMenuProvider() constructor
{
	/// @func can_provide(_entry)
	///
	/// @desc Returns whether this provider has context menu options for the given entry.
	///
	/// @param {Struct.FORMS_FileBrowserEntry} _entry
	///
	/// @return {Bool}
	static can_provide = function (_entry) { return false; }

	/// @func get_options(_entry, _browser)
	///
	/// @desc Returns an array of context menu items for the given entry.
	///
	/// @param {Struct.FORMS_FileBrowserEntry} _entry
	/// @param {Struct.FORMS_FileBrowser} _browser
	///
	/// @return {Array<Struct.FORMS_ContextMenuItem>}
	static get_options = function (_entry, _browser) { return []; }
}

/// @func FORMS_ContextMenuProviderDefault()
///
/// @extends FORMS_FileBrowserContextMenuProvider
///
/// @desc Built-in context menu provider with common file operations.
function FORMS_ContextMenuProviderDefault(): FORMS_FileBrowserContextMenuProvider() constructor
{
	static can_provide = function (_entry) { return true; }

	static get_options = function (_entry, _browser)
	{
		var _options = [];

		if (_entry.IsDirectory)
		{
			var _opt = new FORMS_ContextMenuOption("Open");
			_opt.Icon = FA_ESolid.FolderOpen;
			_opt.Action = method({ browser: _browser, entry: _entry }, function ()
			{
				browser.navigate(entry.Path);
			});
			array_push(_options, _opt);
		}

		array_push(_options, new FORMS_ContextMenuSeparator());

		// Copy Path
		var _opt = new FORMS_ContextMenuOption("Copy Path");
		_opt.Icon = FA_ESolid.Copy;
		_opt.Action = method({ entry: _entry }, function ()
		{
			clipboard_set_text(entry.Path);
		});
		array_push(_options, _opt);

		// Copy Name
		_opt = new FORMS_ContextMenuOption("Copy Name");
		_opt.Action = method({ entry: _entry }, function ()
		{
			clipboard_set_text(entry.Name);
		});
		array_push(_options, _opt);

		return _options;
	}
}

// =========================================================================
// File Browser Widget
// =========================================================================

/// @func FORMS_FileBrowserProps()
///
/// @extends FORMS_CompoundWidgetProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_FileBrowser}.
function FORMS_FileBrowserProps(): FORMS_CompoundWidgetProps() constructor
{
	/// @var {String, Undefined} The starting directory path.
	RootPath = undefined;

	/// @var {Bool, Undefined} Whether to show hidden files.
	ShowHidden = undefined;

	/// @var {Real, Undefined} Thumbnail size for grid view.
	ThumbnailSize = undefined;

	/// @var {Real, Undefined} View mode from {@link FORMS_EFileBrowserView}.
	ViewMode = undefined;
}

/// @func FORMS_FileBrowser([_props])
///
/// @extends FORMS_CompoundWidget
///
/// @desc A file browser widget with real filesystem navigation, thumbnail previews, and drag & drop support.
///
/// @param {Struct.FORMS_FileBrowserProps, Undefined} [_props]
function FORMS_FileBrowser(_props = undefined): FORMS_CompoundWidget(_props) constructor
{
	/// @var {String} Current directory path.
	CurrentPath = forms_get_prop(_props, "RootPath") ?? program_directory;

	/// @var {Bool} Whether to show hidden files. Defaults to `false`.
	ShowHidden = forms_get_prop(_props, "ShowHidden") ?? false;

	/// @var {Real} Thumbnail size for grid view. Defaults to 64.
	ThumbnailSize = forms_get_prop(_props, "ThumbnailSize") ?? 64;

	/// @var {Real} View mode. Defaults to {@link FORMS_EFileBrowserView.Grid}.
	ViewMode = forms_get_prop(_props, "ViewMode") ?? FORMS_EFileBrowserView.Grid;

	/// @var {Array<Struct.FORMS_FileBrowserThumbnailProvider>} Thumbnail providers (checked in order).
	/// @private
	__thumbnailProviders = [
		new FORMS_ThumbnailProviderImage(),
		new FORMS_ThumbnailProviderDefault(),
	];

	/// @var {Array<Struct.FORMS_FileBrowserContextMenuProvider>} Context menu providers (checked in order).
	/// @private
	__contextMenuProviders = [
		new FORMS_ContextMenuProviderDefault(),
	];

	/// @var {Array<Struct.FORMS_FileBrowserEntry>} Current directory entries.
	/// @private
	__entries = [];

	/// @var {Array<String>} Back navigation history.
	/// @private
	__historyBack = [];

	/// @var {Array<String>} Forward navigation history.
	/// @private
	__historyForward = [];

	/// @var {String} Search filter text.
	/// @private
	__searchFilter = "";

	/// @var {Array<Struct.FORMS_FileBrowserEntry>} Folders in the current directory.
	/// @private
	__folders = [];

	/// @var {Array<Struct.FORMS_FileBrowserEntry>} Files in the current directory.
	/// @private
	__files = [];

	// =====================================================================
	// Thumbnail Providers
	// =====================================================================

	/// @func add_thumbnail_provider(_provider)
	///
	/// @desc Adds a custom thumbnail provider. Custom providers are checked before built-in ones.
	///
	/// @param {Struct.FORMS_FileBrowserThumbnailProvider} _provider
	///
	/// @return {Struct.FORMS_FileBrowser} Returns `self`.
	static add_thumbnail_provider = function (_provider)
	{
		// Insert before the default providers
		array_insert(__thumbnailProviders, 0, _provider);
		return self;
	}

	/// @func draw_entry_thumbnail(_entry, _x, _y, _size)
	///
	/// @desc Draws a thumbnail for a file entry using the first matching provider.
	///
	/// @param {Struct.FORMS_FileBrowserEntry} _entry
	/// @param {Real} _x, _y, _size
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

	// =====================================================================
	// Context Menu Providers
	// =====================================================================

	/// @func add_context_menu_provider(_provider)
	///
	/// @desc Adds a custom context menu provider. Custom providers are checked before built-in ones.
	///
	/// @param {Struct.FORMS_FileBrowserContextMenuProvider} _provider
	///
	/// @return {Struct.FORMS_FileBrowser} Returns `self`.
	static add_context_menu_provider = function (_provider)
	{
		array_insert(__contextMenuProviders, 0, _provider);
		return self;
	}

	/// @func open_context_menu(_entry)
	///
	/// @desc Opens a context menu for the given file entry, collecting options from all matching providers.
	///
	/// @param {Struct.FORMS_FileBrowserEntry} _entry
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
			// Remove trailing separator if present
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

	// =====================================================================
	// Navigation
	// =====================================================================

	/// @func navigate(_path[, _addToHistory])
	///
	/// @desc Navigates to a directory.
	///
	/// @param {String} _path The directory path to navigate to.
	/// @param {Bool} [_addToHistory] Whether to add the current path to history. Defaults to `true`.
	///
	/// @return {Struct.FORMS_FileBrowser} Returns `self`.
	static navigate = function (_path, _addToHistory = true)
	{
		if (!directory_exists(_path)) return self;

		if (_addToHistory && CurrentPath != _path)
		{
			array_push(__historyBack, CurrentPath);
			__historyForward = [];
		}

		CurrentPath = _path;
		__scan_current_directory();
		return self;
	}

	/// @func navigate_back()
	///
	/// @desc Navigates to the previous directory in history.
	///
	/// @return {Struct.FORMS_FileBrowser} Returns `self`.
	static navigate_back = function ()
	{
		if (array_length(__historyBack) == 0) return self;
		array_push(__historyForward, CurrentPath);
		var _path = array_pop(__historyBack);
		navigate(_path, false);
		return self;
	}

	/// @func navigate_forward()
	///
	/// @desc Navigates to the next directory in history.
	///
	/// @return {Struct.FORMS_FileBrowser} Returns `self`.
	static navigate_forward = function ()
	{
		if (array_length(__historyForward) == 0) return self;
		array_push(__historyBack, CurrentPath);
		var _path = array_pop(__historyForward);
		navigate(_path, false);
		return self;
	}

	/// @func navigate_up()
	///
	/// @desc Navigates to the parent directory.
	///
	/// @return {Struct.FORMS_FileBrowser} Returns `self`.
	static navigate_up = function ()
	{
		var _parent = filename_path(CurrentPath);
		// Remove trailing slash for comparison
		if (string_length(_parent) > 1
			&& (string_char_at(_parent, string_length(_parent)) == "\\"
				|| string_char_at(_parent, string_length(_parent)) == "/"))
		{
			_parent = string_copy(_parent, 1, string_length(_parent) - 1);
		}
		if (_parent != CurrentPath && _parent != "")
		{
			navigate(_parent);
		}
		return self;
	}

	/// @func get_selected_entries()
	///
	/// @desc Returns all currently selected entries.
	///
	/// @return {Array<Struct.FORMS_FileBrowserEntry>}
	static get_selected_entries = function ()
	{
		var _selected = [];
		for (var i = 0; i < array_length(__entries); ++i)
		{
			if (__entries[i].Selected)
			{
				array_push(_selected, __entries[i]);
			}
		}
		return _selected;
	}

	// =====================================================================
	// Internal: Directory Scanning
	// =====================================================================

	/// @private
	static __scan_current_directory = function ()
	{
		// Clean up old thumbnails
		for (var i = 0; i < array_length(__files); ++i)
		{
			var _e = __files[i];
			if (_e.Thumbnail != undefined && sprite_exists(_e.Thumbnail))
			{
				sprite_delete(_e.Thumbnail);
			}
		}

		__entries = [];
		__folders = [];
		__files = [];
		var _path = CurrentPath;

		// Scan for all entries
		var _fname = file_find_first(_path + "\\*", fa_directory);
		while (_fname != "")
		{
			if (_fname != "." && _fname != "..")
			{
				var _fullPath = _path + "\\" + _fname;
				var _isDir = directory_exists(_fullPath);

				if (!ShowHidden && string_char_at(_fname, 1) == ".")
				{
					// Skip hidden files
				}
				else
				{
					var _entry = new FORMS_FileBrowserEntry(_fullPath, _isDir);
					array_push(__entries, _entry);
					if (_isDir)
					{
						array_push(__folders, _entry);
					}
					else
					{
						array_push(__files, _entry);
					}
				}
			}
			_fname = file_find_next();
		}
		file_find_close();

		// Sort alphabetically
		var _sortFunc = function (_a, _b)
		{
			var _na = string_lower(_a.Name);
			var _nb = string_lower(_b.Name);
			return (_na < _nb) ? -1 : ((_na > _nb) ? 1 : 0);
		};
		array_sort(__folders, _sortFunc);
		array_sort(__files, _sortFunc);
	}

	/// @private
	/// @private
	static __get_filtered_folders = function ()
	{
		if (__searchFilter == "") return __folders;
		var _filter = string_lower(__searchFilter);
		var _result = [];
		for (var i = 0; i < array_length(__folders); ++i)
		{
			if (string_pos(_filter, string_lower(__folders[i].Name)) > 0)
			{
				array_push(_result, __folders[i]);
			}
		}
		return _result;
	}

	/// @private
	static __get_filtered_files = function ()
	{
		if (__searchFilter == "") return __files;
		var _filter = string_lower(__searchFilter);
		var _result = [];
		for (var i = 0; i < array_length(__files); ++i)
		{
			if (string_pos(_filter, string_lower(__files[i].Name)) > 0)
			{
				array_push(_result, __files[i]);
			}
		}
		return _result;
	}

	// =====================================================================
	// Breadcrumb Path
	// =====================================================================

	/// @private
	static __get_breadcrumbs = function ()
	{
		var _parts = [];
		var _path = CurrentPath;
		var _pos = 1;
		var _len = string_length(_path);

		while (_pos <= _len)
		{
			// Find next separator
			var _nextSep = _pos;
			while (_nextSep <= _len
				&& string_char_at(_path, _nextSep) != "\\"
				&& string_char_at(_path, _nextSep) != "/")
			{
				_nextSep++;
			}

			var _part = string_copy(_path, _pos, _nextSep - _pos);
			if (_part != "")
			{
				var _partPath = string_copy(_path, 1, _nextSep - 1);
				array_push(_parts, { name: _part, path: _partPath });
			}

			_pos = _nextSep + 1;
		}

		return _parts;
	}

	// =====================================================================
	// UI Construction
	// =====================================================================

	FlexBox = new FORMS_FlexBox({ Width: "100%", Height: "100%", IsHorizontal: false });
	add_child(FlexBox);

	// Toolbar
	var _self = self;
	Toolbar = new(function (_fb): FORMS_Container() constructor
	{
		FileBrowser = _fb;
		Width.from_string("100%");
		Height.from_string("52px");
		Pen.SpacingX = 2;

		/// @private
		__pathEditing = false;

		/// @private
		__pathEditValue = "";

		static draw_content = function ()
		{
			var _style = forms_get_style();
			var _fb = FileBrowser;
			var _iconProps = { Width: 24 };
			Pen.start();

			// Navigation buttons
			if (Pen.icon_solid(FA_ESolid.ArrowLeft, _iconProps))
			{
				_fb.navigate_back();
			}
			if (Pen.icon_solid(FA_ESolid.ArrowRight, _iconProps))
			{
				_fb.navigate_forward();
			}
			if (Pen.icon_solid(FA_ESolid.ArrowUp, _iconProps))
			{
				_fb.navigate_up();
			}
			if (Pen.icon_solid(FA_ESolid.ArrowRotateRight, _iconProps))
			{
				_fb.__scan_current_directory();
			}

			Pen.space();

			// Path bar: editable input + breadcrumb buttons
			var _padX = Pen.PaddingX ?? _style.Padding;
			var _pathWidth = __realWidth - Pen.X - _padX;
			if (__pathEditing)
			{
				// Editable path input
				if (Pen.input("fb-path", __pathEditValue,
					{
						Width: _pathWidth,
						Placeholder: "Enter path...",
					}))
				{
					__pathEditValue = Pen.get_result();
				}

				// Confirm on Enter
				if (keyboard_check_pressed(vk_enter))
				{
					if (directory_exists(__pathEditValue))
					{
						_fb.navigate(__pathEditValue);
					}
					__pathEditing = false;
				}

				// Cancel on Escape or clicking outside
				if (keyboard_check_pressed(vk_escape)
					|| (mouse_check_button_pressed(mb_left)
						&& !Pen.is_mouse_over(Pen.X - _pathWidth, Pen.Y, _pathWidth, Pen.__lineHeight)))
				{
					__pathEditing = false;
				}
			}
			else
			{
				// Breadcrumb buttons - click path area to edit
				var _crumbs = _fb.__get_breadcrumbs();
				var _crumbStartX = Pen.X;
				for (var i = 0; i < array_length(_crumbs); ++i)
				{
					if (i > 0) Pen.text("/", { Muted: true });
					if (Pen.button(_crumbs[i].name, { Minimal: true }))
					{
						_fb.navigate(_crumbs[i].path);
					}
				}

				// Edit icon at the end
				Pen.space();
				if (Pen.icon_solid(FA_ESolid.PenToSquare,
					{
						Width: 20,
						Muted: true,
						Tooltip: "Edit path"
					}))
				{
					__pathEditing = true;
					__pathEditValue = _fb.CurrentPath;
				}
			}

			Pen.nl();

			// Search input
			var _padX = Pen.PaddingX ?? _style.Padding;
			var _hasSearch = (_fb.__searchFilter != "");
			var _clearBtnWidth = _hasSearch ? 20 : 0;
			if (Pen.input("fb-search", _fb.__searchFilter,
				{
					Width: __realWidth - Pen.X - _padX - 60 - _clearBtnWidth,
					Placeholder: "Search...",
				}))
			{
				_fb.__searchFilter = Pen.get_result();
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
					_fb.__searchFilter = "";
				}
			}

			Pen.space();

			// View mode toggle
			if (Pen.icon_solid(FA_ESolid.TableCellsLarge,
				{
					Width: 24,
					Active: (_fb.ViewMode
						== FORMS_EFileBrowserView.Grid),
					Tooltip: "Grid View"
				}))
			{
				_fb.ViewMode = FORMS_EFileBrowserView.Grid;
			}
			if (Pen.icon_solid(FA_ESolid.List,
				{
					Width: 24,
					Active: (_fb.ViewMode
						== FORMS_EFileBrowserView.List),
					Tooltip: "List View"
				}))
			{
				_fb.ViewMode = FORMS_EFileBrowserView.List;
			}

			Pen.finish();
			FORMS_CONTENT_UPDATE_SIZE;
			return self;
		}
	})(_self);
	FlexBox.add_child(Toolbar);

	// Dock: left = folder tree, right = file view
	Dock = new FORMS_Dock({ Width: "100%", Flex: 1 });
	FlexBox.add_child(Dock);

	// Folder list panel (left side - shows folders in current directory)
	FolderList = new(function (_fb): FORMS_ScrollPane() constructor
	{
		FileBrowser = _fb;
		Pen.PaddingX = 4;
		Pen.PaddingY = 4;
		BackgroundColorIndex = 0;

		static draw_content = function ()
		{
			var _style = forms_get_style();
			var _fb = FileBrowser;
			var _folders = _fb.__get_filtered_folders();
			var _folderCount = array_length(_folders);

			Pen.start();

			var _lineH = Pen.__lineHeight;

			if (_folderCount > 0)
			{
				// Virtual scrolling: only draw visible rows
				var _visibleTop = ScrollY;
				var _visibleBottom = ScrollY + __realHeight;
				var _firstVisible = max(floor(_visibleTop / _lineH), 0);
				var _lastVisible = min(ceil(_visibleBottom / _lineH), _folderCount - 1);

				// Skip to first visible row
				Pen.Y = Pen.StartY + _firstVisible * _lineH;

				for (var i = _firstVisible; i <= _lastVisible; ++i)
				{
					var _folder = _folders[i];

					// Hover + click on full row
					var _mouseOver = Pen.is_mouse_over(Pen.X, Pen.Y, Pen.Width, _lineH);
					if (_mouseOver)
					{
						forms_draw_rectangle(Pen.X, Pen.Y, Pen.Width, _lineH, _style.Background[3]
							.get(), 0.5);

						if (forms_left_click())
						{
							_fb.navigate(_folder.Path);
						}

						// Right-click context menu
						if (mouse_check_button_pressed(mb_right))
						{
							_fb.open_context_menu(_folder);
						}
					}

					// Folder icon
					fa_draw(FA_FntSolid12, FA_ESolid.Folder, Pen.X, Pen.Y, 0x41C0EB);
					Pen.move(20);

					// Folder name
					Pen.text(_folder.Name);

					Pen.nl();
				}

				// Set total content size for scrollbar
				Pen.MaxY = max(Pen.MaxY, Pen.StartY + _folderCount * _lineH);
			}
			else
			{
				Pen.text("No folders", { Muted: true });
				Pen.nl();
			}

			Pen.finish();
			FORMS_CONTENT_UPDATE_SIZE;
			return self;
		}
	})(_self);

	// File view panel
	FileView = new(function (_fb): FORMS_ScrollPane() constructor
	{
		FileBrowser = _fb;
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
			var _fb = FileBrowser;
			var _entries = _fb.__get_filtered_files();
			var _entryCount = array_length(_entries);

			Pen.start();

			if (_fb.ViewMode == FORMS_EFileBrowserView.Grid)
			{
				__draw_grid(_entries, _entryCount, _style, _fb);
			}
			else
			{
				__draw_list(_entries, _entryCount, _style, _fb);
			}

			Pen.finish();
			FORMS_CONTENT_UPDATE_SIZE;
			return self;
		}

		/// @private
		static __draw_grid = function (_entries, _entryCount, _style, _fb)
		{
			var _thumbSize = _fb.ThumbnailSize;
			var _cellWidth = _thumbSize + 8;
			var _cellHeight = _thumbSize + 20;
			var _cols = max(floor((Pen.Width) / _cellWidth), 1);
			var _totalRows = ceil(_entryCount / _cols);

			// Virtual scrolling: only draw visible rows
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

				// Selection highlight
				if (_entry.Selected)
				{
					forms_draw_roundrect(_x, _y, _cellWidth - 2, _cellHeight - 2, 4,
						_style.Highlight.get(), 1.0);
				}

				// Mouse interaction
				var _mouseOver = Pen.is_mouse_over(_x, _y, _cellWidth - 2, _cellHeight - 2);
				if (_mouseOver)
				{
					if (!_entry.Selected)
					{
						forms_draw_roundrect(_x, _y, _cellWidth - 2, _cellHeight - 2, 4,
							_style.Background[3].get(), 0.5);
					}

					// Click to select
					if (forms_left_click())
					{
						if (!keyboard_check(vk_control))
						{
							for (var j = 0; j < _entryCount; ++j) _entries[j].Selected = false;
						}
						_entry.Selected = !_entry.Selected;
					}

					// Double-click to open
					if (mouse_check_button_pressed(mb_left) && _entry.IsDirectory)
					{
						if (_entry[$ "__lastClick"] != undefined
							&& current_time - _entry.__lastClick < 400)
						{
							_fb.navigate(_entry.Path);
							_entry.__lastClick = 0;
						}
						else
						{
							_entry[$ "__lastClick"] = current_time;
						}
					}

					// Drag initiation
					if (mouse_check_button_pressed(mb_left))
					{
						__dragPressIndex = i;
						__dragPressX = forms_mouse_get_x();
						__dragPressY = forms_mouse_get_y();
					}

					forms_set_tooltip(_entry.Name);

					// Right-click context menu
					if (mouse_check_button_pressed(mb_right))
					{
						if (!_entry.Selected)
						{
							for (var j = 0; j < _entryCount; ++j) _entries[j].Selected = false;
							_entry.Selected = true;
						}
						_fb.open_context_menu(_entry);
					}
				}

				// Thumbnail
				_fb.draw_entry_thumbnail(_entry, _x + 4, _y + 2, _thumbSize);

				// Label (trimmed)
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

			// Set total content size for scrollbar (even for non-drawn items)
			Pen.MaxY = max(Pen.MaxY, Pen.StartY + _totalRows * _cellHeight);
			Pen.MaxX = max(Pen.MaxX, Pen.StartX + _cols * _cellWidth);

			// Drag handling
			__handle_drag(_entries, _entryCount, _fb);
		}

		/// @private
		static __draw_list = function (_entries, _entryCount, _style, _fb)
		{
			var _lineH = Pen.__lineHeight;

			// Virtual scrolling: only draw visible rows
			var _visibleTop = ScrollY;
			var _visibleBottom = ScrollY + __realHeight;
			var _firstVisible = max(floor(_visibleTop / _lineH), 0);
			var _lastVisible = min(ceil(_visibleBottom / _lineH), _entryCount - 1);

			// Skip to first visible row
			Pen.Y = Pen.StartY + _firstVisible * _lineH;

			for (var i = _firstVisible; i <= _lastVisible; ++i)
			{
				var _entry = _entries[i];

				// Selection highlight
				if (_entry.Selected)
				{
					forms_draw_rectangle(Pen.X, Pen.Y, Pen.Width, _lineH, _style.Highlight.get());
				}

				// Mouse interaction
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

					if (mouse_check_button_pressed(mb_left) && _entry.IsDirectory)
					{
						if (_entry[$ "__lastClick"] != undefined
							&& current_time - _entry.__lastClick < 400)
						{
							_fb.navigate(_entry.Path);
							_entry.__lastClick = 0;
						}
						else
						{
							_entry[$ "__lastClick"] = current_time;
						}
					}

					if (mouse_check_button_pressed(mb_left))
					{
						__dragPressIndex = i;
						__dragPressX = forms_mouse_get_x();
						__dragPressY = forms_mouse_get_y();
					}

					// Right-click context menu
					if (mouse_check_button_pressed(mb_right))
					{
						if (!_entry.Selected)
						{
							for (var j = 0; j < _entryCount; ++j) _entries[j].Selected = false;
							_entry.Selected = true;
						}
						_fb.open_context_menu(_entry);
					}
				}

				// Icon
				var _icon = _entry.IsDirectory ? FA_ESolid.Folder : FA_ESolid.File;
				var _iconColor = _entry.IsDirectory ? 0x41C0EB : _style.TextMuted.get();
				fa_draw(FA_FntSolid12, _icon, Pen.X, Pen.Y, _iconColor);
				Pen.move(20);

				// Name
				Pen.text(_entry.Name, { Muted: !_entry.Selected });

				// Extension (right-aligned, muted)
				if (!_entry.IsDirectory && _entry.Extension != "")
				{
					var _extWidth = string_width(_entry.Extension);
					forms_draw_text(Pen.StartX + Pen.Width - _extWidth, Pen.Y,
						_entry.Extension, _style.TextMuted.get());
				}

				Pen.nl();
			}

			// Set total content size for scrollbar
			Pen.MaxY = max(Pen.MaxY, Pen.StartY + _entryCount * _lineH);

			// Drag handling
			__handle_drag(_entries, _entryCount, _fb);
		}

		/// @private
		static __handle_drag = function (_entries, _entryCount, _fb)
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
					// Ensure the pressed entry is selected
					if (__dragPressIndex < _entryCount && !_entries[__dragPressIndex].Selected)
					{
						for (var j = 0; j < _entryCount; ++j) _entries[j].Selected = false;
						_entries[__dragPressIndex].Selected = true;
					}

					var _selected = _fb.get_selected_entries();
					if (array_length(_selected) > 0)
					{
						_root.DragTarget = new FORMS_FileDragPayload(_selected);
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
	_dockLeft.set_tabs([FolderList]);

	var _dockRight = Dock.get_second();
	_dockRight.ShowTabs = false;
	_dockRight.set_tabs([FileView]);

	// Initial scan
	__scan_current_directory();
}
