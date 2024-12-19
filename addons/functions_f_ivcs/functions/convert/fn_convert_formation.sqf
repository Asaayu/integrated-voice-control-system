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
