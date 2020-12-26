
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

    this.KneelInteraction_createTracks();
    this.KneelInteraction_playAnimation();
    parent.GotoState('PhasePick');
  }

  latent function KneelInteraction_createTracks() {
    var max_number_of_clues: int;
    var current_clue_position: Vector;
    var i: int;

    max_number_of_clues = RandRange(8, 3);

    for (i = 0; i < max_number_of_clues; i += 1) {
      current_clue_position = parent.previous_phase_checkpoint 
        + VecRingRand(0, 5);

      FixZAxis(current_clue_position);

      parent
        .trail_maker
        .addTrackHere(current_clue_position, VecToRotation(VecRingRand(1, 2)));
    }

    // and we had a clue right on Geralt for the animation
    current_clue_position = parent.previous_phase_checkpoint + VecRingRand(0, 1);

    parent.trail_maker.addTrackHere(
      current_clue_position,
      thePlayer.GetWorldRotation()
    );
  }

  latent function KneelInteraction_playAnimation() {
    var monster_clue: RER_MonsterClue;

    Sleep(1);
    
    monster_clue = parent.trail_maker.getLastPlacedTrack();
    monster_clue.GotoState('Interacting');

    Sleep(7);
  }
}
