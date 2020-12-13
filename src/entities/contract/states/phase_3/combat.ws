
state Combat in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State Combat");

    this.Combat_main();
  }

  entry function Combat_main() {

  }
}
