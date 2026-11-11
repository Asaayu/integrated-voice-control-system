/*
    Integrated AI Voice Control System
    File: fn_targetObject.sqf
    Function: IVCS_fnc_targetObject
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Orders a group of units to target an object.

    Parameters:
    _units: Array - An array of units
    _objectText: String - The object to target

    Returns:
    NONE

    Notes:
    Units will target the object and a confirmation icon will be displayed above the object if the UI is enabled.
*/

params [["_units",[],[[]]], ["_objectText", "", [""]]];

private _object = [_objectText] call IVCS_fnc_convertObjects;

if (isNull _object) then
{
    systemChat localize "STR_IVCS_FEEDBACK_TARGET_OBJECT_NOT_FOUND";
}
else
{
    _units commandTarget _object;

    [_object, localize "STR_IVCS_FEEDBACK_TARGET_TEXT"] call IVCS_fnc_drawTargetConfirmation;
};
