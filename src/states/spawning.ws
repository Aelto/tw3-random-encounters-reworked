
state Spawning in CRandomEncounters {
  private var is_spawn_forced: bool;

  event OnEnterState(previous_state_name: name) {
    parent.RemoveTimer('randomEncounterTick');

    super.OnEnterState(previous_state_name);

    // Set is_spawn_forced if the previous state was SpawningForced
    this.is_spawn_forced = previous_state_name == 'SpawningForced';


    LogChannel('modRandomEncounters', "Entering state SPAWNING");

    triggerCreaturesSpawn();
  }

  entry function triggerCreaturesSpawn() {
    var picked_encounter_type: EncounterType;

    LogChannel('modRandomEncounters', "creatures spawning triggered");

    picked_encounter_type = this.getRandomEncounterType();
    
    if (!parent.settings.is_enabled || !this.is_spawn_forced && this.shouldAbortCreatureSpawn()) {
      parent.GotoState('SpawningCancelled');

      return;
    }

    LogChannel('modRandomEncounters', "picked encounter type: " + picked_encounter_type);

    makeGroupComposition(
      picked_encounter_type,
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
        
        || current_zone == REZ_CITY
        && !parent.settings.allow_big_city_spawns

        || isPlayerBusy()

        || parent.rExtra.isPlayerInSettlement()
        && !parent.settings.doesAllowCitySpawns();
  }

  function getRandomEncounterType(): EncounterType {
    var max_roll: int;
    var roll: int;

    max_roll = parent.settings.all_monster_hunt_chance
             + parent.settings.all_monster_contract_chance
             + parent.settings.all_monster_ambush_chance;

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
