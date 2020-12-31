
// When the player is near a noticeboard, if the noticeboard has no contracts left
// it will start a CONTRACT encounter
class RER_ListenerNoticeboardContract extends RER_EventsListener {
  // if this boolean is set to true, it means the event triggered when Geralt was
  // near a noticeboard. So if it is true the event will instead wait for Geralt
  // to leave the city instead of looking for nearby noticeboards
  private var was_triggered: bool;

  // this is the position that will be stored when the event will first be
  // triggered. This is the position near the noticeboard.
  // It is used to draw a cone from the noticeboard to the player's position
  // outside the city and to spawn the contract in this cone.
  private var position_near_noticeboard: Vector;

  // if set to true, the next time the event interval will run it will trigger
  // the noticeboard cutscene.
  private var force_noticeboard_event: bool;
  
  var time_before_other_spawn: float;
  default time_before_other_spawn = 0;

  var menu_slider_value: float;
  var trigger_chance: float;
  var settlement_radius_check: float;
  var distance_trigger_chance_scale: float;
  var minimum_distance_multiplier: float;
  var maximum_distance_multiplier: float;

  var allow_automatic_cutscene: bool;

  var last_known_position_in_city: Vector;

  public latent function loadSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    this.menu_slider_value = StringToFloat(
      inGameConfigWrapper
      .GetVarValue('RERevents', 'eventNoticeboardContract')
    );

    this.allow_automatic_cutscene = inGameConfigWrapper
      .GetVarValue('RERevents', 'eventNoticeboardContractAutomaticCutscene');

    this.trigger_chance = 100 - this.menu_slider_value;
    this.settlement_radius_check = this.menu_slider_value;
    this.distance_trigger_chance_scale = 50 + this.menu_slider_value;
    this.minimum_distance_multiplier = this.menu_slider_value / 200 + 1.2;
    this.maximum_distance_multiplier = this.menu_slider_value / 100 + 1.2;

    // always set it to true to listen to the keybind
    this.active = true;

    theInput.RegisterListener(this, 'OnRERforceNoticeboardEvent', 'OnRERforceNoticeboardEvent');
  }

  event OnRERforceNoticeboardEvent(action: SInputAction) {
    if (IsPressed(action)) {
      this.force_noticeboard_event = true;
    }
  }

  public latent function onInterval(was_spawn_already_triggered: bool, master: CRandomEncounters, delta: float, chance_scale: float): bool {
    var has_spawned: bool;

    if (this.time_before_other_spawn > 0) {
      time_before_other_spawn -= delta;
    }

    if (isPlayerBusy()) {
      return false;
    }

    if (this.was_triggered) {
      has_spawned = this.waitForPlayerToLeaveCity(master, chance_scale);
    }
    else {
      has_spawned = this.lookForNearbyNoticeboards(master);
    }

    return has_spawned;
  }

  private latent function waitForPlayerToLeaveCity(master: CRandomEncounters, chance_scale: float): bool {
    var meters_from_city: float;

    if (master.rExtra.isPlayerInSettlement(this.settlement_radius_check)) {
      // NDEBUG("in settlement, radius = " + this.settlement_radius_check);

      this.last_known_position_in_city = thePlayer.GetWorldPosition();
      
      return false;
    }

    meters_from_city = VecDistance(this.last_known_position_in_city, thePlayer.GetWorldPosition());

    // NDEBUG("" + this.trigger_chance * chance_scale + meters_from_city / this.distance_trigger_chance_scale);

    // every 100 meters walked add 1%. One percent here is huge, due to the low
    // default value (around 1.5%)
    if (this.force_noticeboard_event || RandRangeF(100) < this.trigger_chance * chance_scale + meters_from_city / this.distance_trigger_chance_scale) {
      LogChannel('modRandomEncounters', "RER_ListenerNoticeboardContract - triggered encounter");

      this.createContractEncounter(master);

      // so that it can start from a noticeboard again
      this.was_triggered = false;

      return true;
    }

    return false;
  }

  private latent function createContractEncounter(master: CRandomEncounters) {
    var contract_position: Vector;
    var player_distance_from_noticeboard: float;
    var position_attempts: int;
    var found_position: bool;

    player_distance_from_noticeboard = VecDistance(thePlayer.GetWorldPosition(), this.position_near_noticeboard);

    for (position_attempts = 0; position_attempts < 10; position_attempts += 1) {
      contract_position = this.position_near_noticeboard + VecConeRand(
        VecHeading(thePlayer.GetWorldPosition() - this.position_near_noticeboard),
        25, // small angle to increase the chances the player will see the encounter
        player_distance_from_noticeboard * this.minimum_distance_multiplier,
        player_distance_from_noticeboard * this.maximum_distance_multiplier
      );

      if (getGroundPosition(contract_position)) {
        found_position = true;

        break;
      }
    }

    if (!found_position) {
      contract_position = thePlayer.GetWorldPosition();
    }

    createRandomCreatureContract(master, new RER_BestiaryEntryNull in this, contract_position);
  }

  private latent function lookForNearbyNoticeboards(master: CRandomEncounters): bool {
    // to avoid triggering this event too frequently
    if (this.time_before_other_spawn > 0) {
      return false;
    }

    // cancel only if the event wasn't forced
    if (!this.allow_automatic_cutscene && !this.force_noticeboard_event) {
      return false;
    }

    if (this.isThereEmptyNoticeboardNearby()) {
      LogChannel('modRandomEncounters', "RER_ListenerNoticeboardContract - triggered nearby noticeboard");

      this.time_before_other_spawn += master.events_manager.internal_cooldown;

      this.position_near_noticeboard = thePlayer.GetWorldPosition();

      // play a few consecutive oneliners and a camera scene targeting the nearest noticeboard
      // if one exists and if camera scenes aren't disabled from the menu
      this.startNoticeboardCutscene(master);

      this.was_triggered = true;
    }

    return false;
  }

  private latent function startNoticeboardCutscene(master: CRandomEncounters) {
    var scene: RER_CameraScene;
    var camera: RER_StaticCamera;
    var noticeboards: array<CGameplayEntity>;
    var noticeboard: CGameplayEntity;
    var look_at_position: Vector;

    noticeboards = this.getNearbyNoticeboards();

    if (noticeboards.Size() == 0) {
      return;
    }

    noticeboard = noticeboards[0];
    
    if( !master.settings.disable_camera_scenes ) {
      REROL_should_scour_noticeboards(true);
      playNoticeboardCameraScene(noticeboard);
    }
    else {
      REROL_should_scour_noticeboards(false);
    }

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
    // else {
    //   REROL_ill_take_the_contract();
    // }
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

  private function isThereEmptyNoticeboardNearby(): bool {
    var noticeboards: array<CGameplayEntity>;
    var current_noticeboard: W3NoticeBoard;
    var i: int;

    noticeboards = this.getNearbyNoticeboards();

    // no noticeboad nearby, we can leave
    if (noticeboards.Size() == 0) {
      return false;
    }

    if (this.force_noticeboard_event) {
      this.force_noticeboard_event = false;

      return true;
    }

    for (i = 0; i < noticeboards.Size(); i += 1) {
      if ((W3NoticeBoard)noticeboards[i]) {
        current_noticeboard = (W3NoticeBoard)noticeboards[i];

        if (!current_noticeboard.HasAnyQuest()) {
          return true;
        }
      }
    }
    
    return false;
  }
}
