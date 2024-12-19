params [["_direction","",[""]],["_relative_object",objNull,[objNull]]];

private _direction_final = switch (toLower _direction) do
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
		(getDir _relative_object) + 180
	};
	case ("right"):
	{
		(getDir _relative_object) + 90
	};
	case ("left"):
	{
		(getDir _relative_object) - 90
	};

	case ("front");
	case ("forward");
	case ("forwards");
	default
	{
	    (getDir _relative_object) + 0
	};
};

_direction_final
