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
                    localize "STR_IVCS_FEEDBACK_TARGET_TEXT",
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
};