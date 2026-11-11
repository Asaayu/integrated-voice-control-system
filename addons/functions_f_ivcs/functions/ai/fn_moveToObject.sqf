/*
    Integrated AI Voice Control System
    File: fn_moveToObject.sqf
    Function: IVCS_fnc_moveToObject
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Moves a group of units to the position of an object.

    Parameters:
    _units: Array - An array of units
    _objectText: String - The string returned from the speech recognition engine to be converted into an object

    Returns:
    NONE

    Notes:
    The object string must be a valid object name or object type. If the object is not found, a system chat message will be displayed.
*/

params [["_units",[],[[]]], ["_objectText", "", [""]]];

private _object = [_objectText, true] call IVCS_fnc_convertObjects;

if !(isNull _object) then
{
    _units commandMove getPos _object;

    [_object, localize "STR_IVCS_FEEDBACK_MOVE_TO_TARGET_TEXT"] call IVCS_fnc_drawTargetConfirmation;
}
else
{
    systemChat localize "STR_IVCS_FEEDBACK_TARGET_OBJECT_NOT_FOUND";
};
