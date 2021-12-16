
state Waiting in RER_ContractManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    NLOG("RER_ContractManager - state WAITING");
  }
}