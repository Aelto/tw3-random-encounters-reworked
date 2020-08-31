
latent function createRandomCreatureHunt(master: CRandomEncounters, optional creature_type: CreatureType) {

  LogChannel('modRandomEncounters', "making create hunt");

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

  if (creature_type == CreatureGRYPHON) {
    makeGryphonCreatureHunt(master);
  }
  else {
    makeDefaultCreatureHunt(master, creature_type);
  }
}


latent function makeGryphonCreatureHunt(master: CRandomEncounters) {
  var composition: CreatureHuntGryphonComposition;

  composition = new CreatureHuntGryphonComposition in master;

  composition.init(master.settings);
  composition.spawn(master);
}

class CreatureHuntGryphonComposition extends CompositionSpawner {
  public function init(settings: RE_Settings) {
    this
      .setRandomPositionMinRadius(settings.minimum_spawn_distance * 3)
      .setRandomPositionMaxRadius((settings.minimum_spawn_distance + settings.spawn_diameter) * 3)
      .setAutomaticKillThresholdDistance(settings.kill_threshold_distance * 3)
      .setCreatureType(CreatureGRYPHON)
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
      entity
    );

    current_rer_entity.automatic_kill_threshold_distance = this
      .automatic_kill_threshold_distance;

    current_rer_entity.this_newnpc.SetLevel(GetWitcherPlayer().GetLevel());
    
    if (!master.settings.enable_encounters_loot) {
      current_rer_entity.removeAllLoot();
    }

    current_rer_entity.startEncounter(this.blood_splats_templates);


    this.rer_entities.PushBack(current_rer_entity);
  }
}


latent function makeDefaultCreatureHunt(master: CRandomEncounters, creature_type: CreatureType) {
  var composition: CreatureHuntComposition;

  composition = new CreatureHuntComposition in master;

  composition.init(master.settings);
  composition.setCreatureType(creature_type)
    .spawn(master);
}

// CAUTION, it extends `CreatureAmbushWitcherComposition`
class CreatureHuntComposition extends CreatureAmbushWitcherComposition {
  public function init(settings: RE_Settings) {
    this
      .setRandomPositionMinRadius(settings.minimum_spawn_distance * 2)
      .setRandomPositionMaxRadius((settings.minimum_spawn_distance + settings.spawn_diameter) * 2)
      .setAutomaticKillThresholdDistance(settings.kill_threshold_distance * 2);
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

      current_rer_entity.this_newnpc.SetLevel(GetWitcherPlayer().GetLevel());
      if (!master.settings.enable_encounters_loot) {
        current_rer_entity.removeAllLoot();
      }
      
      current_rer_entity.startWithBait(bait);
    }

    return true;
  }
}
