
// A trail is created is created from the previous checkpoint to a random position
// where creatures will be waiting
state TrailCombat in RandomEncountersReworkedContractEntity extends TrailPhase {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State TrailCombat");

    this.TrailCombat_main();
  }

  var destination: Vector;

  entry function TrailCombat_main() {
    if (!this.getNewTrailDestination(this.destination)) {
      LogChannel('modRandomEncounters', "Contract - State TrailCombat, could not find trail destination");
      parent.endContract();

      return;
    }

    this.drawTrailsToWithCorpseDetailsMaker(
      this.destination,
      parent.number_of_creatures
    );

    this.spawnRandomMonster();

    this.waitForPlayerToReachPoint(this.destination, 15);

    REROL_there_you_are();

    parent.previous_phase_checkpoint = this.destination;

    parent.GotoState('Combat');
  }

  latent function spawnRandomMonster() {
    var bestiary_entry: RER_BestiaryEntry;

    bestiary_entry = parent
      .master
      .bestiary
      .getRandomEntryFromBestiary();

    bestiary_entry.spawn(this.destination);
  }

  latent function waitForPlayerToReachPoint_action(): bool {
    this.keepCreaturesOnPoint();

    // tell it to stop waiting if one creature targets Geralt
    return parent.hasOneOfTheEntitiesGeraltAsTarget();
  }

}
