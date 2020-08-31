@echo off 
setlocal enableextensions disabledelayedexpansion

set "textFile=..\modBootstrap-registry\content\scripts\local\mods_registry.ws"

:: we check if the file does not exist
if not exist %textFile% echo "Registry file not found, have you fully installed modBootstrap?" && pause && exit

set search="//add(modCreate_UiExampleMod());"
set replace="add(modCreate_RandomEncountersReworked());"
set comment="// Random Encounters Reworked - https://www.nexusmods.com/witcher3/mods/5018 "

:: first we remove the line if it's already in the file
powershell -command "(Get-Content %textFile%).replace('%replace%', '') | Set-Content %textFile%"
powershell -command "(Get-Content %textFile%).replace('%comment%', '') | Set-Content %textFile%"

:: then we insert it right after the example
powershell -command "(Get-Content %textFile%).replace('%search%', ""%search%`n`n`t`t%comment%`n`t`t%replace%"") | Set-Content %textFile%"