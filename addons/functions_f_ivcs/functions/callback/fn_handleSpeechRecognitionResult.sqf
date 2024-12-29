/*
    Integrated AI Voice Control System
    File: fn_handleSpeechRecognitionResult.sqf
    Function: IVCS_fnc_handleSpeechRecognitionResult
    Author: Asaayu
    Date: 2024-12-22

    Description:
    Handles the result of the speech recognition engine, this function is called when the extension callback handler receives a speech recognition result.

    Parameters:
    _left: ARRAY - The prefix of the speech recognition result
    _function: STRING - The function that the speech recognition result is for
    _right: ARRAY - The arguments of the speech recognition result

    Returns:
    NONE

    Notes:
    This function is called by the extension callback handler when a speech recognition result is received and should not be called directly.
*/

params [
    ["_left",[],[[]]],
    ["_function","",[""]],
    ["_right",[],[[]]]
];

private _player = call IVCS_fnc_player;
private _units = [_left] call IVCS_fnc_convertUnits;

// If no units are found, then try to convert the group
if (count _units <= 0) then
{
    _units = [_left] call IVCS_fnc_convertGroups;

    // If no groups are found, then fallback to the entire group
    if (count _units <= 0) then
    {
        _units = (units group _player - [_player]);
    };
};

// Output the text to group chat
if (uiNamespace getVariable ["ivcs_output_group_chat", true]) then
{
    private _text = switch _function do
    {
        case "assign_color": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1____2", "%1.1", "%1"]])#0};
        case "cancel_target": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___CANCEL_TARGET", "%1.1", "%1"]])#0};
        case "combat_aware": {localize "STR_A3___1___AWARE"};
        case "combat_combat": {localize "STR_A3___1___COMBAT"};
        case "combat_safe": {localize "STR_A3___1___RELAX"};
        case "combat_stealth": {localize "STR_A3___1___STEALTH"};
        case "drop_bag": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___DROP_PACK", "%1.1", "%1"]])#0};
        case "eject": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___EJECT", "%1.1", "%1"]])#0};
        case "engine_off": {localize "STR_IVCS_SYSTEMCHAT_ENGINE_OFF_1"};
        case "engine_on": {localize "STR_IVCS_SYSTEMCHAT_ENGINE_ON_1"};
        case "find_cover": {localize "STR_A3___1___TAKE_COVER"};
        case "fire": {localize "STR_IVCS_SYSTEMCHAT_FIRE_1"};
        case "flank_back_quick";
        case "flank_front_quick";
        case "flank_left_quick";
        case "flank_right_quick";
        case "formation_column": {localize "STR_A3_FORMATION___COLUMN"};
        case "formation_diamond": {localize "STR_A3_FORMATION___DIAMOND"};
        case "formation_echelon_left": {localize "STR_A3_FORMATION___ECHELON_L_"};
        case "formation_echelon_right": {localize "STR_A3_FORMATION___ECHELON_R_"};
        case "formation_file": {localize "STR_A3_FORMATION___FILE"};
        case "formation_line": {localize "STR_A3_FORMATION___LINE"};
        case "formation_staggered_column": {localize "STR_A3_FORMATION___STAGGERED_COL_"};
        case "formation_vee": {localize "STR_A3_FORMATION___VEE"};
        case "formation_wedge": {localize "STR_A3_FORMATION___WEDGE"};
        case "garrison_nearby": {localize "STR_IVCS_SYSTEMCHAT_GARRISON_1"};
        case "get_in_player";
        case "get_in": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___GET_IN", "%1.1", "%1"]])#0};
        case "get_out": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___DISMOUNT", "%1.1", "%1"]])#0};
        case "hold_fire": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___HOLD_FIRE", "%1.1", "%1"]])#0};
        case "land_helicopter": {localize "STR_IVCS_SYSTEMCHAT_LAND_HELICOPTER_1"};
        case "lasers_off": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___POINTERS_OFF", "%1.1", "%1"]])#0};
        case "lasers_on": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___POINTERS_ON", "%1.1", "%1"]])#0};
        case "lights_off": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___FLASHLIGHTS_OFF", "%1.1", "%1"]])#0};
        case "lights_on": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___FLASHLIGHTS_ON", "%1.1", "%1"]])#0};
        case "move_back_quick": {format[("ivcs" callExtension ["replace", [localize "STR_A3__MUNIT___MOVE____MGRPDIR_1", "%4.1", "%2"]])#0, "%1", localize "STR_A3_ARGUMENTS_DIRECTION_RELATIVE1_270_0"]};
        case "move_cursor": {localize "STR_IVCS_SYSTEMCHAT_MOVE_1"};
        case "move_distance_and";
        case "move_distance_point";
        case "move_distance": {("ivcs" callExtension ["replace", [localize "STR_A3__MUNIT___MOVE____MGRPDIR_1", "%4.1", "%2"]])#0};
        case "move_front_quick": {format[("ivcs" callExtension ["replace", [localize "STR_A3__MUNIT___MOVE____MGRPDIR_1", "%4.1", "%2"]])#0, "%1", localize "STR_A3_ARGUMENTS_DIRECTION_RELATIVE1_0_0"]};
        case "move_grid": {localize "STR_A3__MUNIT___MOVE___GRID___MGRID"};
        case "move_left_quick": {format[("ivcs" callExtension ["replace", [localize "STR_A3__MUNIT___MOVE____MGRPDIR_1", "%4.1", "%2"]])#0, "%1", localize "STR_A3_ARGUMENTS_DIRECTION_RELATIVE1_180_0"]};
        case "move_object";
        case "move_right_quick": {format[("ivcs" callExtension ["replace", [localize "STR_A3__MUNIT___MOVE____MGRPDIR_1", "%4.1", "%2"]])#0, "%1", localize "STR_A3_ARGUMENTS_DIRECTION_RELATIVE1_90_0"]};
        case "open_fire_red": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___FREE_TO_ENGAGE", "%1.1", "%1"]])#0};
        case "open_fire_white": {localize "STR_IVCS_SYSTEMCHAT_OPEN_FIRE_WHITE_1"};
        case "open_fire": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___OPEN_FIRE", "%1.1", "%1"]])#0};
        case "pos_auto": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___COPY_MY_STANCE", "%1.1", "%1"]])#0};
        case "pos_down": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___PRONE", "%1.1", "%1"]])#0};
        case "pos_middle": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___CROUCH", "%1.1", "%1"]])#0};
        case "pos_up": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___STAND", "%1.1", "%1"]])#0};
        case "regroup": {("ivcs" callExtension ["replace", [localize "STR_A3___1___REGROUP", "%1.1", "%1"]])#0};
        case "salute": {localize "STR_IVCS_SYSTEMCHAT_SALUTE_1"};
        case "scan_horizon": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___SCAN_HORIZON", "%1.1", "%1"]])#0};
        case "sensors_off": {localize "STR_IVCS_SYSTEMCHAT_SENSORS_OFF_1"};
        case "sensors_on": {localize "STR_IVCS_SYSTEMCHAT_SENSORS_ON_1"};
        case "sit": {localize "STR_IVCS_SYSTEMCHAT_SIT_1"};
        case "sitrep": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___SITREP", "%1.1", "%1"]])#0};
        case "stop": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___STOP", "%1.1", "%1"]])#0};
        case "suppressive_fire": {localize "STR_IVCS_SYSTEMCHAT_MOVE_1"};
        case "target_object": {("ivcs" callExtension ["replace", [localize "STR_A3_TARGET____1", "%1", "%2"]])#0};
        case "watch_cursor": {localize "STR_IVCS_SYSTEMCHAT_WATCH_1"};
        case "watch_direction": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___WATCH____2", "%1.1", "%1"]])#0};
        case "take_position": {localize "STR_IVCS_SYSTEMCHAT_TAKE_POSITION_1"};
        case "heal_self": {localize "STR_IVCS_SYSTEMCHAT_HEAL_SELF_1"};
        case "heal_find": {localize "STR_IVCS_SYSTEMCHAT_HEAL_FIND_1"};
        case "heal_find_player": {localize "STR_IVCS_SYSTEMCHAT_HEAL_FIND_PLAYER_1"};
        case "heal_other": {("ivcs" callExtension ["replace", [localize "str_a3___1_1___heal____2", "%1.1", "%1"]])#0};
        case "quick_attack": {localize "STR_IVCS_SYSTEMCHAT_QUICK_ATTACK_1"};
        default {""};
    };

    if (_text != "") then
    {
        private _leftText = ("ivcs" callExtension ["title_case", [_left joinString ", "]])#0;
        private _rightText = ("ivcs" callExtension ["title_case", [_right joinString " "]])#0;

        private _number = true;
        {
            if !(_x in ["0","1","2","3","4","5","6","7","8","9"]) then
            {
                _number = false;
                break;
            };
        } forEach _right;

        // Arrays with only numbers are joined without a separator as it's a grid reference
        if (_number) then
        {
            _rightText = _right joinString "";
        };

        _player groupChat (format [_text, _leftText, _rightText]);
    }
    else
    {
        private _message = format["Function '%1' does not have a text representation found in fn_handleSpeechRecognitionResult.sqf file.", _function];
        diag_log _message;
        systemChat _message;
        [_message] call BIS_fnc_error;
    };
};

// Terminate any existing order handles for the units selected to avoid conflicting orders
{
    private _handles = _x getVariable ["ivcs_handles", []];
    { terminate _x } forEach _handles;

    private _frameHandles = _x getVariable ["ivcs_frame_handles", []];
    { [_x] call CBA_fnc_removePerFrameHandler; } forEach ivcs_frame_handles;

    // "PATH" needs to be enabled as it may have been disabled by the HealOther or HealFind functions
    _x enableAI "PATH";

    _x setVariable ["ivcs_handles", []];
    _x setVariable ["ivcs_frame_handles", []];
} forEach _units;

// These functions are defined in the grammar file which is used by the speech recognition engine
switch (toLower _function) do
{
    case "sitrep":
    {
        [_units] call IVCS_fnc_sitrep;
    };
    case "lights_on":
    {
        [_units, true] call IVCS_fnc_gunLights;
    };
    case "lights_off":
    {
        [_units, false] call IVCS_fnc_gunLights;
    };
    case "lasers_on":
    {
        [_units, true] call IVCS_fnc_gunPointers;
    };
    case "lasers_off":
    {
        [_units, false] call IVCS_fnc_gunPointers;
    };
    case "regroup":
    {
        [_units] call IVCS_fnc_regroup;
    };
    case "stop":
    {
        // Tell the units to stop
        commandStop _units;
    };
    case "cancel_target":
    {
        // Tell the units to cancel their current target
        _units commandTarget objNull;
    };
    case "target_object":
    {
        [_units, _right#0] call IVCS_fnc_targetObject;
    };
    case "move_object":
    {
        [_units, _right#0] call IVCS_fnc_moveToObject;
    };
    case "fire":
    {
        // Force the units to fire a single shot
        {
            [_x, currentMuzzle _x] call BIS_fnc_fire;
        } forEach _units;
    };
    case "hold_fire":
    {
        // Tell the units to never fire
        [_units, "BLUE"] call IVCS_fnc_setCombatMode;
    };
    case "open_fire":
    {
        // Tell the units to fire at will, but not leave formation
        [_units, "YELLOW"] call IVCS_fnc_setCombatMode;
    };
    case "open_fire_red":
    {
        // Tell the units to fire at will, but not leave formation
        [_units, "RED"] call IVCS_fnc_setCombatMode;
    };
    case "open_fire_white":
    {
        // Tell the units to only fire at will if fired upon
        [_units, "WHITE"] call IVCS_fnc_setCombatMode;
    };
    case "assign_color":
    {
        [_units, _right] call IVCS_fnc_assignTeamColor;
    };
    case "find_cover":
    {
        private _positions = [_player, 20] call IVCS_fnc_coverPositions;
        [_units, _positions] call IVCS_fnc_moveToCover;
    };
    case "garrison_nearby":
    {
        private _positions = [_player, 20] call IVCS_fnc_garrisonPositions;
        [_units, _positions] call IVCS_fnc_moveToGarrison;
    };
    case "move_cursor":
    {
        private _position = call IVCS_fnc_getCursorWorldPosition;
        _units commandMove _position;
    };
    case "move_grid":
    {
        // Get units to move to a grid position
        private _position = (_right joinString "") call BIS_fnc_gridToPos;
        _position = [_position#0#0 + (_position#1#0)/2, _position#0#1 + (_position#1#1)/2];
        _units commandMove _position;
    };
    case "move_left_quick":
    {
        // Moves the units to a position relative to the position
        _units commandMove (_player getPos [40, (getDir _player) - 90]);
    };
    case "move_right_quick":
    {
        // Moves the units to a position relative to the position
        _units commandMove (_player getPos [40, (getDir _player) + 90]);
    };
    case "move_front_quick":
    {
        // Moves the units to a position relative to the position
        _units commandMove (_player getPos [40, (getDir _player) + 0]);
    };
    case "move_back_quick":
    {
        // Moves the units to a position relative to the position
        _units commandMove (_player getPos [40, (getDir _player) - 180]);
    };
    case "flank_left_quick":
    {
        // Changes the units formation position
        _units commandMove (_player getPos [40, (getDir _player) - 90]);
    };
    case "flank_right_quick":
    {
        // Changes the units formation position
        _units commandMove (_player getPos [40, (getDir _player) + 90]);
    };
    case "flank_front_quick":
    {
        // Changes the units formation position
        _units commandMove (_player getPos [40, (getDir _player) + 0]);
    };
    case "flank_back_quick":
    {
        // Changes the units formation position
        _units commandMove (_player getPos [40, (getDir _player) - 180]);
    };
    case "move_distance_point";
    case "move_distance_and";
    case "move_distance":
    {
        _right params ["_distance","_unit","_direction"];

        private _distance = parseNumber _distance;
        private _unit = [1000, 1] select (_unit find "meter" == 0);
        private _direction = [_direction, _player] call IVCS_fnc_convertDirection;
        private _end_pos = (getPosATL _player) getPos [_distance * _unit, _direction];
        _units commandMove _end_pos;
    };
    case "watch_direction":
    {
        _right params ["_direction"];

        private _direction = [_direction, _player] call IVCS_fnc_convertDirection;
        _units commandWatch (_player getPos [10000, _direction]);
    };
    case "watch_cursor":
    {
        private _position = call IVCS_fnc_getCursorWorldPosition;
        _units commandWatch _position;
    };
    case "suppressive_fire":
    {
        [_units, _right] call IVCS_fnc_suppressiveFire;
    };
    case "scan_horizon":
    {
        [_units] call IVCS_fnc_scanHorizon;
    };
    case "get_out":
    {
        commandGetOut _units;
    };
    case "eject":
    {
        {
            _x action ["Eject", vehicle _x];
        } forEach _units;
    };
    case "get_in_player";
    case "get_in":
    {
        [_units, _right] call IVCS_fnc_getIn;
    };
    case "salute":
    {
        {
            [_x] call IVCS_fnc_confirmationSpeak;
            _x action ["salute", _x];
        } forEach _units;
    };
    case "sit":
    {
        {
            [_x] call IVCS_fnc_confirmationSpeak;
            _x action ["sitdown", _x];
        } forEach _units;
    };
    case "drop_bag":
    {
        {
            if (backpack _x != "") then
            {
                private _holder = createVehicle ["GroundWeaponHolder_Scripted", getPosATL _x, [], 0, "CAN_COLLIDE"];
                _x action ["DropBag", _holder, backpack _x];
            };
        } forEach _units;
    };
    case "pos_up":
    {
        ["100_Commands", "OnYourFeet.ogg"] call IVCS_fnc_speak;
        {
            _x setUnitPos "UP";
        } forEach _units;
    };
    case "pos_middle":
    {
        ["100_Commands", "StayLow.ogg"] call IVCS_fnc_speak;
        {
            _x setUnitPos "MIDDLE";
        } forEach _units;
    };
    case "pos_down":
    {
        ["100_Commands", selectRandom["GoProne_1.ogg","GoProne_2.ogg"]] call IVCS_fnc_speak;
        {
            _x setUnitPos "DOWN";
        } forEach _units;
    };
    case "pos_auto":
    {
        ["100_Commands", "CopyMyStance.ogg"] call IVCS_fnc_speak;
        {
            _x setUnitPos "AUTO";
        } forEach _units;
    };
    case "combat_safe":
    {
        ["100_Commands", selectRandom["Safe_1.ogg","Safe_2.ogg","Relax.ogg"], true] call IVCS_fnc_speak;
        {
            _x setCombatBehaviour "SAFE";
        } forEach _units;
    };
    case "combat_aware":
    {
        ["100_Commands", selectRandom["StayAlert.ogg","KeepFocused.ogg"], true] call IVCS_fnc_speak;
        {
            _x setCombatBehaviour "AWARE";
        } forEach _units;
    };
    case "combat_combat":
    {
        ["100_Commands", selectRandom["Danger.ogg","LockAndLoad.ogg","PrepareForContact.ogg","GetReadyToFight.ogg"], true] call IVCS_fnc_speak;
        {
            _x setCombatBehaviour "COMBAT";
        } forEach _units;
    };
    case "combat_stealth":
    {
        ["100_Commands", selectRandom["DownAndQuiet.ogg","CommStealth.ogg"], true] call IVCS_fnc_speak;
        {
            _x setCombatBehaviour "STEALTH";
        } forEach _units;
    };
    case "formation_wedge":
    {
        (group _player) setFormation "WEDGE";
    };
    case "formation_vee":
    {
        (group _player) setFormation "VEE";
    };
    case "formation_staggered_column":
    {
        (group _player) setFormation "STAG COLUMN";
    };
    case "formation_line":
    {
        (group _player) setFormation "LINE";
    };
    case "formation_file":
    {
        (group _player) setFormation "FILE";
    };
    case "formation_echelon_right":
    {
        (group _player) setFormation "ECH RIGHT";
    };
    case "formation_echelon_left":
    {
        (group _player) setFormation "ECH LEFT";
    };
    case "formation_diamond":
    {
        (group _player) setFormation "DIAMOND";
    };
    case "formation_column":
    {
        (group _player) setFormation "COLUMN";
    };
    case "engine_on":
    {
        {
            if (alive _x && {!isNull objectParent _x && {driver (vehicle _x) == _x}}) then
            {
                _x action ["engineOn", vehicle _x];
            };
        } forEach _units;
    };
    case "engine_off":
    {
        {
            if (alive _x && {!isNull objectParent _x && {driver (vehicle _x) == _x}}) then
            {
                _x action ["engineOff", vehicle _x];
            };
        } forEach _units;
    };
    case "sensors_on":
    {
        {
            _x action ["ActiveSensorsOn", vehicle _x];
        } forEach _units;
    };
    case "sensors_off":
    {
        {
            _x action ["ActiveSensorsOff", vehicle _x];
        } forEach _units;
    };
    case "land_helicopter":
    {
        {
            if ((vehicle _x) isKindOf "Helicopter") then
            {
                _x land "LAND";
            };
        } forEach _units;
    };
    case "take_position":
    {
        _units commandMove (_player getPos [1, (getDir _player)]);
    };
    case "heal_self":
    {
        {
            private _success = [_x] call IVCS_fnc_healSelf;
            if (_success) then
            {
                [_x] call IVCS_fnc_confirmationSpeak;
            };
        } forEach _units;
    };
    case "heal_find":
    {
        [_units] call IVCS_fnc_healFind;
    };
    case "heal_find_player":
    {
        [_units] call IVCS_fnc_healFindPlayer;
    };
    case "quick_attack":
    {
        // Combat mode, Fire at will, Engage at will, open fire
        {
            _x setUnitCombatMode "RED";
            _x setCombatBehaviour "COMBAT";
        } forEach _units;
    };
    case "heal_other":
    {
        // If units is everyone and _right is empty, then this was just the phrase "heal"
        if (count _units == count (units group _player - [_player]) && count _right == 0) then
        {
            {
                private _success = [_x] call IVCS_fnc_healSelf;
                if (_success) then
                {
                    [_x] call IVCS_fnc_confirmationSpeak;
                };
            } forEach _units;
        }
        else
        {
            [_units, _right] call IVCS_fnc_healOther;
        };
    };
    default
    {
        private _message = format["Function '%1' not found in callback_input file.", _function];
        diag_log _message;
        systemChat _message;
        [_message] call BIS_fnc_error;
    };
};
