/// @func ce_tween_back_in(_time, _value, _final, _duration[, back])
/// @desc Cubic easing in with a back effect - accelerating from zero velocity.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
/// @param {real} [_back] The intensity of the back effect.
function ce_tween_back_in(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	return _value + _final - ce_tween_back_out(_duration - _time, _value, _final, _duration);
}

/// @func ce_tween_back_inout(_time, _value, _final, _duration[, back])
/// @desc Cubic easing in with a back effect - acceleration until halfway, then deceleration.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
/// @param {real} [_back] The intensity of the back effect.
function ce_tween_back_inout(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	if (_time < _duration * 0.5)
	{
		return ((_value + _final - ce_tween_back_out(_duration - _time * 2, _value, _final, _duration)) * 0.5) + (_value * 0.5);
	}
	return (ce_tween_back_out(_time * 2 - _duration, _value, _final, _duration) * 0.5) + (_final * 0.5);
}

/// @func ce_tween_back_out(_time, _value, _final, _duration[, back])
/// @desc Cubic easing in with a back effect - decelerating to zero velocity.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
/// @param {real} [_back] The intensity of the back effect.
function ce_tween_back_out(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	var _back = (argument_count > 4) ? argument[4] : 1.75;
	_final -= _value;
	_time = (_time / _duration) - 1;
	return ((_final * ((_time * _time * ((_back + 1) * _time + _back)) + 1)) + _value);
}

/// @func ce_tween_bounce_in(_time, _value, _final, _duration)
/// @desc Easing in with bounces - accelerating from zero velocity.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_bounce_in(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	return _value + _final - ce_tween_bounce_out(_duration - _time, _value, _final, _duration);
}

/// @func ce_tween_bounce_inout(_time, _value, _final, _duration)
/// @desc Easing in/out with bounces - acceleration until halfway, then deceleration.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_bounce_inout(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	if (_time < _duration * 0.5)
	{
		return ((_value + _final - ce_tween_bounce_out(_duration - _time * 2, _value, _final, _duration)) * 0.5) + (_value * 0.5);
	}
	return (ce_tween_bounce_out(_time * 2 - _duration, _value, _final, _duration) * 0.5) + (_final * 0.5);
}

/// @func ce_tween_bounce_out(_time, _value, _final, _duration)
/// @desc Easing in/out with bounces - decelerating to zero velocity.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_bounce_out(_time, _value, _final, _duration)
{
	_time /= _duration;
	_final -= _value;

	if (_time < 1 / 2.75)
	{
		return ((_final * 7.5625 * _time * _time) + _value);
	}

	if (_time < 2 / 2.75)
	{
		_time -= 1.5 / 2.75;
		return (_final * ((7.5625 * _time * _time) + 0.75) + _value);
	}

	if (_time < (2.5 / 2.75))
	{
		_time -= 2.25 / 2.75;
		return (_final * ((7.5625 * _time * _time) + 0.9375) + _value);
	}

	_time -= 2.625 / 2.75;
	return ((_final * ((7.5625 * _time * _time) + 0.984375)) + _value);
}

/// @func ce_tween_circ_in(_time, _value, _final, _duration)
/// @desc Circular easing in - accelerating from zero velocity.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_circ_in(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	return _value + _final - ce_tween_circ_out(_duration - _time, _value, _final, _duration);
}

/// @func ce_tween_circ_inout(_time, _value, _final, _duration)
/// @desc Circular easing in/out - acceleration until halfway, then deceleration.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_circ_inout(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	if (_time < _duration * 0.5)
	{
		return ((_value + _final - ce_tween_circ_out(_duration - _time * 2, _value, _final, _duration)) * 0.5) + (_value * 0.5);
	}
	return (ce_tween_circ_out(_time * 2 - _duration, _value, _final, _duration) * 0.5) + (_final * 0.5);
}

/// @func ce_tween_circ_out(_time, _value, _final, _duration)
/// @desc Circular easing out - decelerating to zero velocity.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_circ_out(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	_final -= _value;
	_time /= _duration;
	--_time;
	return ((_final * sqr(1 - (_time * _time))) + _value);
}

/// @func ce_tween_cubic_in(_time, _value, _final, _duration)
/// @desc Cubic easing in - accelerating from zero velocity.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_cubic_in(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	return _value + _final - ce_tween_cubic_out(_duration - _time, _value, _final, _duration);
}

/// @func ce_tween_cubic_inout(_time, _value, _final, _duration)
/// @desc Cubic easing in/out - acceleration until halfway, then deceleration.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_cubic_inout(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	if (_time < _duration * 0.5)
	{
		return ((_value + _final - ce_tween_cubic_out(_duration - _time * 2, _value, _final, _duration)) * 0.5) + (_value * 0.5);
	}
	return (ce_tween_cubic_out(_time * 2 - _duration, _value, _final, _duration) * 0.5) + (_final * 0.5);
}

/// @func ce_tween_cubic_out(_time, _value, _final, _duration)
/// @desc Cubic easing out - decelerating to zero velocity
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_cubic_out(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	_final -= _value;
	_time /= _duration;
	--_time;
	return ((_final * ((_time * _time * _time) + 1)) + _value);
}

/// @func ce_tween_elastic_in(_time, _value, _final, _duration)
/// @desc Easing with an elastic effect - accelerating from zero velocity.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_elastic_in(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	return _value + _final - ce_tween_elastic_out(_duration - _time, _value, _final, _duration);
}

/// @func ce_tween_elastic_inout(_time, _value, _final, _duration)
/// @desc Easing in/out with an elastic effect - acceleration until halfway, then deceleration.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_elastic_inout(_time, _value, _final, _duration)
{
	if (_time==0)
	{
		return _value;
	}

	_final -= _value;
	_time /= _duration * 0.5;

	if (_time == 2)
	{
		return (_value + _final);
	}

	var p = _duration * 0.3 * 1.5;
	var s = (_final < abs(_final))
		? (p / 4)
		: (p / (2 * pi)) * arcsin(1);

	_time -= 1;

	if (_time < 0)
	{
		return ((-0.5 * _final * power(2, 10 * _time) * sin(((_time * _duration) - s) * ((2 * pi) / p))) + _value);
	}

	return ((0.5 * _final * power(2, -10 * _time) * sin(((_time * _duration) - s) * ((2 * pi) / p))) + _final + _value);
}

/// @func ce_tween_elastic_out(_time, _value, _final, _duration)
/// @desc Easing out with an elastic effect - decelerating to zero velocity.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_elastic_out(_time, _value, _final, _duration)
{
	if (_time == 0)
	{
		return _value;
	}

	_final -= _value;
	_time /= _duration;

	if (_time == 1)
	{
		return (_value + _final);
	}

	var p = _duration * 0.3;
	var s = (_final < 0)
		? (p / 4)
		: (p / (2 * pi)) * arcsin(1);

	return ((_final * power(2,-10 * _time) * sin(((_time * _duration) - s) * ((2 * pi) / p))) + _final + _value);
}

/// @func ce_tween_exp_in(_time, _value, _final, _duration)
/// @desc Exponential easing in - accelerating from zero velocity.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_exp_in(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	return _value + _final - ce_tween_exp_out(_duration - _time, _value, _final, _duration);
}

/// @func ce_tween_exp_inout(_time, _value, _final, _duration)
/// @desc Exponential easing in/out - accelerating until halfway, then decelerating.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_exp_inout(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	if (_time < _duration * 0.5)
	{
		return ((_value + _final - ce_tween_exp_out(_duration - _time * 2, _value, _final, _duration)) * 0.5) + (_value * 0.5);
	}
	return (ce_tween_exp_out(_time * 2 - _duration, _value, _final, _duration) * 0.5) + (_final * 0.5);
}

/// @func ce_tween_exp_out(_time, _value, _final, _duration)
/// @desc Exponential easing out - decelerating to zero velocity.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_exp_out(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	_final -= _value;
	return ((_final * (-power(2, -10 * (_time / _duration)) + 1)) + _value);
}

/// @func ce_tween_linear(_time, _value, _final, _duration)
/// @desc Simple linear tweening - no easing, no acceleration.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_linear(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	_final -= _value;
	return ((_final * (_time / _duration)) + _value);
}

/// @func ce_tween_quad_in(_time, _value, _final, _duration)
/// @desc Quadratic easing in - accelerating from zero velocity.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_quad_in(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	return _value + _final - ce_tween_quad_out(_duration - _time, _value, _final, _duration);
}

/// @func ce_tween_quad_inout(_time, _value, _final, _duration)
/// @desc Quadratic easing in/out - acceleration until halfway, then deceleration.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_quad_inout(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	if (_time < _duration * 0.5)
	{
		return ((_value + _final - ce_tween_quad_out(_duration - _time * 2, _value, _final, _duration)) * 0.5) + (_value * 0.5);
	}
	return (ce_tween_quad_out(_time * 2 - _duration, _value, _final, _duration) * 0.5) + (_final * 0.5);
}

/// @func ce_tween_quad_out(_time, _value, _final, _duration)
/// @desc Quadratic easing out - decelerating to zero velocity.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_quad_out(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	_final -= _value;
	_time /= _duration;
	return ((-_final * _time * (_time - 2)) + _value);
}

/// @func ce_tween_quart_in(_time, _value, _final, _duration)
/// @desc Quartic easing in - accelerating from zero velocity.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_quart_in(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	return _value + _final - ce_tween_quart_out(_duration - _time, _value, _final, _duration);
}

/// @func ce_tween_quart_inout(_time, _value, _final, _duration)
/// @desc Quartic easing in/out - acceleration until halfway, then deceleration.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_quart_inout(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	if (_time < _duration * 0.5)
	{
		return ((_value + _final - ce_tween_quart_out(_duration - _time * 2, _value, _final, _duration)) * 0.5) + (_value * 0.5);
	}
	return (ce_tween_quart_out(_time * 2 - _duration, _value, _final, _duration) * 0.5) + (_final * 0.5);
}

/// @func ce_tween_quart_out(_time, _value, _final, _duration)
/// @desc Quartic easing out - decelerating to zero velocity.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_quart_out(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	_final -= _value;
	_time /= _duration;
	--_time;
	return ((-_final * (_time * _time * _time * _time - 1)) + _value);
}

/// @func ce_tween_quint_in(_time, _value, _final, _duration)
/// @desc Quintic easing in - accelerating from zero velocity.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_quint_in(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	return _value + _final - ce_tween_quint_out(_duration - _time, _value, _final, _duration);
}

/// @func ce_tween_quint_inout(_time, _value, _final, _duration)
/// @desc Quintic easing in/out - acceleration until halfway, then deceleration.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_quint_inout(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	if (_time < _duration * 0.5)
	{
		return ((_value + _final - ce_tween_quint_out(_duration - _time * 2, _value, _final, _duration)) * 0.5) + (_value * 0.5);
	}
	return (ce_tween_quint_out(_time * 2 - _duration, _value, _final, _duration) * 0.5) + (_final * 0.5);
}

/// @func ce_tween_quint_out(_time, _value, _final, _duration)
/// @desc Quintic easing out - decelerating to zero velocity.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_quint_out(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	_final -= _value;
	_time /= _duration;
	--_time;
	return ((_final * ((_time * _time * _time * _time * _time) + 1)) + _value);
}

/// @func ce_tween_sin_in(_time, _value, _final, _duration)
/// @desc Sinusoidal easing in - accelerating from zero velocity.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_sin_in(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	return _value + _final - ce_tween_sin_out(_duration - _time, _value, _final, _duration);
}

/// @func ce_tween_sin_inout(_time, _value, _final, _duration)
/// @desc Sinusoidal easing in/out - accelerating until halfway, then decelerating.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_sin_inout(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	if (_time < _duration * 0.5)
	{
		return ((_value + _final - ce_tween_sin_out(_duration - _time * 2, _value, _final, _duration)) * 0.5) + (_value * 0.5);
	}
	return (ce_tween_sin_out(_time * 2 - _duration, _value, _final, _duration) * 0.5) + (_final * 0.5);
}

/// @func ce_tween_sin_out(_time, _value, _final, _duration)
/// @desc Sinusoidal easing out - decelerating to zero velocity.
/// @param {real} _time Current time in frames/seconds/µs...
/// @param {real} _value Starting value.
/// @param {real} _final Target value.
/// @param {real} _duration Duration in frames/seconds/µs...
function ce_tween_sin_out(_time, _value, _final, _duration)
{
	gml_pragma("forceinline");
	_final -= _value;
	return ((_final * sin((_time / _duration) * pi * 0.5)) + _value);
}