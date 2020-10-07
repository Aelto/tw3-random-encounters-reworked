
enum CreatureComposition {
  CreatureComposition_AmbushWitcher = 1
}

latent function createRandomCreatureAmbush(out master: CRandomEncounters, creature_type: CreatureType) {
  var creature_composition: CreatureComposition;
  var bestiary_entry: RER_BestiaryEntry;

  creature_composition = CreatureComposition_AmbushWitcher;

  if (creature_type == CreatureNONE) {
    bestiary_entry = master
      .bestiary
      .getRandomEntryFromBestiary(master, EncounterType_DEFAULT);
  }
  else {
    bestiary_entry = master
      .bestiary
      .entries[creature_type];
  }

  // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/5:
  // added the NONE check because the SpawnRoller can return
  // the NONE value if the user set all values to 0.
  if (bestiary_entry.isNull()) {
    LogChannel('modRandomEncounters', "creature_type is NONE, cancelling spawn");

    return;
  }

  LogChannel('modRandomEncounters', "spawning ambush - " + bestiary_entry.type);

  if (creature_type == CreatureWILDHUNT) {
    makeCreatureWildHunt(master);
  }
  else {
    switch (creature_composition) {
      case CreatureComposition_AmbushWitcher:
        makeCreatureAmbushWitcher(bestiary_entry, master);
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

  composition.init(master.settings);
  composition.setBestiaryEntry(master.bestiary.entries[CreatureWILDHUNT])
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


latent function makeCreatureAmbushWitcher(bestiary_entry: RER_BestiaryEntry, out master: CRandomEncounters) {
  var composition: CreatureAmbushWitcherComposition;

  composition = new CreatureAmbushWitcherComposition in master;

  composition.init(master.settings);
  composition.setBestiaryEntry(bestiary_entry)
    .spawn(master);
}

class CreatureAmbushWitcherComposition extends CompositionSpawner {
  public function init(settings: RE_Settings) {
    LogChannel('modRandomEncounters', "CreatureAmbushWitcherComposition");

    this
      .setRandomPositionMinRadius(settings.minimum_spawn_distance)
      .setRandomPositionMaxRadius(settings.minimum_spawn_distance + settings.spawn_diameter)
      .setAutomaticKillThresholdDistance(settings.kill_threshold_distance)
      .setEncounterType(EncounterType_DEFAULT)
      .setAllowTrophy(settings.trophies_enabled_by_encounter[EncounterType_DEFAULT])
      .setAllowTrophyPickupScene(settings.trophy_pickup_scene);
  }

  var rer_entity_template: CEntityTemplate;

  protected latent function beforeSpawningEntities(): bool {
    this.rer_entity_template = (CEntityTemplate)LoadResourceAsync(
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
      entity,
      this.master
    );

    if (this.allow_trophy) {
      // if the user allows trophy pickup scene, tell the entity
      // to send RER a request on its death.
      current_rer_entity.pickup_animation_on_death = this.allow_trophy_pickup_scene;
    }

    current_rer_entity.automatic_kill_threshold_distance = this
      .automatic_kill_threshold_distance;

    this.rer_entities.PushBack(current_rer_entity);
  }

  protected latent function afterSpawningEntities(): bool {
    var i: int;
    var current_rer_entity: RandomEncountersReworkedEntity;

    for (i = 0; i < this.rer_entities.Size(); i += 1) {
      current_rer_entity = this.rer_entities[i];

      if (!master.settings.enable_encounters_loot) {
        current_rer_entity.removeAllLoot();
      }
      
      current_rer_entity.startWithoutBait();
    }

    return true;
  }
}
