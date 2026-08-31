import 'release.precompiled.justfile'
import 'strings.justfile'

release: compile-cahirc
  @ just release-modular
  @ just release-precompiled

[private]
[working-directory: ".."]
compile-cahirc:
  cahirc .

[private]
[working-directory: ".."]
release-modular:
  @ echo generating release: modular

  @ echo - purge the modular release
  @ rm -rf release/modular
  @ mkdir -p release/modular

  @ echo - copy scripts to modular release
  @ mkdir -p release/modular/mods/modrandom_encounters_reworked/content/scripts/local/random_encounters_reworked
  @ cp -r dist/* release/modular/mods/modrandom_encounters_reworked/content/scripts/local/random_encounters_reworked

  @ echo - copy mod menu to modular release
  @ mkdir -p release/modular/bin/config/r4game/user_config_matrix/pc
  @ cp mod-menu.xml release/modular/bin/config/r4game/user_config_matrix/pc/random-encounter-reworked.xml

  @ echo - copy dlc to modular release
  @ mkdir -p release/modular/dlc
  @ cp -r modRandomEncountersReworked/packed release/modular/dlc/dlcrandom_encounters_reworked/

  @ echo - generating strings for modular release
  @ just scripts/encode_w3strings
  @ cp strings/*.w3strings release/modular/mods/modrandom_encounters_reworked/content/
  @ cp strings/*.csv release/modular/mods/modrandom_encounters_reworked/content/

  just scripts/release-modular-zip

  @ echo generating release: modular <~ [DONE]

[working-directory: "../release/modular"]
release-modular-zip:
  @ echo - zipping modular release
  @ zip -r modrandom_encounters_reworked mods bin
