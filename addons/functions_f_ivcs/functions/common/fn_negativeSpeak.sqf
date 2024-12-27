/*
    Integrated AI Voice Control System
    File: fn_negativeSpeak.sqf
    Function: IVCS_fnc_negativeSpeak
    Author: Asaayu
    Date: 2024-12-27

    Description:
    Plays a negative sound for the unit passed through the parameter.

    Parameters:
    _unit: Object - The unit to play the confirmation sound for

    Returns:
    NONE

    Notes:
    The confirmation sound is a random sound from the Confirmation soundset.
*/

params [["_unit",objNull,[objNull]]];

private _voiceLines = ['CannotComply_1.ogg', 'CannotComply_2.ogg', 'Negative_1.ogg', 'Negative_2.ogg', 'Negative_3.ogg', 'NoCanDo_1.ogg', 'NoCanDo_2.ogg'];
["130_Com_Reply", selectRandom _voiceLines, false, _unit] call IVCS_fnc_speak;

_unit groupChat localize "str_a3_negative";