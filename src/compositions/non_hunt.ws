
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
  var rifts: array<CRiftEntity>;


  protected latent function beforeSpawningEntities(): bool {
    var success: bool;

    success = super.beforeSpawningEntities();
    if (!success) {
      return false;
    }

    this.portal_template = master.resources.getPortalResource();

    return true;
  }

  protected latent function forEachEntity(entity: CEntity) {
    var rift: CRiftEntity;

    super.forEachEntity(entity);

    ((CNewNPC)entity)
        .SetTemporaryAttitudeGroup('hostile_to_player', AGP_Default);
      
    ((CNewNPC)entity)
      .NoticeActor(thePlayer);

    rift = (CRiftEntity)theGame.CreateEntity(
      this.portal_template,
      entity.GetWorldPosition(),
      entity.GetWorldRotation()
    );
    rift.ActivateRift();

    rifts.PushBack(rift);
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

  protected latent function afterSpawningEntities(): bool {
    var rer_entity: RandomEncountersReworkedHuntEntity;
    var rer_entity_template: CEntityTemplate;

    rer_entity_template = (CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_hunt_entity.w2ent",
      true
    );

    rer_entity = (RandomEncountersReworkedHuntEntity)theGame.CreateEntity(rer_entity_template, this.initial_position, thePlayer.GetWorldRotation());
    rer_entity.startEncounter(this.master, this.created_entities, this.bestiary_entry, true);

    return true;
  }
}
