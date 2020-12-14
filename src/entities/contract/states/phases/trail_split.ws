
// Two trails are created at the previous checkpoint and the player has to follow
// one or the other, he cannot follow one and go back later.
state TrailSplit in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State TrailSplit");

    this.TrailSplit_main();
  }

  entry function TrailSplit_main() {

  }
}
