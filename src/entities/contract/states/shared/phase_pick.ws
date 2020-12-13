
state PhasePick in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State PhasePick");

    parent.played_phases.PushBack(previous_state_name);

    if (previous_state_name == 'Loading') {
      this.PhasePick_phase_0();
    }
    else {
      PhasePick_phase_1_2(previous_state_name);
    }
  }

  // Picks a random phase_0 phase
  entry function PhasePick_phase_0() {
    var roll: float;

    roll = RandRange(10);

    if (roll < 5) {
      parent.GotoState('CluesInvestigate');
    }
    else {
      parent.GotoState('KneelInteraction');
    }
  }

  entry function PhasePick_phase_1_2(previous_state_name: name) {
    
  }
}
