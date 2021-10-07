if !(missionNamespace getVariable ["ivcs_mission_loaded", false]) then
{
	// Pause menu options
	[[localize "STR_IVCS_PAUSE_MENU_TEST_BUTTON_NAME", localize "STR_IVCS_PAUSE_MENU_TEST_BUTTON_TOOLTIP"], "ivcs_test_display"] call CBA_fnc_addPauseMenuOption;
	[[localize "STR_IVCS_PAUSE_MENU_TRAINING_BUTTON_NAME", localize "STR_IVCS_PAUSE_MENU_TRAINING_BUTTON_TOOLTIP"], "ivcs_training_display"] call CBA_fnc_addPauseMenuOption;
	[[localize "STR_IVCS_PAUSE_MENU_SPEECH_BUTTON_NAME", localize "STR_IVCS_PAUSE_MENU_SPEECH_BUTTON_TOOLTIP"], "ivcs_speech_display"] call CBA_fnc_addPauseMenuOption;
	[[localize "STR_IVCS_PAUSE_MENU_SOUND_BUTTON_NAME", localize "STR_IVCS_PAUSE_MENU_SOUND_BUTTON_TOOLTIP"], "ivcs_sound_display"] call CBA_fnc_addPauseMenuOption;
	missionNamespace setVariable ["ivcs_mission_loaded", true];
};

// Confidence value for user input
[
	"ivcs_confidence",
	"SLIDER",
	["STR_IVCS_SETTINGS_CONFIDENCE_NAME", "STR_IVCS_SETTINGS_CONFIDENCE_TOOLTIP"],
	["STR_IVCS_MOD_NAME", "STR_IVCS_SETTINGS_SUBCATEGORY_RESULT_NAME"],
	[0, 100, 80, 0],
	2,
	{
		_this params ["_value"];
		"ivcs" callExtension ["set_confidence", [(_value/100) toFixed 2]];
	}
] call CBA_fnc_addSetting;

// Inital silence timeout
[
	"ivcs_inital_silence_timeout",
	"SLIDER",
	["STR_IVCS_SETTINGS_INITAL_SILENCE_TIMEOUT_NAME", "STR_IVCS_SETTINGS_INITAL_SILENCE_TIMEOUT_TOOLTIP"],
	["STR_IVCS_MOD_NAME", "STR_IVCS_SETTINGS_SUBCATEGORY_INPUT_NAME"],
	[0, 10, 5, 2],
	2,
	{
		_this params ["_value"];
		"ivcs" callExtension ["set_inital_silence", [_value toFixed 2]];
	}
] call CBA_fnc_addSetting;
// End silence finished timeout
[
	"ivcs_end_silence_finished_timeout",
	"SLIDER",
	["STR_IVCS_SETTINGS_END_SILENCE_FINISHED_TIMEOUT_NAME", "STR_IVCS_SETTINGS_END_SILENCE_FINISHED_TIMEOUT_TOOLTIP"],
	["STR_IVCS_MOD_NAME", "STR_IVCS_SETTINGS_SUBCATEGORY_INPUT_NAME"],
	[0, 10, 0.5, 2],
	2,
	{
		_this params ["_value"];
		"ivcs" callExtension ["set_end_silence_finished", [_value toFixed 2]];
	}
] call CBA_fnc_addSetting;
// End silence timeout
[
	"ivcs_end_silence_timeout",
	"SLIDER",
	["STR_IVCS_SETTINGS_END_SILENCE_TIMEOUT_NAME", "STR_IVCS_SETTINGS_END_SILENCE_TIMEOUT_TOOLTIP"],
	["STR_IVCS_MOD_NAME", "STR_IVCS_SETTINGS_SUBCATEGORY_INPUT_NAME"],
	[0, 10, 0.15, 2],
	2,
	{
		_this params ["_value"];
		"ivcs" callExtension ["set_end_silence", [_value toFixed 2]];
	}
] call CBA_fnc_addSetting;
// End babbel timeout
[
	"ivcs_end_babbel_timeout",
	"SLIDER",
	["STR_IVCS_SETTINGS_END_BABBEL_TIMEOUT_NAME", "STR_IVCS_SETTINGS_END_BABBEL_TIMEOUT_TOOLTIP"],
	["STR_IVCS_MOD_NAME", "STR_IVCS_SETTINGS_SUBCATEGORY_INPUT_NAME"],
	[0, 10, 0, 2],
	2,
	{
		_this params ["_value"];
		"ivcs" callExtension ["set_end_babbel", [_value toFixed 2]];
	}
] call CBA_fnc_addSetting;


// User feedback
[
	"ivcs_target_confirm_ui",
	"CHECKBOX",
	["STR_IVCS_SETTINGS_TARGET_CONFIRM_UI_NAME", "STR_IVCS_SETTINGS_TARGET_CONFIRM_UI_TOOLTIP"],
	["STR_IVCS_MOD_NAME", "STR_IVCS_SETTINGS_SUBCATEGORY_USER_FEEDBACK_NAME"],
	true,
	2,
	{
		_this params ["_value"];
		uiNamespace setVariable ["ivcs_target_confirm_ui", _value];
	}
] call CBA_fnc_addSetting;
[
	"ivcs_output_group_chat",
	"CHECKBOX",
	["STR_IVCS_SETTINGS_OUTPUT_GROUP_CHAT_NAME", "STR_IVCS_SETTINGS_OUTPUT_GROUP_CHAT_TOOLTIP"],
	["STR_IVCS_MOD_NAME", "STR_IVCS_SETTINGS_SUBCATEGORY_USER_FEEDBACK_NAME"],
	true,
	2,
	{
		_this params ["_value"];
		uiNamespace setVariable ["ivcs_output_group_chat", _value];
	}
] call CBA_fnc_addSetting;
