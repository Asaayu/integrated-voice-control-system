#include "\z\ivcs\addons\main_f_ivcs\common.hpp"
#include "cfgpatches.hpp"

class Extended_PreInit_EventHandlers
{
	class ivcs_preinit
	{
		clientInit = "call compile preprocessFileLineNumbers '\z\ivcs\addons\functions_f_ivcs\xeh\cba_clientPreInit.sqf'";
		serverInit = "call compile preprocessFileLineNumbers '\z\ivcs\addons\functions_f_ivcs\xeh\cba_serverPreInit.sqf'";
	};
};

class Extended_PostInit_EventHandlers
{
	class ivcs_postinit
	{
		clientInit = "call compile preprocessFileLineNumbers '\z\ivcs\addons\functions_f_ivcs\xeh\cba_clientPostInit.sqf'";
		serverInit = "call compile preprocessFileLineNumbers '\z\ivcs\addons\functions_f_ivcs\xeh\cba_serverPostInit.sqf'";
	};
};


class CfgFunctions
{
	class functions_f_ivcs
	{
		tag = "IVCS";
		class ivcs_common
		{
			file = "\z\ivcs\addons\functions_f_ivcs\functions\common";
			class openExternalProgram {};
		};
		class ivcs_ptt
		{
			file = "\z\ivcs\addons\functions_f_ivcs\functions\ptt";
			class onPttDown {};
			class onPttUp {};
		};
		class ivcs_callback
		{
			file = "\z\ivcs\addons\functions_f_ivcs\functions\callback";
			class addExtensionCallbackHandler {};
			class handleSpeechRecognitionResult {};
			class handleUiCallback {};
		};
		class ivcs_convert
		{
			file = "\z\ivcs\addons\functions_f_ivcs\functions\convert";
			class convertUnits {};
			class convertGroups {};
			class convertDirection {};
			class convertObjects {};
			class convertRole {};
			class convertFormation {};
		};
		// class ivcs_ai
		// {
		// 	file = "\z\ivcs\addons\functions_f_ivcs\functions\ai";
		// 	class cover {};
		// };
		// class ivcs_player
		// {
		// 	file = "\z\ivcs\addons\functions_f_ivcs\functions\player";
		// 	class speak {};
		// };
	};
};
