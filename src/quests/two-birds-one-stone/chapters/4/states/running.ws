state Running in RER_Q1_chapter4 extends BaseChapter {
  event OnEnterState(previous_state_name: name) {
    this.Running_main();
  }


  entry function Running_main() {
    this.waitForPlayerToReachPoint(
      ((RER_quest1)parent.quest_entry).constants.chapter_4_trail_position_end,
      5
    );

    this.playScene();
    parent.quest_entry.completeCurrentChapterAndGoToNext();
  }

  latent function playScene() {
    var camera_0: SU_StaticCamera;
    var camera_1: SU_StaticCamera;
    var camera_2: SU_StaticCamera;

    camera_0 = SU_getStaticCamera();

    camera_0.teleportAndLookAt(
      thePlayer.GetWorldPosition()
      + Vector(0, 0, 2)
      + thePlayer.GetWorldRight() * -2,

      thePlayer.GetWorldPosition()
      + thePlayer.GetWorldForward() * 100
    );

    theGame.FadeOut(0.5);
    camera_0.start();
    theGame.FadeInAsync(1);

    thePlayer.TeleportWithRotation(
      ((RER_quest1)parent.quest_entry).constants.chapter_4_trail_position_end,
      EulerAngles(0, 141.85, 0)
    );

    camera_1 = SU_getStaticCamera();
    camera_1.activationDuration = 3;

    camera_1.teleportAndLookAt(
      thePlayer.GetWorldPosition()
      + Vector(0, 0, 2)
      + thePlayer.GetWorldRight() * 2,

      thePlayer.GetWorldPosition()
      + thePlayer.GetWorldForward() * 100
    );

    camera_1.start();

    (new RER_RandomDialogBuilder in thePlayer).start()
    .dialog(new REROL_view_from_there_spectacular in thePlayer, true)
    .play();

    camera_2 = SU_getStaticCamera();
    camera_2.activationDuration = 0.5;

    camera_2.teleportAndLookAt(
      thePlayer.GetWorldPosition()
      + Vector(0, 0, 2)
      + thePlayer.GetWorldRight() * 2,

      ((RER_quest1)parent.quest_entry).constants.chapter_4_troll_position
    );

    camera_2.start();

    (new RER_RandomDialogBuilder in thePlayer).start()
    .dialog(new REROL_a_man_eating_troll in thePlayer, true)
    .play();

    camera_2.Stop();
  }
}