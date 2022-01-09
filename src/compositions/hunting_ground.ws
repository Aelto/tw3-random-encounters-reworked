
latent function createRandomCreatureHuntingGround(master: CRandomEncounters, bestiary_entry: RER_BestiaryEntry) {
  var composition: CreatureHuntingGroundComposition;

  composition = new CreatureHuntingGroundComposition in master;

  composition.init(master.settings);
  composition.setBestiaryEntry(bestiary_entry)
    .spawn(master);
}

class CreatureHuntingGroundComposition extends CompositionSpawner {
  public function init(settings: RE_Settings) {
    LogChannel('modRandomEncounters', "CreatureHuntingGroundComposition");

    this
      .setRandomPositionMinRadius(settings.minimum_spawn_distance)
      .setRandomPositionMaxRadius(settings.minimum_spawn_distance + settings.spawn_diameter)
      .setAutomaticKillThresholdDistance(settings.kill_threshold_distance)
      .setAllowTrophy(settings.trophies_enabled_by_encounter[EncounterType_HUNTINGGROUND])
      .setEncounterType(EncounterType_HUNTINGGROUND);

  }

  protected latent function afterSpawningEntities(): bool {
    var rer_entity: RandomEncountersReworkedHuntingGroundEntity;
    var rer_entity_template: CEntityTemplate;

    rer_entity_template = (CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_hunting_ground_entity.w2ent",
      true
    );

    rer_entity = (RandomEncountersReworkedHuntingGroundEntity)theGame.CreateEntity(rer_entity_template, this.initial_position, thePlayer.GetWorldRotation());
    rer_entity.startEncounter(this.master, this.created_entities, this.bestiary_entry);

    return true;
  }
}