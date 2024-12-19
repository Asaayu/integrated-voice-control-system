params [["_units_num_list", [], [[]]]];

private _unit_num =
{
	params [["_unit", objNull, [objNull]]];
	if (isNull _unit) exitWith {-1};

	private _name = vehicleVarName _unit;
	_unit setVehicleVarName "";

	private _data = str _unit;
	_unit setVehicleVarName _name;

	parseNumber (_data select [(_data find ":") + 1])
};

private _zero = false;
private _units = (units group player) - [player];
private _output = [];
{
	private _number = parseNumber _x;
	if (_number > 0) then
	{
		private _index = _units findIf {(_x call _unit_num) == _number};

		if (_index != -1 && {_index < count _units}) then
		{
			_output pushBackUnique (_units#_index);
		};
	};
} forEach _units_num_list;
_output
