
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

# v2.13 changelog, trophy prices
 - human: 5 -> 5
 - vampire: 250 -> 160
 - higher_vampire: _did not exist_ -> 200
 - necrophage: 12 -> 10
 - spirit: 45 -> 30
 - garkain: 240 -> 150
 - arachas: 40 -> 35
 - nightwraith: 80 -> 50
 - noonwraith: 80 -> 50
 - cyclop: 300 -> 75
 - czart: 150 -> 90
 - forktail: 170 -> 90
 - wyvern: 170 -> 95
 - cockatrice: 170 -> 95
 - dracolizard: 170 -> 120
 - basilisk: 170 -> 100
 - griffin: 170 -> 95
 - insectoid: 45 -> 20
 - elemental: 100 -> 100
 - fiend: 180 -> 95
 - grave_hag: 70 -> 30
 - wight: 200 -> 120
 - sharley: 300 -> 200
 - giant: 320 -> 110
 - harpy: 6 -> 6
 - ekimmara: 110 -> 120
 - katakan: 110 -> 120
 - leshen: 120 -> 105
 - nekker: 6 -> 6
 - troll: 30 -> 25
 - wraith: 30 -> 10
 - beast: 3 -> 3
 - wildhunt: 45 -> 25
 - fogling: 50 -> 25
 - werewolf: 70 -> 110
