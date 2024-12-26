/*
    Integrated AI Voice Control System
    File: fn_regroup.sqf
    Function: IVCS_fnc_regroup
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Orders a group of units to regroup on the player.

    Parameters:
    _units: Array - An array of units

    Returns:
    NONE

    Notes:
    Units will regroup on the player and the formation direction will be set to the player's direction.
*/

params [["_units",[],[[]]]];

private _player = call IVCS_fnc_player;

_units commandFollow (leader group _player);
(group _player) setFormDir (getDir _player);