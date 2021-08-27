params [["_left",[],[[]]], ["_function","",[""]], ["_right",[],[[]]]];

private _player = missionNamespace getVariable ["bis_fnc_moduleRemoteControl_unit", player];
private _full_group = units group _player - [_player];
private _units = [];

// Check if there are any units
_units = [_left] call ivcs_fnc_convert_units;

// Check if there are any groups
if (count _units <= 0) then
{
	_units = [_left] call ivcs_fnc_convert_groups;

	// Default to everyone in the group if nothing could be found
	if (count _units <= 0) then
	{
		_units = _full_group
	};
};

private _confirmation_speak = { ["130_Com_Reply",format["Confirmation%1_%2.ogg",(round random 1) + 1, (round random 9) + 1], false, _this] call IVCS_fnc_speak; };

if (uiNamespace getVariable ["ivcs_output_group_chat", true]) then
{
	private _text = switch _function do
	{
		case "regroup": {("ivcs" callExtension ["replace", [localize "STR_A3___1___REGROUP", "%1.1", "%1"]])#0};
		case "stop": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___STOP", "%1.1", "%1"]])#0};
		case "cancel_target": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___CANCEL_TARGET", "%1.1", "%1"]])#0};
		case "target_object": {("ivcs" callExtension ["replace", [localize "STR_A3_TARGET____1", "%1", "%2"]])#0};
		case "hold_fire": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___HOLD_FIRE", "%1.1", "%1"]])#0};
		case "open_fire": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___OPEN_FIRE", "%1.1", "%1"]])#0};
		case "assign_color": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1____2", "%1.1", "%1"]])#0};
		case "find_cover": {localize "STR_A3___1___TAKE_COVER"};
		case "move_grid": {localize "STR_A3__MUNIT___MOVE___GRID___MGRID"};
		case "move_left_quick": {format[("ivcs" callExtension ["replace", [localize "STR_A3__MUNIT___MOVE____MGRPDIR_1", "%4.1", "%2"]])#0, "%1", localize "STR_A3_ARGUMENTS_DIRECTION_RELATIVE1_180_0"]};
		case "move_right_quick": {format[("ivcs" callExtension ["replace", [localize "STR_A3__MUNIT___MOVE____MGRPDIR_1", "%4.1", "%2"]])#0, "%1", localize "STR_A3_ARGUMENTS_DIRECTION_RELATIVE1_90_0"]};
		case "move_front_quick": {format[("ivcs" callExtension ["replace", [localize "STR_A3__MUNIT___MOVE____MGRPDIR_1", "%4.1", "%2"]])#0, "%1", localize "STR_A3_ARGUMENTS_DIRECTION_RELATIVE1_0_0"]};
		case "move_back_quick": {format[("ivcs" callExtension ["replace", [localize "STR_A3__MUNIT___MOVE____MGRPDIR_1", "%4.1", "%2"]])#0, "%1", localize "STR_A3_ARGUMENTS_DIRECTION_RELATIVE1_270_0"]};
		case "move_distance_point";
		case "move_distance_and";
		case "move_object";
		case "move_distance": {("ivcs" callExtension ["replace", [localize "STR_A3__MUNIT___MOVE____MGRPDIR_1", "%4.1", "%2"]])#0};
		case "open_fire_red": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1____2", "%1.1", "%1"]])#0};
		case "salute": {localize "STR_IVCS_SYSTEMCHAT_SALUTE_1"};
		case "sit": {localize "STR_IVCS_SYSTEMCHAT_SIT_1"};
		case "drop_bag": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___DROP_PACK", "%1.1", "%1"]])#0};
		case "pos_up": {localize "STR_IVCS_SYSTEMCHAT_STAND_1"};
		case "pos_middle": {localize "STR_IVCS_SYSTEMCHAT_CROUCH_1"};
		case "pos_down": {localize "STR_IVCS_SYSTEMCHAT_PRONE_1"};
		case "pos_auto": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___COPY_MY_STANCE", "%1.1", "%1"]])#0};
		case "combat_stealth": {localize "STR_A3___1___STEALTH"};
		case "combat_combat": {localize "STR_A3___1___COMBAT"};
		case "combat_aware": {localize "STR_A3___1___AWARE"};
		case "combat_safe": {localize "STR_A3___1___RELAX"};
		case "formation_wedge": {localize "STR_A3_FORMATION___WEDGE"};
		case "formation_vee": {localize "STR_A3_FORMATION___VEE"};
		case "formation_staggered_column": {localize "STR_A3_FORMATION___STAGGERED_COL_"};
		case "formation_line": {localize "STR_A3_FORMATION___LINE"};
		case "formation_file": {localize "STR_A3_FORMATION___FILE"};
		case "formation_echelon_right": {localize "STR_A3_FORMATION___ECHELON_R_"};
		case "formation_echelon_left": {localize "STR_A3_FORMATION___ECHELON_L_"};
		case "formation_diamond": {localize "STR_A3_FORMATION___DIAMOND"};
		case "formation_column": {localize "STR_A3_FORMATION___COLUMN"};
		case "get_in_player";
		case "get_in": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___GET_IN", "%1.1", "%1"]])#0};
		case "get_out": {localize "STR_IVCS_SYSTEMCHAT_GET_OUT_1"};
		case "scan_horizon": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___SCAN_HORIZON", "%1.1", "%1"]])#0};
		case "move_cursor": {localize "STR_IVCS_SYSTEMCHAT_MOVE_1"};
		case "sitrep": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___SITREP", "%1.1", "%1"]])#0};
		case "lights_off": {localize "STR_IVCS_SYSTEMCHAT_LIGHTS_OFF_1"};
		case "lights_on": {localize "STR_IVCS_SYSTEMCHAT_LIGHTS_ON_1"};
		case "lasers_off": {localize "STR_IVCS_SYSTEMCHAT_LASER_OFF_1"};
		case "lasers_on": {localize "STR_IVCS_SYSTEMCHAT_LASER_ON_1"};
		case "watch_direction": {("ivcs" callExtension ["replace", [localize "STR_A3___1_1___WATCH____2", "%1.1", "%1"]])#0};
		case "suppressive_fire": {localize "STR_A3_SUPPRESSIVE_FIRE_"};
		default {""};
	};

	if (_text != "") then
	{
		private _left_text = ("ivcs" callExtension ["title_case", [_left joinString ", "]])#0;
		private _right_text = ("ivcs" callExtension ["title_case", [_right joinString " "]])#0;

		// Check if it's only numbers in the right text
		private _number = true;
		{
			if !(_x in ["0","1","2","3","4","5","6","7","8","9"]) then
			{
				_number = false;
				break;
			};
		} foreach _right;
		if _number then
		{
			// Don't place spaces between only numbers
			_right_text = _right joinString "";
		};
		_player groupChat (format [_text, _left_text, _right_text]);
	}
	else
	{
		private _message = format["Function '%1' does not have a text representation found in callback_input file.", _function];
		diag_log _message;
		systemChat _message;
		[_message] call BIS_fnc_error;
	};
};

// By default all handles
{
	private _handles = _x getVariable ["ivcs_handles", []];
	{
		terminate _x;
	} foreach _handles;

	_x setVariable ["ivcs_handles", []];
	_x setVariable ["ivcs_scan_horizon_end", true];
} foreach _units;

// These functions are defined in the grammar file which is used by the speech recognition engine
switch (tolower _function) do
{
	case "sitrep":
	{
		["120_Com_Ask", selectRandom["ReportIn.ogg", "Sitrep.ogg"], true] call IVCS_fnc_speak;
		[_units, _player,_confirmation_speak] spawn
		{
			_this params ["_units","_player","_confirmation_speak"];
			sleep 1;
			{
				if (alive _x) then
				{
					// Unit is alive
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
								_text = _add#_foreachindex;
							}
							else
							{
								_text = _text + ", " + (_add#_foreachindex);
							};
						};
					} forEach [_distance, _injured, _ammo];

					if (_text == "") then
					{
						_text = localize "STR_A3_A_M05_65_MOVING_BRA_0";
					};

					_x groupChat _text;
					_x call _confirmation_speak;
				}
				else
				{
					// Unit is dead
					["140_Com_Status", selectRandom["WeLostOneE_1.ogg","WeLostOneE_2.ogg","WeLostOneE_3.ogg"], true] call IVCS_fnc_speak;
					[_x] joinSilent grpNull;
				};
				_player reveal _x;
				sleep 1.5;
			} foreach _units;
		};
	};
	case "lights_off":
	{
		["100_Commands", "FlashlightsOff.ogg", true] call IVCS_fnc_speak;
		{
			_x enableGunLights "ForceOff";
		} foreach _units;
	};
	case "lights_on":
	{
		["100_Commands", "FlashlightsOn.ogg", true] call IVCS_fnc_speak;
		{
			_x enableGunLights "ForceOn";
		} foreach _units;
	};
	case "lasers_off":
	{
		["100_Commands", "PointersOff.ogg", true] call IVCS_fnc_speak;
		{
			_x enableIRLasers false;
		} foreach _units;
	};
	case "lasers_on":
	{
		["100_Commands", "PointersOn.ogg", true] call IVCS_fnc_speak;
		{
			_x enableIRLasers true;
		} foreach _units;
	};
	case "regroup":
	{
		// Tell the units to follow
		_units commandFollow (leader group _player);
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
		// Tell the units to target the object
		private _object = [_right#0] call ivcs_fnc_convert_objects;

		// Only command units to watch the target if the object actually exists
		if !(isNull _object) then
		{
			_units commandTarget _object;

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
							localize "STR_IVCS_FEEDBACK_TARGET_TEXT",
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
			systemChat localize "STR_IVCS_FEEDBACK_TARGET_OBJECT_NOT_FOUND";
		};
	};
	case "move_object":
	{
		// Tell the units to target the object
		private _object = [_right#0, true] call ivcs_fnc_convert_objects;

		// Only command units to watch the target if the object actually exists
		if !(isNull _object) then
		{
			_units commandMove getPos _object;

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
							localize "STR_IVCS_FEEDBACK_MOVE_TO_TARGET_TEXT",
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
			systemChat localize "STR_IVCS_FEEDBACK_TARGET_OBJECT_NOT_FOUND";
		};
	};
	case "hold_fire":
	{
		// Tell the units to never fire
		if (_units isEqualTo _full_group) then
		{
			_player setCombatMode "BLUE";
		}
		else
		{
			{
				_x setUnitCombatMode "BLUE";
			} foreach _units;
		};
	};
	case "open_fire":
	{
		// Tell the units to fire at will, but not leave formation
		if (_units isEqualTo _full_group) then
		{
			_player setCombatMode "YELLOW";
		}
		else
		{
			{
				_x setUnitCombatMode "YELLOW";
			} foreach _units;
		};
	};
	case "open_fire_red":
	{
		// Tell the units to fire at will, but not leave formation
		if (_units isEqualTo _full_group) then
		{
			_player setCombatMode "RED";
		}
		else
		{
			{
				_x setUnitCombatMode "RED";
			} foreach _units;
		};
	};
	case "assign_color":
	{
		// Get units to join the color team
		private _colors = ["white", "red", "green", "yellow", "blue"];
		private _index = _colors findIf {private _color = _x; _right findif {_x == _color} > -1};
		if (_index > -1) then
		{
			private _team = _colors#_index;
			["030_Teams", _team+"Team.ogg"] call IVCS_fnc_speak;

			if (_team == "white") then {_team = "main"};
			{
				_x assignTeam _team;
			} foreach _units;
		};
	};
	case "find_cover":
	{
		// Get units to move to a cover position
		private _positions = [_player, 20] call IVCS_fnc_cover;
		{
			private _pos = selectRandom _positions;
			if (count _positions <= 0) then
			{
				_pos = _x getPos [20, random 360];
			}
			else
			{
				_positions deleteAt (_positions findIf {_x isEqualTo _pos});
			};

			_x commandMove AGLToASL _pos;
		} foreach _units;
	};
	case "move_cursor":
	{
		private _position = if visibleMap then
		{
			// Move to a position on the map
			(findDisplay 12 displayCtrl 51) posScreenToWorld getMousePosition;
		}
		else
		{
			// Move to the position where the player is looking
			screenToWorld [0.5,0.5];
		};
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
		// Get units to move to a grid position
		_units commandMove (_player getPos [40, (getDir _player) - 90]);
	};
	case "move_right_quick":
	{
		// Get units to move to a grid position
		_units commandMove (_player getPos [40, (getDir _player) + 90]);
	};
	case "move_front_quick":
	{
		// Get units to move to a grid position
		_units commandMove (_player getPos [40, (getDir _player) + 0]);
	};
	case "move_back_quick":
	{
		// Get units to move to a grid position
		_units commandMove (_player getPos [40, (getDir _player) - 180]);
	};
	case "move_distance_point";
	case "move_distance_and";
	case "move_distance":
	{
		// Get units to move a relative way
		_right params ["_distance","_unit","_direction"];

		private _distance = parseNumber _distance;
		private _unit = [1000, 1] select (_unit find "meter" == 0);
		private _direction = [_direction, _player] call ivcs_fnc_convert_direction;

		private _end_pos = [getPosATL _player, _distance*_unit, _direction] call BIS_fnc_relPos;
		_units commandMove _end_pos;
	};
	case "watch_direction":
	{
		// Get units to watch a relative direction
		_right params ["_direction"];
		private _direction = [_direction, _player] call ivcs_fnc_convert_direction;
		_units commandWatch (_player getPos [10000, _direction]);
	};
	case "suppressive_fire":
	{
		// Get units to suppress a position
		_right params [["_type","",[""]]];

		private _object = [_type] call ivcs_fnc_convert_objects;

		// Only command units to watch the target if the object actually exists
		if !(isNull _object) then
		{
			_units commandSuppressiveFire _object;

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
							localize "STR_IVCS_FEEDBACK_SUPPRESSIVE_FIRE_TARGET_TEXT",
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
			// Players do have the option to call
			// suppresive fire without defining a target
			if (_type == "") then
			{
				// If no target was given try to use the position under the camera
				private _pos = screenToWorld [0.5,0.5];

				// Limit to 500 meters to avoid running into issues where
				if (_player distance _pos < 500) then
				{
					_units commandSuppressiveFire AGLToASL _pos;
				}
				else
				{
					_units commandSuppressiveFire (_player getPos [300, getDir _player]);
				};
			}
			else
			{
				systemChat localize "STR_IVCS_FEEDBACK_TARGET_OBJECT_NOT_FOUND";
			};
		};
	};
	case "scan_horizon":
	{
		["100_Commands", "scanhorizon.ogg", true] call IVCS_fnc_speak;
		{
			_x setVariable ["ivcs_scan_horizon_end", nil];

			// Create a loop to control the AI scanning
			private _id = [
				{
					private _unit = _this#0#0;
					private _damage = _this#0#1;
					private _id = _this#1;

					if (isNil "_unit" || _unit getVariable ["ivcs_scan_horizon_end", false] || !alive _unit || damage _unit > _damage || behaviour _unit == "COMBAT" || _unit call BIS_fnc_enemyDetected) then
					{
						[_handle] call CBA_fnc_removePerFrameHandler;
					}
					else
					{
						if !isGamePaused then
						{
							private _dir = _unit getVariable ["ivcs_dir", getDir _unit];
							_unit doWatch (_unit getPos [300, _dir + 40]);

							_unit setVariable ["ivcs_dir", _dir + 40];
						};
					};
				},
				5,
				[_x, damage _x]
			] call CBA_fnc_addPerFrameHandler;

			_x setVariable ["ivcs_scan_horizon_id", _id];
		} foreach _units;
	};
	case "get_out":
	{
		// Tell all units to get out of their vehicles
		commandGetOut _units;
	};
	case "get_in_player";
	case "get_in":
	{
		// Get units to suppress a position
		_right params [["_type","",[""]], "_as", ["_role","",[""]]];

		private _object = [_type] call ivcs_fnc_convert_objects;

		if (_function == "get_in_player" && {!(vehicle _player isEqualTo player)}) then
		{
			_object = vehicle _player;
		};

		if !(isNull _object) then
		{
			private _role_text = [_role] call ivcs_fnc_convert_role;

			["100_Commands", selectRandom["BoardThatVehicle.ogg","GetInThatVehicle.ogg"]] call IVCS_fnc_speak;

			{
				private _handle = [_x, _object, _role_text] spawn
				{
					_this params ["_unit", "_object", "_role_text"];
					_unit doMove (getPosATL _object);
					private _time = time + 30;
					private _radius = sizeOf typeOf _object;
					waitUntil {(time >= _time) || (_unit distance _object <= _radius && {speed _unit <= 0.1})};
					if (time >= _time) exitWith {};
					if (locked _object == 2) exitWith {};

					switch _role_text do
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
			} foreach _units;

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
	};
	case "salute":
	{
		// This is for the salute call
		{
			if (_foreachindex == 0) then {_x call _confirmation_speak};

			// Get units to salute
			_x action ["salute", _x];
		} foreach _units;
	};
	case "sit":
	{
		{
			if (_foreachindex == 0) then {_x call _confirmation_speak};

			// Sit down
			_x action ["sitdown", _x];
		} foreach _units;
	};
	case "drop_bag":
	{
		{
			if (backpack _x != "") then
			{
				private _holder = createVehicle ["GroundWeaponHolder_Scripted", getPosATL _x, [], 0, "CAN_COLLIDE"];
				_x action ["DropBag", _holder, backpack _x];
			};
		} foreach _units;
	};
	case "pos_up":
	{
		["100_Commands", "OnYourFeet.ogg"] call IVCS_fnc_speak;
		{
			_x setUnitPos "UP";
		} foreach _units;
	};
	case "pos_middle":
	{
		["100_Commands", "StayLow.ogg"] call IVCS_fnc_speak;
		{
			_x setUnitPos "MIDDLE";
		} foreach _units;
	};
	case "pos_down":
	{
		["100_Commands", selectRandom["GoProne_1.ogg","GoProne_2.ogg"]] call IVCS_fnc_speak;
		{
			_x setUnitPos "DOWN";
		} foreach _units;
	};
	case "pos_auto":
	{
		["100_Commands", "CopyMyStance.ogg"] call IVCS_fnc_speak;
		{
			_x setUnitPos "AUTO";
		} foreach _units;
	};
	case "combat_safe":
	{
		["100_Commands", selectRandom["Safe_1.ogg","Safe_2.ogg","Relax.ogg"], true] call IVCS_fnc_speak;
		{
			_x setCombatBehaviour "SAFE";
		} foreach _units;
	};
	case "combat_aware":
	{
		["100_Commands", selectRandom["StayAlert.ogg","KeepFocused.ogg"], true] call IVCS_fnc_speak;
		{
			_x setCombatBehaviour "AWARE";
		} foreach _units;
	};
	case "combat_combat":
	{
		["100_Commands", selectRandom["Danger.ogg","LockAndLoad.ogg","PrepareForContact.ogg","GetReadyToFight.ogg"], true] call IVCS_fnc_speak;
		{
			_x setCombatBehaviour "COMBAT";
		} foreach _units;
	};
	case "combat_stealth":
	{
		["100_Commands", selectRandom["DownAndQuiet.ogg","CommStealth.ogg"], true] call IVCS_fnc_speak;
		{
			_x setCombatBehaviour "STEALTH";
		} foreach _units;
	};
	case "formation_wedge":
	{
		(group player) setFormation "WEDGE";
	};
	case "formation_vee":
	{
		(group player) setFormation "VEE";
	};
	case "formation_staggered_column":
	{
		(group player) setFormation "STAG COLUMN";
	};
	case "formation_line":
	{
		(group player) setFormation "LINE";
	};
	case "formation_file":
	{
		(group player) setFormation "FILE";
	};
	case "formation_echelon_right":
	{
		(group player) setFormation "ECH RIGHT";
	};
	case "formation_echelon_left":
	{
		(group player) setFormation "ECH LEFT";
	};
	case "formation_diamond":
	{
		(group player) setFormation "DIAMOND";
	};
	case "formation_column":
	{
		(group player) setFormation "COLUMN";
	};
	default
	{
		private _message = format["Function '%1' not found in callback_input file.", _function];
		diag_log _message;
		systemChat _message;
		[_message] call BIS_fnc_error;
	};
};
