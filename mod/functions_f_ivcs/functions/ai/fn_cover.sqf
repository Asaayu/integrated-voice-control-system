params [["_unit",objnull,[objnull]],["_distance",20,[0]]];

// Get a list of nearby buildings and terrain objects
private _objects = (nearestTerrainObjects [_unit, ["TREE", "SMALL TREE", "BUSH", "BUILDING", "HIDE"], _distance, false]) + (nearestObjects  [_unit, ["Building"], _distance]);

// Get a list of unique positions
private _final = [];
{
	{
		_final pushBackUnique _x;
	} foreach (_x buildingPos -1);
} foreach _objects;

// Return possible positions
_final
