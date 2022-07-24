
state Waiting in RER_EventsManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    // LogChannel('modRandomEncounters', "RER_EventsManager - State Waiting");

    this.Waiting_main();
  }

  entry function Waiting_main() {
    // LogChannel('modRandomEncounters', "RER_EventsManager - Waiting_main()");
    
    Sleep(parent.delay);

    parent.GotoState('ListeningForEvents');
  }
}
