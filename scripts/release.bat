:: update the /release directory with:
:: - the mod menu in /release/bin
:: - the mod DLC in /release/dlc
:: - the mod content in /release/mod

call variables.cmd
call bundle.bat
call encode-csv-strings.bat
call compile.bat

rmdir "%modpath%\release" /s /q
mkdir "%modpath%\release"

REM XCOPY "%modpath%\src\" "%modpath%\release\mods\%modname%\content\scripts\rer_local\" /e /s /y

mkdir "%modpath%\release\mods\%modname%\content\scripts\local\
> "%modpath%\release\mods\%modname%\content\scripts\local\rer_scripts.min.ws" (for /r "%modpath%\dist\" %%F in (*.ws) do @type "%%F")
XCOPY "%modpath%\strings\" "%modpath%\release\mods\%modname%\content\" /e /s /y
XCOPY "%modpath%\%modname%\packed\" "%modpath%\release\dlc\dlc%modname%\" /e /s /y
XCOPY "%modpath%\shared-utils\shared-utils\packed\" "%modpath%\release\dlc\dlcsharedutils\" /e /s /y

mkdir "%modpath%\release\bin\config\r4game\user_config_matrix\pc\"
copy "%modPath%\mod-menu.xml" "%modpath%\release\bin\config\r4game\user_config_matrix\pc\%modname%.xml" /y
copy "%modPath%\scripts\update-mod.ps1" "%modpath%\release\mods\%modname%\update-mod.ps1" /y
copy "%modPath%\scripts\update-mod.bat" "%modpath%\release\mods\%modname%\update-mod.bat" /y

REM Shared utilities
XCOPY "%modpath%\shared-utils\mod_sharedutils_mappins\" "%modpath%\release\mods\mod_sharedutils_mappins\" /e /s /y
XCOPY "%modpath%\shared-utils\mod_sharedutils_dialogChoices\" "%modpath%\release\mods\mod_sharedutils_dialogChoices\" /e /s /y
XCOPY "%modpath%\shared-utils\mod_sharedutils_npcInteraction\" "%modpath%\release\mods\mod_sharedutils_npcInteraction\" /e /s /y
XCOPY "%modpath%\shared-utils\mod_sharedutils_noticeboards\" "%modpath%\release\mods\mod_sharedutils_noticeboards\" /e /s /y
XCOPY "%modpath%\shared-utils\mod_sharedutils_helpers\" "%modpath%\release\mods\mod_sharedutils_helpers\" /e /s /y
XCOPY "%modpath%\shared-utils\mod_sharedutils_damagemodifiers\" "%modpath%\release\mods\mod_sharedutils_damagemodifiers\" /e /s /y
XCOPY "%modpath%\shared-utils\mod_sharedutils_glossary\" "%modpath%\release\mods\mod_sharedutils_glossary\" /e /s /y
XCOPY "%modpath%\shared-utils\mod_sharedutils_oneliners\" "%modpath%\release\mods\mod_sharedutils_oneliners\" /e /s /y
XCOPY "%modpath%\shared-utils\mod_sharedutils_menudescriptors\" "%modpath%\release\mods\mod_sharedutils_menudescriptors\" /e /s /y

:: Dependencies
XCOPY "%modpath%\dependencies\" "%modpath%\release\" /e /s /y

call compileblob.bat

if "%1"=="-github" (
  echo "creating github release"
  
  node create-gh-release %2
)