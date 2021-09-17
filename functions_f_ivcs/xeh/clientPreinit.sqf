// Call the preload function
"ivcs" callExtension "preload";

// Add the extension callback
call IVCS_fnc_callback;

// Add the settings
#include "_settings.sqf"

// Add the KEYBINDS
#include "_keybinds.sqf"

[] spawn
{
	sleep 1;
	if (!is3DEN && {!isNull (findDisplay 46)}) then
	{
		// Call this file after a mission is loaded
		addMissionEventHandler ["Loaded",
		{
			call compile preprocessFileLineNumbers '\ivcs\functions_f_ivcs\xeh\clientPreinit.sqf';
		}];

		// Create the engine if it does not exist
		"ivcs" callExtension "mission_start";

		// Reload the grammar each mission start
		"ivcs" callExtension "reload_grammar";

		// Remove any frame handlers that are already present
		private _frame_id = uiNamespace getVariable ["ivcs_ptt_check_id", -1];
		if (_frame_id > -1) then
		{
			[_frame_id] call CBA_fnc_removePerFrameHandler
		};

		// Add loop to check if PTT key should be un-pressed
		private _frame_id =
		[
			{
				if (uiNamespace getVariable ["ivcs_ptt_down", false] && {!isGameFocused || isGamePaused}) then
				{
					uiNamespace setVariable ["ivcs_ptt_down", false];
					[] call ivcs_fnc_ptt_up;
				};
			},
			0.1,
			[]
		] call CBA_fnc_addPerFrameHandler;

		uiNamespace setVariable ["ivcs_ptt_check_id", _frame_id];
	};
};
