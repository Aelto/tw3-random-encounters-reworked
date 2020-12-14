
// A trail is created is created from the previous checkpoint to a random position
// where creatures will be waiting
state TrailCombat in RandomEncountersReworkedContractEntity extends TrailPhase {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State TrailCombat");

    this.TrailCombat_main();
  }

  entry function TrailCombat_main() {
    var destination: Vector;

    if (!this.getNewTrailDestination(destination)) {
      LogChannel('modRandomEncounters', "Contract - State TrailCombat, could not find trail destination");
      parent.endContract();
    }

    this.drawTrailsToWithCorpseDetailsMaker(parent.number_of_creatures);

    // TODO: spawn random monsters

    this.keepCreaturesOnPoint(destination, 20);
  }

  var has_played_oneliner: bool;
  latent function waitForPlayerToReachPoint_action() {
    if (!has_played_oneliner && RandRange(10000) < 0.00001) {
      REROL_miles_and_miles_and_miles();

      has_played_oneliner = true;
    }

    this.keepCreaturesOnPoint();
  }

}
