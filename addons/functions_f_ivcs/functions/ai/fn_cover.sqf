params [["_unit",objNull,[objNull]],["_distance",20,[0]]];

// Get a list of nearby buildings and terrain objects
private _objects = (nearestTerrainObjects [_unit, ["TREE", "SMALL TREE", "BUSH", "BUILDING", "HIDE"], _distance, false]) + (nearestObjects  [_unit, ["Building"], _distance]);

// Get a list of unique positions
private _final = [];
{
	{
		_final pushBackUnique _x;
	} forEach (_x buildingPos -1);
} forEach _objects;

// Return possible positions
_final
