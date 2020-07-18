function getRandomPositionBehindCamera(out initial_pos: Vector, optional distance: float): bool {
  var collision_normal: Vector;
  // var camera_direction: Vector;
  var player_position: Vector;
  var minimum_distance: float;

  minimum_distance = 10.0;

  // value of `0.0` means the parameter was not supplied
  if (distance == 0.0) {
    distance = 60;
  }
  else if (distance < minimum_distance) {
    distance = minimum_distance; // meters
  }

  player_position = thePlayer.GetWorldPosition();

  initial_pos = player_position + VecConeRand(theCamera.GetCameraHeading(), 270, -minimum_distance, -distance);
  
  FixZAxis(initial_pos);

  if (initial_pos.Z >= theGame.GetWorld().GetWaterLevel(initial_pos, true)) {
    return false;
  }

  return theGame
    .GetWorld()
    .StaticTrace(
      initial_pos + 5,// Vector(0,0,5),
      initial_pos - 5,//Vector(0,0,5),
      initial_pos,
      collision_normal
    );
}