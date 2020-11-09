
state Ending in RandomEncountersReworkedHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "RandomEncountersReworkedHuntEntity - State Ending");

    this.Ending_main();
  }

  entry function Ending_main() {
    parent.clean();
  }
}
