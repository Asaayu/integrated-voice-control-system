/*
    Integrated AI Voice Control System
    File: fn_confirmationSpeak.sqf
    Function: IVCS_fnc_confirmationSpeak
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Plays a confirmation sound for the unit passed through the parameter.

    Parameters:
    _unit: Object - The unit to play the confirmation sound for

    Returns:
    NONE

    Notes:
    The confirmation sound is a random sound from the Confirmation soundset.
*/

params [["_unit",objNull,[objNull]]];

private _formattedFileName = format["Confirmation%1_%2.ogg",(round random 1) + 1, (round random 9) + 1];
["130_Com_Reply", _formattedFileName, false, _unit] call IVCS_fnc_speak;