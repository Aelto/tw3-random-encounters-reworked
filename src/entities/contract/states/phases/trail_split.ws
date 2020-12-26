
// Two trails are created at the previous checkpoint and the player has to follow
// one or the other, he cannot follow one and go back later.
state TrailSplit in RandomEncountersReworkedContractEntity extends TrailChoice {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State TrailSplit");

    this.TrailSplit_main();
  }

  entry function TrailSplit_main() {
    var picked_destination: int;

    this.trail_origin_radius = 0.1;

    this.createTrails();

    REROL_wonder_they_split();

    picked_destination = this.waitForPlayerToReachOnePoint();

    this.updateCheckpoint(picked_destination);

    parent.GotoState('PhasePicked');
  }
}
