state Running in RER_Q1_chapter1 extends BaseChapter {
  event OnEnterState(previous_state_name: name) {
    this.Running_main();
  }

  entry function Running_main() {
    var pin: SU_MapPin;

    if (!this.isPlayerInRegion("skellige")) {
      return;
    }

    this.waitForPlayerToReachPoint(
      ((RER_quest1)parent.quest_entry).constants.chapter1_geralt_position_scene,
      10
    );

    this.playScene();

    Sleep(2);

    parent.quest_entry.completeCurrentChapterAndGoToNext();
  }

  latent function playScene() {
    var camera_0: SU_StaticCamera;
    var camera_1: SU_StaticCamera;

    camera_0 = SU_getStaticCamera();

    camera_0.teleportAndLookAt(
      ((RER_quest1)parent.quest_entry).constants.chapter1_camera_position_scene_start,
      ((RER_quest1)parent.quest_entry).constants.chapter1_geralt_position_scene + Vector(0, 0, -10)
    );

    theGame.FadeOut(0.2);
    camera_0.start();
    theGame.FadeInAsync(0.4);

    thePlayer.TeleportWithRotation(
      ((RER_quest1)parent.quest_entry).constants.chapter1_geralt_position_scene,
      EulerAngles(0, 67.95, 0)
    );
    

    camera_1 = SU_getStaticCamera();
    camera_1.activationDuration = 10;
    camera_1.deactivationDuration = 1.5;

    camera_1.teleportAndLookAt(
      ((RER_quest1)parent.quest_entry).constants.chapter1_camera_position_scene_end,
      ((RER_quest1)parent.quest_entry).constants.chapter1_corpse_position
    );

    camera_1.start();

    thePlayer.PlayerStartAction( PEA_InspectHigh );
    Sleep(2);

    (new RER_RandomDialogBuilder in thePlayer).start()
    .dialog(new REROL_harpies_got_their_nest_here in thePlayer, true)
    .play();

    thePlayer.PlayerStopAction( PEA_InspectHigh );

    Sleep(7);

    camera_1.Stop();

  }
}