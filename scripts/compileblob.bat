::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Generate a precompiled.rsblob from a mod's scripts.
:: - depends on two ENV variables:
::   - REDKIT_ROOT, a path to a REDkit install
::   - WITCHER_ROOT, a path to a Witcher 3 install
:: Adjust the following path to point to the root of the mod that needs a blob:
set modpath=%cd%\..\release\mods\modRandomEncountersReworked

:: path to the `/content/scripts` of the mod
set modscripts=%modpath%\content\scripts

set redkit=%REDKIT_ROOT%\bin\x64_RedKit

:: IMPORTANT
:: use the `dev-scripts` folder from sharedutils instead of the content0 from
:: the game as we need both content0 and the sharedutils dependencies to compile
set gamescripts=%cd%\..\..\tw3-shared-utils\dev-scripts

:: where the `blob.rsblob` will be created
set output=%modpath%\content

:: wcc_lite requires the current working directory to be inside redkit
cd %redkit% 
:: removes the existing blob
del "%output%\precompiled.rsblob"

call wcc_lite.exe compilescripts "%gamescripts%" -patch="%modscripts%" -out="%output%"

:: the command outputs a blob.rsblob, rename it to the proper name
rename "%output%\blob.rsblob" precompiled.rsblob