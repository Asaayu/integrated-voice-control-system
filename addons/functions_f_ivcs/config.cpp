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
		class ivcs_ai
		{
			file = "\z\ivcs\addons\functions_f_ivcs\functions\ai";
			class assignTeamColor {};
			class getIn {};
			class gunLights {};
			class gunPointers {};
			class healSelf {};
			class moveToCover {};
			class moveToGarrison {};
			class moveToObject {};
			class regroup {};
			class scanHorizon {};
			class setCombatMode {};
			class sitrep {};
			class suppressiveFire {};
			class targetObject {};
		};
		class ivcs_callback
		{
			file = "\z\ivcs\addons\functions_f_ivcs\functions\callback";
			class addExtensionCallbackHandler {};
			class handleSpeechRecognitionResult {};
			class handleUiCallback {};
		};
		class ivcs_common
		{
			file = "\z\ivcs\addons\functions_f_ivcs\functions\common";
			class confirmationSpeak {};
			class coverPositions {};
			class garrisonPositions {};
			class getCursorWorldPosition {};
			class hasMedicalItem {};
			class openExternalProgram {};
			class player {};
			class speak {};
		};
		class ivcs_convert
		{
			file = "\z\ivcs\addons\functions_f_ivcs\functions\convert";
			class convertDirection {};
			class convertFormation {};
			class convertGroups {};
			class convertObjects {};
			class convertRole {};
			class convertUnits {};
		};
		class ivcs_ptt
		{
			file = "\z\ivcs\addons\functions_f_ivcs\functions\ptt";
			class onPttDown {};
			class onPttUp {};
		};
	};
};
