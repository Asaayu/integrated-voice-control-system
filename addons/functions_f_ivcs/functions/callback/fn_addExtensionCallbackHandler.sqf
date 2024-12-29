/*
    Integrated AI Voice Control System
    File: fn_addExtensionCallbackHandler.sqf
    Function: IVCS_fnc_addExtensionCallbackHandler
    Author: Asaayu
    Date: 2024-12-22

    Description:
    Adds an extension callback handler to handle extension events, such as speech recognition results.

    Parameters:
    NONE

    Returns:
    NONE

    Notes:
    This function is automatically called on mission start in the CBA preInit file, it does not need to be called manually.
*/

private _id = missionNamespace getVariable ["ivcs_extension_callback_handler_id", -1];
if (_id > -1) exitWith {};

private _eventHandlerId = addMissionEventHandler ["ExtensionCallback", {
    params ["_name", "_function", "_data"];

    if (_name != "IVCS") exitWith {};

    switch (toLower _function) do
    {
        case "log":
        {
            diag_log text format ["[IVCS] %1", _data];
        };
        case "speech_recognition_result":
        {
            private _input = parseSimpleArray _data;
            _input call IVCS_fnc_handleSpeechRecognitionResult;
        };
        case "set_ptt_background_display":
        {
            switch (toLower _data) do
            {
                case "show": {["set_ptt_background_display", [0.2, 0]] call IVCS_fnc_handleUiCallback};
                case "hide": {["set_ptt_background_display", [0.2, 1]] call IVCS_fnc_handleUiCallback};
                default {["Unknown PTT background display (%1) not defined in callback master switch", _data] call BIS_fnc_error};
            };
        };
        case "set_ptt_background_color":
        {
            switch (toLower _data) do
            {
                case "listening": {["set_ptt_background_color", [0, 0, 0, 0.5]] call IVCS_fnc_handleUiCallback};
                case "rejected": {["set_ptt_background_color", [0.8, 0.063, 0.063, 0.5]] call IVCS_fnc_handleUiCallback};
                case "recognized": {["set_ptt_background_color", [0.13, 0.54, 0.21, 0.5]] call IVCS_fnc_handleUiCallback};
                case "belowthreshold": {["set_ptt_background_color", [0.988, 0.518, 0.012, 0.5]] call IVCS_fnc_handleUiCallback};
                default {["Unknown PTT background color (%1) not defined in callback master switch", _data] call BIS_fnc_error};
            };
        };
        case "set_ptt_text":
        {
            ["set_ptt_text", [_data]] call IVCS_fnc_handleUiCallback;
        };
        case "set_ptt_confidence_text":
        {
            ["set_ptt_confidence_text", [_data]] call IVCS_fnc_handleUiCallback;
        };
        case "set_test_text":
        {
            ["set_test_text", [_data]] call IVCS_fnc_handleUiCallback;
        };
        case "set_test_text_color":
        {
            ["set_test_text_color", [_data, [0, 1, 0, 1]]] call IVCS_fnc_handleUiCallback;
        };
        default
        {
            ["Unknown function (%1) not defined in callback master switch", _function] call BIS_fnc_error;
        };
    };
}];

missionNamespace setVariable ["ivcs_extension_callback_handler_id", _eventHandlerId];