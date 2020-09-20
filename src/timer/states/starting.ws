
state Starting in RER_EventsManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "RER_EventsManager - State Starting");

    this.Starting_main();
  }

  entry function Starting_main() {
    var i: int;
    var listener: RER_EventsListener;

    for (i = 0; i < parent.listeners.Size(); i += 1) {
      listener = parent.listeners[i];

      if (!listener.isActive) {
        listener.onReady(parent);
      }
    }
    
    parent.GotoState('Waiting');
  }
}
