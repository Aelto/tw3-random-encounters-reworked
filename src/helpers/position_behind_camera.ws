function getRandomPositionBehindCamera(out initial_pos: Vector, optional distance: float): bool {
  var collision_normal: Vector;
  var camera_direction: Vector;
  var player_position: Vector;

  camera_direction = theCamera.GetCameraDirection();

  if (distance == 0.0) {
    distance = 3.0; // meters
  }

  camera_direction.X *= -distance;
  camera_direction.Y *= -distance;

  player_position = thePlayer.GetWorldPosition();

  initial_pos = player_position + camera_direction;
  initial_pos.Z = player_position.Z;

  return theGame
    .GetWorld()
    .StaticTrace(
      initial_pos + 5,// Vector(0,0,5),
      initial_pos - 5,//Vector(0,0,5),
      initial_pos,
      collision_normal
    );
}