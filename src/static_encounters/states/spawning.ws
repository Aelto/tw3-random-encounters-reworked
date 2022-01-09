
state Spawning in RER_StaticEncounterManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    NLOG("RER_StaticEncounterManager - state Spawning");

    this.Spawning_main();
  }

  entry function Spawning_main() {
    this.spawnStaticEncounters(parent.master);
    parent.GotoState('Waiting');
  }

  public latent function spawnStaticEncounters(master: CRandomEncounters) {
    var player_position: Vector;
    var max_distance: float;
    var large_chance: float;
    var small_chance: float;
    var has_spawned: bool;
    var i: int;

    max_distance = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('RERencountersGeneral', 'minSpawnDistance'))
                 + StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('RERencountersGeneral', 'spawnDiameter'));

    small_chance = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('RERencountersGeneral', 'RERstaticEncounterSmallSpawnChance'));
    large_chance = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('RERencountersGeneral', 'RERstaticEncounterLargeSpawnChance'));

    player_position = thePlayer.GetWorldPosition();

    if (parent.used_version == StaticEncountersVariant_LUCOLIVIER) {
      for (i = 0; i < parent.lucolivier_encounters.Size(); i += 1) {
        has_spawned = this.trySpawnStaticEncounter(
          master,
          parent.lucolivier_encounters[i],
          player_position,
          max_distance,
          small_chance,
          large_chance
        );

        // spawn only 1 Static Encounter per trigger.
        // if (has_spawned) {
        //   break;
        // }

        SleepOneFrame();
      }
    }
    else {
      for (i = 0; i < parent.aeltoth_encounters.Size(); i += 1) {
        has_spawned = this.trySpawnStaticEncounter(
          master,
          parent.aeltoth_encounters[i],
          player_position,
          max_distance,
          small_chance,
          large_chance
        );

        // if (has_spawned) {
        //   break;
        // }

        SleepOneFrame();
      }
    }
  }

  private latent function trySpawnStaticEncounter(master: CRandomEncounters, encounter: RER_StaticEncounter, player_position: Vector, max_distance: float, small_chance: float, large_chance: float): bool {
    var composition: CreatureHuntingGroundComposition;

    if (!encounter.canSpawn(player_position, small_chance, large_chance, max_distance)) {
      return false;
    }

    composition = new CreatureHuntingGroundComposition in master;

    composition.init(master.settings);
    composition.setBestiaryEntry(encounter.bestiary_entry)
      .setSpawnPosition(encounter.getSpawningPosition())
      .spawn(master);

    return true;
  }
}
