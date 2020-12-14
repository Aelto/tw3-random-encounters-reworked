
// This phase waits for a bit, then wait until all current creatures are killed
// and finally waits until Geralt leaves combat (because other creatures could
// have joined the fight in the meantime)
state Combat in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State Combat");

    this.Combat_main();
  }

  entry function Combat_main() {

  }
}
