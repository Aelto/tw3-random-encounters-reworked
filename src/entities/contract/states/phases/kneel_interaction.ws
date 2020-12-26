
// This phase starts an animation and a oneliner instantly and then goes to
// the PhasePicker state.
state KneelInteraction in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State KneelInteraction");

    this.KneelInteraction_main();
  }

  entry function KneelInteraction_main() {
    parent.previous_phase_checkpoint = thePlayer.GetWorldPosition();

    this.KneelInteraction_createTracks();
    this.KneelInteraction_playAnimation();
    parent.GotoState('PhasePick');
  }

  latent function KneelInteraction_createTracks() {
    var max_number_of_clues: int;
    var current_clue_position: Vector;
    var i: int;

    max_number_of_clues = RandRange(8, 3);

    for (i = 0; i < max_number_of_clues; i += 1) {
      current_clue_position = parent.previous_phase_checkpoint 
        + VecRingRand(0, 5);

      FixZAxis(current_clue_position);

      parent
        .trail_maker
        .addTrackHere(current_clue_position, VecToRotation(VecRingRand(1, 2)));
    }

    // and we had a clue right on Geralt for the animation
    current_clue_position = parent.previous_phase_checkpoint + VecRingRand(0, 1);

    parent.trail_maker.addTrackHere(
      current_clue_position,
      thePlayer.GetWorldRotation()
    );
  }

  latent function KneelInteraction_playAnimation() {
    var monster_clue: RER_MonsterClue;

    REROL_mhm();
    Sleep(1);
    
    monster_clue = parent.trail_maker.getLastPlacedTrack();
    monster_clue.GotoState('Interacting');

    if (!parent.master.settings.disable_camera_scenes) {
      this.playCameraScene();
      Sleep(3);
    }
    else {
      Sleep(7);
    }
  }

  private latent function playCameraScene() {
    var scene: RER_CameraScene;
    var camera: RER_StaticCamera;
    var look_at_position: Vector;

    // where the camera is placed
    scene.position_type = RER_CameraPositionType_ABSOLUTE;
    scene.position = theCamera.GetCameraPosition() + Vector(2, 2, 1);

    // where the camera is looking
    scene.look_at_target_type = RER_CameraTargetType_STATIC;
    look_at_position = thePlayer.GetWorldPosition();
    scene.look_at_target_static = look_at_position;

    scene.velocity_type = RER_CameraVelocityType_FORWARD;
    scene.velocity = Vector(0.001, 0.001, 0);

    scene.duration = 2;
    scene.position_blending_ratio = 0.01;
    scene.rotation_blending_ratio = 0.01;

    camera = RER_getStaticCamera();
    
    camera.playCameraScene(scene, true);
  }
}
