@echo off

call variables.cmd

rem cleanup
rmdir "%modPath%\backup\" /s /q
