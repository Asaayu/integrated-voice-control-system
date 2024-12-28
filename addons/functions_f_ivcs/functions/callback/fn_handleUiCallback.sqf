/*
    Integrated AI Voice Control System
    File: fn_handleUiCallback.sqf
    Function: IVCS_fnc_handleUiCallback
    Author: Asaayu
    Date: 2024-12-22

    Description:
    Handles callbacks from the extension that are requesting UI changes.

    Parameters:
    _left: ARRAY - The prefix of the speech recognition result
    _function: STRING - The function that the speech recognition result is for
    _right: ARRAY - The arguments of the speech recognition result

    Returns:
    NONE

    Notes:
    This function is called by the extension callback handler when a callback is received, and should not be called directly.
*/

params [
    ["_function","",[""]],
    ["_data",[],[[]]]
];

// Helper function to update the text of a list of controls
private _updateControlText = {
    params ["_display", "_ctrls", "_text"];
    {
        private _ctrl = _display displayCtrl _x;
        if (ctrlType _ctrl == 13) then
        {
            _ctrl ctrlSetStructuredText parseText _text;
        }
        else
        {
            _ctrl ctrlSetText _text;
        };
    } forEach _ctrls;
};

switch (_function) do {
    case "set_ptt_background_display":
    {
        _data params [["_time",0,[0]], ["_fade",0,[0]]];

        private _display = uiNamespace getVariable ["ivcs_ptt_display", displayNull];
        private _ctrls = [100, 101, 1000, 1001];

        {
            private _ctrl = _display displayCtrl _x;
            _ctrl ctrlSetFade _fade;
            _ctrl ctrlCommit _time;
        } forEach _ctrls;
    };
    case "set_ptt_background_color":
    {
        _data params [["_r",0,[0]], ["_g",0,[0]], ["_b",0,[0]], ["_a",0,[0]]];

        private _display = uiNamespace getVariable ["ivcs_ptt_display", displayNull];
        private _ctrls = [100, 101];

        {
            private _ctrl = _display displayCtrl _x;
            _ctrl ctrlSetTextColor [_r, _g, _b, _a];
        } forEach _ctrls;
    };
    case "set_ptt_text":
    {
        _data params [["_text",""]];

        private _display = uiNamespace getVariable ["ivcs_ptt_display", displayNull];
        [_display, [1000], _text] call _updateControlText;
    };
    case "set_ptt_confidence_text":
    {
        _data params [["_text",""]];

        private _display = uiNamespace getVariable ["ivcs_ptt_display", displayNull];
        private _finalText = format[localize "STR_IVCS_PTT_CONFIDENCE_TEXT", _text];
        [_display, [1001], _finalText] call _updateControlText;
    };
    case "set_test_text":
    {
        _data params [["_textInput",""]];

        private _display = uiNamespace getVariable ["ivcs_test_display", displayNull];
        private _ctrls = [5000];

        if (_textInput != "") then
        {
            (_textInput splitString(":")) params [["_text",""], ["_confidence",""]]; // formatted as "text:confidence"
            private _localizedConfidence = format[localize "STR_IVCS_SETTINGS_TESTING_CONFIDENCE_TEXT", _confidence];
                private _finalText = format["<t font='RobotoCondensed'>%1</t> - %2", _text, _localizedConfidence];
            [_display, _ctrls, _finalText] call _updateControlText;
        }
        else
        {
            [_display, _ctrls, ""] call _updateControlText;
        };
    };
    case "set_test_text_color":
    {
        _data params ["_ctrlId", "_color"];
        _color params [["_r",0,[0]], ["_g",0,[0]], ["_b",0,[0]], ["_a",0,[0]]];

        private _display = uiNamespace getVariable ["ivcs_test_display", displayNull];
        private _ctrl = _display displayCtrl parseNumber(_ctrlId);
        _ctrl ctrlSetTextColor [_r, _g, _b, _a];
    };
    default
    {
        private _message = format["Function '%1' not found in callback_input file.", _function];
        diag_log _message;
        systemChat _message;
        [_message] call BIS_fnc_error;
    };
};
