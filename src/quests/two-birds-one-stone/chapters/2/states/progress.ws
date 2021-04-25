state Progress in RER_Q1_chapter2 extends BaseChapter {
  event OnEnterState(previous_state_name: name) {
    this.Progress_main();
  }

  entry function Progress_main() {
    (new RER_RandomDialogBuilder in thePlayer).start()
    .dialog(new REROL_tracks_end_here_damn_birds_ground_clean in thePlayer, true)
    .play();

    parent.nextState();
  }
}