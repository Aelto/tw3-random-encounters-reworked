
state Exit in RER_PresetManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    NLOG("RER_PresetManager - state Exit");

    this.Exit_applySettings();
  }

  entry function Exit_applySettings() {
    parent.done = true;
  }

}
