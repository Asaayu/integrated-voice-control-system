// Base
#define QUOTE(text) #text

// CgPatches
#define AUTHORS authors[]= {"Asaayu"}; author = "Asaayu"
#define URL url = "https://steamcommunity.com/id/asaayu/myworkshopfiles/?appid=107410"
#define NAME(subtitle) name = QUOTE(Integrated Voice Control System - )#subtitle
#define VERSION requiredVersion = 0.1

// UI defines
#define SW safezoneW
#define SH safezoneH
#define SX safezoneX
#define SY safezoneY

#define W(value) (value * SW)
#define H(value) (value * SH)
#define X(value) (SX + value * SW)
#define Y(value) (SY + value * SH)
