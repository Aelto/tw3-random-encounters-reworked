
// The TrailBreakoff state is a simple phase to lead Geralt to a point, where
// he will then say something along the line of "Lost the trail, should look around"
// the trail starts from the previous checkpoint and goes to a random position.
//
// This phase is useful to move Geralt around and then play another phase such as
// the ambush phase. Because the ambush phase is a stationary phase without any trail.
// So by combining TrailBreakoff and Ambush you get Geralt being ambushed while
// following a trail.
state TrailBreakoff in RandomEncountersReworkedContractEntity extends TrailPhase {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State TrailBreakoff");

    this.TrailBreakoff_main();
  }

  var destination: Vector;

  entry function TrailBreakoff_main() {
    if (!this.getNewTrailDestination(this.destination, 0.5)) {
      LogChannel('modRandomEncounters', "Contract - State TrailBreakoff, could not find trail destination");
      parent.endContract();

      return;
    }

    this.play_oneliner_begin();

    this.drawTrailsToWithCorpseDetailsMaker(
      this.destination,
      parent.number_of_creatures
    );

    this.waitForPlayerToReachPoint(this.destination, 10);

    this.play_oneliner_end();

    parent.previous_phase_checkpoint = this.destination;

    parent.GotoState('PhasePick');
  }

  latent function play_oneliner_begin() {
    var previous_phase: name;

    previous_phase = parent.getPreviousPhase('Ambush');

    if (previous_phase == 'TrailBreakoff') {
      REROL_trail_goes_on();
    }
  }

  latent function play_oneliner_end() {
    if (RandRange(10) < 5) {
      REROL_trail_ends_here();
    }
    else {
      REROL_trail_breaks_off();
    }
  }
}
