/*
    Integrated AI Voice Control System
    File: fn_healFindPlayer.sqf
    Function: IVCS_fnc_healFindPlayer
    Author: Asaayu
    Date: 2024-12-28

    Description:
    Finds the closest unit with a medical item in their inventory and moves them to the player's position to receive healing.

    Parameters:
    _units: Array - An array of units to get in the vehicle

    Returns:
    NONE

    Notes:
    The AI will attempt to move to the position of the closest unit that has a medical item in their inventory to receive healing.
*/

params [["_units",[],[[]]]];

private _player = call IVCS_fnc_player;
private _closestUnit = objNull;
{
    if (alive _x && {_x != _player && {!isPlayer _x && {[_x] call IVCS_fnc_hasMedicalItem}}}) then {
        if (isNull _closestUnit) then
        {
            _closestUnit = _x;
        }
        else
        {
            if (_unit distance _x <= _unit distance _closestUnit) then
            {
                _closestUnit = _x;
            };
        };
    };
} forEach _units;

if (isNull _closestUnit) exitWith {};

private _handle = [_player, _closestUnit] spawn
{
    _this params ["_unit", "_medic"];

    private _exitTime = time + 30;
    private _radius = 3;
    private _startHealth = damage _unit;

    // Get the unit to regroup to un-do any previous orders
    _medic doFollow (leader group _medic);
    _medic doMove (getPosATL _unit);

    private _lastCall = time;
    waitUntil {
        // Continually tell the unit to move to the target's position in-case their moving
        if (time - _lastCall >= 5) then
        {
            _medic doMove (getPosATL _unit);
            _lastCall = time;
        };

        // Exit the loop if...
        (time >= _exitTime) ||
        (stopped _medic) ||
        !(isNull objectParent _unit) ||
        !(alive _unit) ||
        !(alive _medic) ||
        (damage _unit == 0) ||
        (damage _unit < _startHealth) ||
        (_medic distance _unit <= _radius && { speed _unit <= 0.1 })
    };
    if (time >= _exitTime || _medic distance _unit > _radius) exitWith {
        [_medic] call IVCS_fnc_negativeSpeak;
        _medic doFollow (leader group _medic);
    };

    _medic disableAI "PATH"; // Stop the target from moving away from the unit
    _medic action ["HealSoldier", _unit];

    private _exitTime = time + 10;
    waitUntil {damage _unit > _startHealth || !alive _unit || !alive _medic || time >= _exitTime };

    _medic enableAI "PATH";
    _medic doFollow (leader group _medic);
};

private _handles = _closestUnit getVariable ["ivcs_handles", []];
_closestUnit setVariable ["ivcs_handles", (_handles + _handler)];