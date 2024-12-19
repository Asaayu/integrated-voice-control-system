
private _id = missionNamespace getVariable ["ivcs_extension", -1];

if (_id <= -1) then
{
	_id = addMissionEventHandler ["ExtensionCallback",
	{
		params ["_name", "_function", "_data"];
		if (_name == "IVCS") then
		{
			switch (tolower _function) do
			{
				case "call_function":
				{
					private _input = parseSimpleArray _data;
					_input call ivcs_fnc_callback_input;
				};
				case "systemchat":
				{
					systemChat _data;
				};
				case "ctrlsettext":
				{
					private _data = parseSimpleArray _data;
					_data params [["_name","",[""]], ["_idc",-1,[-1]], ["_text","",[""]]];

					private _display = uiNamespace getVariable [_name, displayNull];
					private _ctrl = _display displayCtrl _idc;
					if (ctrlType _ctrl == 13) then
					{
						_ctrl ctrlSetStructuredText parseText _text;
					}
					else
					{
						_ctrl ctrlSetText _text;
					};
				};
				case "ctrlsettext_readable":
				{
					private _data = parseSimpleArray _data;
					_data params [["_name","",[""]], ["_idc",-1,[-1]], ["_text","",[""]]];

					private _text = ("ivcs" callExtension ["convert_number_readable", [_text]])#0;
					private _display = uiNamespace getVariable [_name, displayNull];
					private _ctrl = _display displayCtrl _idc;
					if (ctrlType _ctrl == 13) then
					{
						_ctrl ctrlSetStructuredText parseText _text;
					}
					else
					{
						_ctrl ctrlSetText _text;
					};
				};
				case "ctrlsettextcolor":
				{
					private _data = parseSimpleArray _data;
					_data params [["_name","",[""]], ["_idc",-1,[-1]], ["_color",[1,1,1,1],[[]]]];
					private _display = uiNamespace getVariable [_name, displayNull];
					private _ctrl = _display displayCtrl _idc;
					_ctrl ctrlSetTextColor _color;
				};
				case "ctrlshow":
				{
					private _data = parseSimpleArray _data;
					_data params [["_name","",[""]], ["_idc",-1,[-1]], ["_show",[false],[false]]];
					private _display = uiNamespace getVariable [_name, displayNull];
					private _ctrl = _display displayCtrl _idc;
					_ctrl ctrlShow _show;
				};
				case "fadedisplay":
				{
					private _data = parseSimpleArray _data;
					_data params [["_name","",[""]], ["_time",0,[0]], ["_fade",0,[0]]];
					private _display = uiNamespace getVariable [_name, displayNull];
					private _ctrls = [100, 101, 1000, 1001];
					{
						private _ctrl = _display displayCtrl _x;
						_ctrl ctrlSetFade _fade;
						_ctrl ctrlCommit _time;
					} foreach _ctrls;
				};
				default
				{
					["Unknown function (%1) not defined in callback master switch", _function] call BIS_fnc_error;
				};
			};
		};
	}];

	missionNamespace setVariable ["ivcs_extension", _id];
};
