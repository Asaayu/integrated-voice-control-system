/*
    Integrated AI Voice Control System
    File: fn_convertFormation.sqf
    Function: IVCS_fnc_convertFormation
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Converts a formation string into a formation role.

    Parameters:
    _input: String - The formation to convert

    Returns:
    String - The formation role

    Notes:
    Formation strings must be one of the following:
    - column
    - staggered column
    - wedge
    - echelon left
    - echelon right
    - vee
    - file
    - diamond
    - line
*/

params [["_input","",[""]]];

private _role = switch _input do
{
    case "column": {"COLUMN"};
    case "staggered column": {"STAG COLUMN"};
    case "wedge": {"WEDGE"};
    case "echelon left": {"ECH LEFT"};
    case "echelon right": {"ECH RIGHT"};
    case "vee": {"VEE"};
    case "file": {"FILE"};
    case "diamond": {"DIAMOND"};
    case "line";
    default {"LINE"};
};

// Output the formation
_role
