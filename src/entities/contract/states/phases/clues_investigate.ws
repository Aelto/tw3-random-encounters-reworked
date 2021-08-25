
// This phase places clues on the ground and sometimes creatures at the previous
// checkpoint. It waits for the player to enter the radius and then enters in
// combat or in PhasePicker if there is no creature.
state CluesInvestigate in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State CluesInvestigate");

    this.CluesInvestigate_Main();
  }

  entry function CluesInvestigate_Main() {
    this.createClues();
    this.playStatingOnelinerAndCameraScene();
    RER_tutorialTryShowContract();
    this.waitUntilPlayerReachesFirstClue();
    this.createLastClues();
    this.waitUntilPlayerReachesLastClue();
    
    this.CluesInvestigate_GotoNextState();
  }

  latent function playStatingOnelinerAndCameraScene() {
    if (!parent.started_from_noticeboard) {
      return;
    }

    REROL_where_will_i_find_this_monster();
    parent.playContractEncounterCameraScene(this.investigation_center_position);
  }

  var investigation_center_position: Vector;
  var investigation_radius: int;
  default investigation_radius = 15;

  var has_monsters_with_clues: bool;

  var eating_animation_slot: CAIPlayAnimationSlotAction;

  latent function createClues() {
    var max_number_of_clues: int;
    var current_clue_position: Vector;
    var i: int;

    this.investigation_center_position = parent.previous_phase_checkpoint;

    // 1. we place the clues randomly
    // 1.1 first by placing the corpses
    max_number_of_clues = RandRange(20, 10);

    for (i = 0; i < max_number_of_clues; i += 1) {
      current_clue_position = this.investigation_center_position 
        + VecRingRand(0, this.investigation_radius);

      FixZAxis(current_clue_position);

      parent
        .corpse_maker
        .addTrackHere(current_clue_position, VecToRotation(VecRingRand(1, 2)));
    }

    // 1.2 then we place some random tracks
    max_number_of_clues = RandRange(50, 30) / parent.master.settings.foottracks_ratio;

    for (i = 0; i < max_number_of_clues; i += 1) {
      current_clue_position = this.investigation_center_position 
        + VecRingRand(0, this.investigation_radius);

      FixZAxis(current_clue_position);

      parent
        .trail_maker
        .addTrackHere(current_clue_position, VecToRotation(VecRingRand(1, 2)));
    }

    // 1.3 then we place blood
    max_number_of_clues = RandRange(25, 10);

    for (i = 0; i < max_number_of_clues; i += 1) {
      current_clue_position = this.investigation_center_position 
        + VecRingRand(0, this.investigation_radius);

      FixZAxis(current_clue_position);

      parent
        .blood_maker
        .addTrackHere(current_clue_position, VecToRotation(VecRingRand(1, 2)));
    }

    // 2. we play a camera scene after we created all the clues.
    //    if set to true, will play a oneliner and camera scene when the
    //    investigation position is finally determined. Meaning, now.
    //    the cutscene plays only if the contract is close enough from the player
    //    camera scene plays if above condition is met and camera scenes are
    //    not disabled from the menu
    // TODO:
    if (!parent.started_from_noticeboard) {
      this.startOnSpawnCutscene();
    }

    // 3. there is a chance necrophages are feeding on the corpses
    if (RandRange(10) < 6) {
      this.addMonstersWithClues();
    }
  }

  private latent function startOnSpawnCutscene() {
    var minimum_spawn_distance: float;

    minimum_spawn_distance = parent.master.settings.minimum_spawn_distance * 1.5;

    if (VecDistanceSquared(thePlayer.GetWorldPosition(), this.investigation_center_position) > minimum_spawn_distance * minimum_spawn_distance) {
      return;
    }

    if (parent.master.settings.geralt_comments_enabled) {
      REROL_smell_of_a_rotting_corpse(true);
    }

    if (!parent.master.settings.disable_camera_scenes
    && parent.master.settings.enable_action_camera_scenes) {
      playCameraSceneOnSpawn();
    }
  }

  private latent function playCameraSceneOnSpawn() {
    var scene: RER_CameraScene;
    var camera: RER_StaticCamera;
    var look_at_position: Vector;

    // where the camera is placed
    scene.position_type = RER_CameraPositionType_ABSOLUTE;
    scene.position = theCamera.GetCameraPosition() + Vector(0.3, 0, 1);

    // where the camera is looking
    scene.look_at_target_type = RER_CameraTargetType_STATIC;
    look_at_position = this.investigation_center_position;
    scene.look_at_target_static = look_at_position;

    scene.velocity_type = RER_CameraVelocityType_FORWARD;
    scene.velocity = Vector(0.001, 0.001, 0);

    scene.duration = 2;
    scene.position_blending_ratio = 0.01;
    scene.rotation_blending_ratio = 0.01;

    camera = RER_getStaticCamera();
    
    camera.playCameraScene(scene, true);
  }

  private latent function addMonstersWithClues() {
    var monsters_bestiary_entry: RER_BestiaryEntry;
    var created_entities: array<CEntity>;
    var i: int;

    // 1. pick the type of monsters we'll add near the clues
    //    it's either necropages or Wild hunt soldiers if
    //    the bestiary type for this encounter is Wild Hunt
    if (parent.bestiary_entry.type == CreatureWILDHUNT) {
      monsters_bestiary_entry = parent
        .master
        .bestiary
        .entries[CreatureWILDHUNT];

      this.addWildHuntClues();
    }
    else {
      monsters_bestiary_entry = parent
        .master
        .bestiary
        .entries[CreatureGHOUL];
    }

    this.has_monsters_with_clues = true;

    // mainly used for the necrophages
    this.eating_animation_slot = new CAIPlayAnimationSlotAction in this;
    this.eating_animation_slot.OnCreated();
    this.eating_animation_slot.animName = 'exploration_eating_loop';
    this.eating_animation_slot.blendInTime = 1.0f;
    this.eating_animation_slot.blendOutTime = 1.0f;  
    this.eating_animation_slot.slotName = 'NPC_ANIM_SLOT';

    // 2. we spawn the monsters
    created_entities = monsters_bestiary_entry
      .spawn(
        parent.master,
        parent.previous_phase_checkpoint,,,
        parent.entity_settings.allow_trophies,
        EncounterType_CONTRACT,
        false // because they're put in a passive state it is safer to make them
        // as not persistent
      );

    for (i = 0; i < created_entities.Size(); i += 1) {
      parent.entities.PushBack(created_entities[i]);
    }
  }

  private var rifts: array<CRiftEntity>;

  private latent function addWildHuntClues() {
    var portal_template: CEntityTemplate;
    var number_of_rifts: int;
    var rift: CRiftEntity;
    var i: int;

    number_of_rifts = RandRange(3, 1);

    portal_template = parent.master.resources.getPortalResource();
    for (i = 0; i < number_of_rifts; i += 1) {
      rift = (CRiftEntity)theGame.CreateEntity(
        portal_template,
        this.investigation_center_position + VecRingRand(0, this.investigation_radius)
      );

      rift.ActivateRift();

      this.rifts.PushBack(rift);
    }
  }

  latent function waitUntilPlayerReachesFirstClue() {
    var distance_from_player: float;
    var has_set_weather_snow: bool;
    var can_show_markers: bool;
    var map_pin: SU_MapPin;
    
    can_show_markers = theGame.GetInGameConfigWrapper()
      .GetVarValue('RERoptionalFeatures', 'RERmarkersContractFirstPhase');
    
    has_set_weather_snow = false;

    // 1. first we wait until the player is in the investigation radius
    if (can_show_markers) {
      map_pin = new SU_MapPin in thePlayer;
      map_pin.tag = "RER_contract_target";
      map_pin.position = this.investigation_center_position;
      map_pin.description = GetLocStringByKey("rer_mappin_regular_description");
      map_pin.label = GetLocStringByKey("rer_mappin_regular_title");
      map_pin.type = "TreasureQuest";
      map_pin.radius = 10;
      map_pin.region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());
      map_pin.appears_on_minimap = theGame.GetInGameConfigWrapper()
          .GetVarValue('RERoptionalFeatures', 'RERminimapMarkerGenericObjectives');

      thePlayer.addCustomPin(map_pin);
    }

    do {
      distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), this.investigation_center_position);

      if (this.has_monsters_with_clues) {
        if (parent.hasOneOfTheEntitiesGeraltAsTarget()) {
          break;
        }

        if (parent.bestiary_entry.type != CreatureWILDHUNT) {
          this.playEatingAnimationNecrophages();
        }

        // if the chosen type is the wildhunt and there are wild hunt members
        // the weather should be snowy.
        if (parent.bestiary_entry.type == CreatureWILDHUNT
        && !has_set_weather_snow) {

          if (distance_from_player < this.investigation_radius * this.investigation_radius * 3) {
            RequestWeatherChangeTo('WT_Snow', 7, false);

            REROL_air_strange_and_the_mist(false);
            has_set_weather_snow = true;
          }
        }
      }

      Sleep(0.5);
    } while (distance_from_player > this.investigation_radius * this.investigation_radius * 1.5);

    if (can_show_markers) {
      SU_removeCustomPinByPosition(this.investigation_center_position);
    }

    // 2. once the player is in the radius, we play sone oneliners
    //    cannot play if there were necrophages around the corpses.
    if (this.has_monsters_with_clues) {
      if (parent.bestiary_entry.type == CreatureWILDHUNT) {
        REROL_the_wild_hunt();
      }
      else if (!parent.areAllEntitiesDead()) {
        REROL_necrophages_great();
      }

      this.makeNecrophagesTargetPlayer();

      this.waitUntilAllEntitiesAreDead();

      RequestWeatherChangeTo('WT_Clear',30,false);

      Sleep(2);

      if (parent.bestiary_entry.type == CreatureWILDHUNT) {
        REROL_wild_hunt_killed_them();
      }
      else {
        REROL_clawed_gnawed_not_necrophages();
      }

      parent.entities.Clear();

    }
    else {
      if (RandRange(10) < 2) {
        REROL_so_many_corpses();

        // a small sleep to leave some space between the oneliners
        Sleep(0.5);
      }
      REROL_died_recently();
    }

    REROL_should_look_around(true);
  }

  private latent function playEatingAnimationNecrophages() {
    var i: int;

    for (i = 0; i < parent.entities.Size(); i += 1) {
      ((CActor)parent.entities[i]).SetTemporaryAttitudeGroup(
        'q104_avallach_friendly_to_all',
        AGP_Default
      );

      ((CNewNPC)parent.entities[i]).ForgetAllActors();

      ((CActor)parent.entities[i]).ForceAIBehavior(this.eating_animation_slot, BTAP_Emergency);
    }
  }

  private latent function makeNecrophagesTargetPlayer() {
    var i: int;

    for (i = 0; i < parent.entities.Size(); i += 1) {
      ((CActor)parent.entities[i]).SetTemporaryAttitudeGroup(
        'monsters',
        AGP_Default
      );

      ((CNewNPC)parent.entities[i]).NoticeActor(thePlayer);
    }
  }

  private latent function waitUntilAllEntitiesAreDead() {
    while (!parent.areAllEntitiesDead() || thePlayer.IsInCombat()) {
      Sleep(0.4);
    }

    parent.entities.Clear();
  }

  var investigation_last_clues_position: Vector;

  latent function createLastClues() {
    var number_of_foot_paths: int;
    var current_track_position: Vector;
    var i: int;
    
    LogChannel('modRandomEncounters', "creating Last clues");

    // 1. we search for a random position around the site.
    this.investigation_last_clues_position = this.investigation_center_position + VecRingRand(
      this.investigation_radius * 2,
      this.investigation_radius * 1.6
    );

    // 2. we place the last clues, tracks leaving the investigation site
    // from somewhere in the investigation radius to the last clues position.
    // We do this multiple times
    number_of_foot_paths = parent.number_of_creatures;

    for (i = 0; i < number_of_foot_paths; i += 1) {
      // 2.1 we find a random position in the investigation radius
      current_track_position = this.investigation_center_position + VecRingRand(
        0,
        this.investigation_radius
      );

      // 2.2 we start drawing the trail
      parent
        .trail_maker
        .drawTrail(
          current_track_position,
          this.investigation_last_clues_position,
          6, // the radius
          ,, // no details used
          true, // uses the failsafe
          parent.master.settings.use_pathfinding_for_trails
        );
    }
  }

  latent function waitUntilPlayerReachesLastClue() {
    var distance_from_player: float;
    var has_played_oneliner: bool;

    has_played_oneliner = false;

    Sleep(1);

    // 1. first we wait until the player is near the last investigation clues
    do {
      distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), this.investigation_last_clues_position);

      if (!has_played_oneliner && RandRange(10000) < 0.00001) {
        REROL_ground_splattered_with_blood();

        has_played_oneliner = true;
      }

      Sleep(0.2);
    } while (distance_from_player > 15 * 15);

    // 2. once the player is near, we play some oneliners
    if (RandRange(10) < 5) {
      REROL_wonder_clues_will_lead_me();
    } else {
      REROL_came_through_here();
    }
  }

  latent function CluesInvestigate_GotoNextState() {
    parent.previous_phase_checkpoint = parent.trail_maker.getLastPlacedTrack().GetWorldPosition();
    
    parent.GotoState('PhasePick');
  }
}
