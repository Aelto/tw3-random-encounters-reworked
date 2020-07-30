
function getRandomPositionBehindCamera(out initial_pos: Vector, optional distance: float, optional minimum_distance: float): bool {  // var camera_direction: Vector;
  var player_position: Vector;
  var point_z: float;
  var attempts_left: int;

  if (minimum_distance == 0.0) {
    minimum_distance = 20.0;
  }

  // value of `0.0` means the parameter was not supplied
  if (distance == 0.0) {
    distance = 40;
  }

  else if (distance < minimum_distance) {
    distance = minimum_distance; // meters
  }

  player_position = thePlayer.GetWorldPosition();
  attempts_left = 3;

  for (attempts_left; attempts_left > 0; attempts_left -= 1) {
    initial_pos = player_position + VecConeRand(theCamera.GetCameraHeading(), 270, -minimum_distance, -distance);

    if (getGroundPosition(initial_pos)) {
      return true;
    }
  }

  return false;
}
