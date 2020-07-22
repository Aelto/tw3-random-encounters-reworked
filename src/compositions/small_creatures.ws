
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

  var creatures_entities: array<CEntity>;

  var i: int;
  var summon: CNewNPC;
  var initial_position: Vector;

  LogChannel('modRandomEncounters', "making small creatures composition ambush witcher");

  creatures_templates = master.resources.getCreatureResourceBySmallCreatureType(
    master.rExtra.getRandomSmallCreatureByCurrentArea(master.settings, master.spawn_roller),
    master.rExtra
  );

  if (!getRandomPositionBehindCamera(initial_position)) {
    LogChannel('modRandomEncounters', "could not find proper spawning position");

    return;
  }

  LogChannel('modRandomEncounters', "spawning position found : " + initial_position.X + " " + initial_position.Y + " " + initial_position.Z);


  number_of_creatures = rollDifficultyFactor(
    creatures_templates.difficulty_factor,
    master.settings.selectedDifficulty
  );

  LogChannel('modRandomEncounters', "preparing to spawn " + number_of_creatures + " creatures, difficulty: " + master.settings.selectedDifficulty);

  creatures_templates = fillEnemyTemplateList(creatures_templates, number_of_creatures);
  creatures_entities = spawnTemplateList(creatures_templates.templates, initial_position, 0.01);

  for (i = 0; i < creatures_entities.Size(); i += 1) {
    summon = (CNewNPC) creatures_entities[i];

    summon.SetLevel(GetWitcherPlayer().GetLevel());
    summon.NoticeActor(thePlayer);
    // summon.SignalGameplayEventParamObject('ForceTarget', thePlayer);
    summon.SignalGameplayEventParamObject('hostile_to_player', thePlayer);
  }
}