
/**
 * move the supplied creatures away if the player is in a cutscene. Does nothing
 * if it's not the case.
 * The function will look for a ground position before teleporting them away,
 * and will teleport every creature from the array if one or more creatures
 * goes under the threshold value.
 */
function RER_moveCreaturesAwayIfPlayerIsInCutscene(entities: array<CEntity>, radius: float) {
  var player_position: Vector;
  var squared_distance: float;
  var squared_radius: float;
  var position: Vector;
  var i: int;

  if (!isPlayerInScene()) {
    return;
  }

  // square the radius
  squared_radius *= radius;
  player_position = thePlayer.GetWorldPosition();

  for (i = 0; i < entities.Size(); i += 1) {
    squared_distance = VecDistanceSquared2D(player_position, entities[i].GetWorldPosition());

    // the entity is under the threshold value
    if (squared_distance < squared_radius) {
      // it could not find a suitable position. We do nothing and return, maybe
      // the next time this function is called will be the good one.
      if (!getRandomPositionBehindCamera(position, radius)) {
        return;
      }

      // we re-use i here because it doesn't matter as we'll leave the function
      // after that.
      for (i = 0; i < entities.Size(); i += 1) {
        entities[i].Teleport(position);
      }

      // and leave now
      return;
    }
  }
}
