# expects a linux environment, if you're on windows you can use WSL to run
# the recipes.
#
# recipe book for generating w3strings out of a `.csv` file.
w3strings := "/mnt/d/programs/witcher_3_mod_tools/bin/x64/w3strings.exe"

[working-directory('../strings')]
encode_w3strings: && duplicate_english_w3strings
    @ echo - encoding w3strings
    @ rm -f *.w3strings
    @ {{ w3strings }} --encode en.w3strings.csv --id-space 5018
    @ rm -f *.ws
    @ mv en.w3strings.csv.w3strings en.w3strings

[private]
[working-directory('../strings')]
duplicate_english_w3strings:
    @ cp en.w3strings ar.w3strings
    @ cp en.w3strings br.w3strings
    @ cp en.w3strings cz.w3strings
    @ cp en.w3strings de.w3strings
    @ cp en.w3strings es.w3strings
    @ cp en.w3strings esmx.w3strings
    @ cp en.w3strings fr.w3strings
    @ cp en.w3strings hu.w3strings
    @ cp en.w3strings it.w3strings
    @ cp en.w3strings jp.w3strings
    @ cp en.w3strings kr.w3strings
    @ cp en.w3strings pl.w3strings
    @ cp en.w3strings ru.w3strings
    @ cp en.w3strings zh.w3strings
    @ cp en.w3strings cn.w3strings
