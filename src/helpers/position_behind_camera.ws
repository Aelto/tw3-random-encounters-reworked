
function getRandomPositionBehindCamera(out initial_pos: Vector, optional distance: float, optional minimum_distance: float): bool {  // var camera_direction: Vector;
  var player_position: Vector;
  var point_z: float;

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
  initial_pos = player_position + VecConeRand(theCamera.GetCameraHeading(), 270, -minimum_distance, -distance);

  return getGroundPosition(initial_pos);
}
