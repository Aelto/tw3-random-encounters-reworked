
precompiled_mod := "release/precompiled/mods/modrandom_encounters_reworked_precompiled"

[working-directory("..")]
release-precompiled:
    @ echo generating release: precompile

    @ echo - purge the precompiled release
    @ rm -rf release/precompiled
    @ mkdir -p release/precompiled

    @ echo - copy scripts to precompile release
    @ mkdir -p {{ precompiled_mod }}/content/scripts/local/random_encounters_reworked/
    @ cp -r dist/* {{ precompiled_mod }}/content/scripts/local/random_encounters_reworked/

    @ echo - copy dlc to precompile release
    @ mkdir -p release/precompiled/dlc
    @ cp -r modRandomEncountersReworked/packed release/precompiled/dlc/dlcrandom_encounters_reworked/

    @ echo - copy metadata to precompile release
    @ cp info.json {{ precompiled_mod }}/content

    @ echo - generating precompile blob
    @ just scripts/generate-blob-on-windows
    @ mv {{ precompiled_mod }}/content/scripts/blob.rsblob {{ precompiled_mod }}/content/precompiled.rsblob

    @ just scripts/release-precompiled-zip
    @ echo generating release: precompile <~ [DONE]

[working-directory("../release/precompiled")]
release-precompiled-zip:
    @ echo - zipping precompiled release
    @ zip -r modrandom_encounters_reworked_precompiled mods

[private]
[working-directory("..")]
generate-blob-on-windows:
    @ cmd.exe /c "just scripts/generate-blob"

gamescripts := "D:/dev/github/tw3-shared-utils/dev-scripts"
modtocompile := "D:/dev/github/tw3-random-encounters-reworked" / precompiled_mod
[private]
[windows]
[working-directory("D:/programs/Steam/steamapps/common/The Witcher 3 REDkit/bin/x64_RedKit")]
generate-blob:
    wcc_lite.exe compilescripts "{{ gamescripts }}" -patch="{{ modtocompile }}/content/scripts" -out "{{ modtocompile }}/content"

[windows]
set shell := ["nu", "-c"]
