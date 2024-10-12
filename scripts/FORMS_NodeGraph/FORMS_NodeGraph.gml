/// @func FORMS_NodeGraph()
///
/// @desc
///
/// @private
function FORMS_NodeGraph() constructor
{
	/// @var {Array<Struct.FORMS_Node>}
	/// @readonly
	Nodes = [];

	/// @private
	__evalId = 0;

	/// @var {Struct.FORMS_Pin, Undefined}
	/// @private
	__connectFrom = undefined;

	/// @private
	__connectToX = 0;

	/// @private
	__connectToY = 0;

	/// @func add_node(_node)
	///
	/// @desc Adds a node to the graph.
	///
	/// @param {Struct.FORMS_Node} _node The node to add.
	///
	/// @return {Struct.FORMS_NodeGraph} Returns `self`.
	static add_node = function (_node)
	{
		forms_assert(_node.Graph == undefined, "Node is already added to a graph!");
		array_push(Nodes, _node);
		_node.Graph = self;
		return self;
	}

	/// @func eval([_args])
	///
	/// @desc Evaluates the node graph.
	///
	/// @param {Any} [_args] Arguments. Defaults to `undefined`.
	///
	/// @return {Struct} Returns a struct where keys are entry-point nodes and
	/// values are the results of their evaluation.
	///
	/// @see FORMS_Node.IsEntryPoint
	static eval = function (_args = undefined)
	{
		var _evalId = __evalId++;
		var _result = {};
		for (var i = array_length(Nodes) - 1; i >= 0; --i)
		{
			var _node = Nodes[i];
			_result[$  _node] = _node.eval(_args, _evalId);
		}
		return _result;
	}

	/// @func draw()
	///
	/// @desc Draws the node graph.
	///
	/// @return {Struct.FORMS_NodeGraph} Returns `self`.
	static draw = function ()
	{
		// Draw pin connections
		for (var i = array_length(Nodes) - 1; i >= 0; --i)
		{
			with(Nodes[i])
			{
				for (var j = array_length(PinsIn) - 1; j >= 0; --j)
				{
					var _pinIn = PinsIn[j];

					for (var k = array_length(_pinIn.Other) - 1; k >= 0; --k)
					{
						var _pinOut = _pinIn.Other[k];

						// TODO: Draw pin connection
					}
				}
			}
		}

		// Draw nodes
		for (var i = array_length(Nodes) - 1; i >= 0; --i)
		{
			Nodes[i].draw();
		}

		return self;
	}
}

/// @func FORMS_Node(_name[, _pinsIn[, _pinsOut]])
///
/// @desc
///
/// @param {String} _name The name of the node.
/// @param {Array<Struct.FORMS_Pin>} [_pinsIn] An array of the node's input
/// pins.
/// @param {Array<Struct.FORMS_Pin>} [_pinsOut] An array of the node's output
/// pins.
///
/// @private
function FORMS_Node(_name, _pinsIn = [], _pinsOut = []) constructor
{
	/// @var {Struct.NodeGrap, Undefined} The graph to which this node belongs.
	/// Default value is `undefined`.
	Graph = undefined;

	/// @var {String} The name of the node.
	Name = _name;

	/// @var {Array<Struct.FORMS_Pin>} An array of the node's input pins.
	/// @readonly
	PinsIn = _pinsIn;

	/// @var {Array<Struct.FORMS_Pin>} An array of the node's output pins.
	/// @readonly
	PinsOut = _pinsOut;

	/// @var {Bool} If true then the node is collapsed and its pins are hidden.
	Collapsed = false;

	/// @var {Bool} If true then the node is an entry point. Default value is
	/// false.
	/// @readonly
	IsEntryPoint = false;

	/// @var {Real} The node's X position.
	X = 0;

	/// @var {Real} The node's Y position.
	Y = 0;

	/// @var {Real} The node's width.
	Width = 0;

	/// @var {Real} The node's height.
	Height = 0;

	/// @var {Function, Undefined} A function executed when the node is
	/// evaluated or `undefined` (default). The arguments passed to the function
	/// are the pin, args and evalID.
	OnEval = undefined;

	/// @private
	__evalId = undefined;

	/// @var {Any} The result of evaluation. Default value is `undefined`.
	/// @see FORMS_Node.eval
	Result = undefined;

	{
		for (var i = array_length(PinsIn) - 1; i >= 0; --i)
		{
			var _pin = PinsIn[i];
			forms_assert(_pin.Node == undefined, "Pin is already added to a node!");
			_pin.Node = self;
			_pin.IsInput = true;
		}

		for (var i = array_length(PinsOut) - 1; i >= 0; --i)
		{
			var _pin = PinsOut[i];
			forms_assert(_pin.Node == undefined, "Pin is already added to a node!");
			_pin.Node = self;
			_pin.IsInput = false;
		}
	}

	/// @private
	static __eval_pins = function (_args, _evalId)
	{
		for (var i = array_length(PinsIn) - 1; i >= 0; --i)
		{
			PinsIn[i].eval(_args, _evalId);
		}

		for (var i = array_length(PinsOut) - 1; i >= 0; --i)
		{
			PinsOut[i].eval(_args, _evalId);
		}
	}

	/// @func eval(_args, _evalId)
	///
	/// @desc Evaluates the node.
	///
	/// @param {Any} _args
	/// @param {Real} _evalId
	///
	/// @return {Any} The result of evaluation.
	static eval = function (_args, _evalId)
	{
		if (__evalId == _evalId)
		{
			return Result;
		}
		__evalId = _evalId;
		__eval_pins(_args, _evalId);
		if (OnEval != undefined)
		{
			OnEval(self, _args, _evalId);
		}
		return Result;
	}

	/// @func draw()
	///
	/// @desc Draws the node.
	///
	/// @return {Struct.FORMS_Node} Returns `self`.
	static draw = function ()
	{
		return self;
	}
}

/// @enum
/// @private
enum FORMS_EPinType
{
	Real,
	String,
	Color,
	Vec2,
	Vec3,
	Vec4,
	Asset,
};

/// @var {Array<Constant.Color>}
/// @private
global.__formsPinColor = [
	0xFF0000, // Real
	0x00FF00, // String
	0x0000FF, // Color
	0x00FFFF, // Vec2
	0xFF00FF, // Vec3
	0xFFFF00, // Vec4
	0xFFFFFF, // Asset
];

/// @func forms_pin_set_color(_pinType, _color)
///
/// @desc Configures color of pins of given type.
///
/// @param {Real} _pinType The type of the pin. Use values from
/// {@link FORMS_EPinType}.
/// @param {Constant.Color} _color The new pin color.
///
/// @private
function forms_pin_set_color(_pinType, _color)
{
	gml_pragma("forceinline");
	global.__formsPinColor[@ _pinType] = _color;
}

/// @func forms_pin_get_color(_pinType)
///
/// @desc Retrieves color for given pin type.
///
/// @param {Real} _pinType The type of the pin. Use values from
/// {@link FORMS_EPinType}.
///
/// @return {Constant.Color} The pin color.
///
/// @private
function forms_pin_get_color(_pinType)
{
	gml_pragma("forceinline");
	return global.__formsPinColor[_pinType];
}

/// @func FORMS_Pin(_name, _type[, _assetType])
///
/// @desc
///
/// @param {String} _name The name of the pin.
/// @param {Real} _type The type of the pin. Use values from
/// {@link FORMS_EPinType}.
/// @param {Constant.AssetType, Undefined} [_assetType]
///
/// @private
function FORMS_Pin(_name, _type, _assetType = undefined) constructor
{
	/// @var {Struct.FORMS_Node, Undefined} The node to which this pin belongs.
	/// Default value is `undefined`.
	Node = undefined;

	/// @var {String} The name of the pin.
	Name = _name;

	/// @var {Real} The type of the pin. Use values from {@link FORMS_EPinType}.
	/// @readonly
	Type = _type;

	/// @var {Constant.AssetType, Undefined}
	/// @readonly
	AssetType = _assetType;

	/// @var {Bool} If true then this is an input pin, otherwise it is an
	/// output pin. Default value is true.
	/// @readonly
	IsInput = true;

	/// @var {Bool} If true then the pin is disabled and its connection cannot
	/// be changed. Default value is false.
	Disabled = false;

	/// @var {Array<Struct.FORMS_Pin>} An array of pins that this pin is
	/// connected to.
	Other = [];

	/// @var {Real} The pin's X position.
	X = 0;

	/// @var {Real} The pin's Y position.
	Y = 0;

	/// @var {Real} The pin's radius.
	Radius = 8;

	/// @var {Function, Undefined} A function executed when the pin is evaluated
	/// or `undefined` (default). The arguments passed to the function are the
	/// pin, args and evalID.
	OnEval = undefined;

	/// @private
	__evalId = undefined;

	/// @var {Any} The result of evaluation. Default value is `undefined`.
	/// @see FORMS_Pin.eval
	Result = undefined;

	/// @func is_compatible(_pin)
	///
	/// @desc Checks whether this pin is compatible with other given pin.
	/// Incompatible pins cannot be connected.
	///
	/// @param {Struct.FORMS_Pin} _pin The pin to check compatibility with.
	///
	/// @return {Bool} Returns true if the pins are compatible.
	static is_compatible = function (_pin)
	{
		return (Node != _pin.Node
			&& IsInput != _pin.IsInput);
	}

	/// @func is_connected(_pin)
	///
	/// @desc Checks if the pins is connected to other given pin.
	///
	/// @param {Struct.FORMS_Pin} _pin The pin to check.
	///
	/// @return {Bool} Returns true if the pins are connected.
	static is_connected = function (_pin)
	{
		for (var i = array_length(Other) - 1; i >= 0; --i)
		{
			if (Other[i] == _pin)
			{
				return true;
			}
		}
		return false;
	}

	/// @func connect(_pin)
	///
	/// @desc Connects the pin with other given pin.
	///
	/// @param {Struct.FORMS_Pin} _pin The pin to connect with.
	///
	/// @return {Struct.FORMS_Pin} Returns `self`.
	///
	/// @note The pins must be compatible, otherwise this ends with an error!
	///
	/// @see FORMS_Pin.is_compatible
	static connect = function (_pin)
	{
		forms_assert(is_compatible(_pin), "Pins are not compatible!");
		if (!is_connected(_pin))
		{
			array_push(Other, _pin);
			array_push(_pin.Other, self);
		}
		return self;
	}

	/// @func disconnect(_pin)
	///
	/// @desc Disconnects from given pin.
	///
	/// @param {Struct.FORMS_Pin} _pin The pin to disconnect from.
	///
	/// @return {Struct.FORMS_Pin} Returns `self`.
	static disconnect = function (_pin)
	{
		for (var i = array_length(Other) - 1; i >= 0; --i)
		{
			if (Other[i] == _pin)
			{
				// Remove other pin
				array_delete(Other, i, 1);

				for (var j = array_length(_pin.Other) - 1; j >= 0; --j)
				{
					if (_pin.Other[j] == self)
					{
						// Remove self from other pin
						array_delete(_pin.Other, j, 1);
						break;
					}
				}

				break;
			}
		}
		return self;
	}

	/// @func clear_connections()
	///
	/// @desc Removes all pin connections.
	///
	/// @return {Struct.FORMS_Pin} Returns `self`.
	static clear_connections = function ()
	{
		for (var i = array_length(Other) - 1; i >= 0; --i)
		{
			var _pin = Other[i];
			for (var j = array_length(_pin.Other) - 1; j >= 0; --j)
			{
				if (_pin.Other[j] == self)
				{
					// Remove self from other pin
					array_delete(_pin.Other, j, 1);
					break;
				}
			}
		}
		Other = [];
		return self;
	}

	/// @private
	static __eval_others = function (_args, _evalId)
	{
		for (var i = array_length(Other) - 1; i >= 0; --i)
		{
			Other[i].Node.eval(_args, _evalId);
		}
	}

	/// @func eval(_args, _evalId)
	///
	/// @desc Evaluates the pin.
	///
	/// @param {Any} _args
	/// @param {Real} _evalId
	///
	/// @return {Any} The result of evaluation.
	static eval = function (_args, _evalId)
	{
		if (__evalId == _evalId)
		{
			return Result;
		}
		__evalId = _evalId;
		__eval_others(_args, _evalId);
		if (OnEval != undefined)
		{
			OnEval(self, _args, _evalId);
		}
		return Result;
	}

	/// @func draw()
	///
	/// @desc Draws the pin.
	///
	/// @return {Struct.FORMS_Pin} Returns `self`.
	static draw = function ()
	{
		return self;
	}
}
