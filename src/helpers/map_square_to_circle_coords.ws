
// maps coordinates that are in a square to a circle. The coordinates should be
// expressed in % around the center  so values between -1 and 1.
// It ignores the Z value too, and uses only X and Y.
//
// The formula used is from this website:
// https://www.xarg.org/2017/07/how-to-map-a-square-to-a-circle/
function RER_mapSquareToCircleCoordinates(point: Vector): Vector {
  var x, y: float;
  var output: Vector;

  // in case the Z and W of the point are needed, we copy them.
  output = point;

  // first we convert the coordinates that are in the range [0; 1] to coordinates
  // in the range [-1; 1]
  x = point.X * 2 - 1;
  y = point.Y * 2 - 1;

  // convert to circle units
  output.X = x * SqrtF(1 - y * y / 2);
  output.Y = y * SqrtF(1 - x * x / 2);

  // // then we convert back to [0; 1] range
  // output.X = (output.X + 1) / 2;
  // output.Y = (output.Y + 1) / 2;

  return output;
}

// the input is supposed to be a Vector where only X and Y matter and both values
// range between -1 and 1 to represent a % value around the center of the circle.
// You can map square coordinates to circle coordinates with the function:
// RER_mapSquareToCircleCoordinates
//
// This function however returns real coordinates around the `circle_center` based
// on the supplied `circle_coordinates` that were supplied.
// NOTE: the Vector for `circle_center` uses the Z in XYZ for the radius.
function RER_placeCircleCoordinatesAroundPoint(circle_coordinates: Vector, circle_center: Vector): Vector {
  return Vector(
    circle_center.X + circle_center.Z * circle_coordinates.X,
    circle_center.Y + circle_center.Z * circle_coordinates.Y
  );
}