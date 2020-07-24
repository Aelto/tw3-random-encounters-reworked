@echo off

call variables.cmd

cd %modkitpath%

rmdir "%modpath%\modRandomEncountersReworked\packed\content\" /s /q
mkdir "%modpath%\modRandomEncountersReworked\packed\content\"

call wcc_lite.exe pack -dir=%modpath%\modRandomEncountersReworked\files -outdir=%modpath%\modRandomEncountersReworked\packed\content\
call wcc_lite.exe metadatastore -path=%modpath%\modRandomEncountersReworked\packed\content\

cd %modpath%\scripts