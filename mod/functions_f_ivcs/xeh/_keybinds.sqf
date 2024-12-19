#include "\a3\ui_f\hpp\defineDIKCodes.inc"

[
	localize "STR_IVCS_MOD_NAME",
	"ivcs_ptt_key",
	[
		localize "STR_IVCS_KEYBIND_PTT_NAME",
		localize "STR_IVCS_KEYBIND_PTT_TOOLTIP"
	],
	{
		private _return = false;
		if (!is3DEN && {!isNull player}) then
		{
			_this call ivcs_fnc_ptt_down;
			_return = true;
		};
		_return
	},
	{ _this call ivcs_fnc_ptt_up; },
	[
		DIK_GRAVE,
		[
			false,
			true,
			false
		]
	]
] call CBA_fnc_addKeybind;
