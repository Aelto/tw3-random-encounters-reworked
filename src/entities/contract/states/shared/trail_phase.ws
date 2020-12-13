
// The `TrailPhase` state is kind of an abstract state other states should inherit from.
// It offers the needed functions for any state that wants to be an
// intermediary/repeatable state.
state TrailPhase in RandomEncountersReworkedContractEntity {

  // variables used in this function:
  // - parent.TrailPhase_trail_origin: Vector
  // - parent.TrailPhase_trail_destination: Vector
  // - parent.TrailPhase_trail_details_maker: RER_TrailMaker
  // - parent.TrailPhase_trail_details_chance: float
  //
  // Draws a trail from to the current phase. This function is used when the player
  // is expected to follow a trail before reaching the action place
  latent function drawTrailToAction() {
    var radius: float;
    var use_failsafe: bool;

    radius = 6;
    use_failsafe = true;

    parent
    .trail_maker
    .drawTrail(
      parent.TrailPhase_trail_origin,
      parent.TrailPhase_trail_destination,
      radius,
      parent.TrailPhase_trail_details_maker,
      parent.TrailPhase_trail_details_chance,
      use_failsafe
    );
  }

  // variables used in this function:
  // - parent.entities: array<CEntity>
  // - parent.TrailPhase_keep_creatures_point: Vector;
  // - parent.TrailPhase_keep_creatures_radius: float;
  //
  // Checks if one of the creatures is outside the given point and its radius
  // and teleports it back into the circle  ifthe creature is indeed outside.
  // The function is supposed to be called in a fast while loop to keep the
  // creatures on point in an efficient way.
  latent function keepCreaturesOnPoint() {
    var distance_from_point: float;
    var old_position: Vector;
    var new_position: Vector;
    var i: int;

    for (i = 0; i < parent.entities.Size(); i += 1) {
      old_position = parent.entities[i].GetWorldPosition();

      distance_from_point = VecDistanceSquared(
        old_position,
        parent.TrailPhase_keep_creatures_point
      );

      if (distance_from_point > parent.TrailPhase_keep_creatures_radius) {
        new_position = VecInterpolate(
          old_position,
          parent.TrailPhase_keep_creatures_point,
          1 / this.TrailPhase_keep_creatures_radius
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