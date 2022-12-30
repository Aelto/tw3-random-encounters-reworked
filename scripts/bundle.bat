:: Bundles the files from /modRandomEncountersReworked for the DLC.

@echo off

call variables.cmd

cd %modkitpath%

rmdir "%modpath%\modRandomEncountersReworked\packed\content\" /s /q
mkdir "%modpath%\modRandomEncountersReworked\packed\content\"

call wcc_lite.exe pack -dir=%modpath%\modRandomEncountersReworked\files\mod\cooked\ -outdir=%modpath%\modRandomEncountersReworked\packed\content\
call wcc_lite.exe metadatastore -path=%modpath%\modRandomEncountersReworked\packed\content\

cd %modpath%\scripts