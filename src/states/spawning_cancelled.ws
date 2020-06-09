state SpawningCancelled in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('ModRandomEncounters', "entering state SPAWNING-CANCELLED");

    parent.GotoState('Waiting');
  }
}
