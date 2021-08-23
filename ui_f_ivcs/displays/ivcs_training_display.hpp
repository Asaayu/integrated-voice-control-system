class ivcs_training_display
{
	idd = 65001;
	enableSimulation = 0;

	// Start/Stop the testing engine
	onLoad = "uiNamespace setVariable ['ivcs_test_display',(_this#0)]; 'ivcs' callExtension 'open_training'; _this spawn {(_this#0) closeDisplay 0;}";
	onUnload = "";

	class controlsbackground {};
	class controls {};
};
