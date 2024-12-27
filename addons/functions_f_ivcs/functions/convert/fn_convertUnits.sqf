/*
    Integrated AI Voice Control System
    File: fn_convertUnits.sqf
    Function: IVCS_fnc_convertUnits
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Converts a list of unit numbers into a list of units.

    Parameters:
    _units_num_list: Array - An array of unit numbers

    Returns:
    Array - An array of units

    Notes:
    Unit numbers are the order in which the units were created in the mission.
*/

params [["_units_num_list", [], [[]]]];

private _fnc_unitNum =
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
private _player = call IVCS_fnc_player;
private _units = (units group _player) - [_player];
private _output = [];
{
    private _number = parseNumber _x;
    if (_number > 0) then
    {
        private _index = _units findIf {(_x call _fnc_unitNum) == _number};

        if (_index != -1 && {_index < count _units}) then
        {
            _output pushBackUnique (_units#_index);
        };
    };
} forEach _units_num_list;
_output
