/*
    Integrated AI Voice Control System
    File: fn_garrisonPositions.sqf
    Function: IVCS_fnc_garrisonPositions
    Author: Asaayu
    Date: 2024-12-24

    Description:
    Returns a list of possible garrison positions for the given unit within the specified distance.

    Parameters:
    _unit: Object - The unit to find garrison positions for
    _distance: Number - The distance to search for garrison positions

    Returns:
    Array - A list of possible garrison positions

    Notes:
    This function will search for nearby buildings to find possible garrison positions.
*/

params [["_unit",objNull,[objNull]],["_distance",20,[0]]];

private _final = [];
private _objects = (nearestTerrainObjects [_unit, ["BUILDING"], _distance, false]) + (nearestObjects  [_unit, ["Building"], _distance]);
{
    {
        _final pushBackUnique _x;
    } forEach (_x buildingPos -1);
} forEach _objects;

_final
