@echo off
msbuild extension/IntegratedVoiceControlSystem.sln /p:Configuration=Release /p:Platform=x64
msbuild extension/IntegratedVoiceControlSystem.sln /p:Configuration=Release /p:Platform=x86
hemtt release
pause
