/// @func FORMS_FileBrowserProps()
///
/// @extends FORMS_CompoundWidgetProps
///
/// @desc Properties accepted by the constructor of {@link FORMS_FileBrowser}.
function FORMS_FileBrowserProps(): FORMS_CompoundWidgetProps() constructor {}

/// @func FORMS_FileBrowser([_props])
///
/// @extends FORMS_CompoundWidget
///
/// @desc
///
/// @param {Struct.FORMS_FileBrowserProps, Undefined} [_props]
function FORMS_FileBrowser(_props = undefined): FORMS_CompoundWidget(_props) constructor
{
	var _propsFolder = {
		Icon: FA_ESolid.FolderOpen,
		IconCollapsed: FA_ESolid.Folder,
		IconFont: FA_FntSolid12,
		IconColor: c_gray,
		Collapsed: true,
	};

	__folderTree = new FORMS_Tree([
		new FORMS_TreeItem("Engine", _propsFolder, [
			new FORMS_TreeItem("Shaders", _propsFolder),
		]),
		new FORMS_TreeItem("Project", _propsFolder, [
			new FORMS_TreeItem("Models", _propsFolder, [
				new FORMS_TreeItem("Characters", _propsFolder),
				new FORMS_TreeItem("Items", _propsFolder),
				new FORMS_TreeItem("Scenery", _propsFolder),
			]),
			new FORMS_TreeItem("Sounds", _propsFolder),
			new FORMS_TreeItem("Textures", _propsFolder),
		]),
	]);

	FlexBox = new FORMS_FlexBox({ Width: "100%", Height: "100%", IsHorizontal: false });
	add_child(FlexBox);

	/// @readonly
	Toolbar = new(function (): FORMS_Container() constructor
	{
		Width.from_string("100%");
		Height.from_string("60px");
		Pen.SpacingX = 4;
		FileBrowser = undefined;

		static draw_content = function ()
		{
			var _iconProps = { BackgroundAlpha: 1.0, BackgroundColorHover: 0x555555 };
			Pen.start();

			if (Pen.icon_solid(FA_ESolid.ArrowLeft, _iconProps)) {}

			if (Pen.icon_solid(FA_ESolid.ArrowRight, _iconProps)) {}

			if (Pen.icon_solid(FA_ESolid.House, _iconProps)) {}

			if (Pen.icon_solid(FA_ESolid.ArrowRotateRight, _iconProps)) {}

			if (Pen.icon_solid(FA_ESolid.Upload, _iconProps)) {}

			Pen.button("Path");
			Pen.button("To");
			Pen.button("Some");
			Pen.button("Folder");
			Pen.button("Here");

			Pen.nl();

			FileBrowser ??= find_parent_type(FORMS_FileBrowser);

			Pen.input("input-search-folder", "",
			{
				Width: FileBrowser.Dock.get_first().__realWidth - Pen
					.PaddingX,
				Placeholder: "Search folders..."
			});
			Pen.input("input-search-file", "",
			{
				Width: __realWidth - Pen.X - Pen.PaddingX - 4,
				Placeholder: "Search files..."
			});

			Pen.finish();
			FORMS_CONTENT_UPDATE_SIZE;
			return self;
		};
	})();

	FlexBox.add_child(Toolbar);

	/// @readonly
	Dock = new FORMS_Dock({ Width: "100%", Flex: 1, SplitterColor: 0x272727 });

	FlexBox.add_child(Dock);

	/// @readonly
	FileTree = new FORMS_ScrollPane(new(function (): FORMS_Container() constructor
	{
		FileBrowser = undefined;
		Pen.PaddingX = 4;
		Pen.PaddingY = 4;
		BackgroundColor = 0x212121;

		static draw_content = function ()
		{
			Pen.start();
			FileBrowser.__folderTree.draw(Pen);
			Pen.finish();
			FORMS_CONTENT_UPDATE_SIZE;
			return self;
		};
	})());

	FileTree.Container.FileBrowser = self;
	FileTree.HScrollbar.BackgroundColor = 0x212121;
	FileTree.VScrollbar.BackgroundColor = 0x212121;

	Dock.split_left(0.3);

	var _dockLeft = Dock.get_first();
	_dockLeft.ShowTabs = false;
	_dockLeft.set_tabs([FileTree]);

	var _dockRight = Dock.get_second();
	_dockRight.ShowTabs = false;
	_dockRight.BackgroundColor = 0x212121;
}
