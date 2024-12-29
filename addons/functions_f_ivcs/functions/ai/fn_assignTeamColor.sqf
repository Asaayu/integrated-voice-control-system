/*
    Integrated AI Voice Control System
    File: fn_assignTeamColor.sqf
    Function: IVCS_fnc_assignTeamColor
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Assigns a team color to a list of units.

    Parameters:
    _units: Array - An array of units

    Returns:
    NONE

    Notes:
    Team colors can be either red, green, yellow, blue, or white.
*/

params [["_units",[],[[]]], ["_right", [], [[]]]];

// Get units to join the color team
private _colors = ["white", "red", "green", "yellow", "blue"];
private _index = _colors findIf {private _color = _x; _right findIf {_x == _color} > -1};
if (_index > -1) then
{
    private _team = _colors#_index;
    ["030_Teams", _team+"Team.ogg"] call IVCS_fnc_speak;

    if (_team == "white") then {_team = "main"};
    {
        _x assignTeam _team;
    } forEach _units;
};