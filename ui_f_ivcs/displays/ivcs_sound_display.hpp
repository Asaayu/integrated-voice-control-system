class ivcs_sound_display
{
	idd = 65003;
	enableSimulation = 0;

	// Start/Stop the testing engine
	onLoad = "uiNamespace setVariable ['ivcs_speech_display',(_this#0)]; 'ivcs' callExtension 'open_sound_control_panel_settings'; _this spawn {(_this#0) closeDisplay 0;}";
	onUnload = "";

	class controlsbackground {};
	class controls {};
};
