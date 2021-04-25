state Running in RER_Q1_chapter0 extends BaseChapter {
  event OnEnterState(previous_state_name: name) {
    NLOG("Chapter 1 Running");
    this.Running_main();
  }

  entry function Running_main() {
    var interactive_point: SU_InteractivePoint;
    var position: Vector;
    var template: CEntityTemplate;

    template = (CEntityTemplate)LoadResourceAsync(
      "dlc\dlcsharedutils\data\su_interactive_point.w2ent",
      true
    );

    position = ((RER_quest1)parent.quest_entry)
      .constants
      .chapter0_geralt_position_scene;

    interactive_point = (SU_InteractivePoint)theGame.CreateEntity(
      template,
      position,
      thePlayer.GetWorldRotation()
    );

    this.waitUntilInteraction((CPeristentEntity)interactive_point);
    this.playScene();
    parent.quest_entry.completeCurrentChapterAndGoToNext();
  }

  latent function playScene() {
    var camera: SU_StaticCamera;
    var camera_1: SU_StaticCamera;
    var player_position: Vector;
    var camera_position: Vector;

    camera_position = ((RER_quest1)parent.quest_entry)
      .constants
      .chapter0_camera_position_scene_start;

    player_position = ((RER_quest1)parent.quest_entry)
        .constants
        .chapter0_geralt_position_scene;

    camera = SU_getStaticCamera();
    camera.fadeStartDuration = 1.5;
    camera.fadeEndDuration = 1.5;
    camera.teleportAndLookAt(camera_position, player_position);

    // thePlayer.Teleport(player_position);
    thePlayer.PlayerStartAction( PEA_InspectMid );
    // camera.start();

    camera_1 = SU_getStaticCamera();
    camera_1.activationDuration = 15;
    camera_1.deactivationDuration = 1.5;
    camera_position = ((RER_quest1)parent.quest_entry)
      .constants
      .chapter0_camera_position_scene_end;

    camera_1.teleportAndLookAt(camera_position, player_position);
    // camera_1.start();

    (new RER_RandomDialogBuilder in thePlayer).start()
    .dialog(new REROL_feather_broken_there_was_fight in thePlayer, true)
    .play();

    // thePlayer.PlayerStopAction( PEA_InspectMid );
    Sleep(0.5);
    thePlayer.PlayerStartAction( PEA_InspectLow );

    (new RER_RandomDialogBuilder in thePlayer).start()
    .dialog(new REROL_data_ground_splattered_with_blood in thePlayer, true)
    .play();

    thePlayer.PlayerStopAction( PEA_InspectLow );
    
    (new RER_RandomDialogBuilder in thePlayer).start()
    .dialog(new REROL_data_trail_goes_on in thePlayer, true)
    .play();

    
    Sleep(0.25);
    // camera_1.Stop();


    Sleep(2);
  }
}