/*
    Integrated AI Voice Control System
    File: fn_scanHorizon.sqf
    Function: IVCS_fnc_scanHorizon
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Orders a group of units to scan the horizon, looking for enemies. Until they are damaged, in combat, detect an enemy, or another command is given.

    Parameters:
    _units: Array - An array of units

    Returns:
    NONE

    Notes:
    Units will scan the horizon in a loop until they are damaged, in combat, or detect an enemy.
*/

params [["_units",[],[[]]]];

["100_Commands", "scanhorizon.ogg", true] call IVCS_fnc_speak;

{
    // Create a loop to control the AI scanning
    private _handler = [
        {
            private _unit = _this#0#0;
            private _damage = _this#0#1;
            private _id = _this#1;

            if (isNil "_unit" || !alive _unit || damage _unit > _damage || behaviour _unit == "COMBAT" || _unit call BIS_fnc_enemyDetected) then
            {
                [_handle] call CBA_fnc_removePerFrameHandler;
            }
            else
            {
                if !isGamePaused then
                {
                    private _dir = _unit getVariable ["ivcs_dir", getDir _unit];
                    _unit doWatch (_unit getPos [300, _dir + 40]);

                    _unit setVariable ["ivcs_dir", _dir + 40];
                };
            };
        },
        5,
        [_x, damage _x]
    ] call CBA_fnc_addPerFrameHandler;

    private _frame_handles = _x getVariable ["ivcs_frame_handles", []];
    _x setVariable ["ivcs_frame_handles", (_frame_handles + _handler)];
} forEach _units;