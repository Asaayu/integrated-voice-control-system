/*
    Integrated AI Voice Control System
    File: fn_player.sqf
    Function: IVCS_fnc_player
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Gets the current player object, using the zeus remote controlled unit if currently remote controlling a unit.

    Parameters:
    NONE

    Returns:
    Object - The player object

    Notes:
    Will return the player object if not remote controlling a unit.
*/

missionNamespace getVariable ["bis_fnc_moduleRemoteControl_unit", player];
