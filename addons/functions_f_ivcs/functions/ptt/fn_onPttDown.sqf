/*
    Integrated AI Voice Control System
	File: fn_onPttDown.sqf
	Function: IVCS_fnc_onPttDown
    Author: Asaayu
    Date: 2024-12-22

    Description:
	Called when the PTT key is pressed, displays the PTT overlay, as well as sending an event to the extension to start listening for voice input.

    Parameters:
	NONE

	Returns:
	NONE

    Notes:
	This function is called by the CBA keybind system when the PTT key is pressed, this function should not be called directly.
*/

"ivcs_ptt" cutRsc ["ivcs_ptt_display", "PLAIN", 0, true, false];
uiNamespace setVariable ["ivcs_ptt_down", true];

"ivcs" callExtension "ptt_down";
