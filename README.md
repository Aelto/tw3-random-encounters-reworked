# W3_RandomEncounters_Tweaks
[Witcher 3 Random Encounters mod](https://www.nexusmods.com/witcher3/mods/785?tab=description) Reworked. The original mod was not updated since a few years. Bugs fixed and performance improvements. Some new features coming soon

- Read [Installing](#installing) to see how to install the mod
- Watch the [videos](#videos) to see it in action

# What is it
It is not simply the old mod with a few bug fixes. I rewrote everything to serve as a base for my needs and the features i'll implement later-on. The only thing i kept from the original mod are the paths to the creatures templates.

> Credits to [erxv](https://www.nexusmods.com/witcher3/users/3812549) on nexusmods and its mod [Random Encounters](https://www.nexusmods.com/witcher3/mods/785). If you like my version, you should also show appreciation for his work. It saved me lots of time and i learned alot from his code.

This mod will add random encounters to your adventure in The Witcher 3. It can be humans attacking you or a monster wandering around while you're tracking him.

# Features & Changes
> I rewrote most of the logic for the mod before adding my features into it. The only thing i kept were the paths to the creatures templates. By doing so i managed to get everything working perfectly with (almost) no bugs. _Note that I am currently playing the game with my version of the mod_

- Simplified the mod menu, no more ground-encounter/group-encounter/human-encounter/flying-encounter. There is a single list of all the creatures available with spawning chances going from `0` to `100`. Of course if you set `100` to every creature they'll all have the same spawning rate in the end. So if you set Human to `100` and wolves to `20`, the humans have 5x more chances to appear.

- Every creature can (should) spawn, even basilisks, gryphons etc... They were not even implemented in the original version but still in the mod menu

- No more drop in framerate when a creature appears  (_at least on my computer 😊, even with 10 harpies everyting is running smoothly_). Everything is done asynchronously so we keep our sweet 60 frames per second and no longer know when we are ambushed. It was the main reason i wrote this because every time i had a freeze i _knew_ i would get attacked, defeating the whole purpose of the mod. 

- Each creature type has his [own spawn count based on difficulty](/src/templates.ws) to keep things balanced

- Each creature spawn has a chance of being a large creature encounter, a boss fight. The value can be changed in the mod menu.

## Videos

- [The Witcher 3 | Mod RandomEncounters reworked](https://www.youtube.com/watch?v=LR50xPzPtEs) showing large creatures spawning every 15 seconds.
- [The Witcher 3 | Mod RandomEncounters reworked](https://www.youtube.com/watch?v=w5X2bH3uIOw) showing large creatures hunts starting every 15 seconds.

## Features coming soon

- A group composition (i could not find a better name for it) is when an encounter is composed of different types of creatures. Like a giant fighting bandits, or a hunter attacked by wolves or even ghouls and drowners against you. 
  > note that i have a working proof of concept for this, but prefered waiting for it to be 100% ready

- A random event is when something you do triggers a creature spawn. You just killed a few bandits, well bad luck for you there are ghouls coming toward you now. Or you entered a forest and are fighting wolves, the noise attracted a hungry bear.

- (_more of a concept at the moment_) Improved AI, such as humans leaving a fight to go find other friends. This would work like the strongholds in blood and wine.

- Improved timer. I do not like how the spawning timer is a simple random value between to numbers at the moment. I plan to change how it work so the mod will react to events such as entering/leaving an area or fighting a type of creature.

## Missing features not implemented yet

- Removed the trophy system
- I can't understand how the localization works, you will find missing strings in the mod menu.

# Installing

1. The mod has two dependencies that you should install first :
    1. [modBootstrap](https://www.nexusmods.com/witcher3/mods/2109/?)
    2. [modSharedImports](https://www.nexusmods.com/witcher3/mods/2110/?)

2. Then take the [`/release`](/release) directory and drop its content (not the directory itself) in your `The Witcher 3` directory
3. Add the following line of code into `The Witcher 3\Mods\modBootstrap-registry\content\scripts\local\mods_registry.ws`
    ```rs
    add(modCreate_RandomEncountersReworked());
    ```
    so the file looks like this :
    ```rs
    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    class CModRegistry extends CModFactory {
        protected function createMods() {
            // add mod creation calls here, like this:
            //
            // add(modCreate_<ModName>());
            // ...

            // see example dir
            //add(modCreate_ExampleMod());
            //add(modCreate_ExampleEntityMod());
            //add(modCreate_UiExampleMod());

            add(modCreate_RandomEncountersReworked()); // <-- you added this line
        }
    }
    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    ```
4. Start the game, let it compile the new scripts and open the new mod menu to configure the mod as you want.
5. Done.

# Source code
The source code can be found on my github repository : [W3_RandomEncounters_Tweaks](https://github.com/Aelto/W3_RandomEncounters_Tweaks)

# Credits

- original idea by [erxv](https://www.nexusmods.com/witcher3/users/3812549) on nexusmods.
- original code by [erxv](https://www.nexusmods.com/witcher3/users/3812549) on nexusmods. It would have been hard without it.