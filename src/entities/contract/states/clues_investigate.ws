
state CluesInvestigate in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State CluesInvestigate");

    this.CluesInvestigate_Main();
  }

  entry function CluesInvestigate_Main() {
    this.pickRandomBestiaryEntry();
    this.createClues();
    this.waitUntilPlayerReachesFirstClue();
    this.createLastClues();
    this.waitUntilPlayerReachesLastClue();
    this.CluesInvestigate_goToNextState();
  }

  latent function pickRandomBestiaryEntry() {
    parent.chosen_bestiary_entry = parent
      .master
      .bestiary
      .getRandomEntryFromBestiary(parent.master, EncounterType_CONTRACT);

    parent.number_of_creatures = rollDifficultyFactor(
      parent.chosen_bestiary_entry.template_list.difficulty_factor,
      parent.master.settings.selectedDifficulty,
      parent.master.settings.enemy_count_multiplier
    );

    LogChannel('modrandomencounters', "chosen bestiary entry" + parent.chosen_bestiary_entry.type);
  }

  var investigation_radius: int;
  default investigation_radius = 15;

  var has_monsters_with_clues: bool;

  var eating_animation_slot: CAIPlayAnimationSlotAction;

  latent function createClues() {
    var found_initial_position: bool;
    var max_number_of_clues: int;
    var current_clue_position: Vector;
    var trail_resources: array<CEntityTemplate>;
    var trail_ratio: int;
    var i: int;
    
    // 1. first find the place where the clues will be created
    found_initial_position = getRandomPositionBehindCamera(
      parent.investigation_center_position,
      parent.master.settings.minimum_spawn_distance
      + parent.master.settings.spawn_diameter,
      parent.master.settings.minimum_spawn_distance,
      10
    );

    if (!found_initial_position) {
      parent.GotoState('Ending');

      return;
    }

    // 2. load all the needed resources
    switch (parent.chosen_bestiary_entry.type) {
      case CreatureBARGHEST :
      case CreatureWILDHUNT :
      case CreatureNIGHTWRAITH :
      case CreatureNOONWRAITH :
      case CreatureWRAITH :
        // these are the type of creatures where we use fog
        // so we increase the ratio to save performances.
        trail_ratio = 4;

      default :
        trail_ratio = 1;
    }

    parent.trail_maker = new RER_TrailMaker in this;
    
    trail_resources.PushBack(
      getTracksTemplateByCreatureType(
        parent.chosen_bestiary_entry.type
      )
    );

    parent.trail_maker.init(
      trail_ratio
      600,
      trail_resources
    );

    parent.blood_maker = new RER_TrailMaker in this;
    parent.blood_maker.init(
      1
      100,
      parent
        .master
        .resources
        .getBloodSplatsResources()
    );

    parent.corpse_maker = new RER_TrailMaker in this;
    parent.corpse_maker.init(
      1,
      50,
      parent
        .master
        .resources
        .getCorpsesResources()
    )


    // 3. we place the clues randomly
    // 3.1 first by placing the corpses
    max_number_of_clues = RandRange(20, 10);

    for (i = 0; i < max_number_of_clues; i += 1) {
      current_clue_position = parent.investigation_center_position 
        + VecRingRand(0, this.investigation_radius);

      FixZAxis(current_clue_position);

      parent
        .corpse_maker
        .addTrackHere(current_clue_position, VecToRotation(VecRingRand(1, 2)));
    }

    // 3.2 then we place some random tracks
    max_number_of_clues = RandRange(120, 60);

    for (i = 0; i < max_number_of_clues; i += 1) {
      current_clue_position = parent.investigation_center_position 
        + VecRingRand(0, this.investigation_radius);

      FixZAxis(current_clue_position);

      parent
        .trail_maker
        .addTrackHere(current_clue_position, VecToRotation(VecRingRand(1, 2)));
    }

    // 3.3 then we place lots of blood
    max_number_of_clues = RandRange(100, 200);

    for (i = 0; i < max_number_of_clues; i += 1) {
      current_clue_position = parent.investigation_center_position 
        + VecRingRand(0, this.investigation_radius);

      FixZAxis(current_clue_position);

      parent
        .blood_maker
        .addTrackHere(current_clue_position, VecToRotation(VecRingRand(1, 2))));
    }

    // 4. there is a chance necrophages are feeding on the corpses
    if (RandRange(10) < 6) {
      this.addMonstersWithClues();
    }
  }

  private latent function addMonstersWithClues() {
    var monsters_bestiary_entry: RER_BestiaryEntry;
    var created_entities: array<CEntity>;
    var i: int;

    // 1. pick the type of monsters we'll add near the clues
    //    it's either necropages or Wild hunt soldiers if
    //    the bestiary type for this encounter is Wild Hunt
    if (parent.chosen_bestiary_entry.type == CreatureWILDHUNT) {
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
        master,
        parent.investigation_center_position,,,
        parent.allow_trophy
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
        parent.investigation_center_position + VecRingRand(0, this.investigation_radius)
      );

      rift.ActivateRift();

      this.rifts.PushBack(rift);
    }
  }

  latent function waitUntilPlayerReachesFirstClue() {
    var distance_from_player: float;

    var has_set_weather_snow: bool;
    
    has_set_weather_snow = false;

    // 1. first we wait until the player is in the investigation radius
    do {
      distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), parent.investigation_center_position);

      if (this.has_monsters_with_clues) {
        if (parent.hasOneOfTheEntitiesGeraltAsTarget()) {
          break;
        }

        if (parent.chosen_bestiary_entry.type != CreatureWILDHUNT) {
          this.playEatingAnimationNecrophages();
        }

        // if the chosen type is the wildhunt and there are wild hunt members
        // the weather should be snowy.
        if (parent.chosen_bestiary_entry.type == CreatureWILDHUNT
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

    // 2. once the player is in the radius, we play sone oneliners
    //    cannot play if there were necrophages around the corpses.
    if (this.has_monsters_with_clues) {
      if (parent.chosen_bestiary_entry.type == CreatureWILDHUNT) {
        REROL_the_wild_hunt();
      }
      else if (!parent.areAllEntitiesDead()) {
        REROL_necrophages_great();
      }

      this.makeNecrophagesTargetPlayer();

      this.waitUntilAllEntitiesAreDead();

      RequestWeatherChangeTo('WT_Clear',30,false);

      Sleep(2);

      if (parent.chosen_bestiary_entry.type == CreatureWILDHUNT) {
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

    REROL_should_look_around();
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
    while (!parent.areAllEntitiesDead()) {
      Sleep(0.4);
    }

    parent.entities.Clear();
  }


  latent function createLastClues() {
    var number_of_foot_paths: int;
    var current_track_position: Vector;
    var i: int;
    
    LogChannel('modRandomEncounters', "creating Last clues");

    // 1. we search for a random position around the site.
    parent.investigation_last_clues_position = parent.investigation_center_position + VecRingRand(
      this.investigation_radius * 2,
      this.investigation_radius * 1.6
    );

    // 2. we place the last clues, tracks leaving the investigation site
    // from somewhere in the investigation radius to the last clues position.
    // We do this multiple times
    number_of_foot_paths = parent.number_of_creatures;

    for (i = 0; i < number_of_foot_paths; i += 1) {
      // 2.1 we find a random position in the investigation radius
      current_track_position = parent.investigation_center_position + VecRingRand(
        0,
        this.investigation_radius
      );

      // 2.2 we start drawing the trail
      parent
        .trail_maker
        .drawTrail(
          current_track_position,
          parent.investigation_last_clues_position,
          6, // the radius
          ,, // no details used
          true // uses the failsafe
        )
    }
  }

  latent function waitUntilPlayerReachesLastClue() {
    var distance_from_player: float;
    var has_played_oneliner: bool;

    has_played_oneliner = false;

    Sleep(1);

    // 1. first we wait until the player is near the last investigation clues
    do {
      distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), parent.investigation_last_clues_position);

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

  latent function CluesInvestigate_goToNextState() {
    parent.GotoState('CluesFollow');
  }
}
