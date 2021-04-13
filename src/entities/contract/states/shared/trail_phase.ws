
// The `TrailPhase` state is kind of an abstract state other states should inherit from.
// It offers the needed functions for any state that wants to be an
// intermediary/repeatable state.
state TrailPhase in RandomEncountersReworkedContractEntity {

  // Draws a trail from the previous checkpoint. This function is used when the player
  // is expected to follow a trail before reaching the destination point
  latent function drawTrailsTo(destination: Vector, trails_count: int) {
    var radius: float;
    var use_failsafe: bool;
    var i: int;

    trails_count = Min(trails_count, 1);
    radius = 3;
    use_failsafe = true;

    for (i = 0; i < trails_count; i += 1) {
      parent
      .trail_maker
      .drawTrail(
        parent.previous_phase_checkpoint,
        destination,
        radius,
        ,
        ,
        use_failsafe,
        parent.master.settings.use_pathfinding_for_trails
      );
    }
  }

  latent function drawTrailsToWithCorpseDetailsMaker(destination: Vector, trails_count: int) {
    var corpse_and_blood_details_maker: RER_CorpseAndBloodTrailDetailsMaker;
    var radius: float;
    var use_failsafe: bool;
    var details_chance: float;
    var i: int;

    trails_count = Min(trails_count, 1);
    radius = 3;
    use_failsafe = true;
    details_chance = 1;

    corpse_and_blood_details_maker = new RER_CorpseAndBloodTrailDetailsMaker in this;
    corpse_and_blood_details_maker.corpse_maker = parent.corpse_maker;
    corpse_and_blood_details_maker.blood_maker = parent.blood_maker;

    for (i = 0; i < trails_count; i += 1) {
      parent
      .trail_maker
      .drawTrail(
        parent.previous_phase_checkpoint,
        destination,
        radius,
        corpse_and_blood_details_maker,
        details_chance,
        use_failsafe,
        parent.master.settings.use_pathfinding_for_trails
      );
    }
  }

  // Get a new random trail destination and returns true if it found one, or false
  // if it didn't.
  function getNewTrailDestination(out destination: Vector, optional distance_multiplier: float): bool {
    var found_destination: bool;
    var max_attempt_count: int;
    var current_search_destination: Vector;
    var search_heading: float;
    var min_radius: float;
    var max_radius: float;
    var i: int;

    if (distance_multiplier == 0) {
      distance_multiplier = 1;
    }

    max_attempt_count = 10;
    search_heading = VecHeading(parent.previous_phase_checkpoint - thePlayer.GetWorldPosition());
    min_radius = 100 * distance_multiplier;
    max_radius = 200 * distance_multiplier;

    for (i = 0; i < max_attempt_count; i += 1) {
      current_search_destination = parent.previous_phase_checkpoint
          + VecConeRand(search_heading, 270, min_radius, max_radius);

      found_destination = getGroundPosition(current_search_destination, 5);
      if (found_destination) {
        destination = current_search_destination;

        return true;
      }
    }

    return false;
  }

  // waits for the player to reach the supplied position. It's a latent function
  // that will sleep until the player reaches the point. Be careful.
  latent function waitForPlayerToReachPoint(position: Vector, radius: float) {
    var distance_from_player: float;
    var can_show_markers: bool;
    var should_cancel: bool;
    var map_pin: SU_MapPin;

    can_show_markers = theGame.GetInGameConfigWrapper()
      .GetVarValue('RERoptionalFeatures', 'RERmarkersContractIntermediaryPhase');

    if (can_show_markers) {
      map_pin = new SU_MapPin in thePlayer;
      map_pin.tag = "RER_contract_target";
      map_pin.position = position;
      map_pin.description = GetLocStringByKey("rer_mappin_regular_description");
      map_pin.label = GetLocStringByKey("rer_mappin_regular_title");
      map_pin.type = "TreasureQuest";
      map_pin.radius = 10;
      map_pin.region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

      thePlayer.addCustomPin(map_pin);
    }

    // squared radius to save performances by using VecDistanceSquared
    radius *= radius;
    distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), position);

    while (distance_from_player > radius && !parent.hasOneOfTheEntitiesGeraltAsTarget()) {
      SleepOneFrame();

      should_cancel = this.waitForPlayerToReachPoint_action();
      if (should_cancel) {
        break;
      };

      distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), position);
    }

    SU_removeCustomPinByPosition(position);
  }

  // override the function if necessary
  latent function waitForPlayerToReachPoint_action(): bool { return false; }

  // Checks if one of the creatures is outside the given point and its radius
  // and teleports it back into the circle  ifthe creature is indeed outside.
  // The function is supposed to be called in a fast while loop to keep the
  // creatures on point in an efficient way.
  latent function keepCreaturesOnPoint(position: Vector, radius: float) {
    var distance_from_point: float;
    var old_position: Vector;
    var new_position: Vector;
    var i: int;

    for (i = 0; i < parent.entities.Size(); i += 1) {
      old_position = parent.entities[i].GetWorldPosition();

      distance_from_point = VecDistanceSquared(
        old_position,
        position
      );

      if (distance_from_point > radius) {
        new_position = VecInterpolate(
          old_position,
          position,
          1 / radius
        );

        FixZAxis(new_position);

        if (new_position.Z < old_position.Z) {
          new_position.Z = old_position.Z;
        }

        parent
          .entities[i]
          .Teleport(new_position);
      }
    }
  }

}