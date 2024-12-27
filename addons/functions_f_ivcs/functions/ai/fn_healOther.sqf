/*
    Integrated AI Voice Control System
    File: fn_healOther.sqf
    Function: IVCS_fnc_healOther
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Tells an array of units to heal another unit.

    Parameters:
    _units: Array - An array of units to get in the vehicle
    _targetText: Array - A string of the target unit to heal

    Returns:
    NONE

    Notes:
    Only units that have a medical item in their inventory will be told to heal the target.
*/

params [["_units",[],[[]]], ["_targetText", "", [""]]];

private _targets = [_targetText] call IVCS_fnc_convertUnits;

if !(isNull _target) then
{
    {
        if !([_x] call IVCS_fnc_hasMedicalItem) exitWith {
            [_x] call IVCS_fnc_negativeSpeak;
        };

        private _handle = [_x, _target] spawn
        {
            _this params ["_unit", "_target"];

            private _exitTime = time + 30;
            private _radius = 3;
            private _startHealth = damage _target;

            waitUntil {
                // Continually tell the unit to move to the target's position in-case their moving
                _unit doMove (getPosATL _target);

                // Exit the loop if...
                (time >= _exitTime) ||
                (!isNull objectParent _target) ||
                (!alive _target) ||
                (damage _target == 0) ||
                (damage _target <= _startHealth) ||
                (_unit distance _target <= _radius && { speed _unit <= 0.1 })
            };
            if (time >= _time || _unit distance _target > _radius) exitWith {
                [_unit] call IVCS_fnc_negativeSpeak;
            };

            _target disableAI "PATH"; // Stop the target from moving away from the unit
            _unit action ["HealSoldier", _target];

            private _exitTime = time + 10;
            waitUntil {damage _target >= _startHealth || !alive _unit || !alive _target || time >= _exitTime };

            _target enableAI "PATH";
            _unit doFollow (leader group _unit);
        };

        private _handles = _x getVariable ["ivcs_handles", []];
        _x setVariable ["ivcs_handles", (_handles + _handler)];
    } forEach _units;
}
else
{
    systemChat localize "STR_IVCS_FEEDBACK_TARGET_UNIT_NOT_FOUND";
};