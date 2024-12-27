/*
    Integrated AI Voice Control System
    File: fn_convertObjects.sqf
    Function: IVCS_fnc_convertObjects
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Converts an object string into an object.

    Parameters:
    _input: String - The object to convert
    _friendlyAllowed: Boolean - Whether to allow friendly objects to be selected

    Returns:
    Object - The object

    Notes:
    Selected object is sorted by distance and direction the player is facing, if cancel is selected, it will return objNull to fail intentionally.
*/

params [["_input","",[""]],["_friendlyAllowed",false,[false]]];

private _player = call IVCS_fnc_player;

private _fnc_type =
{
    params ["_unit","_types","_friendlyAllowed"];

    private _pass = false;
    {
        if (_unit isKindOf _x) exitWith
        {
            _pass = true;
        };
    } forEach _types;

    [_pass, false] select (_friendlyAllowed && {_unit isKindOf "Man" && {(side _player) getFriend (side _unit) >= 0.6}});
};

private _fnc_search =
{
    params ["_types","_friendlyAllowed"];

    private _target = cursorTarget;
    if (alive _target && {[_target, _types, _friendlyAllowed] call _fnc_type}) then
    {
        _target
    }
    else
    {
        private _target_object = cursorObject;
        if (alive _target_object && {[_target_object, _types, _friendlyAllowed] call _fnc_type}) then
        {
            _target_object
        }
        else
        {
            private _possible = [];

            {
                // Only return objects that are alive, non-hidden, and of the correct type
                if (alive _x  && {!(isObjectHidden _x) && {simulationEnabled _x && {[_x, _types, _friendlyAllowed] call _fnc_type}}}) then
                {
                    private _direction = _player getDir _x;
                    private _diff = abs (_direction - (getDir _player));

                    /*
                    This is another way to do it but also accounts for distance from the player - I prefer the other method
                    private _direction_coeff = ((getPosATL _player) vectorFromTo (getPosATL _x)) vectorDotProduct (vectorDir _player);
                    if (_direction_coeff >= 0.97) then
                    */
                    if (_diff <= 10) then
                    {
                        // Make sure this unit isn't obstructed to the player
                        if !(lineIntersects [(AGLToASL positionCameraToWorld [0,0,0]), eyePos _x, vehicle _player, vehicle _x]) then
                        {
                            _possible pushBackUnique [_diff, _x];

                        };
                    };
                };
            } forEach (vehicles + allUnits);

            if (count _possible > 0) then
            {
                private _final_diff = 10;
                private _final = objNull;
                {
                    if ((_x#0) <= _final_diff) then
                    {
                        _final_diff = _x#0;
                        _final = _x#1;
                    };
                } forEach _possible;

                _final
            }
            else
            {
                objNull
            };
        };
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
        [["Man"],_friendlyAllowed] call _fnc_search;
    };

    // All Vehicles
    case "vehicle":
    {
        [["Land","Air","Ship"],_friendlyAllowed] call _fnc_search;
    };

    // Vehicles - Land
    case "car":
    {
        [["Car"],_friendlyAllowed] call _fnc_search;
    };
    case "truck":
    {
        [["Truck_F"],_friendlyAllowed] call _fnc_search;
    };
    case "kart":
    {
        [["Kart_01_Base_F"],_friendlyAllowed] call _fnc_search;
    };
    case "quadbike":
    {
        [["Quadbike_01_base_F"],_friendlyAllowed] call _fnc_search;
    };
    case "suv":
    {
        [["SUV_01_base_F"],_friendlyAllowed] call _fnc_search;
    };
    case "armor";
    case "tank":
    {
        [["Tank_F"],_friendlyAllowed] call _fnc_search;
    };
    case "apc":
    {
        [["Wheeled_APC_F", "APC_Tracked_01_base_F"],_friendlyAllowed] call _fnc_search;
    };

    // Vehicles - Water
    case "boat";
    case "ship";
    case "submarine":
    {
        [["Ship"],_friendlyAllowed] call _fnc_search;
    };

    // Vehicles - Air
    case "plane":
    {
        [["Plane"],_friendlyAllowed] call _fnc_search;
    };
    case "helicopter";
    case "chopper";
    case "heli":
    {
        [["Helicopter"],_friendlyAllowed] call _fnc_search;
    };
    case "aircraft":
    {
        [["Air"],_friendlyAllowed] call _fnc_search;
    };

    // Can't determine the type of object
    case "cancel";
    default {objNull};
};

// Output the object
_object
