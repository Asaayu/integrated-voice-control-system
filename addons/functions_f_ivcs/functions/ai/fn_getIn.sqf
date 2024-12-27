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

    Returns:
    NONE

    Notes:
    The AI will attempt to move to the position of the vehicle and get in.
*/

params [["_units",[],[[]]], ["_right", [], [[]]]];

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
        _x setVariable ["ivcs_handles", (_handles + _handler)];
    } forEach _units;

    if (uiNamespace getVariable ["ivcs_target_confirm_ui", true]) then
    {
        addMissionEventHandler ["Draw3D",
        {
            private _time = _thisArgs#0;
            private _object = _thisArgs#1;

            if (alive _object && {time <= _time + 4}) then
            {
                drawIcon3D
                [
                    "a3\ui_f\data\GUI\Cfg\Cursors\hc_overenemy_gs.paa",
                    [1,1,1,linearConversion [_time + 2, _time + 2.5, time, 1, 0]],
                    _object modelToWorldVisual (_object selectionPosition "pelvis"),
                    1,
                    1,
                    0,
                    localize "STR_IVCS_FEEDBACK_GET_IN_TARGET_TEXT",
                    2,
                    0.03,
                    "RobotoCondensedLight",
                    "center",
                    true
                ];
            }
            else
            {
                removeMissionEventHandler ["Draw3D", _thisEventHandler];
            };
        },
        [
            time,
            _object
        ]];
    };
}
else
{
    // No vehicle target could be found
    systemChat localize "STR_IVCS_FEEDBACK_VEHICLE_OBJECT_NOT_FOUND";
};