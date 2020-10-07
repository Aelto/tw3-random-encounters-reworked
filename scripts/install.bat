:: copies the files from the repository into the game
:: it's an easy way to install it

@echo off

call variables.cmd

rem install scripts
rmdir "%gamePath%\mods\%modName%\content\scripts" /s /q
XCOPY "%modPath%\src" "%gamePath%\mods\%modName%\content\scripts\rer_local\" /e /s /y
XCOPY "%modPath%\strings" "%gamepath%\mods\%modname%\content\" /e /s /y
copy "%modPath%\mod-menu.xml" "%gamePath%\bin\config\r4game\user_config_matrix\pc\%modname%.xml" /y

if "%1"=="-dlc" (
  echo "copying DLC"
  rmdir "%gamePath%\dlc\dlc%modName%" /s /q
  xcopy "%modPath%\release\dlc" "%gamepath%\dlc" /e /s /y
)
