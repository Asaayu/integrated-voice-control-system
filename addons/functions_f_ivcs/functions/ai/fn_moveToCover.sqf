/*
    Integrated AI Voice Control System
    File: fn_moveToCover.sqf
    Function: IVCS_fnc_moveToCover
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Moves a list of units to cover positions.

    Parameters:
    _units: Array - An array of units
    _positions: Array - An array of positions to move to

    Returns:
    NONE

    Notes:
    Units will move to the nearest cover position provided in the _positions array.
*/

params [["_units",[],[[]]], ["_positions", [], [[]]]];

["100_Commands", "TakeCover.ogg"] call IVCS_fnc_speak;

{
    private _pos = selectRandom _positions;
    if !(isNil "_pos") then
    {
        _positions deleteAt (_positions findIf {_x isEqualTo _pos});
    }
    else
    {
        _pos = _x getPos [20, random 360];
    };

    _x commandMove AGLToASL _pos;
} forEach _units;