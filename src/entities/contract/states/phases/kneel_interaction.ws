
// This phase starts an animation and a oneliner instantly and then goes to
// the PhasePicker state.
state KneelInteraction in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State KneelInteraction");

    this.KneelInteraction_main();
  }

  entry function KneelInteraction_main() {
    parent.previous_phase_checkpoint = thePlayer.GetWorldPosition();

    this.createTracks();
    this.playAnimation();
    parent.GotoState('PhasePick');
  }

  latent function createTracks() {
    var max_number_of_clues: int;
    var current_clue_position: Vector;
    var i: int;

    max_number_of_clues = RandRange(8, 3);

    for (i = 0; i < max_number_of_clues; i += 1) {
      current_clue_position = parent.previous_phase_checkpoint 
        + VecRingRand(0, 10);

      FixZAxis(current_clue_position);

      parent
        .trail_maker
        .addTrackHere(current_clue_position, VecToRotation(VecRingRand(1, 2)));
    }
  }

  latent function playAnimation() {
    var monster_clue: RER_MonsterClue;

    monster_clue = parent.trail_maker.getLastPlacedTrack();

    monster_clue.GotoState('Interacting');

    Sleep(7);
  }
}
