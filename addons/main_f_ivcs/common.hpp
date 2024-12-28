// Base
#define QUOTE(TEXT) #TEXT

// CgPatches
#define AUTHORS authors[]= {"Asaayu"}; author = "Asaayu"
#define URL url = "https://steamcommunity.com/id/asaayu/myworkshopfiles/?appid=107410"
#define NAME(SUBTITLE) name = QUOTE(Integrated Voice Control System - #SUBTITLE)
#define VERSION requiredVersion = 0.1

// UI defines
#define SW safezoneW
#define SH safezoneH
#define SX safezoneX
#define SY safezoneY

#define W(VALUE) QUOTE(VALUE * SW)
#define H(VALUE) QUOTE(VALUE * SH)
#define X(VALUE) QUOTE(SX + VALUE * SW)
#define Y(VALUE) QUOTE(SY + VALUE * SH)
