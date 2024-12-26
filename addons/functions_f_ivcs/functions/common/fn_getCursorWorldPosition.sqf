/*
    Integrated AI Voice Control System
    File: fn_getCursorWorldPosition.sqf
    Function: IVCS_fnc_getCursorWorldPosition
    Author: Asaayu
    Date: 2024-12-25

    Description:
    Gets the world position of the cursor on the map if the map is visible, otherwise gets the position of the middle of the screen.

    Parameters:
    NONE

    Returns:
    NONE

    Notes:
    NONE
*/

if visibleMap then
{
    // Get the position of the cursor on the map
    (findDisplay 12 displayCtrl 51) posScreenToWorld getMousePosition;
}
else
{
    // Get the position of the middle of the screen (where the player is currently looking)
    screenToWorld [0.5,0.5];
};
