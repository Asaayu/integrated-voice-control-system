/*
    Integrated AI Voice Control System
    File: fn_sitrep.sqf
    Function: IVCS_fnc_sitrep
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Orders a group of units to report in with a sitrep. The AI will report in with their status, or will leave the group if they are dead.

    Parameters:
    _units: Array - An array of units

    Returns:
    NONE

    Notes:
    Units will report in with their status, or will leave the group if they are dead, and will be revealed to the player.
*/

params [["_units",[],[[]]]];

[_units] spawn
{
    _this params [["_units",[],[[]]]];
    private _player = call IVCS_fnc_player;

    ["120_Com_Ask", selectRandom["ReportIn.ogg", "Sitrep.ogg"], true] call IVCS_fnc_speak;
    sleep 1;

    {
        if (alive _x) then
        {
            private _weapon = currentWeapon _x;
            private _distance = _player distance _x > 100;
            private _injured = damage _x > 0.25;
            private _ammo = _weapon != "" && {{private _mag = _x; ([_weapon] call BIS_fnc_compatibleMagazines) findIf {_x == _mag} > -1} count (magazines _x) <= 2};
            private _ammo_empty = _weapon != "" && {{private _mag = _x; ([_weapon] call BIS_fnc_compatibleMagazines) findIf {_x == _mag} > -1} count (magazines _x) <= 0};

            private _unit = _x;
            private _text = "";
            {
                private _add = [format[localize "STR_A3_GRID___2", "", mapGridPosition _unit], localize "STR_A3_INJURED", [localize "STR_A3_LOW_AMMO", localize "STR_A3_VR_HELI_WEAPONS_NO_AMMO"] select _ammo_empty];
                if (_x) then
                {
                    if (_text == "") then
                    {
                        _text = _add#_forEachIndex;
                    }
                    else
                    {
                        _text = _text + ", " + (_add#_forEachIndex);
                    };
                };
            } forEach [_distance, _injured, _ammo];

            if (_text == "") then
            {
                _text = localize "STR_A3_A_M05_65_MOVING_BRA_0";
            };

            _x groupChat _text;
            [_x] call IVCS_fnc_confirmationSpeak;
        }
        else
        {
            ["140_Com_Status", selectRandom["WeLostOneE_1.ogg","WeLostOneE_2.ogg","WeLostOneE_3.ogg"], true] call IVCS_fnc_speak;
            [_x] joinSilent grpNull;
        };
        _player reveal _x;

        sleep 1.5;
    } forEach _units;
};