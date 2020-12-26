
state Ending in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State Ending");

    this.Ending_main();
  }

  entry function Ending_main() {
    Sleep(1);
    REROL_its_over();

    parent.clean();
  }
}
