
state Ending in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State Ending");

    this.Ending_main();
  }

  entry function Ending_main() {
    Sleep(1);

    // play the oneliner only if two phases were played. There is always one phase
    // that is played as it's the starting phase, so we check for two.
    if (parent.played_phases.Size() > 2) {
      REROL_its_over();
    }

    parent.clean();
  }
}
