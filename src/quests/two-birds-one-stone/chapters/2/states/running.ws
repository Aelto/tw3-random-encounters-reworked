state Running in RER_Q1_chapter2 extends BaseChapter {
  event OnEnterState(previous_state_name: name) {
    this.Running_main();
  }


  entry function Running_main() {
    var harpy_entities: array<CEntity>;
    
    if (!this.isPlayerInRegion("skellige")) {
      return;
    }

    harpy_entities = this.spawnHarpies();

    while (this.areAllEntitiesFarFromPlayer(harpy_entities)) {
      this.keepCreaturesOnPoint(
        ((RER_quest1)parent.quest_entry).constants.chapter2_harpy_spawn_position,
        20,
        harpy_entities
      );

      SleepOneFrame();
    }

    this.resetEntitiesAttitudes(harpy_entities);
    this.makeEntitiesTargetPlayer(harpy_entities);
    this.waitUntilPlayerFinishesCombat(harpy_entities);

    Sleep(2);

    parent.quest_entry.completeCurrentChapterAndGoToNext();
  }

  latent function spawnHarpies(): array<CEntity> {
    var rer_entity: CRandomEncounters;
    var entities: array<CEntity>;

    if (!getRandomEncounters(rer_entity)) {
      NDEBUG("ERROR: could not find RER class to spawn entities");
    }

    entities = rer_entity.bestiary.entries[CreatureHARPY]
      .spawn(
        rer_entity,
        ((RER_quest1)parent.quest_entry).constants.chapter2_harpy_spawn_position,
        5, // count
        , // density
        true, // trophies
        EncounterType_HUNTINGGROUND,
        true, // do not persist
        true, // ignore bestiary feature
        'RER_quest1_chapter2_harpy'
      );

    return entities;
  }
}