
// Many trails are created around the previous checkpoint and the player has to
// follow one. He cannot go back and follow another one.
// It's almost like the TrailSplit phase but the trails aren't created exactly
// on the previous checkpoint, but in a radius around it. It's more suited for
// phases like Combat, Ambush, CluesInvestigate, etc...
state TrailChoice in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State TrailChoice");

    this.TrailChoice_main();
  }

  entry function TrailChoice_main() {

  }
}
