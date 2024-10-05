/// @macro {Code} A shorthand for
/// `Width = Pen.get_max_x(); Height = Pen.get_max_y();`. Useful in custom
/// implementations of {@link FORMS_Content.draw}.
#macro FORMS_CONTENT_UPDATE_SIZE \
    do { Width = Pen.get_max_x(); Height = Pen.get_max_y(); } until (1)

/// @func FORMS_Content()
///
/// @desc A struct that defines contents drawn by {@link FORMS_Container}s.
///
/// @example
/// The following example defines a custom content that draws text
/// "Hello World!".
/// ```gml
/// function MyContent() : FORMS_Content() constructor
/// {
///     static draw = function ()
///     {
///         Pen.start()
///             .text("Hello World!")
///             .nl()
///             .finish();
///         FORMS_CONTENT_UPDATE_SIZE;
///         return self;
///     };
/// }
/// ```
///
/// @see FORMS_CONTENT_UPDATE_SIZE
function FORMS_Content() constructor
{
	/// @var {Struct.FORMS_Container, Undefined} The container to which this
	/// content belongs or `undefined` (default).
	/// @readonly
	Container = undefined;

	/// @var {Struct.FORMS_Pen} A pen used by this content to draw text and
	/// controls like inputs, checkboxes, buttons etc.
	/// @readonly
	Pen = new FORMS_Pen(self);

	/// @var {Real} The width of the content. Updated at the end of
	/// {@link FORMS_Content.draw}.
	/// @see FORMS_Content.fetch_size
	Width = 0;

	/// @var {Real} The height of the content. Updated at the end of
	/// {@link FORMS_Content.draw}.
	/// @see FORMS_Content.fetch_size
	Height = 0;

	/// @func fetch_size()
	///
	/// @desc Draws the content into a off-screen surface to fetch the width and
	/// height of the content.
	///
	/// @return {Struct.FORMS_Content} Returns `self`.
	static fetch_size = function ()
	{
		var _surface = surface_create(1, 1);
		surface_set_target(_surface);
		draw();
		surface_reset_target();
		surface_free(_surface);
		return self;
	};

	/// @func draw()
	///
	/// @desc Draws the content and updates its size.
	///
	/// @return {Struct.FORMS_Content} Returns `self`.
	///
	/// @example
	/// The following example defines a custom content that draws text
	/// "Hello World!".
	/// ```gml
	/// function MyContent() : FORMS_Content() constructor
	/// {
	///     static draw = function ()
	///     {
	///         Pen.start()
	///             .text("Hello World!")
	///             .nl()
	///             .finish();
	///         FORMS_CONTENT_UPDATE_SIZE;
	///         return self;
	///     };
	/// }
	/// ```
	///
	/// @see FORMS_CONTENT_UPDATE_SIZE
	static draw = function ()
	{
		return self;
	};
}
