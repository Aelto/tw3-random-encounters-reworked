call variables.cmd

cd %modpath%\strings
del *.w3strings
%modkitpath%\w3strings --encode en.w3strings.csv --id-space 5018

del *.ws
rename en.w3strings.csv.w3strings en.w3strings

cd %modpath%\scripts

node create-all-string-from-en.js