
enum CreatureComposition {
  CreatureComposition_AmbushWitcher = 1
}

latent function createRandomCreatureComposition(out random_encounters_class: CRandomEncounters, optional creature_type: CreatureType) {
  var creature_composition: CreatureComposition;

  creature_composition = CreatureComposition_AmbushWitcher;

  if (!creature_type) {
    creature_type = master.rExtra.getRandomCreatureByCurrentArea(
      master.settings,
      master.spawn_roller
    );
  }

  // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/5:
  // added the NONE check because the SpawnRoller can return
  // the NONE value if the user set all values to 0.
  if (creature_type == CreatureNONE) {
    LogChannel('modRandomEncounters', "creature_type is NONE, cancelling spawn");

    return;
  }

  if (creature_type == CreatureWILDHUNT) {
    makeCreatureWildHunt(random_encounters_class);
  }
  else {
    switch (creature_composition) {
      case CreatureComposition_AmbushWitcher:
        makeCreatureAmbushWitcher(creature_type, random_encounters_class);
        break;
    }
  }
}


          //////////////////////////////////////
          // maker functions for compositions //
          //////////////////////////////////////

// TODO: the wild hunt should change the weather when they spawn.
// I can't add it now because there is no way for me to know if 
// all the creatures are alive or not. 
latent function makeCreatureWildHunt(out master: CRandomEncounters) {
  var creatures_templates: EnemyTemplateList;
  var number_of_creatures: int;

  var creatures_entities: array<RandomEncountersReworkedEntity>;
  var rer_entity: RandomEncountersReworkedEntity;

  var i: int;
  var initial_position: Vector;

  var portal_template: CEntityTemplate;
  var wildhunt_rift_handler: WildHuntRiftHandler;

  LogChannel('modRandomEncounters', "making small creatures composition ambush witcher");

  if (!getRandomPositionBehindCamera(initial_position)) {
    LogChannel('modRandomEncounters', "could not find proper spawning position");

    return;
  }

  creatures_templates = master
    .resources
    .getCreatureResourceByCreatureType(CreatureWILDHUNT, master.rExtra);

  number_of_creatures = rollDifficultyFactor(
    creatures_templates.difficulty_factor,
    master.settings.selectedDifficulty
  );

  LogChannel('modRandomEncounters', "preparing to spawn " + number_of_creatures + " creatures, difficulty: " + master.settings.selectedDifficulty);

  creatures_templates = fillEnemyTemplateList(creatures_templates, number_of_creatures);

  // we spawn the WildHunt with 3 units per square-meter to keep them close together because
  // they are supposed to go through portals.
  creatures_entities = spawnTemplateList(creatures_templates.templates, initial_position, 3);


  for (i = 0; i < creatures_entities.Size(); i += 1) {
    rer_entity = creatures_entities[i];

    rer_entity.this_newnpc.SetTemporaryAttitudeGroup('hostile_to_player', AGP_Default);
    rer_entity.this_newnpc.NoticeActor(thePlayer);

    rer_entity.this_newnpc.SetLevel(GetWitcherPlayer().GetLevel());
    if (!master.settings.enable_encounters_loot) {
      rer_entity.removeAllLoot();
    }
    
    rer_entity.startWithoutBait();
  }

  portal_template = master.resources.getPortalResource();
  wildhunt_rift_handler = new WildHuntRiftHandler in this;
  wildhunt_rift_handler.rifts.PushBack(
    theGame.createEntity(
      portal_template,
      initial_position,
      thePlayer.GetWorldRotation()
    )
  );

  wildhunt_rift_handler.start();

  // i add this while loop because i don't know how 
  // the GC (if there is one) works in the engine.
  // And i don't want the class to be garbage collected
  // while it's still doing its job with timers and all.
  // We're in a latent function anyways so it's no big deal,
  // it's only delaying the next encounter by a few seconds.
  while (!wildhunt_rift_handler.job_done) {
    SleepOneFrame();
  }
}

latent function makeCreatureAmbushWitcher(creature_type: CreatureType, out master: CRandomEncounters) {
  var creatures_templates: EnemyTemplateList;
  var number_of_creatures: int;

  var creatures_entities: array<RandomEncountersReworkedEntity>;
  var rer_entity: RandomEncountersReworkedEntity;

  var i: int;
  var initial_position: Vector;

  LogChannel('modRandomEncounters', "making creatures composition ambush witcher");

  if (!getRandomPositionBehindCamera(initial_position)) {
    LogChannel('modRandomEncounters', "could not find proper spawning position");

    return;
  }

  creatures_templates = master
    .resources
    .getCreatureResourceByCreatureType(creature_type, master.rExtra);

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
    if (!master.settings.enable_encounters_loot) {
      rer_entity.removeAllLoot();
    }
    
    rer_entity.startWithoutBait();
  }
}
