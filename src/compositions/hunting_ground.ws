
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
      .setEncounterType(EncounterType_HUNTINGGROUND);

  }

  protected latent function afterSpawningEntities(): bool {
    var rer_entity: RandomEncountersReworkedContractEntity;
    var rer_entity_template: CEntityTemplate;

    rer_entity_template = (CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_contract_entity.w2ent",
      true
    );

    rer_entity = (RandomEncountersReworkedContractEntity)theGame.CreateEntity(rer_entity_template, this.initial_position, thePlayer.GetWorldRotation());
    rer_entity.startEncounter(this.master, this.bestiary_entry);

    return true;
  }
}