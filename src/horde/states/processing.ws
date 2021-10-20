
state Processing in RER_HordeManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_HordeManager - Processing");

    this.Processing_main();
  }

  entry function Processing_main() {
    var creature_to_spawn: CreatureType;
    var number_of_requests: int;
    var i: int;

    while (true) {
      Sleep(5);

      number_of_requests = parent.requests.Size();

      if (number_of_requests <= 0) {
        parent.GotoState('Waiting');

        return;
      }

      // the horde monsters are spawned only if regular monsters can be spawned
      if (shouldAbortCreatureSpawn(parent.master.settings, parent.master.rExtra, parent.master.bestiary)
      || parent.master.rExtra.isPlayerInSettlement(50)) {
        continue;
      }

      for (i = 0; i < number_of_requests; i += 1) {
        creature_to_spawn = this.getFirstCreatureWithPositiveCounter(parent.requests[i]);
        
        SUH_removeDeadEntities(parent.requests[i].entities);

        if (creature_to_spawn == CreatureNONE) {
          if (SUH_areAllEntitiesDead(parent.requests[i].entities)) {
            parent.requests[i].onComplete(parent.master);
            parent.requests.Remove(parent.requests[i]);

            i -= 1;
            number_of_requests -= 1;
          }

          continue;
        }
        
        this.spawnMonsterFromRequest(parent.requests[i], creature_to_spawn);
      }
    }
  }

  latent function spawnMonsterFromRequest(request: RER_HordeRequest, creature_to_spawn: CreatureType) {
    var bestiary_entry: RER_BestiaryEntry;
    var position: Vector;
    var entities: array<CEntity>;
    var i: int;

    if (!getRandomPositionBehindCamera(position)) {
      return;
    }

    bestiary_entry = parent.master.bestiary.getEntry(parent.master, creature_to_spawn);

    entities = bestiary_entry
      .spawn(
        parent.master,
        position,
        1,,
        EncounterType_CONTRACT,
        RER_flag(RER_BESF_NO_TROPHY, !parent.master.settings.trophies_enabled_by_encounter[EncounterType_CONTRACT])
        | RER_BESF_NO_PERSIST
      );

    for (i = 0; i < entities.Size(); i += 1) {
      request.entities.PushBack(entities[i]);
      request.counters_per_creature_types[creature_to_spawn] -= 1;
    }
  }

  function getFirstCreatureWithPositiveCounter(request: RER_HordeRequest): CreatureType {
    var i: int;

    for (i = 0; i < CreatureMAX; i += 1) {
      if (request.counters_per_creature_types[i] > 0) {
        return i;
      }
    }

    return CreatureNONE;
  }
}