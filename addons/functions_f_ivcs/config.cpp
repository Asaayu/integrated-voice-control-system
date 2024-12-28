#include "\z\ivcs\addons\main_f_ivcs\common.hpp"
#include "cfgpatches.hpp"
#include "cfgfunctions.hpp"

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
