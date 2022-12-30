:: Get the list of all commits since the last release.
@echo off

:: Get the last release name.
for /f %%i in ('git describe --tags --abbrev^=0') do set lastrelease=%%i

:: Get the commits.
git log %lastrelease%..HEAD --oneline
