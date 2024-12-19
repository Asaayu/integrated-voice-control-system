// Show the display
if (isNull (uiNamespace getVariable ['ivcs_ptt_display',displayNull])) then
{
	"ivcs_ptt" cutRsc ["ivcs_ptt_display", "PLAIN", 0, true];
};

// Send the PTT down command to the extension
"ivcs" callExtension "ptt_down";

uiNamespace setVariable ["ivcs_ptt_down", true];
