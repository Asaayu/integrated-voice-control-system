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
    _rightText: Array - A string of the target unit to heal

    Returns:
    NONE

    Notes:
    Only units that have a medical item in their inventory will be told to heal the target.
*/

params [["_units",[],[[]]], ["_rightText", [], [[]]]];

private _targets = [_rightText] call IVCS_fnc_convertUnits;

if (!isNil "_targets" && {count _targets > 0}) then
{
    private _target = _targets select 0;
    if (isNull _target || damage _target == 0) exitWith {};

    {
        if (_x == _target) exitWith {};

        if !([_x] call IVCS_fnc_hasMedicalItem) exitWith {
            [_x, localize "STR_IVCS_SYSTEMCHAT_NO_MEDICAL_EQUIPMENT_1"] call IVCS_fnc_negativeSpeak;
        };

        private _handle = [_x, _target] spawn
        {
            _this params ["_unit", "_target"];

            private _exitTime = time + 30;
            private _radius = 3;
            private _startHealth = damage _target;

            // Get the unit to regroup to un-do any previous orders
            _unit doFollow (leader group _unit);
            _unit doMove (getPosATL _target);

            private _lastCall = time;
            waitUntil {
                // Continually tell the unit to move to the target's position in-case their moving
                if (time - _lastCall >= 5) then
                {
                    _unit doMove (getPosATL _target);
                    _lastCall = time;
                };

                // Exit the loop if...
                (stopped _unit) ||
                !(isNull objectParent _target) ||
                !(alive _target) ||
                (damage _target == 0) ||
                (damage _target < _startHealth) ||
                (_unit distance _target <= _radius && { speed _unit <= 0.1 })
            };

            if (time >= _exitTime || _unit distance _target > _radius) exitWith {
                [_unit] call IVCS_fnc_negativeSpeak;
                _unit doFollow (leader group _unit);
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