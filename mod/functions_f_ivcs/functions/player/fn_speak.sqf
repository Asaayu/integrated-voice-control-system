params [["_folder", "", [""]], ["_file", "", [""]], ["_force_normal", false, [false]], ["_unit", player, [objnull]]];

private _voice = configfile >> "CfgVoice" >> (speaker _unit);
private _voice_directory = (getArray (_voice >> "directories"))#0;

// Remove the first backslash
_voice_directory = _voice_directory select [1, 999];

if (_voice_directory isEqualTo "") exitWith {false};

// "\A3\Dubbing_Radio_F\data\ENG\Male01ENG\"
// Make sure there is a blackslash at the end of the string
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

playSound3D [_voice_directory + _folder + "\" + _file, vehicle _unit, false, eyepos _unit, 1, 1, 0];
true;
