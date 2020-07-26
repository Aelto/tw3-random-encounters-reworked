
latent function createRandomLargeCreatureHunt(master: CRandomEncounters) {
  var creatures_templates: EnemyTemplateList;
  var number_of_creatures: int;
  var bait: CEntity;

  var creatures_entities: array<RandomEncountersReworkedEntity>;
  var createEntityHelper: CCreateEntityHelper;

  var current_entity_template: SEnemyTemplate;
  var current_template: CEntityTemplate;

  var i: int;
  var j: int;
  var initial_position: Vector;

  LogChannel('modRandomEncounters', "making create hunt");

  creatures_templates = master.resources.getCreatureResourceByLargeCreatureType(
    master.rExtra.getRandomLargeCreatureByCurrentArea(
      master.settings,
      master.spawn_roller
    )
  );

  if (!getRandomPositionBehindCamera(initial_position, 60, 40)) {
    LogChannel('modRandomEncounters', "could not find proper spawning position");

    return;
  }

  number_of_creatures = number_of_creatures = rollDifficultyFactor(
    creatures_templates.difficulty_factor,
    master.settings.selectedDifficulty
  );;

  LogChannel('modRandomEncounters', "preparing to spawn " + number_of_creatures + " creatures");

  creatures_templates = fillEnemyTemplateList(creatures_templates, number_of_creatures);
  creatures_entities = spawnTemplateList(creatures_templates.templates, initial_position, 0.01);

  // creating the bait now
  createEntityHelper = new CCreateEntityHelper;
  createEntityHelper.Reset();
  theGame.CreateEntityAsync(
    createEntityHelper,
    (CEntityTemplate)LoadResourceAsync("characters\npc_entities\animals\hare.w2ent", true),
    initial_position,
    thePlayer.GetWorldRotation(),
    true,
    false,
    false,
    PM_DontPersist
  );

  while(createEntityHelper.IsCreating()) {            
    SleepOneFrame();
  }

  bait = createEntityHelper.GetCreatedEntity();
 
  LogChannel('modRandomEncounters', "bait entity spawned");

  for (i = 0; i < creatures_entities.Size(); i += 1) {
    LogChannel('modRandomEncounters', "adding bait to: " + i);
    creatures_entities[i].startWithBait(bait);
  }
}
