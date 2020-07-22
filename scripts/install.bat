@echo off

call variables.cmd

rem Backup current install
call cleanup.bat
XCOPY "%gamePath%\mods\%modName%\content\scripts" "%modPath%\backup\" /e /s /y
copy "%gamePath%\bin\config\r4game\user_config_matrix\pc\randomEncounters.xml" "%modPath%\backup\modRandomEncounters.xml" /y

rem install scripts
rmdir "%gamePath%\mods\%modName%\content\scripts" /s /q
XCOPY "%modPath%\src" "%gamePath%\mods\%modName%\content\scripts\" /e /s /y
copy "%modPath%\randomEncounters.xml" "%gamePath%\bin\config\r4game\user_config_matrix\pc\randomEncounters.xml" /y
