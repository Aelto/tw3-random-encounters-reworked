
state Loading in RER_AddonManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    NLOG("RER_AddonManager - state Loading");

    this.Loading_main();
  }

  entry function Loading_main() {
    parent.states_to_process = theGame.GetDefinitionsManager()
      .GetItemsWithTag('RER_Addon');

    parent.GotoState('Waiting');
  }
}