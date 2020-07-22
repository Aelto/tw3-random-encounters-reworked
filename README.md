# W3_RandomEncounters_Tweaks
[Witcher 3 Random Encounters mod](https://www.nexusmods.com/witcher3/mods/785?tab=description) tweaks


# Installing
Install the original mod as you would do normally, then :
  - Use the [install.bat](/scripts/install.bat) script in the `/scripts` folder of this repository:
    1. For it to work update the [variable.cmd](/scripts/variable.cmd) file with your witcher instal directory
    2. Place yourself into [/scripts](/scripts) (_ignore the dollar sign, it is there to represent a command-line prompt_)
       ```bash
       $ cd scripts
       ```
    3. run the [install.bat](/scripts/install.bat) file (_ignore the dollar sign, it is there to represent a command-line prompt_)
       ```bash
       $ install
       ```
  - Or do it manually:
    1. delete everything that is in `The Witcher 3/mods/modRandomEncounters/content/scripts/`
    2. copying the content of [/src/](/src) into `The Witcher 3/mods/modRandomEncounters/content/scripts/`
    3. copying [randomEncounters.xml](/randomEncounters.xml) in `The Witcher 3/bin/config/r4game/user_config_matrix/pc` to replace the original xml file.


# Credits

- scripts are based on this [repository](https://github.com/CikitosWitcher3Mods/Fatigue)