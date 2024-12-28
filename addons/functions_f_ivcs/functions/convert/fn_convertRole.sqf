/*
    Integrated AI Voice Control System
    File: fn_convertRole.sqf
    Function: IVCS_fnc_convertRole
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Converts a role string into a role.

    Parameters:
    _input: String - The role to convert

    Returns:
    String - The role

    Notes:
    Role strings must be one of the following:
    - driver
    - pilot
    - commander
    - gunner
    - turret
    - cargo
    - passenger
*/

params [["_input","",[""]]];

private _role = switch _input do
{
    case "driver";
    case "pilot": {"driver"};

    case "commander": {"commander"};

    case "gunner";
    case "turret": {"gunner"};

    case "cargo";
    case "passenger": {"cargo"};

    case "";
    default {""};
};

// Output the object
_role
