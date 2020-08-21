
state Spawning in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    parent.RemoveTimer('randomEncounterTick');

    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "Entering state SPAWNING");

    triggerCreaturesSpawn();
  }

  entry function triggerCreaturesSpawn() {
    var picked_encounter_type: EncounterType;

    LogChannel('modRandomEncounters', "creatures spawning triggered");

    picked_encounter_type = this.getRandomEncounterType();
    
    if (this.shouldAbortCreatureSpawn()) {
      parent.GotoState('SpawningCancelled');

      return;
    }

    LogChannel('modRandomEncounters', "picked encounter type: " + picked_encounter_type);

    makeGroupComposition(
      picked_encounter_type,
      is_city_spawn,
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

        || parent.rExtra.isPlayerInSettlement()
        && !parent.settings.doesAllowCitySpawns();
  }

  function getRandomEncounterType(): EncounterType {
    var max_roll: int;
    var roll: int;

    max_roll = parent.settings.all_monster_hunt_chance
             + parent.settings.all_monster_contract_chance;

    roll = RandRange(max_roll);
    if (roll < parent.settings.all_monster_hunt_chance) {
      return EncounterType_HUNT;
    }

    roll -= parent.settings.all_monster_hunt_chance;
    if (roll < parent.settings.all_monster_contract_chance) {
      return EncounterType_CONTRACT;
    }

    return EncounterType_DEFAULT;
  }
}
