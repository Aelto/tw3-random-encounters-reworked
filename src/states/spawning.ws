
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

    LogChannel('modRandomEncounters', "the player is in settlement:" + this.isInSettlement());

    return is_meditating 
        || current_zone == REZ_NOSPAWN
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
        
        || !parent.settings.citySpawn
        && (
          // either from an hardcoded city in RER
          // or if the game tells us the player is
          // in a settlement.
          current_zone == REZ_CITY 
          || this.isInSettlement()
        );
  }

  function isInSettlement(): bool {
    var current_area : EAreaName;

		current_area = theGame.GetCommonMapManager().GetCurrentArea();

    // the .isInSettlement() method doesn't work when is skellige
    // it always returns true.
    if (current_area == AN_Skellige_ArdSkellig) {
      // HACK: it can be a great way to see if a settlement is nearby
      // by looking for a noticeboard. Though some settlements don't have
      // any noticeboard.
      // TODO: get the nearest signpost and read its tag then check
      // if it is a known settlement.
      return parent.rExtra.isNearNoticeboard();
    }
    
    return thePlayer.IsInSettlement();
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
