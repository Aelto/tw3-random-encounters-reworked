
enum SmallCreatureComposition {
  SmallCreatureComposition_AmbushWitcher = 1
}

latent function createRandomSmallCreatureComposition(out random_encounters_class: CRandomEncounters) {
  var small_creature_composition: SmallCreatureComposition;

  small_creature_composition = SmallCreatureComposition_AmbushWitcher;

  switch (small_creature_composition) {
    case SmallCreatureComposition_AmbushWitcher:
      makeSmallCreatureAmbushWitcher(random_encounters_class);
      break;
  }
}


          //////////////////////////////////////
          // maker functions for compositions //
          //////////////////////////////////////


latent function makeSmallCreatureAmbushWitcher(out master: CRandomEncounters) {
  var creatures_templates: EnemyTemplateList;
  var number_of_creatures: int;

  var creatures_entities: array<RandomEncountersReworkedEntity>;
  var rer_entity: RandomEncountersReworkedEntity;
  var small_creature_type: SmallCreatureType;

  var i: int;
  var initial_position: Vector;

  LogChannel('modRandomEncounters', "making small creatures composition ambush witcher");

  small_creature_type = master.rExtra.getRandomSmallCreatureByCurrentArea(
    master.settings,
    master.spawn_roller
  );

  // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/5:
  // added the NONE check because the SpawnRoller can return
  // the NONE value if the user set all values to 0.
  if (small_creature_type == SmallCreatureNONE) {
    LogChannel('modRandomEncounters', "small_creature_type is NONE, cancelling spawn");

    return;
  }

  if (!getRandomPositionBehindCamera(initial_position)) {
    LogChannel('modRandomEncounters', "could not find proper spawning position");

    return;
  }

  creatures_templates = master
    .resources
    .getCreatureResourceBySmallCreatureType(small_creature_type,master.rExtra);

  number_of_creatures = rollDifficultyFactor(
    creatures_templates.difficulty_factor,
    master.settings.selectedDifficulty
  );

  LogChannel('modRandomEncounters', "preparing to spawn " + number_of_creatures + " creatures, difficulty: " + master.settings.selectedDifficulty);

  creatures_templates = fillEnemyTemplateList(creatures_templates, number_of_creatures);
  creatures_entities = spawnTemplateList(creatures_templates.templates, initial_position, 0.01);

  for (i = 0; i < creatures_entities.Size(); i += 1) {
    rer_entity = creatures_entities[i];
    rer_entity.this_newnpc.SetLevel(GetWitcherPlayer().GetLevel());
    rer_entity.startWithoutBait();
  }
}
