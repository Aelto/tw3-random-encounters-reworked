
state Waiting in RER_EventsManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "RER_EventsManager - State Waiting");
  }

  entry function main() {
    parent.AddTimer('intervalFunction', 0.20, false);
  }
}
