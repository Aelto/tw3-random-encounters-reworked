
latent function createRandomLargeCreatureHunt(master: CRandomEncounters) {
  var large_creature_type: LargeCreatureType;

  LogChannel('modRandomEncounters', "making create hunt");

  large_creature_type = master.rExtra.getRandomLargeCreatureByCurrentArea(
    master.settings,
    master.spawn_roller
  );

  // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/5:
  // added the NONE check because the SpawnRoller can return
  // the NONE value if the user set all values to 0.
  if (large_creature_type == LargeCreatureNONE) {
    LogChannel('modRandomEncounters', "large_creature_type is NONE, cancelling spawn");

    return;
  }

  if (large_creature_type == LargeCreatureGRYPHON) {
    makeGryphonLargeCreatureHunt(master);
  }
  else {
    makeDefaultLargeCreatureHunt(master, large_creature_type);
  }
}

latent function makeGryphonLargeCreatureHunt(master: CRandomEncounters) {
  var creatures_templates: EnemyTemplateList;
  var rer_gryphon_entity: RandomEncountersReworkedGryphonHuntEntity;
  var gryphon_entity: CEntity;

  var i: int;
  var j: int;
  var current_entity_template: SEnemyTemplate;
  var rer_entity_template: CEntityTemplate;
  var chosen_template: CEntityTemplate;
  var create_entity_helper: CCreateEntityHelper;
  var initial_position: Vector;
  var player_position: Vector;
  var blood_splats_templates: array<CEntityTemplate>;

  LogChannel('modRandomEncounters', "makeGryphonLargeCreatureHunt - starting");

  creatures_templates = master
    .resources
    .getCreatureResourceByLargeCreatureType(LargeCreatureGRYPHON);

  creatures_templates = fillEnemyTemplateList(creatures_templates, 1);

  if (!getRandomPositionBehindCamera(initial_position, 200, 120, 10)) {
    LogChannel('modRandomEncounters', "could not find proper spawning position");

    return;
  }

  rer_entity_template = (CEntityTemplate)LoadResourceAsync("dlc\modtemplates\randomencounterreworkeddlc\data\rer_flying_hunt_entity.w2ent", true);

  for (i = 0; i < creatures_templates.templates.Size(); i += 1) {
    current_entity_template = creatures_templates.templates[i];

    if (current_entity_template.count == 0) {
      continue;
    }

    LogChannel('modRandomEncounters', "chosen template: " + current_entity_template.template);

    chosen_template = (CEntityTemplate)LoadResourceAsync(current_entity_template.template, true);

    break;
  }

  blood_splats_templates = master.resources.getBloodSplatsResources();

  create_entity_helper = new CCreateEntityHelper;
  create_entity_helper.Reset();
  theGame.CreateEntityAsync(create_entity_helper, chosen_template, initial_position, thePlayer.GetWorldRotation(), true, false, false, PM_DontPersist);

  LogChannel('modRandomEncounters', "spawning entity at " + initial_position.X + " " + initial_position.Y + " " + initial_position.Z);

  player_position = thePlayer.GetWorldPosition();
  LogChannel('modRandomEncounters', "player at " + player_position.X + " " + player_position.Y + " " + player_position.Z);

  while(create_entity_helper.IsCreating()) {            
    SleepOneFrame();
  }

  gryphon_entity = create_entity_helper.GetCreatedEntity();

  rer_gryphon_entity = (RandomEncountersReworkedGryphonHuntEntity)theGame.CreateEntity(
    rer_entity_template,
    initial_position,
    thePlayer.GetWorldRotation()
  );

  rer_gryphon_entity.attach(
    (CActor)gryphon_entity,
    (CNewNPC)gryphon_entity,
    gryphon_entity
  );

  rer_gryphon_entity.startEncounter(blood_splats_templates);
  
}

latent function makeDefaultLargeCreatureHunt(master: CRandomEncounters, large_creature_type: LargeCreatureType) {
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

  if (!getRandomPositionBehindCamera(initial_position, 60, 40)) {
    LogChannel('modRandomEncounters', "could not find proper spawning position");

    return;
  }

  creatures_templates = master
    .resources
    .getCreatureResourceByLargeCreatureType(large_creature_type);

  number_of_creatures = rollDifficultyFactor(
    creatures_templates.difficulty_factor,
    master.settings.selectedDifficulty
  );

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
