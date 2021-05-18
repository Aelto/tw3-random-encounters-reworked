
state Noticeboard in RER_contractManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    NLOG("RER_contractManager - state NOTICEBOARD");

    this.Noticeboard_main();
  }

  private var menu_distance_value: float;

  entry function Noticeboard_main() {
    var last_known_position_in_city: Vector;
    var distance_trigger_chance_scale: float;
    var position_when_it_started: Vector;
    var meters_from_city: float;
    var trigger_chance: float;
    var chance_scale: float;
    var roll_delay: float;

    this.menu_distance_value = 40;
    position_when_it_started = thePlayer.GetWorldPosition();

    while (thePlayer.IsActionBlockedBy(EIAB_Interactions, 'NoticeBoard')) {
      SleepOneFrame();
    }
    
    this.startNoticeboardCutscene(parent.master);
   
    // 1.
    // first we wait for the playe to leave the settlement.
    // by default it's a 50meters radius check
    while (parent.master.rExtra.isPlayerInSettlement(50)) {
      last_known_position_in_city = thePlayer.GetWorldPosition();

      Sleep(1);
    }

    // 2.
    // randomly roll to see if the contract should start
    trigger_chance = 100 - this.menu_distance_value;
    roll_delay = 0.5;
    distance_trigger_chance_scale = 50 + trigger_chance;

    // the 60 here represents 60 seconds. which means that a 50% trigger chance
    // means 50% chance to trigger every 60 seconds
    chance_scale = roll_delay / 60;

    while (true) {
      meters_from_city = VecDistance(
        last_known_position_in_city,
        thePlayer.GetWorldPosition()
      );

      if (RandRangeF(100) < trigger_chance * chance_scale + meters_from_city / distance_trigger_chance_scale) {
        break;
      }

      Sleep(0.5);
    }

    // 3. it triggered, start a contract
    this.createContractEncounter(position_when_it_started);
  }

  latent function createContractEncounter(position_when_it_started: Vector) {
    var player_distance_from_noticeboard: float;
    var minimum_distance_multiplier: float;
    var maximum_distance_multiplier: float;
    var contract_position: Vector;
    var contract_heading: float;
    var position_attempts: int;
    var found_position: bool;

    minimum_distance_multiplier = this.menu_distance_value / 200 + 1.2;
    maximum_distance_multiplier = this.menu_distance_value / 100 + 1.2;

    player_distance_from_noticeboard = VecDistance(thePlayer.GetWorldPosition(), position_when_it_started);

    for (position_attempts = 0; position_attempts < 10; position_attempts += 1) {
      contract_position = position_when_it_started + VecConeRand(
        VecHeading(thePlayer.GetWorldPosition() - position_when_it_started),
        25, // small angle to increase the chances the player will see the encounter
        player_distance_from_noticeboard * minimum_distance_multiplier,
        player_distance_from_noticeboard * maximum_distance_multiplier
      );

      if (getGroundPosition(contract_position)) {
        found_position = true;

        break;
      }
    }

    if (!found_position) {
      contract_position = thePlayer.GetWorldPosition();
    }

    contract_heading = VecHeading(contract_position - position_when_it_started);

    createRandomCreatureContractWithPositionAndHeading(parent.master, new RER_BestiaryEntryNull in this, contract_position, contract_heading);
    parent.GotoState('Waiting');
  }

  private latent function startNoticeboardCutscene(master: CRandomEncounters) {
    var noticeboards: array<CGameplayEntity>;
    var noticeboard: CGameplayEntity;
    var look_at_position: Vector;

    noticeboards = this.getNearbyNoticeboards();

    if (noticeboards.Size() == 0) {
      return;
    }

    noticeboard = noticeboards[0];

    RER_tutorialTryShowNoticeboard();
    
    // if( !master.settings.disable_camera_scenes ) {
    //   playNoticeboardCameraScene(noticeboard);
    // }

    if (RandRange(10) < 2) {
      REROL_unusual_contract();
    }

    Sleep(0.4);
    REROL_mhm();
    Sleep(0.1);

    if (RandRange(10) < 5) {
      REROL_ill_tend_to_the_monster();
    }
    else {
      REROL_i_accept_the_challenge();
    }
  }

  private latent function playNoticeboardCameraScene( noticeboard: CGameplayEntity ) {
    var scene: RER_CameraScene;
    var camera: RER_StaticCamera;
    var look_at_position: Vector;

    // where the camera is placed
    scene.position_type = RER_CameraPositionType_ABSOLUTE;
    scene.position = theCamera.GetCameraPosition() + Vector(0.3, 0, 1);

    // where the camera is looking
    scene.look_at_target_type = RER_CameraTargetType_STATIC;
    look_at_position = noticeboard.GetWorldPosition();
    FixZAxis(look_at_position);
    scene.look_at_target_static = look_at_position + Vector(0, 0, 0);

    scene.velocity_type = RER_CameraVelocityType_FORWARD;
    scene.velocity = Vector(0.001, 0.001, 0);

    scene.duration = 6;
    scene.position_blending_ratio = 0.01;
    scene.rotation_blending_ratio = 0.01;

    camera = RER_getStaticCamera();
    
    camera.playCameraScene(scene, true);
  }

  private function getNearbyNoticeboards(): array<CGameplayEntity> {
    var entities: array<CGameplayEntity>;

     // 'W3NoticeBoard' for noticeboards, 'W3FastTravelEntity' for signpost
    FindGameplayEntitiesInRange(
      entities,
      thePlayer,
      5, // range, we'll have to check if 50 is too big/small
      1, // max results
      , // tag: optional value
      FLAG_ExcludePlayer,
      , // optional value
      'W3NoticeBoard'
    );

    return entities;
  }
}