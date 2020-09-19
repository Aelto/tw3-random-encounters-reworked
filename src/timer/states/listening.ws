
state ListeningForEvents in RER_EventsManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "RER_EventsManager - State ListeningForEvents");

    this.ListeningForEvents_main();
  }

  entry function ListeningForEvents_main() {
    var i: int;
    var listener: RER_EventsListener;
    var was_spawn_already_triggered: bool;
    var spawn_asked: bool;

    was_spawn_already_triggered = false;

    LogChannel('modRandomEncounters', "RER_EventsManager - State ListeningForEvents - listening started");

    for (i = 0; i < parent.listeners.Size(); i += 1) {
      listener = parent.listeners[i];

      if (!listener.active) {
        continue;
      }

      was_spawn_already_triggered = listener
        .onInterval(was_spawn_already_triggered, parent.master, parent.delta) || was_spawn_already_triggered;
    }

    LogChannel('modRandomEncounters', "RER_EventsManager - State ListeningForEvents - listening finished");
    
    parent.GotoState('Waiting');
  }
}
