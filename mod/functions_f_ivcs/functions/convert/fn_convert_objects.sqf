params [["_input","",[""]],["_ff",false,[false]]];

private _search_fnc =
{
	params ["_types","_ff"];

	private _target = cursorTarget;
	if (alive _target && {[_target, _types,_ff] call _type_fnc}) then
	{
		_target
	}
	else
	{
		private _target_object = cursorObject;
		if (alive _target_object && {[_target_object, _types, _ff] call _type_fnc}) then
		{
			_target_object
		}
		else
		{
			private _possible = [];

			{
				// Only return objects that are alive, non-hidden, and of the correct type
				if (alive _x  && {!(isObjectHidden _x) && {simulationEnabled _x && {[_x, _types, _ff] call _type_fnc}}}) then
				{
					private _direction = player getDir _x;
					private _diff = abs (_direction - (getDir player));

					/*
					This is another way to do it but also acconts for distance from the player - I prefer the other method
					private _direction_coeff = ((getPosATL player) vectorFromTo (getPosATL _x)) vectorDotProduct (vectorDir player);
					if (_direction_coeff >= 0.97) then
					*/
					if (_diff <= 10) then
					{
						// Make sure this unit isn't obstructed to the player
						if !(lineIntersects [(AGLToASL positionCameraToWorld [0,0,0]), eyepos _x, vehicle player, vehicle _x]) then
						{
							_possible pushBackUnique [_diff, _x];

						};
					};
				};
			} foreach (vehicles + allUnits);

			if (count _possible > 0) then
			{
				private _final_diff = 10;
				private _final = objnull;
				{
					if ((_x#0) <= _final_diff) then
					{
						_final_diff = _x#0;
						_final = _x#1;
					};
				} foreach _possible;

				_final
			}
			else
			{
				objnull
			};
		};
	};
};

private _type_fnc =
{
	params ["_unit","_types","_ff"];

	private _pass = false;
	{
		if (_unit isKindOf _x) exitWith
		{
			_pass = true;
		};
	} foreach _types;

	if (_ff && {_unit isKindOf "Man" && {(side player) getFriend (side _unit) >= 0.6}}) then
	{
		false;
	}
	else
	{
		_pass;
	};
};

private _object = switch _input do
{
	// Characters
	case "enemy";
	case "character";
	case "soldier";
	case "man";
	case "guy";
	case "woman";
	case "girl";
	case "unit";
	case "person":
	{
		[["Man"],_ff] call _search_fnc;
	};

	// All Vehicles
	case "vehicle":
	{
		[["Land","Air","Ship"],_ff] call _search_fnc;
	};

	// Vehicles - Land
	case "car":
	{
		[["Car"],_ff] call _search_fnc;
	};
	case "truck":
	{
		[["Truck_F"],_ff] call _search_fnc;
	};
	case "kart":
	{
		[["Kart_01_Base_F"],_ff] call _search_fnc;
	};
	case "quadbike":
	{
		[["Quadbike_01_base_F"],_ff] call _search_fnc;
	};
	case "suv":
	{
		[["SUV_01_base_F"],_ff] call _search_fnc;
	};
	case "armor";
	case "tank":
	{
		[["Tank_F"],_ff] call _search_fnc;
	};
	case "apc":
	{
		[["Wheeled_APC_F", "APC_Tracked_01_base_F"],_ff] call _search_fnc;
	};

	// Vehicles - Water
	case "boat";
	case "ship";
	case "submarine":
	{
		[["Ship"],_ff] call _search_fnc;
	};

	// Vehicles - Air
	case "plane":
	{
		[["Plane"],_ff] call _search_fnc;
	};
	case "helicopter";
	case "chopper";
	case "heli":
	{
		[["Helicopter"],_ff] call _search_fnc;
	};
	case "aircraft":
	{
		[["Air"],_ff] call _search_fnc;
	};

	// Can't determine the type of object
	case "cancel";
	default {objnull};
};

// Output the object
_object
