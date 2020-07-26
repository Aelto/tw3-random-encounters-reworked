
state Spawning in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    parent.RemoveTimer('randomEncounterTick');

    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "Entering state SPAWNING");

    triggerCreaturesSpawn();
  }

  entry function triggerCreaturesSpawn() {
    var picked_entity_type: CreatureType;
    var picked_encounter_type: EncounterType;

    LogChannel('modRandomEncounters', "creatures spawning triggered");
    
    if (this.shouldAbortCreatureSpawn()) {
      parent.GotoState('SpawningCancelled');

      return;
    }

    picked_entity_type = this.getRandomEntityTypeWithSettings();
    picked_encounter_type = this.getRandomEncounterType();

    LogChannel('modRandomEncounters', "picked entity type: " + picked_entity_type + ", picked encounter type: " + picked_encounter_type);

    makeGroupComposition(
      picked_encounter_type,
      picked_entity_type,
      parent
    );

    parent.GotoState('Waiting');
  }

  function shouldAbortCreatureSpawn(): bool {
    var current_state: CName;
    var is_meditating: bool;
    var current_zone: EREZone;


    current_state = thePlayer.GetCurrentStateName();
    is_meditating = current_state == 'Meditation' && current_state == 'MeditationWaiting';
    current_zone = parent.rExtra.getCustomZone(thePlayer.GetWorldPosition());

    return is_meditating 
        || thePlayer.IsInInterior()
        || thePlayer.IsInCombat()
        || thePlayer.IsUsingBoat()
        || thePlayer.IsInFistFightMiniGame()
        || thePlayer.IsSwimming()
        || thePlayer.IsInNonGameplayCutscene()
        || thePlayer.IsInGameplayScene()
        || theGame.IsDialogOrCutscenePlaying()
        || theGame.IsCurrentlyPlayingNonGameplayScene()
        || theGame.IsFading()
        || theGame.IsBlackscreen()
        || current_zone == REZ_CITY 
        && !parent.settings.cityBruxa 
        && !parent.settings.citySpawn;
  }

  function getRandomEntityTypeWithSettings(): CreatureType {
    if (theGame.envMgr.IsNight()) {
      if (RandRange(100) < parent.settings.large_creature_chance) {
        return LARGE_CREATURE;
      }

      return SMALL_CREATURE;
    }
    else {
      if (RandRange(100) < parent.settings.large_creature_chance * 2) {
        return LARGE_CREATURE;
      }

      return SMALL_CREATURE;
    }
  }

  function getRandomEncounterType(): EncounterType {
    if (RandRange(100) < parent.settings.all_monster_hunt_chance) {
      return EncounterType_HUNT;
    }

    return EncounterType_DEFAULT;
  }
}
