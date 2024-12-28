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
if !(isNull objectParent _unit) exitWith {false};
if (damage _unit == 0) exitWith {false};

// Check if the unit has a medical item in its inventory
if !([_unit] call IVCS_fnc_hasMedicalItem) exitWith {
    [_unit, localize "STR_IVCS_SYSTEMCHAT_NO_MEDICAL_EQUIPMENT_1"] call IVCS_fnc_negativeSpeak;
};

_unit action ["HealSoldierSelf", _unit]; // May try 'HealSoldier' instead to see what the difference is
true;