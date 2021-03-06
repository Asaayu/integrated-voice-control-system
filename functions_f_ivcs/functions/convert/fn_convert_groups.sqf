params [["_groups",[],[[]]]];

private _all = false;
private _teams = [];

{
	private _group = _x;

	// Pushback all color teams
	{
		if (_group find _x > -1) then
		{
			_teams pushBackUnique _x;
		};
	} foreach ["red","green","yellow","blue","white"];

	// Check if all units are selected
	{
		if (_group find _x > -1) then
		{
			_all = true;
			break;
		};
	} foreach ["group","squad","everybody","everyone","every1","all"];

	// Break out of loop if all units is selected
	if _all then {break;}
} foreach _groups;

private _units = (units group player) - [player];
private _output = [];
if _all then
{
	_output = _units;
}
else
{
	{
		private _team = assignedTeam _x;
		if (_teams findIf {_x == _team || (_team == "main" && {_x == "white"})} >-1) then
		{
			_output pushBackUnique _x;
		};
	} foreach _units;
};
_output
