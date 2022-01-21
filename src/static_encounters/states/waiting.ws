
state Waiting in RER_StaticEncounterManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    NLOG("RER_StaticEncounterManager - state WAITING");
  }
}
