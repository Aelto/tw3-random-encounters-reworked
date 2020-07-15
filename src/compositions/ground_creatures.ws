
enum GroundCreatureComposition {
  GroundCreature_AmbushWitcher = 1
}

latent function createRandomGroundCreatureComposition(random_encounters_class: CRandomEncounters) {
  var ground_creature_composition: GroundCreatureComposition;

  ground_creature_composition = GroundCreature_AmbushWitcher;

  switch (ground_creature_composition) {
    case GroundCreature_AmbushWitcher:
      makeGroundCreatureAmbushWitcher(random_encounters_class);
      break;
  }
}


          //////////////////////////////////////
          // maker functions for compositions //
          //////////////////////////////////////


latent function makeGroundCreatureAmbushWitcher(master: CRandomEncounters) {
  var creatures_templates: array<SEnemyTemplate>;
  var number_of_creatures: int;

  var creatures_entities: array<CEntity>;

  var i: int;
  var summon: CNewNPC;
  var initial_position: Vector;

  LogChannel('modRandomEncounters', "making ground creatures composition ambush witcher");

  getRandomPositionBehindCamera(initial_position);

  number_of_creatures = 1;

  LogChannel('modRandomEncounters', "preparing to spawn " + number_of_creatures + " creatures");

  creatures_templates = master.resources.copy_template_list(
    master.resources.getCreatureResourceByGroundMonsterType(
      master.rExtra.getRandomGroundCreatureByCurrentArea(master.settings)
    )
  );

  creatures_templates = fillEnemyTemplates(creatures_templates, number_of_creatures);
  creatures_entities = spawnTemplateList(creatures_templates, initial_position, 0.01);

  for (i = 0; i < creatures_entities.Size(); i += 1) {
    summon = (CNewNPC) creatures_entities[i];

    summon.SetLevel(GetWitcherPlayer().GetLevel());
    summon.NoticeActor(thePlayer);
    summon.SignalGameplayEventParamObject('ForceTarget', thePlayer);
  }
}