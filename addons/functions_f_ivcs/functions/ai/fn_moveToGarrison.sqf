/*
    Integrated AI Voice Control System
    File: fn_moveToGarrison.sqf
    Function: IVCS_fnc_moveToGarrison
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Moves a list of units to garrison nearby buildings.

    Parameters:
    _units: Array - An array of units
    _positions: Array - An array of positions to garrison
    _positionOnly: Boolean - If true, the units will only move to the positions and not garrison

    Returns:
    NONE

    Notes:
    Units will move to the nearest building to the position. If no position is found, then the units will not do anything.
*/

params [["_units",[],[[]]], ["_positions", [], [[]]]];

["100_Commands", "TakeCover.ogg"] call IVCS_fnc_speak;

{
    private _pos = selectRandom _positions;
    if !(isNil "_pos") then
    {
        _positions deleteAt (_positions findIf {_x isEqualTo _pos});
        _x commandMove AGLToASL _pos;
    };

} forEach _units;