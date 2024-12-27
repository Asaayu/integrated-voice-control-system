/*
    Integrated AI Voice Control System
    File: fn_gunLights.sqf
    Function: IVCS_fnc_gunLights
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Turns the gun lights on or off for a list of units.

    Parameters:
    _units: Array - An array of units

    Returns:
    NONE

    Notes:
    Gun lights are the light attachments for some weapons, it is not related to vehicle lights.
*/

params [["_units",[],[[]]], ["_setOn", true, [true]]];

if (_setOn) then
{
    ["100_Commands", "FlashlightsOn.ogg", true] call IVCS_fnc_speak;
    {
        (group _x) enableGunLights "ForceOn";
    } forEach _units;
}
else
{
    ["100_Commands", "FlashlightsOff.ogg", true] call IVCS_fnc_speak;
    {
        (group _x) enableGunLights "ForceOff";
    } forEach _units;
};
