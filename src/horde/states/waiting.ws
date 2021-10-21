
state Waiting in RER_HordeManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_HordeManager - Waiting");

    this.Waiting_main();
  }

  entry function Waiting_main() {
    (new RER_RandomDialogBuilder in thePlayer)
      .start()
      .either(new REROL_enough_for_now in thePlayer, true, 0.5)
      .either(new REROL_thats_enough in thePlayer, true, 0.5)
      .play();
  }
}