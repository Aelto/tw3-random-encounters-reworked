
state TrailChoice in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State TrailChoice");

    this.TrailChoice_main();
  }

  entry function TrailChoice_main() {

  }
}
