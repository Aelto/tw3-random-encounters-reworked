
function getGroundPosition(out input_position: Vector): bool {
  var output_position: Vector;
  var point_z: float;
  var collision_normal: Vector;

  output_position = input_position;

  // first search for ground based on navigation data.
  theGame
  .GetWorld()
  .NavigationComputeZ( output_position, output_position.Z - 30.0, output_position.Z + 30.0, point_z );

	output_position.Z = point_z;

  // then do a static trace to find the position on ground
  theGame
  .GetWorld()
  .StaticTrace(
    output_position + Vector(0,0,1.5),// + 5,// Vector(0,0,5),
    output_position - Vector(0,0,1.5),// - 5,//Vector(0,0,5),
    output_position,
    collision_normal
  );
  
  // finally, return if the position is above water level
  if (output_position.Z >= theGame.GetWorld().GetWaterLevel(output_position, true)) {
    input_position = output_position;

    return true;
  }

  return false;

  
}
