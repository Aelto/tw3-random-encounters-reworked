
state Waiting in RER_HordeManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_BountyManager - Waiting");
  }
}