/*
    Integrated AI Voice Control System
    File: _cba_client_keybinds.sqf
    Function: NONE
    Author: Asaayu
    Version: 2.0.0.0
    Date: 2024-12-22

    Description:
    This file contains all custom keybinds for the Integrated AI Voice Control System, using the CBA keybind system.

    Parameters:
    NONE

    Returns:
    NONE

    Notes:
    These keybinds are automatically added to the CBA keybind system when the mod is loaded.
*/

#include "\a3\ui_f\hpp\defineDIKCodes.inc"

[
    localize "STR_IVCS_MOD_NAME",
    "ivcs_ptt_key",
    [
        localize "STR_IVCS_KEYBIND_PTT_NAME",
        localize "STR_IVCS_KEYBIND_PTT_TOOLTIP"
    ],
    {
        private _return = false;
        private _player = call IVCS_fnc_player;
        if (!is3DEN && {!isNull _player}) then
        {
            _this call IVCS_fnc_onPttDown;
            _return = true;
        };
        _return
    },
    { _this call IVCS_fnc_onPttUp; },
    [
        DIK_GRAVE,
        [
            false,
            true,
            false
        ]
    ]
] call CBA_fnc_addKeybind;
