/*
    Integrated AI Voice Control System
    File: _cba_client_settings.sqf
    Function: NONE
    Author: Asaayu
    Version: 2.0.0.0
    Date: 2024-12-22

    Description:
    This file contains all custom settings for the Integrated AI Voice Control System, using the CBA settings system.

    Parameters:
    NONE

    Returns:
    NONE

    Notes:
    These settings are automatically added to the CBA settings system when the mod is loaded.
*/

// Pause menu options for testing and opening external programs
if !(missionNamespace getVariable ["ivcs_mission_loaded", false]) then
{
    [[localize "STR_IVCS_PAUSE_MENU_TEST_BUTTON_NAME", localize "STR_IVCS_PAUSE_MENU_TEST_BUTTON_TOOLTIP"], "ivcs_mod_test_display"] call CBA_fnc_addPauseMenuOption;
    [[localize "STR_IVCS_PAUSE_MENU_TRAINING_BUTTON_NAME", localize "STR_IVCS_PAUSE_MENU_TRAINING_BUTTON_TOOLTIP"], "ivcs_open_speech_training_display"] call CBA_fnc_addPauseMenuOption;
    [[localize "STR_IVCS_PAUSE_MENU_SPEECH_BUTTON_NAME", localize "STR_IVCS_PAUSE_MENU_SPEECH_BUTTON_TOOLTIP"], "ivcs_open_speech_settings_display"] call CBA_fnc_addPauseMenuOption;
    [[localize "STR_IVCS_PAUSE_MENU_SOUND_BUTTON_NAME", localize "STR_IVCS_PAUSE_MENU_SOUND_BUTTON_TOOLTIP"], "ivcs_open_sound_control_panel_display"] call CBA_fnc_addPauseMenuOption;
    missionNamespace setVariable ["ivcs_mission_loaded", true];
};

// The minimum required confidence for a command to be executed
[
    "ivcs_confidence",
    "SLIDER",
    ["STR_IVCS_SETTINGS_CONFIDENCE_NAME", "STR_IVCS_SETTINGS_CONFIDENCE_TOOLTIP"],
    ["STR_IVCS_MOD_NAME", "STR_IVCS_SETTINGS_SUBCATEGORY_RESULT_NAME"],
    [0, 100, 80, 0],
    2,
    {
        _this params ["_value"];
        "ivcs" callExtension ["set_minimum_required_confidence", [(_value/100)]];
    }
] call CBA_fnc_addSetting;

// The time interval during which the speech engine accepts input containing only silence before finalizing recognition
[
    "ivcs_initial_silence_timeout",
    "SLIDER",
    ["STR_IVCS_SETTINGS_INITIAL_SILENCE_TIMEOUT_NAME", "STR_IVCS_SETTINGS_INITIAL_SILENCE_TIMEOUT_TOOLTIP"],
    ["STR_IVCS_MOD_NAME", "STR_IVCS_SETTINGS_SUBCATEGORY_INPUT_NAME"],
    [0, 10, 5, 2],
    2,
    {
        _this params ["_value"];
        "ivcs" callExtension ["set_initial_silence_timeout", [_value]];
    }
] call CBA_fnc_addSetting;

// The interval of silence that the speech engine will accept at the end of ambiguous input before finalizing a recognition operation
[
    "ivcs_end_silence_timeout",
    "SLIDER",
    ["STR_IVCS_SETTINGS_END_SILENCE_TIMEOUT_NAME", "STR_IVCS_SETTINGS_END_SILENCE_TIMEOUT_TOOLTIP"],
    ["STR_IVCS_MOD_NAME", "STR_IVCS_SETTINGS_SUBCATEGORY_INPUT_NAME"],
    [0, 10, 1.5, 2],
    2,
    {
        _this params ["_value"];
        "ivcs" callExtension ["set_end_silence_timeout_ambiguous", [_value]];
    }
] call CBA_fnc_addSetting;

// The interval of silence that the speech engine will accept at the end of unambiguous input before finalizing a recognition operation
[
    "ivcs_end_silence_finished_timeout",
    "SLIDER",
    ["STR_IVCS_SETTINGS_END_SILENCE_FINISHED_TIMEOUT_NAME", "STR_IVCS_SETTINGS_END_SILENCE_FINISHED_TIMEOUT_TOOLTIP"],
    ["STR_IVCS_MOD_NAME", "STR_IVCS_SETTINGS_SUBCATEGORY_INPUT_NAME"],
    [0, 10, 0.5, 2],
    2,
    {
        _this params ["_value"];
        "ivcs" callExtension ["set_end_silence_timeout", [_value]];
    }
] call CBA_fnc_addSetting;

// The time interval during which the speech engine accepts input containing only background noise, before finalizing recognition.
[
    "ivcs_end_babble_timeout",
    "SLIDER",
    ["STR_IVCS_SETTINGS_END_BABBLE_TIMEOUT_NAME", "STR_IVCS_SETTINGS_END_BABBLE_TIMEOUT_TOOLTIP"],
    ["STR_IVCS_MOD_NAME", "STR_IVCS_SETTINGS_SUBCATEGORY_INPUT_NAME"],
    [0, 10, 1, 2],
    2,
    {
        _this params ["_value"];
        "ivcs" callExtension ["set_end_babble_timeout", [_value]];
    }
] call CBA_fnc_addSetting;

// If a UI element should be displayed when a target is chosen for a command
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

// If the users commands should be output to the group chat as a normal command would
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

// If the game should use ducking when push to talk is active
[
    "ivcs_ducking",
    "CHECKBOX",
    ["STR_IVCS_SETTINGS_DUCKING_NAME", "STR_IVCS_SETTINGS_DUCKING_TOOLTIP"],
    ["STR_IVCS_MOD_NAME", "STR_IVCS_SETTINGS_SUBCATEGORY_SOUND_NAME"],
    true,
    2,
    {
        _this params ["_value"];
        uiNamespace setVariable ["ivcs_ducking", _value];
    }
] call CBA_fnc_addSetting;
