/*
    Integrated AI Voice Control System
    File: fn_healFind.sqf
    Function: IVCS_fnc_healFind
    Author: Asaayu
    Date: 2024-12-27

    Description:
    Finds the closest unit with a medical item in their inventory and moves the AI to their position to receive healing.

    Parameters:
    _units: Array - An array of units to get in the vehicle

    Returns:
    NONE

    Notes:
    The AI will attempt to move to the position of the closest unit that has a medical item in their inventory to receive healing.
*/

params [["_units",[],[[]]]];

private _player = call IVCS_fnc_player;
{
    private _unit = _x;
    private _closestUnit = objNull;
    private _groupUnits = units group _unit - [_player];

    {
        systemChat format ["%1", _x];
        if (alive _x && {_x != _unit && {!isPlayer _x && {[_x] call IVCS_fnc_hasMedicalItem}}}) then {
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
    } forEach _groupUnits;
    if (isNull _closestUnit) exitWith {
        [_unit] call IVCS_fnc_negativeSpeak;
    };

    private _handle = [_unit, _closestUnit] spawn
    {
        _this params ["_unit", "_medic"];

        private _exitTime = time + 30;
        private _radius = 3;
        private _startHealth = damage _unit;

        // Get the unit to regroup to un-do any previous orders
        _unit doFollow (leader group _unit);
        _unit doMove (getPosATL _medic);

        private _lastCall = time;
        waitUntil {
            // Continually tell the unit to move to the target's position in-case their moving
            if (time - _lastCall >= 5) then
            {
                _unit doMove (getPosATL _medic);
                _lastCall = time;
            };

            // Exit the loop if...
            (time >= _exitTime) ||
            (stopped _unit) ||
            !(isNull objectParent _medic) ||
            !(alive _unit) ||
            !(alive _medic) ||
            (damage _unit == 0) ||
            (damage _unit < _startHealth) ||
            (_unit distance _medic <= _radius && { speed _unit <= 0.1 })
        };
        if (time >= _exitTime || _unit distance _medic > _radius) exitWith {
            [_unit] call IVCS_fnc_negativeSpeak;
            _unit doFollow (leader group _unit);
        };

        _unit disableAI "PATH"; // Stop the unit from moving away from the target
        _medic disableAI "PATH"; // Stop the target from moving away from the unit
        _medic action ["HealSoldier", _unit];

        private _exitTime = time + 10;
        waitUntil {damage _unit > _startHealth || !alive _unit || !alive _medic || time >= _exitTime };

        _unit enableAI "PATH";
        _medic enableAI "PATH";

        _unit doFollow (leader group _unit);
    };

    private _handles = _x getVariable ["ivcs_handles", []];
    _x setVariable ["ivcs_handles", (_handles + _handler)];
} forEach _units;