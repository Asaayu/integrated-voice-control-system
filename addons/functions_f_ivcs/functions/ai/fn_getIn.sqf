/*
    Integrated AI Voice Control System
    File: fn_getIn.sqf
    Function: IVCS_fnc_getIn
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Tells an array of units to get in a vehicle.

    Parameters:
    _units: Array - An array of units to get in the vehicle
    _right: Array - The vehicle type, "as" keyword, and role from the recognized phrase
    _function: String - The recognized function, "get_in_player" makes units get into the player's vehicle

    Returns:
    NONE

    Notes:
    The AI will attempt to move to the position of the vehicle and get in.
*/

params [["_units",[],[[]]], ["_right", [], [[]]], ["_function", "", [""]]];

private _player = call IVCS_fnc_player;

_right params [["_type","",[""]], "_as", ["_role","",[""]]];

private _object = [_type] call IVCS_fnc_convertObjects;
if (_function == "get_in_player" && {!isNull objectParent _player}) then
{
    _object = vehicle _player;
};

if !(isNull _object) then
{
    private _roleText = [_role] call IVCS_fnc_convertRole;

    ["100_Commands", selectRandom["BoardThatVehicle.ogg","GetInThatVehicle.ogg"]] call IVCS_fnc_speak;

    {
        private _handle = [_x, _object, _roleText] spawn
        {
            _this params ["_unit", "_object", "_roleText"];
            _unit doMove (getPosATL _object);
            private _time = time + 30;
            private _radius = sizeOf typeOf _object;
            waitUntil {(time >= _time) || (_unit distance _object <= _radius && {speed _unit <= 0.1})};
            if (time >= _time) exitWith {};
            if (locked _object == 2) exitWith {};

            switch _roleText do
            {
                case "driver":
                {
                    _unit action ["getInDriver", _object];
                };
                case "commander":
                {
                    _unit action ["getInCommander", _object];
                };
                case "gunner":
                {
                    _unit action ["getInGunner", _object];
                };
                case "cargo":
                {
                    _unit action ["getInCargo", _object];
                };
                default
                {
                    _unit moveInAny _object;
                };
            };
        };

        private _handles = _x getVariable ["ivcs_handles", []];
        _x setVariable ["ivcs_handles", (_handles + [_handle])];
    } forEach _units;

    [_object, localize "STR_IVCS_FEEDBACK_GET_IN_TARGET_TEXT"] call IVCS_fnc_drawTargetConfirmation;
}
else
{
    // No vehicle target could be found
    systemChat localize "STR_IVCS_FEEDBACK_VEHICLE_OBJECT_NOT_FOUND";
};
