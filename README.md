# W3_RandomEncounters_Tweaks
[Witcher 3 Random Encounters mod](https://www.nexusmods.com/witcher3/mods/785?tab=description) tweaks

- Read [Installing](#installing) to see how to install the mod

# Features & Changes
> I rewrote most of the logic for the mod before adding my features into it. The only thing i kept were the paths to the creatures templates. By doing this i managed to get everything working perfectly with (almost) no bugs. _Note that I am currently playing the game with my version of the mod_

- Simplified the mod menu, no more ground-encounter/group-encounter/human-encounter/flying-encounter. There is a single list of all the creatures available with spawning chances going from `0` to `100`.

- Every creature can (should) spawn, even basilisks, gryphons etc... They were not even implemented in the original version but still in the mod menu

- No more drop in framerate when a creature appears  (_at least on my computer 😊, even with 10 harpies everyting is running smoothly_). Everything is done asynchronously so we keep our sweet 60 frames per second and no longer know when we are ambushed. It was the main reason i wrote this because every time i had a freeze i _knew_ i would get attacked, defeating the whole purpose of the mod. 

- Each creature type has his [own spawn count based on difficulty](/src/templates.ws) to keep things balanced

- Each creature spawn has 10% chances of being a large creature encounter, a boss fight. There is no config for it yet though, the 10% is [hardcoded](https://github.com/Aelto/W3_RandomEncounters_Tweaks/blob/master/src/states/spawning.ws#L58) at the moment

## Features coming soon

- A group composition (i could not find a better name for it) is when an encounter is composed of different types of creatures. Like a giant fighting bandits, or a hunter attacked by wolves or even ghouls and drowners against you. 
  > note that i have a working proof of concept for this, but prefered waiting for it to be 100% ready

- A random event is when something you do triggers a creature spawn. You just killed a few bandits, well bad luck for you there are ghouls coming toward you now. Or you entered a forest and are fighting wolves, the noise attracted a hungry bear.

- (_more of a concept at the moment_) Improved AI, such as humans leaving a fight to go find other friends. This would work like the strongholds in blood and wine.

- Improved timer. I do not like how the spawning timer is a simple random value between to numbers at the moment. I plan to change how it work so the mod will react to events such as entering/leaving an area or fighting a type of creature.

## Missing features not implemented yet

- Monster hunts are not there yet. The mod menu is there but does nothing. It is coming soon though!

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