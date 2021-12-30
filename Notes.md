
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


# rer contracts
at start, pick a random NPC nearby and tell the player to go talk to him.

update sharedutils to cancel the vanilla interaction event, and when interacted with,
display a custom haggle/ask more info/accept/deny; list of choices.

# functions
 - `GetSubmergeDepth` to check if a movingagentcomponent is under water.
 - `ActionMoveAwayFromNode` could be used to get the path from inside a settlement to outside by using an invisible entity and telling it to move away from the player
 - `ActionMoveToDynamicNode` or `ActionMoveTo` could be used to get pathfinding on land using an invisible entity
   - ❕ maybe even `ActionMoveCustom`, look in the class `CBehTreeActorTaskRunFromDanger` on how to use it
   - `CMoveTRGScript` look for that too
 - `CBTTaskGesturesManager` for the gestures during dialogue
  - `SignalGameplayEvent('GesticulatingActor');` could be used to trigger the manager
 - `DisplayPortalConfirmationPopup` can be used to dispay Yes/No popups