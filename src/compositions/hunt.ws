
latent function createRandomCreatureHunt(master: CRandomEncounters, optional creature_type: CreatureType) {

  LogChannel('modRandomEncounters', "making create hunt");

  if (!creature_type || creature_type == CreatureNONE) {
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

  if (creature_type == CreatureGRYPHON) {
    makeGryphonCreatureHunt(master);
  }
  else {
    makeDefaultCreatureHunt(master, creature_type);
  }
}

latent function makeGryphonCreatureHunt(master: CRandomEncounters) {
  var creatures_templates: EnemyTemplateList;
  var rer_gryphon_entity: RandomEncountersReworkedGryphonHuntEntity;
  var gryphon_entity: CEntity;

  var i: int;
  var j: int;
  var current_entity_template: SEnemyTemplate;
  var rer_entity_template: CEntityTemplate;
  var chosen_template: CEntityTemplate;
  var initial_position: Vector;
  var player_position: Vector;
  var blood_splats_templates: array<CEntityTemplate>;

  LogChannel('modRandomEncounters', "makeGryphonCreatureHunt - starting");

  creatures_templates = master
    .resources
    .getCreatureResourceByCreatureType(CreatureGRYPHON);

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

  gryphon_entity = theGame.CreateEntity(
    chosen_template,
    initial_position,
    thePlayer.GetWorldRotation(),
    true, false, false, PM_DontPersist
  );

  LogChannel('modRandomEncounters', "spawning entity at " + initial_position.X + " " + initial_position.Y + " " + initial_position.Z);

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

  if (!master.settings.enable_encounters_loot) {
    rer_gryphon_entity.removeAllLoot();
  }

  rer_gryphon_entity.startEncounter(blood_splats_templates);
}


latent function makeDefaultCreatureHunt(master: CRandomEncounters, creature_type: CreatureType) {
  var composition: CreatureHuntComposition;

  composition = new CreatureHuntComposition in this;

  composition.init();
  composition.setCreatureType(creature_type)
    .spawn(master);
}

// CAUTION, it extends `CreatureAmbushWitcherComposition`
class CreatureHuntComposition extends CreatureAmbushWitcherComposition {
  public function init() {
    this
      .setRandomPositionMinRadius(40)
      .setRandomPositionMaxRadius(60);
  }

  protected latent function AfterSpawningEntities(): bool {
    var i: int;
    var current_rer_entity: RandomEncountersReworkedEntity;
    var bait: CEntity;

    bait = theGame.CreateEntity(
      (CEntityTemplate)LoadResourceAsync("characters\npc_entities\animals\hare.w2ent", true),
      this.initial_position,
      thePlayer.GetWorldRotation(),
      true,
      false,
      false,
      PM_DontPersist
    );

    for (i = 0; i < this.rer_entities.Size(); i += 1) {
      current_rer_entity = this.rer_entities[i];

      current_rer_entity.this_newnpc.SetLevel(GetWitcherPlayer().GetLevel());
      if (!master.settings.enable_encounters_loot) {
        current_rer_entity.removeAllLoot();
      }
      
      current_rer_entity.startWithBait(bait);
    }

    return true;
  }
}
