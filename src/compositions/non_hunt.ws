
enum CreatureComposition {
  CreatureComposition_AmbushWitcher = 1
}

latent function createRandomCreatureComposition(out master: CRandomEncounters, creature_type: CreatureType) {
  var creature_composition: CreatureComposition;

  creature_composition = CreatureComposition_AmbushWitcher;

  if (creature_type == CreatureNONE) {
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

  LogChannel('modRandomEncounters', "spawning ambush - " + creature_type);

  if (creature_type == CreatureWILDHUNT) {
    makeCreatureWildHunt(master);
  }
  else {
    switch (creature_composition) {
      case CreatureComposition_AmbushWitcher:
        makeCreatureAmbushWitcher(creature_type, master);
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

  composition = new WildHuntAmbushWitcherComposition in master;

  composition.init();
  composition.setCreatureType(CreatureWILDHUNT)
    .spawn(master);
}

class WildHuntAmbushWitcherComposition extends CreatureAmbushWitcherComposition {
  var portal_template: CEntityTemplate;

  protected latent function forEachEntity(entity: CEntity) {
    super.forEachEntity(entity);

    ((CNewNPC)entity)
        .SetTemporaryAttitudeGroup('hostile_to_player', AGP_Default);
      
    ((CNewNPC)entity)
      .NoticeActor(thePlayer);
  }

  protected latent function afterSpawningEntities(): bool {
    var success: bool;
    var rift: CRiftEntity;
    var rifts: array<CRiftEntity>;
    var i: int;

    LogChannel('modRandomEncounters', "after spawning entities WILDHUNT");

    success = super.afterSpawningEntities();
    if (!success) {
      return false;
    }

    this.portal_template = master.resources.getPortalResource();
    for (i = 0; i < this.group_positions.Size(); i += 1) {
      rift = (CRiftEntity)theGame.CreateEntity(
        this.portal_template,
        this.group_positions[i],
        thePlayer.GetWorldRotation()
      );
      rift.ActivateRift();

      rifts.PushBack(rift);
    }

    return true;
  }
}


latent function makeCreatureAmbushWitcher(creature_type: CreatureType, out master: CRandomEncounters) {
  var composition: CreatureAmbushWitcherComposition;

  composition = new CreatureAmbushWitcherComposition in master;

  composition.init();
  composition.setCreatureType(creature_type)
    .spawn(master);
}

class CreatureAmbushWitcherComposition extends CompositionSpawner {
  public function init() {
    LogChannel('modRandomEncounters', "CreatureAmbushWitcherComposition");

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

  protected latent function forEachEntity(entity: CEntity) {
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

  protected latent function afterSpawningEntities(): bool {
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
