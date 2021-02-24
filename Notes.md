
# Notes
> Custom notes i write for myself to not forget them 😊

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

# bounty hunt

Bounties are started by a static NPC in every major city. When you talk to the NPC you get a haggle window where the sum you'll pick is actually a seed for the bounty that will appear. The bounty is composed of `x` creatures where `x` is a random value based on the seed. The creatures are all spawned on the map and a marker is added so the player can go hunt them. There is a limit of 10 markers on the map but a bounty can have more than 10 creatures to hunt and the bounty manager will show the new markers as the player progresses through the bounties.

The seed can range from 0 to +infinity. And for every hundreds (1000) the bounty will gain 1 difficulty point, and 0 is a way to tell the game to generate a random seed for you. So difficulty points start from 0 and increase without no limit for every 1K in the seed.

> the numbers here may change until release.
> You have to play at least 200 bounties to access to the level 100
Difficulty points have the following effects to the bounties and their creatures:
- each point increases crowns dropped by creatures from bounties by 3%
- each point increases the amount of creatures in the groups by 1% (at level 100 you have 100% more creatures)
- each point increases the amount of creatures groups by 1% (at level 100 you have two times more markers)
- each point increases the size of creatures by 0.15% (at level 100 creatures are 15% bigger)
- each point increases the level difference between you and the creatures by 1%. At level 100 and if you have a range of `-3;+3` for the creature levels the range will be converted into `-3;+6`

Bounties can be started with the NPC by simply standing next to him and waiting for the dialogue to finish. The dialogue should not take more than 30 or 60 seconds to finish and once it is finished the player has one minute to leave the area or else a new dialogue will start again and it will start another bounty. If the player leaves while the dialogue is playing, nothing will happen and the NPC will stop talking.

All RER creatures will have a chance to drop a bounty notice, a piece of paper that once given to the NPC will enhance the next bounty hunt with increased difficulty but also increased loot. The more notices the more loot and higher difficulty. Creatures from encounters other than bounties have a higher chance to drop notices than bounty creatures, but the bounty creatures still have a high enough chance to get some notices by just
playing the encounter.

For each notice consumed when the bounty starts the effect of difficulty points will be increased by 5%. So each difficulty point increases crowns by 1% without any notice and 1.10 with two notices. But it will also affect negative effects of difficulty points.

Bounty creatures are spawned **anywhere** on the map and it is up to the player to go for them or leave them and start another bounty. And because the monster types and locations are dictated by the seed, the player can train a specific seed to get an optimised path and farm the creatures. There is no time limit for the bounties, the player can even leave the game and come back later and the creatures will still be there waiting for him. 

As you complete bounty hunts, the maximum level cap increases by 50. So the first time you do a bounty you cannot pick a
seed higher than level 50

## personal notes
- Could use Graden voicelines
- `theGame.CalculateTimePlayed()` and `GameTimeHours(game_time)` could be use to randomly select the position of the bounty master based on play time.