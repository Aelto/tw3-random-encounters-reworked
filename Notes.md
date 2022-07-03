
# Notes
> Custom notes i write for myself to not forget them 😊

 - 0x00088329  Geralt: More will spawn. Need to destroy the nests.
 - 0x00105489  Geralt: Here's the nest…
 - 0x00105493  Geralt: Finally. The main nest…
 - 0x000fb2fe  Geralt: Found a good place for their nest.
 - 0x00101641  Geralt: Monster nest. Best destroyed with a Dancing Star or Grapeshot.

# monster contracts
## new phases i could add
- cart tracks, and cart riddled with arrows + ambush, see this video for the cart:
  https://youtu.be/S8cIZG8ldz8?t=131

## voicelines i could use
- bodies were found here
- Trail ends here
- Must be the place…
- Geralt: Looks like the place mentioned in the journal. Should search it.
- Geralt: I'll keep searching.
- Geralt: Lost the trail. Gotta look around for something else.
- Geralt: Damn it. Think I lost its trail.
- Geralt: Damn, trail breaks off. Could find something else, though.
- Geralt: Dammit, followed the wrong trail
- Geralt: Hmm, trail goes on. Good thing it doesn't end here.
- Geralt: Trail breaks off. Need to find another clue nearby, something else to follow.
- Geralt: Blood stains, barely visible. Someone was dragged this way. Someone who was still alive.
- Geralt: Blood… still fresh. He's close
- Geralt choice: Wonder why they split up.
- Geralt choice: Let's go back


# functions
 - `GetSubmergeDepth` to check if a movingagentcomponent is under water.
 - `ActionMoveAwayFromNode` could be used to get the path from inside a settlement to outside by using an invisible entity and telling it to move away from the player
 - `ActionMoveToDynamicNode` or `ActionMoveTo` could be used to get pathfinding on land using an invisible entity
   - ❕ maybe even `ActionMoveCustom`, look in the class `CBehTreeActorTaskRunFromDanger` on how to use it
   - `CMoveTRGScript` look for that too
 - `CBTTaskGesturesManager` for the gestures during dialogue
  - `SignalGameplayEvent('GesticulatingActor');` could be used to trigger the manager
 - `DisplayPortalConfirmationPopup` can be used to dispay Yes/No popups

# tutorial popups

## Startup (Triggered by moving close to the noticeboard in White Orchard)
Welcome to Random Encounters Reworked!
Popups similar to this one will appear whenever something important related to the mod happens in order to explain what is happening
For now Random Encounters Reworked will not be noticeably active and this is on purpose. To allow users to adapt to the mod and not be bombarded the mod will introduce parts of itself over the course of 10 hours, by then users should be well acquainted with how the mod works
If you need reminding about how a certain event or feature works you can re-enable the tutorial in the mod menu so that when you encounter that event or feature again the popup will also appear again


## Ambushes (Triggered by an ambush)
You have just been ambushed. Enemies are now moving towards you and you must fight them, you can run away but they will follow you until you defeat them. 
Once you defeat them you will be rewarded with crowns and trophies. 
If you do not like being ambushed or wish to change it to be more or less challenging you can change the settings in the Ambushes submenu in the Encounter System Menu


## Events (Triggered by an event)
An event has just occured as a result of your actions. For example the scent of blood from a recent kill has attracted necrophages or maybe the noise of a fight has attracted another creature. 
Not all events are the direct result of player action but some can be


## Bounties (Triggered by starting a bounty)
You have just started a bounty. Bounties consist of one main target and a random number of side targets, they will typically spawn at points of interest around the region. 
The main goal is always to kill the main target, the side targets can be skipped but if you go out of your way to kill them you increase your reward by 100% for every side target killed. This does also however have a side effect of increasing the difficulty of the fight against the main target.


## Bounty Master (Triggered by moving close to him)
You have found the bounty master, a character that can give you bounties. He travels all around the world so he can be found in every region. However he does also move within those regions. 
To find him look on your map


## Bounty Level (Triggered by a change in the bounty level)
Once you have finished a bounty your bounty level may increase, each region has its own bounty level. Whenever you increase your bounty level you will receive an item, this item will increase in rarity with your bounty level


## Examined Tracks (Triggered by examining some tracks)
You have just examined a track left behind by a creature. When examined Geralt will comment on what monster it is and following the trail will lead you to the creature that created them. 
Do keep in mind however that because RER uses vanilla voicelines some creatures may be incorrectly identified, however the family that creature belongs to will always be correct. 
For instance Geralt might find the tracks of a noonwraith but because there are no voicelines for it he says it’s a nightwraith. They are different creatures but are in the same family of “wraiths”


## Ecosystem (Triggered by the death of an RER creature or whatever typically triggers a change in the ecosystem)
Your recent killing of a creature has indirectly changed the surrounding ecosystem. RER stimulates a food chain which changes the creatures you encounter. Whenever you kill creatures the ecosystem changes and if you continue to kill new species can turn up and some can even migrate to other regions. 
You can examine the ecosystem using the Ecosystem Analysis keybind which can tell you useful info about the creatures and their habitats. This keybind is not set up by default so if you would like to use it refer to the in depth installation guide. 
If you do not like this feature you can change its effects or disable it outright in the Ecosystem menu


## Noticeboards (Triggered by picking up an RER custom contract notice)
You have just picked up a custom contract notice that can be distinguished by the poster of the notice always being A. Letoth. When you close this tutorial a menu will appear showing the following: 
 - The type of tokens you can acquire from this noticeboard
 - Your current reputation
 - The contracts available
Note that these factors are unique to each noticeboard in the game
You may have also noticed that the notices used to trigger all the contracts in the vanilla game are absent. This is because RER uses a special reputation system whereby Geralt must earn reputation from completing RER contracts so that the populace know there’s a witcher in the area and will put up the vanilla contracts. 
The reputation system also controls the type of RER contracts you can receive starting with easy and working up to hard contracts. 
If you do not like this system you can disable it in the Contracts System menu


# Rewards (Triggered by picking up a trophy)
You just collected a trophy. These do not serve any purpose outside of being sold for coin but who you sell them to does matter if you wish to maximise profit. 
If you do not like the rewards and wish to change them then you can do so in the Rewards System menu