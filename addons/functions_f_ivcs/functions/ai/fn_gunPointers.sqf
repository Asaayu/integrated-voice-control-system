/*
    Integrated AI Voice Control System
    File: fn_gunPointers.sqf
    Function: IVCS_fnc_gunPointers
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Turns the gun's laser pointers on or off for a list of units.

    Parameters:
    _units: Array - An array of units

    Returns:
    NONE

    Notes:
    Gun pointers are the IR laser attachments for some weapons, is not related to any vehicle IR lasers.
*/

params [["_units",[],[[]]], ["_setOn", true, [true]]];

if (_setOn) then
{
    ["100_Commands", "PointersOn.ogg", true] call IVCS_fnc_speak;
    {
        (group _x) enableIRLasers true;
    } forEach _units;
}
else
{
    ["100_Commands", "PointersOff.ogg", true] call IVCS_fnc_speak;
    {
        (group _x) enableIRLasers false;
    } forEach _units;
};
