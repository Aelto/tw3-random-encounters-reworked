
// The TrailBreakoff state is a simple phase to lead Geralt to a point, where
// he will then say something along the line of "Lost the trail, should look around"
// the trail starts from the previous checkpoint and goes to a random position.
//
// This phase is useful to move Geralt around and then play another phase such as
// the ambush phase. Because the ambush phase is a stationary phase without any trail.
// So by combining TrailBreakoff and Ambush you get Geralt being ambushed while
// following a trail.
state TrailBreakoff in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State TrailBreakoff");

    this.TrailBreakoff_main();
  }

  entry function TrailBreakoff_main() {

  }
}
