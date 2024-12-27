/*
    Integrated AI Voice Control System
    File: fn_setCombatMode.sqf
    Function: IVCS_fnc_setCombatMode
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Sets the combat mode for a list of units.

    Parameters:
    _units: Array - An array of units

    Returns:
    NONE

    Notes:
    Sets the combat mode for the units to the specified mode, not the group as a whole.
*/

params [["_units",[],[[]]], ["_combatMode", "", [""]]];

{
    _x setUnitCombatMode _combatMode;
} forEach _units;