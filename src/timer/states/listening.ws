
state ListeningForEvents in RER_EventsManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "RER_EventsManager - State ListeningForEvents");
  }

  entry function main() {
    
    parent.GotoState('Waiting');
  }
}
