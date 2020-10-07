
state CluesFollow in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State CluesFollow");

    this.CluesFollow_Main();
  }

  entry function CluesFollow_Main() {
    this.createFinalPoint();
    this.createCluesPath();
    this.waitUntilPlayerReachesFinalPoint();
    this.CluesInvestigate_goToNextState();
  }

  var final_point_position: Vector;
  
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
    var creatures_templates: EnemyTemplateList;
    var group_positions: array<Vector>;
    var current_template: CEntityTemplate;
    var current_entity_template: SEnemyTemplate;
    var group_positions_index: int;
    var created_entity: CEntity;
    var j: int;


    // 1. before creating the clues we search for the position of the final
    // point. It must be a large area with a clear path to it
    max_attempt_count = 10;
    found_final_position = false;

    search_heading = VecHeading(parent.investigation_last_clues_position - parent.investigation_center_position);

    for (i = 0; i < max_attempt_count; i += 1) {
      current_search_position = parent.investigation_last_clues_position
        + VecConeRand(search_heading, 270, this.final_point_min_radius, this.final_point_max_radius);

      if (getGroundPosition(current_search_position, this.final_point_personal_space)) {
        this.final_point_position = current_search_position;
        found_final_position = true;

        break;
      }
    }

    LogChannel('modRandomEncounters', "found final position" + found_final_position);

    if (!found_final_position) {
      parent.GotoState('Ending');

      return;
    }

    // 2. now that we found the final position we start placing monsters there.
    creatures_templates = fillEnemyTemplateList(
      parent.chosen_bestiary_entry.template_list,
      parent.number_of_creatures,
      parent.master.settings.only_known_bestiary_creatures
    );

    group_positions = getGroupPositions(
      final_point_position,
      parent.number_of_creatures,
      this.monsters_density
    );

    for (i = 0; i < creatures_templates.templates.Size(); i += 1) {
      current_entity_template = creatures_templates.templates[i];

      if (current_entity_template.count > 0) {
        current_template = (CEntityTemplate)LoadResourceAsync(current_entity_template.template, true);

        for (j = 0; j < current_entity_template.count; j += 1) {
          created_entity = theGame.CreateEntity(
            current_template,
            group_positions[group_positions_index],
            thePlayer.GetWorldRotation()
          );

          ((CNewNPC)created_entity).SetLevel(
            getRandomLevelBasedOnSettings(parent.master.settings)
          );

          parent.entities.PushBack(created_entity);

          group_positions_index += 1;
        }
      }
    }

    if (!parent.master.settings.enable_encounters_loot) {
      parent.removeAllLoot();
    }

    // TODO: handle settings like trophies
  }

  latent function createCluesPath() {
    var number_of_foot_paths: int;
    var current_track_position: Vector;
    var current_track_heading: float;
    var distance_to_final_point: float;
    var final_point_radius: float;
    var i: int;

    // 1. we search how many paths we should draw
    number_of_foot_paths = Max(parent.entities.Size(), 1);

    for (i = 0; i < number_of_foot_paths; i += 1) {
      // 2.1 we find a random position around the last clues position
      current_track_position = parent.investigation_last_clues_position + VecRingRand(
        0,
        2
      );

      // 2.2 we slowly move toward the final point position
      final_point_radius = 6 * 6;

      do {
        current_track_heading = VecHeading(this.final_point_position - current_track_position);

        current_track_position += VecConeRand(
          current_track_heading,
          60, // 60 degrees randomness
          1,
          2
        );

        FixZAxis(current_track_position);

        distance_to_final_point = VecDistanceSquared(current_track_position, this.final_point_position);

        parent.addTrackHere(
          current_track_position,
          VecToRotation(this.final_point_position - current_track_position)
        );

        // SleepOneFrame();
      } while (distance_to_final_point > final_point_radius);
    }
  }  

  var creatures_aggro_radius: float;
  default creatures_aggro_radius = 400; // 20 * 20

  latent function waitUntilPlayerReachesFinalPoint() {
    var distance_from_player: float;

    distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), this.final_point_position); 

    // 1. first we wait until the player has reached the final point
    while (distance_from_player > this.creatures_aggro_radius && !parent.hasOneOfTheEntitiesGeraltAsTarget()) {
      SleepOneFrame();
      
      distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), this.final_point_position); 
    }

    // 2. then we play some oneliners
    REROL_there_you_are();
  }

  latent function createMidFollowAmbush() {
    
  }

  latent function CluesInvestigate_goToNextState() {
    parent.GotoState('Combat');
  }
}
