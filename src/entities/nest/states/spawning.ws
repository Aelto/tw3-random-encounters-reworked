
state Spawning in RER_MonsterNest {
	event OnEnterState(prevStateName: name) {
    NLOG("RER_MonsterNest - State SPAWNING");
    this.Spawning_main();
	}

  entry function Spawning_main() {
    if (!parent.bestiary_entry) {
      parent.bestiary_entry = parent.master.bestiary.getRandomEntryFromBestiary(
        parent.master,
        EncounterType_HUNTINGGROUND,
        false,
        CreatureARACHAS, // left offset
        CreatureDRACOLIZARD // right offset
      );
    }

    // start by spawning a few monsters around the nest
    this.spawnEntities();

    while (parent.monsters_spawned_count < parent.monsters_spawned_limit) {
      NLOG("RER_MonsterNest - spawning monster");
      
      Sleep(RandRange(8, 3));

      SUH_removeDeadEntities(parent.entities);

      // no more than two monsters if the nest was not approached yet
      if (!parent.voicesetPlayed && parent.entities.Size() > 2) {
        continue;
      }

      if (parent.entities.Size() > 5) {
        continue;
      }

      this.spawnEntities();
    }
  }

  latent function spawnEntities() {
    var entities: array<CEntity>;
    var position: Vector;
    var entity: CEntity;
    var i: int;

    if (!parent.voicesetPlayed || !getRandomPositionBehindCamera(position, 10, 5)) {
      position = parent.GetWorldPosition() + VecRingRand(0, 5);
    }

    entities = parent.bestiary_entry.spawn(
      parent.master,
      position,
      RandRange(2), // count
      , //density
      parent.entity_settings.allow_trophies,
      EncounterType_HUNTINGGROUND,
      true, // do no persist
    );

    for (i = 0; i < entities.Size(); i += 1) {
      parent.entities.PushBack(entities[i]);

      parent.monsters_spawned_count += 1;

      // after a certain amount of spawns, we remove the loot from the monsters
      // to avoid abuse.
      if (parent.monsters_spawned_count > parent.disable_monsters_loot_threshold) {
        ((CActor)entities[i])
          .GetInventory()
          .EnableLoot(false);
      }
    }
  }
}