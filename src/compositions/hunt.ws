
latent function createRandomCreatureHunt(master: CRandomEncounters, optional creature_type: CreatureType) {
  var bestiary_entry: RER_BestiaryEntry;

  LogChannel('modRandomEncounters', "making create hunt");

  if (creature_type == CreatureNONE) {
    bestiary_entry = master
      .bestiary
      .getRandomEntryFromBestiary(master, EncounterType_HUNT);
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

  if (bestiary_entry.type == CreatureGRYPHON) {
    makeGryphonCreatureHunt(master);
  }
  else {
    makeDefaultCreatureHunt(master, bestiary_entry);
  }
}


latent function makeGryphonCreatureHunt(master: CRandomEncounters) {
  var composition: CreatureHuntGryphonComposition;

  composition = new CreatureHuntGryphonComposition in master;

  composition.init(master.settings);
  composition
    .setBestiaryEntry(master.bestiary.entries[CreatureGRYPHON])
    .spawn(master);
}

class CreatureHuntGryphonComposition extends CompositionSpawner {
  public function init(settings: RE_Settings) {
    this
      .setRandomPositionMinRadius(settings.minimum_spawn_distance * 3)
      .setRandomPositionMaxRadius((settings.minimum_spawn_distance + settings.spawn_diameter) * 3)
      .setAutomaticKillThresholdDistance(settings.kill_threshold_distance * 3)
      .setAllowTrophy(settings.trophies_enabled_by_encounter[EncounterType_HUNT])
      .setAllowTrophyPickupScene(settings.trophy_pickup_scene)
      .setNumberOfCreatures(1);
  }

  var rer_entity_template: CEntityTemplate;
  var blood_splats_templates: array<CEntityTemplate>;

  protected latent function beforeSpawningEntities(): bool {
    this.rer_entity_template = (CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_flying_hunt_entity.w2ent",
      true
    );

    this.blood_splats_templates = this
      .master
      .resources
      .getBloodSplatsResources();

    return true;
  }

  var rer_entities: array<RandomEncountersReworkedGryphonHuntEntity>;

  protected latent function forEachEntity(entity: CEntity) {
    var current_rer_entity: RandomEncountersReworkedGryphonHuntEntity;

    current_rer_entity = (RandomEncountersReworkedGryphonHuntEntity)theGame.CreateEntity(
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

    if (!master.settings.enable_encounters_loot) {
      current_rer_entity.removeAllLoot();
    }

    current_rer_entity.startEncounter(this.blood_splats_templates);


    this.rer_entities.PushBack(current_rer_entity);
  }
}


latent function makeDefaultCreatureHunt(master: CRandomEncounters, bestiary_entry: RER_BestiaryEntry) {
  var composition: CreatureHuntComposition;

  composition = new CreatureHuntComposition in master;

  composition.init(master.settings);
  composition.setBestiaryEntry(bestiary_entry)
    .spawn(master);
}

// CAUTION, it extends `CreatureAmbushWitcherComposition`
class CreatureHuntComposition extends CreatureAmbushWitcherComposition {
  public function init(settings: RE_Settings) {
    this
      .setRandomPositionMinRadius(settings.minimum_spawn_distance * 2)
      .setRandomPositionMaxRadius((settings.minimum_spawn_distance + settings.spawn_diameter) * 2)
      .setAutomaticKillThresholdDistance(settings.kill_threshold_distance * 2)
      .setEncounterType(EncounterType_HUNT)
      .setAllowTrophy(settings.trophies_enabled_by_encounter[EncounterType_HUNT])
      .setAllowTrophyPickupScene(settings.trophy_pickup_scene);
  }

  protected latent function afterSpawningEntities(): bool {
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

      if (!master.settings.enable_encounters_loot) {
        current_rer_entity.removeAllLoot();
      }
      
      current_rer_entity.startWithBait(bait);
    }

    return true;
  }
}
