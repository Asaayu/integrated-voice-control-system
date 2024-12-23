/*
    Integrated AI Voice Control System
	File: fn_speak.sqf
	Function: IVCS_fnc_speak
    Author: Asaayu
    Date: 2024-12-24

    Description:
	Plays a voice line for the given unit using the voice files for the radio protocol.

    Parameters:
	_folder: String - The folder containing the voice file
	_file: String - The voice file to play
	_force_normal: Boolean - Forces the voice line to be played in the normal state
	_unit: Object - The unit to play the voice line for

	Returns:
	Boolean - Returns true if the voice line was played successfully

    Notes:
	Due to limitations with the Arma 3 engine, the voice line will be played using playSound3D, rather then say3D.
*/

params [["_folder", "", [""]], ["_file", "", [""]], ["_force_normal", false, [false]], ["_unit", player, [objNull]]];

private _voice = configFile >> "CfgVoice" >> (speaker _unit);
private _voice_directory = (getArray (_voice >> "directories"))#0;

// Remove the first backslash
_voice_directory = _voice_directory select [1, 999];

if (_voice_directory isEqualTo "") exitWith {false};

// "\A3\Dubbing_Radio_F\data\ENG\Male01ENG\"
// Make sure there is a black slash at the end of the string
if !((_voice_directory select [count _voice_directory - 1,1]) isEqualTo "\") then
{
	_voice_directory = _voice_directory + "\";
};

// Add the protocol to the voice directory
_voice_directory = _voice_directory + (getText (_voice >> "protocol")) + "\";

// Add the current unit state
private _mode = switch (behaviour _unit) do
{
	case "ERROR";
	case "CARELESS";
	case "SAFE";
	case "AWARE": {"Normal"};
	case "COMBAT": {"Combat"};
	case "STEALTH": {"Stealth"};
};
if _force_normal then {_mode = "Normal"};
_voice_directory = _voice_directory + _mode + "\";

playSound3D [_voice_directory + _folder + "\" + _file, vehicle _unit, false, eyePos _unit, 1, 1, 0];
true;
