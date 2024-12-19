class ivcs_speech_display
{
	idd = 65002;
	enableSimulation = 0;

	// Start/Stop the testing engine
	onLoad = "uiNamespace setVariable ['ivcs_speech_display',(_this#0)]; 'ivcs' callExtension 'open_speech_settings'; _this spawn {(_this#0) closeDisplay 0;}";
	onUnload = "";

	class controlsbackground {};
	class controls {};
};
