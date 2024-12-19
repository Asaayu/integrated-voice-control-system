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
