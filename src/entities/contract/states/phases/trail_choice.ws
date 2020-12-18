
// Many trails are created around the previous checkpoint and the player has to
// follow one. He cannot go back and follow another one.
// It's almost like the TrailSplit phase but the trails aren't created exactly
// on the previous checkpoint, but in a radius around it. It's more suited for
// phases like Combat, Ambush, CluesInvestigate, etc...
state TrailChoice in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State TrailChoice");

    this.TrailChoice_main();
  }

  var destination_one: Vector;
  var destination_two: Vector;

  entry function TrailChoice_main() {
    var short_destination_one: Vector;
    var short_destination_two: Vector;
    var picked_destination: int;

    if (!this.getNewTrailDestination(this.destination_one)) {
      LogChannel('modRandomEncounters', "Contract - State TrailBreakoff, could not find trail destination one");
      parent.endContract();

      return;
    }

    if (!this.getNewTrailDestination(this.destination_two)) {
      LogChannel('modRandomEncounters', "Contract - State TrailBreakoff, could not find trail destination two");
      parent.endContract();

      return;
    }

    short_destination_one = VecInterpolate(parent.previous_phase_checkpoint, this.destination_one, 0.05);
    short_destination_two = VecInterpolate(parent.previous_phase_checkpoint, this.destination_two, 0.05);

    // TODO: add oneliner
    // wonder why they split up

    this.drawTrailsToWithCorpseDetailsMaker(
      short_destination_one,
      Max(parent.number_of_creatures / 2, 1)
    );

    this.drawTrailsToWithCorpseDetailsMaker(
      short_destination_two,
      Max(parent.number_of_creatures / 2, 1)
    );

    picked_destination = this.waitForPlayerToReachOnePoint(
      destination_one,
      destination_two
    );

    if (picked_destination == 1) {
      this.drawTrailsToWithCorpseDetailsMaker(
        this.destination_one,
        Max(parent.number_of_creatures / 2, 1)
      );

      this.waitForPlayerToReachPoint(this.destination_one, 10);
     
      parent.previous_phase_checkpoint = this.destination_one;
    }
    else {
      this.drawTrailsToWithCorpseDetailsMaker(
        this.destination_two,
        Max(parent.number_of_creatures / 2, 1)
      );

      this.waitForPlayerToReachPoint(this.destination_two, 10);

      parent.previous_phase_checkpoint = this.destination_two;
    }

    // TODO: add oneliner

    parent.GotoState('PhasePicked');
  }

  //
  // returns the number corresponding to the destination
  latent function waitForPlayerToReachOnePoint(destination_one: Vector, destination_two: Vector): int {
    var distance_from_player: float;

    // squared radius to save performances by using VecDistanceSquared
    distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), destination_one);

    while (true) {
      SleepOneFrame();

      // 1. first the destination_one
      distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), destination_one);

      if (distance_from_player < 5 * 5) {
        return 1;
      }

      // 2. then the destination_two
      distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), destination_two);

      if (distance_from_player < 5 * 5) {
        return 2;
      }
    }
  }
}
