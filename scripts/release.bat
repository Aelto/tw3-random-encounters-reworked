:: update the /release directory with:
:: - the mod menu in /release/bin
:: - the mod DLC in /release/dlc
:: - the mod content in /release/mod

call variables.cmd
call bundle.bat
call encode-csv-strings.bat

rmdir "%modpath%\release" /s /q
mkdir "%modpath%\release"

REM XCOPY "%modpath%\src\" "%modpath%\release\mods\%modname%\content\scripts\rer_local\" /e /s /y

mkdir "%modpath%\release\mods\%modname%\content\scripts\local\
> "%modpath%\release\mods\%modname%\content\scripts\local\rer_scripts.min.ws" (for /r "%modpath%\src\" %%F in (*.ws) do @type "%%F")
XCOPY "%modpath%\strings\" "%modpath%\release\mods\%modname%\content\" /e /s /y
XCOPY "%modpath%\%modname%\packed\" "%modpath%\release\dlc\dlc%modname%\" /e /s /y

mkdir "%modpath%\release\bin\config\r4game\user_config_matrix\pc\"
copy "%modPath%\mod-menu.xml" "%modpath%\release\bin\config\r4game\user_config_matrix\pc\%modname%.xml" /y
copy "%modPath%\scripts\update-registry.bat" "%modpath%\release\mods\%modname%\update-registry.bat" /y
copy "%modPath%\scripts\update-mod.ps1" "%modpath%\release\mods\%modname%\update-mod.ps1" /y
copy "%modPath%\scripts\update-mod.bat" "%modpath%\release\mods\%modname%\update-mod.bat" /y
