call variables.cmd
call bundle.bat

rmdir "%modpath%\release" /s /q
mkdir "%modpath%\release"

XCOPY "%modpath%\src\" "%modpath%\release\mods\%modname%\content\scripts\rer_local\" /e /s /y
XCOPY "%modpath%\strings\" "%modpath%\release\mods\%modname%\content\" /e /s /y
XCOPY "%modpath%\%modname%\packed\" "%modpath%\release\dlc\dlc%modname%\" /e /s /y

mkdir "%modpath%\release\bin\config\r4game\user_config_matrix\pc\"
copy "%modPath%\mod-menu.xml" "%modpath%\release\bin\config\r4game\user_config_matrix\pc\%modname%.xml" /y
