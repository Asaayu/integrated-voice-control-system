params [["_groups",[],[[]]]];

private _all = false;
private _teams = [];

{
	private _group = _x;

	// Push back all color teams
	{
		if (_group find _x > -1) then
		{
			_teams pushBackUnique _x;
		};
	} forEach ["red","green","yellow","blue","white"];

	// Check if all units are selected
	{
		if (_group find _x > -1) then
		{
			_all = true;
			break;
		};
	} forEach ["group","squad","everybody","everyone","every1","all"];

	// Break out of loop if all units is selected
	if _all then {break;}
} forEach _groups;

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
	} forEach _units;
};
_output
