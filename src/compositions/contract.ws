
// This composition is different, it is not really a composition because it
// doesn't use the CompositionSpawner.
// Because this class isn't a class of type "one instance per entity" but
// instead a single class handling the whole encounter.
latent function createRandomCreatureContract(master: CRandomEncounters, bestiary_entry: RER_BestiaryEntry, optional position: Vector) {
  var composition: CreatureContractComposition;

  composition = new CreatureContractComposition in master;
  composition.init(master.settings);
  composition.setBestiaryEntry(bestiary_entry)
    .spawn(master);
}

latent function createRandomCreatureContractWithPositionAndHeading(master: CRandomEncounters, bestiary_entry: RER_BestiaryEntry, position: Vector, heading: float) {
  var composition: CreatureContractComposition;

  composition = new CreatureContractComposition in master;
  composition.init(master.settings);

  composition.setContractHeading(heading);
  composition.setSpawnPosition(position);
  composition.started_from_noticeboard = true;

  composition.setBestiaryEntry(bestiary_entry)
    .spawn(master);
}

class CreatureContractComposition extends CompositionSpawner {
  public var started_from_noticeboard: bool;
  default started_from_noticeboard = false;

  public latent function init(settings: RE_Settings) {
    var bestiary_entry: RER_BestiaryEntry;

    LogChannel('modRandomEncounters', "CreatureContractComposition");

    bestiary_entry = this
      .master
      .bestiary
      .getRandomEntryFromBestiary(
        this.master,
        EncounterType_CONTRACT,
        , // for bounty
        (new RER_SpawnRollerFilter in this)
          .init()
          .setOffsets(CreatureDRACOLIZARD, CreatureMAX)
      );

    this
      .setRandomPositionMinRadius(settings.minimum_spawn_distance)
      .setRandomPositionMaxRadius(settings.minimum_spawn_distance + settings.spawn_diameter)
      .setEncounterType(EncounterType_CONTRACT)
      .setBestiaryEntry(bestiary_entry)

      // these settings aren't used when it's an entity manager.
      // I leave them here for the day where i'll update the CompositionSpawner
      // to work with the new classes.
      // .setAutomaticKillThresholdDistance(settings.kill_threshold_distance)
      // .setAllowTrophy(settings.trophies_enabled_by_encounter[EncounterType_DEFAULT])
      // .setAllowTrophyPickupScene(settings.trophy_pickup_scene)

      // we force -1 creatures here because the contract entity will spawn the
      // creatures later based on the phases.
      // and 0 is the default value the bestiary_entry checks for before rolling
      // a random value.
      .setNumberOfCreatures(-1);

  }

  public var heading: float;
  public var use_heading: bool;
  public function setContractHeading(heading: float) {
    this.heading = heading;
    this.use_heading = true;
  }

  protected latent function afterSpawningEntities(): bool {
    var rer_entity: RandomEncountersReworkedContractEntity;
    var rer_entity_template: CEntityTemplate;

    rer_entity_template = (CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_contract_entity.w2ent",
      true
    );

    rer_entity = (RandomEncountersReworkedContractEntity)theGame.CreateEntity(rer_entity_template, this.initial_position, thePlayer.GetWorldRotation());
    rer_entity.started_from_noticeboard = this.started_from_noticeboard;

    if (this.use_heading) {
      rer_entity.setPhaseTransitionHeading(this.heading);
    }

    rer_entity.startEncounter(this.master, this.bestiary_entry);

    return true;
  }
}