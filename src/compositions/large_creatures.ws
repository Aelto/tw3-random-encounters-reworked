
enum LargeCreatureComposition {
  LargeCreatureComposition_AmbushWitcher = 1
}

latent function createRandomLargeCreatureComposition(out random_encounters_class: CRandomEncounters) {
  var large_creature_composition: LargeCreatureComposition;

  large_creature_composition = LargeCreatureComposition_AmbushWitcher;

  switch (large_creature_composition) {
    case LargeCreatureComposition_AmbushWitcher:
      makeLargeCreatureAmbushWitcher(random_encounters_class);
      break;
  }
}


          //////////////////////////////////////
          // maker functions for compositions //
          //////////////////////////////////////


latent function makeLargeCreatureAmbushWitcher(out master: CRandomEncounters) {
  var creatures_templates: EnemyTemplateList;
  var number_of_creatures: int;

  var creatures_entities: array<CEntity>;

  var i: int;
  var summon: CNewNPC;
  var initial_position: Vector;

  LogChannel('modRandomEncounters', "making large creatures composition ambush witcher");

  creatures_templates = master.resources.getCreatureResourceByLargeCreatureType(
    master.rExtra.getRandomLargeCreatureByCurrentArea(
      master.settings,
      master.spawn_roller
    )
  );

  if (!getRandomPositionBehindCamera(initial_position)) {
    LogChannel('modRandomEncounters', "could not find proper spawning position");

    return;
  }

  number_of_creatures = rollDifficultyFactor(
    creatures_templates.difficulty_factor,
    master.settings.selectedDifficulty
  );

  LogChannel('modRandomEncounters', "preparing to spawn " + number_of_creatures + " creatures");

  creatures_templates = fillEnemyTemplateList(creatures_templates, number_of_creatures);
  creatures_entities = spawnTemplateList(creatures_templates.templates, initial_position, 0.01);

  for (i = 0; i < creatures_entities.Size(); i += 1) {
    summon = (CNewNPC) creatures_entities[i];

    summon.SetLevel(GetWitcherPlayer().GetLevel());
    summon.NoticeActor(thePlayer);
    summon.SignalGameplayEventParamObject('ForceTarget', thePlayer);
  }
}