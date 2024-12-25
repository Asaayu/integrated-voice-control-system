/*
    Integrated AI Voice Control System
	File: fn_healSelf.sqf
	Function: IVCS_fnc_healSelf
    Author: Asaayu
    Date: 2024-12-24

    Description:
	Handler for the "Heal Self" voice command, will attempt to heal the unit passed through the parameter.

    Parameters:
	_unit: Object - The unit to heal itself

	Returns:
	Boolean - Returns true if the unit was healed, false if it was not.

    Notes:
	The unit will only heal itself if it has a medical item in its inventory.
*/

params [["_unit",objNull,[objNull]]];

// Check if the unit is valid
if (isNull _unit) exitWith {false};
if (isPlayer _unit) exitWith {false};
if !(alive _unit) exitWith {false};
if ((vehicle _unit) == _unit) exitWith {false};
if ((damage _unit) <= 0.1) exitWith {false};

// Check if the unit has a medical item in its inventory
if (!([_unit] call IVCS_fnc_hasMedicalItem)) exitWith {false};


// player action ["HealSoldier", soldier1];