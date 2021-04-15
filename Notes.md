
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



## personal notes

- The bounty master will have a new tab for contracts, contracts accepted from this tab will give you a notice with all the information you need to start the hunt.

- A statemachine class should be created `abstract class QuestMakingUtility` which will give useful methods like:
  - keep monsters on point
  - wait for player to reach point
  - will come with a trail_maker ready
  - it will also offer a way to register states with a quest progress. So we don't have to do `GotoState('theNextState')` but instead `parent.quest_progress.goForward()`. And it will know which state to go into based on the current and previous progress.
  - branches could probably be implemented by giving an optional paremeter to `goForward(branch_index)`

- With it will come another class `abstract class QuestProgressUtility` which will be used to store the progress of the player in a quest.
  - it will come with method to progress forward **and** backward (useful for testing)
  - this class will be instanciated in the `QuestMakingUtility` class as a property.

- the main RER class will be updated so we can register `QuestMakingUtility` classes. The mod will then take care of showing the new quest in the bounty master tab 


  
```
	private final function BuildCombo()
	{
		// 1. Create definition
		comboDefinition = new CComboDefinition in this;
		
		// 2. Fill aspects
		OnCreateAttackAspects();
		
		// 3. Create player
		comboPlayer = new CComboPlayer in this;
		if ( !comboPlayer.Build( comboDefinition, parent ) )
		{
			LogChannel( 'ComboNode', "Error: BuildCombo" );	
		}
		
		// Set default blend duration between combo's animations
		comboPlayer.SetDurationBlend( 0.2f );
		
		// Clean up combo data
		CleanUpComboStuff();
	}

```