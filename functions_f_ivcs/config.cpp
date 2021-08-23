#include "..\_common.hpp"
#include "cfgpatches.hpp"

class Extended_PreInit_EventHandlers
{
	class ivcs_preinit
	{
		clientInit = "call compile preprocessFileLineNumbers '\ivcs\functions_f_ivcs\xeh\clientPreinit.sqf'";
		serverInit = "call compile preprocessFileLineNumbers '\ivcs\functions_f_ivcs\xeh\serverPreinit.sqf'";
	};
};
class Extended_PostInit_EventHandlers
{
	class ivcs_postinit
	{
		clientInit = "call compile preprocessFileLineNumbers '\ivcs\functions_f_ivcs\xeh\clientPostinit.sqf'";
		serverInit = "call compile preprocessFileLineNumbers '\ivcs\functions_f_ivcs\xeh\serverPostinit.sqf'";
	};
};


class cfgfunctions
{
        class functions_f_ivcs
        {
                tag = "IVCS";
                class ivcs_callback
		{
			file = "\ivcs\functions_f_ivcs\functions\callback";
			class callback {};
			class callback_input {};
		};
		class ivcs_ptt
		{
			file = "\ivcs\functions_f_ivcs\functions\ptt";
			class ptt_down {};
			class ptt_up {};
		};
		class ivcs_convert
		{
			file = "\ivcs\functions_f_ivcs\functions\convert";
			class convert_units {};
			class convert_groups {};
			class convert_direction {};
			class convert_objects {};
			class convert_role {};
			class convert_formation {};
		};
		class ivcs_ai
		{
			file = "\ivcs\functions_f_ivcs\functions\ai";
			class cover {};
		};
		class ivcs_player
		{
			file = "\ivcs\functions_f_ivcs\functions\player";
			class speak {};
		};
        };
};
