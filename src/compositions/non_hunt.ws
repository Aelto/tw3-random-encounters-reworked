
enum CreatureComposition {
  CreatureComposition_AmbushWitcher = 1
}

latent function createRandomCreatureComposition(out random_encounters_class: CRandomEncounters, optional creature_type: CreatureType) {
  var creature_composition: CreatureComposition;

  creature_composition = CreatureComposition_AmbushWitcher;

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
  var composition: WildHuntAmbushWitcherComposition;

  composition = new WildHuntAmbushWitcherComposition in this;

  composition.init();
  composition.setCreatureType(CreatureWILDHUNT)
    .spawn(master);
}

class WildHuntAmbushWitcherComposition extends CreatureAmbushWitcherComposition {
  var portal_template: CEntityTemplate;
  var wildhunt_rift_handler: WildHuntRiftHandler;

  protected latent function forEachEntity(entity: CEntity) {
    super.forEachEntity(entity);

    ((CNewNPC)entity)
        .SetTemporaryAttitudeGroup('hostile_to_player', AGP_Default);
      
    ((CNewNPC)entity)
      .NoticeActor(thePlayer);
  }

  protected latent function AfterSpawningEntities(): bool {
    if (!super.AfterSpawningEntities()) {
      return false;
    }

    this.portal_template = master.resources.getPortalResource();
    this.wildhunt_rift_handler = new WildHuntRiftHandler in this;
    this.wildhunt_rift_handler.rifts.PushBack(
      theGame.createEntity(
        this.portal_template,
        this.initial_position,
        thePlayer.GetWorldRotation()
      )
    );

    this.wildhunt_rift_handler.start();

    // i add this while loop because i don't know how 
    // the GC (if there is one) works in the engine.
    // And i don't want the class to be garbage collected
    // while it's still doing its job with timers and all.
    // We're in a latent function anyways so it's no big deal,
    // it's only delaying the next encounter by a few seconds.
    while (!this.wildhunt_rift_handler.job_done) {
      SleepOneFrame();
    }

    return true;
  }
}


latent function makeCreatureAmbushWitcher(creature_type: CreatureType, out master: CRandomEncounters) {
  var composition: CreatureAmbushWitcherComposition;

  composition = new CreatureAmbushWitcherComposition in this;

  composition.init();
  composition.setCreatureType(creature_type)
    .spawn(master);
}

class CreatureAmbushWitcherComposition extends CompositionSpawner {
  public function init() {
    this
      .setRandomPositionMinRadius(20)
      .setRandomPositionMaxRadius(40);
  }

  var rer_entity_template: CEntityTemplate;

  protected latent function beforeSpawningEntities(): bool {
    this.rer_entity_template =( CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_default_entity.w2ent",
      true
    );

    return true;
  }

  var rer_entities: array<RandomEncountersReworkedEntity>;

  protected function forEachEntity(entity: CEntity) {
    var current_rer_entity: RandomEncountersReworkedEntity;

    current_rer_entity = (RandomEncountersReworkedEntity)theGame.CreateEntity(
      rer_entity_template,
      initial_position,
      thePlayer.GetWorldRotation()
    );

    current_rer_entity.attach(
      (CActor)entity,
      (CNewNPC)entity,
      entity
    );

    this.rer_entities.PushBack(current_rer_entity);
  }

  protected latent function AfterSpawningEntities(): bool {
    var i: int;
    var current_rer_entity: RandomEncountersReworkedEntity;

    for (i = 0; i < this.rer_entities.Size(); i += 1) {
      current_rer_entity = this.rer_entities[i];

      current_rer_entity.this_newnpc.SetLevel(GetWitcherPlayer().GetLevel());
      if (!master.settings.enable_encounters_loot) {
        current_rer_entity.removeAllLoot();
      }
      
      current_rer_entity.startWithoutBait();
    }

    return true;
  }
}
