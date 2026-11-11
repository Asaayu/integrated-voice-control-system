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
_rightData params [["_type", "", [""]]];

private _object = [_type] call IVCS_fnc_convertObjects;

// Only command units to watch the target if the object actually exists
if !(isNull _object) then
{
    _units commandSuppressiveFire _object;

    [_object, localize "STR_IVCS_FEEDBACK_SUPPRESSIVE_FIRE_TARGET_TEXT"] call IVCS_fnc_drawTargetConfirmation;
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
