/*
    Integrated AI Voice Control System
    File: fn_coverPositions.sqf
    Function: IVCS_fnc_coverPositions
    Author: Asaayu
    Date: 2024-12-24

    Description:
    Returns a list of possible cover positions for the given unit within the specified distance.

    Parameters:
    _unit: Object - The unit to find cover positions for
    _distance: Number - The distance to search for cover positions

    Returns:
    Array - A list of possible cover positions

    Notes:
    This function will search for nearby buildings, trees, bushes, and terrain objects to find possible cover positions.
*/

params [["_unit",objNull,[objNull]],["_distance",20,[0]]];

private _final = [];
private _objects = (nearestTerrainObjects [_unit, ["TREE", "SMALL TREE", "BUSH", "BUILDING", "HIDE"], _distance, false]) + (nearestObjects  [_unit, ["Building"], _distance]);
{
    {
        _final pushBackUnique _x;
    } forEach (_x buildingPos -1);
} forEach _objects;

_final
