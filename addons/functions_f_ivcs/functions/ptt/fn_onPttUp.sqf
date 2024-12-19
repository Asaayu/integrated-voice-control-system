/*
    Integrated AI Voice Control System
	File: fn_onPttUp.sqf
	Function: IVCS_fnc_onPttUp
    Author: Asaayu
    Date: 2024-12-22

    Description:
	Called when the PTT key is released, sends an event to the extension to stop listening for voice input.

    Parameters:
	NONE

	Returns:
	NONE

    Notes:
	This function is called by the CBA keybind system when the PTT key is released, or by the CBA frame handler when the game loses focus or is paused,
	to ensure the PTT key is released in these cases. This function should not be called directly.
*/

"ivcs" callExtension "ptt_up";

"ivcs_ptt" cutText ["", "PLAIN"];
uiNamespace setVariable ["ivcs_ptt_down", false];
