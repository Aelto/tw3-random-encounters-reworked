
state Waiting in RER_AddonManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    NLOG("RER_AddonManager - state WAITING");

    this.Waiting_main(previous_state_name);
  }

  entry function Waiting_main(previous_state_name: name) {
    if (previous_state_name != 'Loading') {
      parent.processed_states.PushBack(previous_state_name);
    }

    this.startProcessingLastState();
  }

  function startProcessingLastState() {
    var last_state: name;
    
    if (parent.states_to_process.Size() <= 0) {
      return;
    }

    last_state = parent.states_to_process.PopBack();
    parent.GotoState(last_state);
  }
}