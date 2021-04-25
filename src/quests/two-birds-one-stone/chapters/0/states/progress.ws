state Progress in RER_Q1_chapter0 extends BaseChapter {
  event OnEnterState(previous_state_name: name) {
    this.Progress_main();
  }

  entry function Progress_main() {
    (new RER_RandomDialogBuilder in thePlayer).start()
    .then(2)
    .dialog(new REROL_thats_my_next_destination in thePlayer, true)
    .play();

    parent.nextState();
  }
}