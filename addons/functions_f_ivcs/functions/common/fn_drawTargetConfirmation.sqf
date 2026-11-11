/*
    Integrated AI Voice Control System
    File: fn_drawTargetConfirmation.sqf
    Function: IVCS_fnc_drawTargetConfirmation
    Author: Asaayu
    Date: 2026-11-12

    Description:
    Draws a short-lived confirmation icon and text above an object that units were ordered to interact with.

    Parameters:
    _object: Object - The object to draw the confirmation above
    _text: String - The text to display under the icon

    Returns:
    NONE

    Notes:
    Nothing is drawn if the target confirmation UI setting is disabled.
*/

params [["_object", objNull, [objNull]], ["_text", "", [""]]];

if (isNull _object || {!(uiNamespace getVariable ["ivcs_target_confirm_ui", true])}) exitWith {};

addMissionEventHandler ["Draw3D",
{
    _thisArgs params ["_time", "_object", "_text"];

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
            _text,
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
    _object,
    _text
]];
