/*
    Integrated AI Voice Control System
    File: fn_hasMedicalItem.sqf
    Function: IVCS_fnc_hasMedicalItem
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Checks if the unit has a single valid medical item in its inventory.

    Parameters:
    _unit: Object - The unit to check
    _includeMedikit: Boolean - Include Medikit items in the check

    Returns:
    Boolean - Returns true if the unit has a medical item, false if it does not.

    Notes:
    Medical items are defined as items that can be used to heal the unit, that inherit from the base FirstAidKit and Medikit classes.
*/

params [["_unit",objNull,[objNull]], ["_includeMedikit",false,[false]]];

if (isNull _unit) exitWith {false};

private _medicalItemTypes = [401 /* FirstAidKit */];
if (_includeMedikit) then
{
    _medicalItemTypes pushBackUnique 619 /* Medikit */;
};

private _items = items _unit;
_items findIf
{
    private _itemType = getNumber (configFile >> "CfgWeapons" >> _x >> "ItemInfo" >> "type");
    _medicalItemTypes findIf {_x == _itemType}  > -1
} > -1
