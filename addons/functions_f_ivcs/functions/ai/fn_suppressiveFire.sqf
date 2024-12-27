/*
    Integrated AI Voice Control System
    File: fn_suppressiveFire.sqf
    Function: IVCS_fnc_suppressiveFire
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Orders a group of units to suppress a position or object, or the cursor position if no target is defined.

    Parameters:
    _units: Array - An array of units
    _rightData: Array - An array of objects or positions

    Returns:
    NONE

    Notes:
    Units will be given a suppressive fire order.
*/

params [["_units",[],[[]]], ["_rightData", [], [[]]]];

// Get units to suppress a position
_rightData params ["_type"];

private _object = [_type] call IVCS_fnc_convertObjects;

// Only command units to watch the target if the object actually exists
if !(isNull _object) then
{
    _units commandSuppressiveFire _object;

    if (uiNamespace getVariable ["ivcs_target_confirm_ui", true]) then
    {
        addMissionEventHandler ["Draw3D",
        {
            private _time = _thisArgs#0;
            private _object = _thisArgs#1;

            if (alive _object && {time <= _time + 4}) then
            {
                drawIcon3D
                [
                    "a3\ui_f\data\GUI\Cfg\Cursors\hc_overenemy_gs.paa",
                    [1,1,1,linearConversion [_time + 2, _time + 2.5, time, 1, 0]],
                    _object modelToWorldVisual (_object selectionPosition "pelvis"),
                    1,
                    1,
                    0,
                    localize "STR_IVCS_FEEDBACK_SUPPRESSIVE_FIRE_TARGET_TEXT",
                    2,
                    0.03,
                    "RobotoCondensedLight",
                    "center",
                    true
                ];
            }
            else
            {
                removeMissionEventHandler ["Draw3D", _thisEventHandler];
            };
        },
        [
            time,
            _object
        ]];
    };
}
else
{
    // If the player doesn't define a target, then suppress the cursor position
    if (_type == "") then
    {
        private _position = call IVCS_fnc_getCursorWorldPosition;
        _units commandSuppressiveFire AGLToASL _position;
    }
    else
    {
        systemChat localize "STR_IVCS_FEEDBACK_TARGET_OBJECT_NOT_FOUND";
    };
};