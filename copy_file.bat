@echo off

:: Define the destination folder
set DEST="S:\SteamLibrary\steamapps\common\Arma 3\@ivcs"

:: Create the destination folder if it doesn't exist
if not exist %DEST% (
    mkdir %DEST%
)

:: Copy the 'grammer' folder to the destination
xcopy /E /I "grammer" %DEST%\grammer

:: Copy 'mod.cpp' to the destination
copy "mod.cpp" %DEST%\mod.cpp

:: Copy 'ivcs.bikey' to the destination
copy "ivcs.bikey" %DEST%\ivcs.bikey

:: Notify user of completion
echo Files and folders have been copied successfully.
pause