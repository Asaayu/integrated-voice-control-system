/*
    Integrated AI Voice Control System
    File: clientPreInit.sqf
    Function: NONE
    Author: Asaayu
    Version: 2.0.0.0
    Date: 2024-12-22

    Description:
    Pre-initialization script for the client side of the extension, sets up the custom settings, keybinds, and frame handlers.

    Parameters:
    NONE

    Returns:
    NONE

    Notes:
    This script is called on mission start, directly by CBA, and should not be called manually.
*/

#include "_cba_client_settings.sqf"
#include "_cba_client_keybinds.sqf"

// The extension is called on mission start to preload it
diag_log ("ivcs" callExtension "info");

call IVCS_fnc_addExtensionCallbackHandler;

if (is3DEN) exitWith {};

addMissionEventHandler ["Loaded", {
    call compile preprocessFileLineNumbers '\z\ivcs\addons\functions_f_ivcs\xeh\cba_clientPreInit.sqf';
}];

// Remove any frame handlers that are already present
private _frame_id = uiNamespace getVariable ["ivcs_ptt_check_id", -1];
if (_frame_id > -1) then
{
    [_frame_id] call CBA_fnc_removePerFrameHandler;
};

// Add loop to check if PTT key should be un-pressed
private _frame_id =
[{
    if (uiNamespace getVariable ["ivcs_ptt_down", false] && {!isGameFocused || isGamePaused}) then
    {
        uiNamespace setVariable ["ivcs_ptt_down", false];
        [] call ivcs_fnc_ptt_up;
    };
}, 0.1, []] call CBA_fnc_addPerFrameHandler;

uiNamespace setVariable ["ivcs_ptt_check_id", _frame_id];
