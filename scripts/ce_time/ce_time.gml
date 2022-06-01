/// @func ce_hours_to_ms(_hours)
/// @param {real} _hours Hours to be converted to milliseconds.
/// @return {real} Hours converted to milliseconds.
function ce_hours_to_ms(_hours)
{
	gml_pragma("forceinline");
	return (_hours * 3600000);
}

/// @func ce_minutes_to_ms(_minutes)
/// @param {real} _minutes Minutes to be converted to milliseconds.
/// @return {real} Minutes converted to milliseconds.
function ce_minutes_to_ms(_minutes)
{
	gml_pragma("forceinline");
	return (_minutes * 60000);
}

/// @func ce_seconds_to_ms(_seconds)
/// @param {real} _seconds Seconds to be converted to milliseconds.
/// @return {real} Seconds converted to milliseconds.
function ce_seconds_to_ms(_seconds)
{
	gml_pragma("forceinline");
	return (_seconds * 1000);
}

/// @func ce_per_second(_value)
/// @param {real} value The value to convert.
/// @return {real} The converted value.
/// @example
/// This will make the calling instance move to the right by 32px per second,
/// independently on the framerate.
/// ```gml
/// x += ce_per_second(32);
/// ```
function ce_per_second(_value)
{
	gml_pragma("forceinline");
	return (_value * delta_time * 0.000001);
}