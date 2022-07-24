
state Addon in RER_AddonManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    NLOG("RER_AddonManager - state " + parent.GetCurrentStateName());
  }

  public function getMaster(): CRandomEncounters {
    return parent.master;
  }

  public function finish() {
    parent.GotoState('Waiting');
  }
}