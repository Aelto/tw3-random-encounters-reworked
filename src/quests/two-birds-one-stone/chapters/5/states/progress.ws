state Progress in RER_Q1_chapter5 extends BaseChapter {
  event OnEnterState(previous_state_name: name) {
    this.Progress_main();
  }

  entry function Progress_main() {
    (new RER_RandomDialogBuilder in thePlayer).start()
    .dialog(new REROL_jump_down_there in thePlayer, true)
    .play();

    parent.nextState();
  }
}