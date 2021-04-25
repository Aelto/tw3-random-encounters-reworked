state Progress in RER_Q1_chapter4 extends BaseChapter {
  event OnEnterState(previous_state_name: name) {
    this.Progress_main();
  }

  entry function Progress_main() {
    (new RER_RandomDialogBuilder in thePlayer).start()
    .dialog(new REROL_mhm_data in thePlayer, true)
    .then(1)
    .dialog(new REROL_large_deep_tracks in thePlayer, true)
    .play();

    REROL_wonder_clues_will_lead_me(true);
    parent.nextState();
  }
}