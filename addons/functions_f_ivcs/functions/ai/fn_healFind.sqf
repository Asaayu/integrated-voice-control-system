/*
    Integrated AI Voice Control System
    File: fn_healFind.sqf
    Function: IVCS_fnc_healFind
    Author: Asaayu
    Date: 2024-12-27

    Description:
    Tells an array of units to find a unit to heal them

    Parameters:
    _units: Array - An array of units to get in the vehicle

    Returns:
    NONE

    Notes:
    The AI will attempt to move to the position of the closest unit that has a medical item in their inventory to receive healing.
*/

params [["_units",[],[[]]]];

{
    private _closestUnit = objNull;
    private _groupUnits = units group _x;

    {
        if (_x == _unit || ![_x] call IVCS_fnc_hasMedicalItem) exitWith {};

        if (isNull _closestUnit) then
        {
            _closestUnit = _x;
        }
        else
        {
            if (_unit distance _x < _unit distance _closestUnit) then
            {
                _closestUnit = _x;
            };
        };
    } forEach _groupUnits;

    private _handle = [_x, _closestUnit] spawn
    {
        _this params ["_unit", "_medic"];

        private _exitTime = time + 30;
        private _radius = 3;
        private _startHealth = damage _unit;

        waitUntil {
            // Continually tell the unit to move to the target's position in-case their moving
            _unit doMove (getPosATL _medic);

            // Exit the loop if...
            (time >= _exitTime) ||
            (!isNull objectParent _medic) ||
            (!alive _unit) ||
            (!alive _medic) ||
            (damage _unit == 0) ||
            (damage _unit <= _startHealth) ||
            (_unit distance _medic <= _radius && { speed _unit <= 0.1 })
        };
        if (time >= _time || _unit distance _medic > _radius) exitWith {
            [_unit] call IVCS_fnc_negativeSpeak;
        };

        _unit disableAI "PATH"; // Stop the unit from moving away from the target
        _medic disableAI "PATH"; // Stop the target from moving away from the unit
        _medic action ["HealSoldier", _unit];

        private _exitTime = time + 10;
        waitUntil {damage _unit >= _startHealth || !alive _unit || !alive _medic || time >= _exitTime };

        _unit enableAI "PATH";
        _medic enableAI "PATH";

        _unit doFollow (leader group _unit);
    };

    private _handles = _x getVariable ["ivcs_handles", []];
    _x setVariable ["ivcs_handles", (_handles + _handler)];
} forEach _units;