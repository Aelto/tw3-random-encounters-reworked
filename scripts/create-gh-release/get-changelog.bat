:: get the list of all commits since the last release
@echo off

:: get the last release name
for /f %%i in ('git describe --tags --abbrev^=0') do set lastrelease=%%i

:: get the commits
git log %lastrelease%..HEAD --oneline
