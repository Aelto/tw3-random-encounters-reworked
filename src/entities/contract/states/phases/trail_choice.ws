
// Many trails are created around the previous checkpoint and the player has to
// follow one. He cannot go back and follow another one.
// It's almost like the TrailSplit phase but the trails aren't created exactly
// on the previous checkpoint, but in a radius around it. It's more suited for
// phases like Combat, Ambush, CluesInvestigate, etc...
state TrailChoice in RandomEncountersReworkedContractEntity extends TrailPhase {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State TrailChoice");

    this.TrailChoice_main();
  }

  var destination_one: Vector;
  var destination_two: Vector;

  entry function TrailChoice_main() {
    var picked_destination: int;

    this.trail_origin_radius = 10;

    this.createTrails();

    this.play_oneliner_begin();

    picked_destination = this.waitForPlayerToReachOnePoint();

    this.updateCheckpoint(picked_destination);

    parent.GotoState('PhasePick');
  }


  //
  // controls how far from the previous checkpoint the trails start
  public var trail_origin_radius: float;
  default trail_origin_radius = 0.5;

  latent function createTrails() {
    var origin: Vector;
    var picked_destination: int;
    var checkpoint_save: Vector;

    checkpoint_save = parent.previous_phase_checkpoint;

    // kind of a hack, because `getNewTrailDestination` uses `parent.previous_phase_checkpoint`
    // as the origin. And we want to be able to choose where it starts
    parent.previous_phase_checkpoint = checkpoint_save + VecRingRand(0, trail_origin_radius);
    if (!this.getNewTrailDestination(this.destination_one, 0.25)) {
      LogChannel('modRandomEncounters', "Contract - State TrailBreakoff, could not find trail destination one");
      parent.endContract();

      return;
    }

    parent.previous_phase_checkpoint = checkpoint_save + VecRingRand(0, trail_origin_radius);
    if (!this.getNewTrailDestination(this.destination_two, 0.25)) {
      LogChannel('modRandomEncounters', "Contract - State TrailBreakoff, could not find trail destination two");
      parent.endContract();

      return;
    }

    this.drawTrailsToWithCorpseDetailsMaker(
      this.destination_one,
      Max(parent.number_of_creatures / 2, 1)
    );

    this.drawTrailsToWithCorpseDetailsMaker(
      this.destination_two,
      Max(parent.number_of_creatures / 2, 1)
    );
  }

  latent function play_oneliner_begin() {
    var previous_phase: name;

    previous_phase = parent.getPreviousPhase('Ambush');

    if (previous_phase == 'TrailBreakoff') {
      REROL_trail_goes_on(true);
    }
    else {
      REROL_should_look_around(true);
    }

    Sleep(2);

    REROL_wonder_they_split(true);
  }

  latent function updateCheckpoint(picked_destination: int) {
    if (picked_destination == 1) {
      parent.updatePhaseTransitionHeading(
        parent.previous_phase_checkpoint,
        this.destination_one
      );

      parent.previous_phase_checkpoint = this.destination_one;
    }
    else {
      parent.updatePhaseTransitionHeading(
        parent.previous_phase_checkpoint,
        this.destination_two
      );

      parent.previous_phase_checkpoint = this.destination_two;
    }
  }

  //
  // returns the number corresponding to the destination
  latent function waitForPlayerToReachOnePoint(): int {
    var distance_from_player: float;
    var radius: float;

    radius = 5 * 5;

    // squared radius to save performances by using VecDistanceSquared
    distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), this.destination_one);

    while (true) {
      SleepOneFrame();

      // 1. first the destination_one
      distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), this.destination_one);

      if (distance_from_player < radius) {
        return 1;
      }

      // 2. then the destination_two
      distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), this.destination_two);

      if (distance_from_player < radius) {
        return 2;
      }
    }

    return 1;
  }
}
