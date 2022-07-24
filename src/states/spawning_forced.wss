
state SpawningForced in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('ModRandomEncounters', "entering state SPAWNING-FORCED");

    parent.GotoState('Spawning');
  }
}
