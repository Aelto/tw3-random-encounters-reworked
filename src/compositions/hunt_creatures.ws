latent function makeCreatureHunt(random_encounters_class: CRandomEncounters) {
  var creatures_templates: EnemyTemplateList;
  var number_of_creatures: int;
  var bait: CEntity;

  var creatures_entities: array<CEntity>;
  var createEntityHelper: CCreateEntityHelper;

  var current_entity_template: SEnemyTemplate;
  var current_template: CEntityTemplate;

  var dummy: RandomEncountersHuntEntity;

  var i: int;
  var j: int;
  var initial_position: Vector;

  LogChannel('modRandomEncounters', "making create hunt");

  creatures_templates = random_encounters_class.resources.getCreatureResourceByLargeCreatureType(
    random_encounters_class.rExtra.getRandomLargeCreatureByCurrentArea(
      random_encounters_class.settings,
      random_encounters_class.spawn_roller
    )
  );

  if (!getRandomPositionBehindCamera(initial_position, 60)) {
    LogChannel('modRandomEncounters', "could not find proper spawning position");

    return;
  }

  number_of_creatures = 1;


  LogChannel('modRandomEncounters', "preparing to spawn " + number_of_creatures + " creatures");

  creatures_templates = fillEnemyTemplateList(creatures_templates, number_of_creatures);
  creatures_entities = spawnTemplateList(creatures_templates.templates, initial_position, 0.01);





  current_template = (CEntityTemplate)LoadResourceAsync("dlc\modtemplates\randomencounterreworkeddlc\data\rer_hunt_entity.w2ent", true);
  // dummy = (RandomEncountersHuntEntity)spawnEntities(current_template, initial_position);
  dummy = (RandomEncountersHuntEntity)theGame.CreateEntity(
    current_template,
    initial_position,
    thePlayer.GetWorldRotation()
  );

  LogChannel('modRandomEncounters', "dummy spawned");




  createEntityHelper = new CCreateEntityHelper;
  createEntityHelper.Reset();
  theGame.CreateEntityAsync(createEntityHelper, (CEntityTemplate)LoadResourceAsync("characters\npc_entities\animals\hare.w2ent", true), initial_position, thePlayer.GetWorldRotation(), true, false, false, PM_DontPersist);

  while(createEntityHelper.IsCreating()) {            
    SleepOneFrame();
  }

  bait = createEntityHelper.GetCreatedEntity();


 
  LogChannel('modRandomEncounters', "bait entity spawned");

  for (i = 0; i < creatures_entities.Size(); i += 1) {
    LogChannel('modRandomEncounters', "adding bait to: " + i);
    
    dummy.setBaitEntity(bait, (CActor)creatures_entities[i], (CNewNPC)creatures_entities[i], creatures_entities[i]);
    LogChannel('modRandomEncounters', "bait added to: " + i);
  }
}