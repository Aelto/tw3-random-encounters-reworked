
// This state is a bit different than the others because it's a transition state
// It goes there and only checks in which state it should move to.
//
// So here is what this state does:
// - The entry function first checks if it should loop or skip directly to the
//   Ending state. If it does, the chances for the next rolls are decreased.
// - Goes back to the clues_follow state.
state CombatLoop in RandomEncountersReworkedContractEntity {
  var has_been_ambushed: bool;

  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State CombatLoop");

    this.CombatLoop_main();
  }

  entry function CombatLoop_main() {
    var can_start: bool;

    // 1. can we start the loop or should we skip this state and go directly to
    //    the Ending state.
    can_start = this.CombatLoop_CanStart();
    if (!can_start) {
      REROL_its_over();

      parent.endContract();

      return;
    }

    // 2. we can start the loop so we decrease the chances for the next loop
    parent.looping_chances -= parent.looping_chances_decrease;

    // 3. we update variables indicating that we're looping
    parent.has_combat_looped = true;

    // 4. we go back to the CluesFollow state
    this.CombatLoop_goToNextState();
  }

  latent function CombatLoop_CanStart(): bool {
    return RandRange(100) < parent.looping_chances;
  }

  latent function CombatLoop_goToNextState() {
    parent.GotoState('CluesFollow');
  }
}
