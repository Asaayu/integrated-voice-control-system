/*
    Integrated AI Voice Control System
	File: fn_openExternalProgram.sqf
	Function: IVCS_fnc_openExternalProgram
    Author: Asaayu
    Date: 2024-12-22

    Description:
	Sends an event to the extension to open an external program outside of the game.
	Allowed programs are whitelisted and defined directly in the extension to prevent abuse.

    Parameters:
	_parentDisplay: Display - The display that called this function, used to close the display after the program is opened.
	_program: String - The enum variable name of the program to open.

	Returns:
	NONE

    Notes:
	This function is used for the main menu buttons and is called directly from their onLoad event handlers, it should not be called directly.
*/

params [["_parentDisplay", displayNull], ["_program", ""]];
if (isNil "_program" || isNil "_parentDisplay") exitWith {};

_parentDisplay closeDisplay 0;
"ivcs" callExtension ["open_external_program", [_program]];