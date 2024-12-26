/*
    Integrated AI Voice Control System
    File: fn_convertDirection.sqf
    Function: IVCS_fnc_convertDirection
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Converts a direction string into a direction in degrees.

    Parameters:
    _direction: String - The direction to convert
    _relativeObject: Object - The object to use as a reference for relative directions

    Returns:
    Number - The direction in degrees

    Notes:
    Direction strings can be either compass ordinals (north, north east, east, etc.) or relative directions (front, back, left, right).
*/

params [["_direction","",[""]],["_relativeObject",objNull,[objNull]]];

private _directionFinal = switch (toLower _direction) do
{
    // Compass Directions
    case ("north"):
    {
        0
    };
    case ("north east"):
    {
        45
    };
    case ("east"):
    {
        90
    };
    case ("south east"):
    {
        135
    };
    case ("south"):
    {
        180
    };
    case ("south west"):
    {
        225
    };
    case ("west"):
    {
        270
    };
    case ("north west"):
    {
        315
    };

    // Relative Directions
    case ("back");
    case ("backwards"):
    {
        (getDir _relativeObject) + 180
    };
    case ("right"):
    {
        (getDir _relativeObject) + 90
    };
    case ("left"):
    {
        (getDir _relativeObject) - 90
    };

    case ("front");
    case ("forward");
    case ("forwards");
    default
    {
        (getDir _relativeObject) + 0
    };
};

_directionFinal
