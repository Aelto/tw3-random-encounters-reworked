
// Pretty much the same as SpawningCancelled, but without the reduced delay
// that happens after a cancel.
state SpawningDelayed in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('ModRandomEncounters', "entering state SPAWNING-DELAYED");

    parent.GotoState('Waiting');
  }
}
