
state CluesFollow in RandomEncountersReworkedContractEntity {

  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State CluesFollow");

    this.CluesFollow_Main();
  }

  entry function CluesFollow_Main() {
    this.createFinalPoint();
    this.createCluesPath();

    if (parent.has_combat_looped) {
      REROL_another_trail();
      Sleep(1);
      REROL_should_look_around();
    }

    this.waitUntilPlayerReachesFinalPoint();
    this.CluesInvestigate_goToNextState();
  }
  
  var final_point_max_radius: float;
  default final_point_max_radius = 200;

  var final_point_min_radius: float;
  default final_point_min_radius = 150;

  // the radius of the final point
  var final_point_personal_space: float;
  default final_point_personal_space = 5;

  var monsters_density: float;
  default monsters_density = 0.01;

  latent function createFinalPoint() {
    // used in 1.
    var max_attempt_count: int;
    var search_heading: float;
    var current_search_position: Vector;
    var found_final_position: bool;
    var i: int;

    // used in 2.
    var created_entities: array<CEntity>;


    // 1. before creating the clues we search for the position of the final
    // point. It must be a large area with a clear path to it
    max_attempt_count = 10;
    found_final_position = false;

    search_heading = VecHeading(parent.investigation_last_clues_position - parent.investigation_center_position);

    for (i = 0; i < max_attempt_count; i += 1) {

      // 1.1 if we're in a case where the combat has looped, we search around the
      // last point found by this state: `parent.final_point_position`
      if (parent.has_combat_looped) {

        // here it's a VecRingRand instead of VecCodeRand
        current_search_position = parent.last_clues_follow_final_position
          + VecRingRand(this.final_point_min_radius, this.final_point_max_radius);
      }
      else {
        current_search_position = parent.investigation_last_clues_position
          + VecConeRand(search_heading, 270, this.final_point_min_radius, this.final_point_max_radius);
      }

      if (getGroundPosition(current_search_position, this.final_point_personal_space)) {
        parent.final_point_position = current_search_position;
        found_final_position = true;

        break;
      }
    }

    LogChannel('modRandomEncounters', "found final position = " + found_final_position);

    if (!found_final_position) {
      parent.endContract();

      return;
    }

    // 2. now that we found the final position we start placing monsters there.
    created_entities = parent
      .chosen_bestiary_entry
      .spawn(
        parent.master,
        parent.final_point_position,
        parent.number_of_creatures,
        this.monsters_density,
        parent.allow_trophy
      );

    for (i = 0; i < created_entities.Size(); i += 1) {
      parent.entities.PushBack(created_entities[i]);
    }
  }

  var chance_to_add_clues_in_path: float;
  default chance_to_add_clues_in_path = 1;

  latent function createCluesPath() {
    var number_of_foot_paths: int;
    var current_track_position: Vector;
    var corpse_and_blood_details_maker: RER_CorpseAndBloodTrailDetailsMaker;
    var i: int;

    // 1. we search how many paths we should draw
    number_of_foot_paths = Max(parent.entities.Size(), 1);

    corpse_and_blood_details_maker = new RER_CorpseAndBloodTrailDetailsMaker in this;
    corpse_and_blood_details_maker.corpse_maker = parent.corpse_maker;
    corpse_and_blood_details_maker.blood_maker = parent.blood_maker;

    // 2. for each foot path
    for (i = 0; i < number_of_foot_paths; i += 1) {
      // 2.1 we find a random position around the last clues position
      if (parent.has_combat_looped) {
        current_track_position = parent.last_clues_follow_final_position + VecRingRand(
          0,
          2
        );
      }
      else {
        current_track_position = parent.investigation_last_clues_position + VecRingRand(
          0,
          2
        );
      }

      // 2.2 we start drawing the trail
      parent
        .trail_maker
        .drawTrail(
          current_track_position,
          parent.final_point_position,
          6, // the radius
          corpse_and_blood_details_maker,
          this.chance_to_add_clues_in_path,
          true // uses the failsafe
        );
    }
  }

  var creatures_aggro_radius: float;
  default creatures_aggro_radius = 400; // 20 * 20

  latent function waitUntilPlayerReachesFinalPoint() {
    var distance_from_player: float;
    var has_played_oneliner: bool;

    has_played_oneliner = false;

    distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), parent.final_point_position); 

    // 1. first we wait until the player has reached the final point
    while (distance_from_player > this.creatures_aggro_radius && !parent.hasOneOfTheEntitiesGeraltAsTarget()) {
      SleepOneFrame();

      if (!has_played_oneliner && RandRange(10000) < 0.00001) {
        REROL_miles_and_miles_and_miles();

        has_played_oneliner = true;
      }

      this.keepCreaturesOnPoint();
      
      distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), parent.final_point_position); 
    }

    // 2. then we play some oneliners
    REROL_there_you_are();
  }

  private function keepCreaturesOnPoint() {
    var distance_from_point: float;
    var new_position: Vector;
    var i: int;

    for (i = 0; i < parent.entities.Size(); i += 1) {
      distance_from_point = VecDistanceSquared(
        parent.entities[i].GetWorldPosition(),
        parent.final_point_position
      );

      if (distance_from_point > this.creatures_aggro_radius) {
        new_position = VecInterpolate(
          parent.entities[i].GetWorldPosition(),
          parent.final_point_position,
          1 / this.creatures_aggro_radius
        );

        FixZAxis(new_position);

        if (new_position.Z < parent.entities[i].GetWorldPosition().Z) {
          new_position.Z = parent.entities[i].GetWorldPosition().Z;
        }

        parent
          .entities[i]
          .Teleport(new_position);
      }
    }
  }

  latent function createMidFollowAmbush() {}

  latent function CluesInvestigate_goToNextState() {
    // before leaving this state we store where the final position was.
    // It is useful if the combat loops because the next investigation will
    // start from this position now.
    parent.last_clues_follow_final_position = parent.final_point_position;

    parent.GotoState('Combat');
  }
}
