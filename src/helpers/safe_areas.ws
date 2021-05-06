function RER_getCoordinatesFromPercentValues(percent_x: float, percent_y: float): Vector {
  var min: float;
  var max: float;
  var output: Vector;
  var area: EAreaName;
  var area_string: string;

  area = theGame.GetCommonMapManager().GetCurrentArea();

  switch (area) {
    case AN_Prologue_Village:
    case AN_Prologue_Village_Winter:
    case AN_Spiral:
    case AN_CombatTestLevel:
    case AN_Wyzima:
    case AN_Island_of_Myst:
      // first the X coordinates
      min = -350;
      max = 375;

      output.X = min + (max - min) * percent_x;

      // then the Y coordinates
      min = -150;
      max = 235;

      output.Y = min + (max - min) * percent_y;
      break;

    case AN_Skellige_ArdSkellig:
      // first the X coordinates
      min = -1750;
      max = 1750;

      output.X = min + (max - min) * percent_x;

      // then the Y coordinates
      min = -1750;
      max = 1750;

      output.Y = min + (max - min) * percent_y;
      break;

    case AN_Kaer_Morhen:
      // first the X coordinates
      min = -180;
      max = 50;

      output.X = min + (max - min) * percent_x;

      // then the Y coordinates
      min = -500;
      max = 900;

      output.Y = min + (max - min) * percent_y;
      break;

    case AN_NMLandNovigrad:
    case AN_Velen:
      // first the X coordinates
      min = -350;
      max = 2500;

      output.X = min + (max - min) * percent_x;

      // then the Y coordinates
      min = -1000;
      max = 2500;

      output.Y = min + (max - min) * percent_y;
      break;

    default:
      area_string = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

      if (area_string == "bob") {
        // first the X coordinates
        min = -1500;
        max = 1250;

        output.X = min + (max - min) * percent_x;

        // then the Y coordinates
        min = -2000;
        max = 1000;

        output.Y = min + (max - min) * percent_y;
      }
      else {
        // first the X coordinates
        min = -300;
        max = 300;

        output.X = min + (max - min) * percent_x;

        // then the Y coordinates
        min = -300;
        max = 300;

        output.Y = min + (max - min) * percent_y;
      }

      break;
  }

  return output;
}

// because lots of bounties end up in bodies of water, this function returns 
// the closest piece of land.
function RER_getSafeCoordinatesFromPoint(point: Vector): Vector {
  // we will use water depth to detect if the point is on land or in water
  // every other functions failed certainly because the game doesn't load
  // the data about the chunks until the player gets close enough.
  //
  // This function works everywhere, and returns 10 000 when it's on land
  // and a value between 0 and 100 or 200 when in a body of water.
  var water_depth: float;
  var signposts: array<CGameplayEntity>;
  var array_of_nodes: array<CNode>;
  var closest_signpost_node: CNode;
  var closest_signpost_position: Vector;
  var distance_in_z_level: float;
  var i: int;
  var output: Vector;

  return point;

  water_depth = theGame.GetWorld().GetWaterDepth(point);

  // it's on land, we can return now
  if (water_depth >= 5000) {
    return point;
  }

  // get all the signposts in the map
  FindGameplayEntitiesInRange(
    signposts,
    thePlayer,
    5000, // range, we'll have to check if 50 is too big/small
    100, // max results
    , // tag: optional value
    FLAG_ExcludePlayer,
    , // optional value
    'W3FastTravelEntity'
  );

  for (i = 0; i < signposts.Size(); i += 1) {
    array_of_nodes.PushBack((CNode)signposts[i]);
  }

  NLOG("number of nodes = " + array_of_nodes.Size());

  // then find the closest one
  closest_signpost_node = FindClosestNode(point, array_of_nodes);
  closest_signpost_position = closest_signpost_node.GetWorldPosition();

  NLOG("closest signpost position = " + VecToString(closest_signpost_position));

  // set the output at the starting point
  output = point;

  // note: we reuse i here, it will be used to calculate the iterations
  i = 0;

  do {
    i += 1;

    // then slowly get closer to the signpost position
    output = VecInterpolate(output, closest_signpost_position, 0.05 * i);

    NLOG("searching safe position at " + VecToString(output));

    // update the water depth
    water_depth = theGame.GetWorld().GetWaterDepth(Vector(output.X, output.Y, 2), true);
    
    distance_in_z_level = closest_signpost_position.Z - output.Z;

    NLOG("distance in Z level = " + distance_in_z_level);

  // while the water depth is not over 5000 which means there is a body of water
  // at the current position
  } while ((water_depth < 5000 || distance_in_z_level > closest_signpost_position.Z * 0.05) && VecDistanceSquared2D(output, closest_signpost_position) > 5 * 5);

  // we do it one last time because the water level gets below 500 on shore too,
  // where this is still a bit of water.
  output = VecInterpolate(output, closest_signpost_position, 0.2);

  NLOG("safe position = " + VecToString(output));

  return output;
}

// the goal of this function is to move the supplied from outside pre-defined
// safe areas in the world. The safe areas were made because the original bounds
// are rectangular and sometimes to avoid a single unreachable area it would mean
// removing 50% of the bound width, which i don't want.
// The safe areas are circles with a radius, and the start by all the safe areas
// the point is in. And then we add to a displacement vector all the translations
// needed to move the point out of the areas. Because we don't do it one by one
// and instead add all the translations needed, it creates a sort of "mean"
// vector that will gracefully move the point outside of ALL areas.
function RER_moveCoordinatesAwayFromSafeAreas(point: Vector): Vector {
  var current_distance_percentage: float;
  var distance_from_center: float;
  var displacement_vector: Vector;
  var safe_areas: array<Vector>;
  var squared_radius: float;
  var i: int;

  safe_areas = RER_getSafeAreasByRegion(
    AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea())
  );

  NLOG("moveCoordinatesAwayFromSafeAreas 1.");

  for (i = 0; i < safe_areas.Size(); i += 1) {
    squared_radius = safe_areas[i].Z * safe_areas[i].Z;
    distance_from_center = VecDistanceSquared2D(safe_areas[i], point);

    // the point is not inside the circle, skip
    if (distance_from_center > squared_radius) {
      continue;
    }

    current_distance_percentage = distance_from_center / squared_radius;

    NLOG("moveCoordinatesAwayFromSafeAreas, squared radius = " + squared_radius + " distance_percentage = " + current_distance_percentage);

    displacement_vector += (
      point 
      - Vector(safe_areas[i].X, safe_areas[i].Y, point.Z)
    ) * (1 - current_distance_percentage);
  }

  NLOG("moveCoordinatesAwayFromSafeAreas 2.");

  return point + displacement_vector;
}

// the goal of this function is to move the supplied point inside the pre-defined
// valid areas in the world. It will work in big steps:
//  - 1. it will take the closest valid area
//  - 2. then we move the point in the closest circle based on its X:Y coordinates.
function RER_moveCoordinatesInsideValidAreas(point: Vector, x_percent: float, y_percent: float): Vector {
  var areas: array<Vector>;
  var closest_area: Vector;
  var distance_from_area: float;
  var distance_from_closest_area: float;
  var region: string;
  var i: int;

  region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

  if (region != "skellige") {
    return point;
  }

  areas.PushBack(Vector(-1828, 1190, 58));
  areas.PushBack(Vector(-1758, 1239, 56));
  areas.PushBack(Vector(-1641, 1284, 85));
  areas.PushBack(Vector(-1637, 1434, 61));
  areas.PushBack(Vector(-1555, 1543, 88));
  areas.PushBack(Vector(-1439, 1486, 60));
  areas.PushBack(Vector(-1355, 1411, 52));
  areas.PushBack(Vector(340, 1544, 32));
  areas.PushBack(Vector(313, 1591, 22));
  areas.PushBack(Vector(274, 1602, 19));
  areas.PushBack(Vector(1600, 1896, 74));
  areas.PushBack(Vector(1493, 1917, 60));
  areas.PushBack(Vector(1358, 1933, 94));
  areas.PushBack(Vector(1339, 1960, 85));
  areas.PushBack(Vector(2752, -116, 84));
  areas.PushBack(Vector(2759, 42, 89));
  areas.PushBack(Vector(2535, 203, 103));
  areas.PushBack(Vector(2541, 306, 47));
  areas.PushBack(Vector(2402, 155, 59));
  areas.PushBack(Vector(2212, 82, 26));
  areas.PushBack(Vector(2267, 35, 27));
  areas.PushBack(Vector(2419, 34, 27));
  areas.PushBack(Vector(2443, -16, 35));
  areas.PushBack(Vector(2491, -83, 36));
  areas.PushBack(Vector(2602, -132, 47));
  areas.PushBack(Vector(1536, -1921, 35));
  areas.PushBack(Vector(1709, -1925, 50));
  areas.PushBack(Vector(1675, -1804, 20));
  areas.PushBack(Vector(1592, -1809, 23));
  areas.PushBack(Vector(1863, -1942, 56));
  areas.PushBack(Vector(1936, -1902, 42));
  areas.PushBack(Vector(1999, -1982, 39));
  areas.PushBack(Vector(2130, -1946, 28));
  areas.PushBack(Vector(2201, -1944, 38));
  areas.PushBack(Vector(2302, -1977, 73));
  areas.PushBack(Vector(-1575, -758, 75));
  areas.PushBack(Vector(-1676, -632, 113));
  areas.PushBack(Vector(-1816, -619, 75));
  areas.PushBack(Vector(-1954, -638, 83));
  areas.PushBack(Vector(-2118, -655, 46));
  areas.PushBack(Vector(-1947, -820, 44));
  areas.PushBack(Vector(-1744, -824, 76));
  areas.PushBack(Vector(420, -1352, 54));
  areas.PushBack(Vector(172, -1322, 49));
  areas.PushBack(Vector(88, -1230, 53));
  areas.PushBack(Vector(-41, -1209, 54));
  areas.PushBack(Vector(-353, -940, 71));
  areas.PushBack(Vector(-429, -785, 78));
  areas.PushBack(Vector(-520, -566, 86));
  areas.PushBack(Vector(-520, -303, 182));
  areas.PushBack(Vector(-406, -206, 155));
  areas.PushBack(Vector(-200, -297, 175));
  areas.PushBack(Vector(-192, -537, 63));
  areas.PushBack(Vector(-124, -448, 53));
  areas.PushBack(Vector(31, -229, 132));
  areas.PushBack(Vector(237, -249, 198));
  areas.PushBack(Vector(188, -40, 103));
  areas.PushBack(Vector(310, -501, 143));
  areas.PushBack(Vector(436, -485, 90));
  areas.PushBack(Vector(361, -685, 66));
  areas.PushBack(Vector(254, -815, 78));
  areas.PushBack(Vector(298, -971, 80));
  areas.PushBack(Vector(543, -795, 59));
  areas.PushBack(Vector(631, -805, 31));
  areas.PushBack(Vector(380, -24, 123));
  areas.PushBack(Vector(203, 92, 64));
  areas.PushBack(Vector(223, 244, 77));
  areas.PushBack(Vector(-10, 419, 122));
  areas.PushBack(Vector(319, 555, 69));
  areas.PushBack(Vector(365, 298, 84));
  areas.PushBack(Vector(514, 184, 121));
  areas.PushBack(Vector(497, 357, 72));
  areas.PushBack(Vector(553, 588, 73));
  areas.PushBack(Vector(490, 629, 41));
  areas.PushBack(Vector(357, 738, 29));
  areas.PushBack(Vector(324, 795, 30));
  areas.PushBack(Vector(649, 694, 42));
  areas.PushBack(Vector(756, 706, 47));
  areas.PushBack(Vector(982, 627, 94));
  areas.PushBack(Vector(1092, 492, 34));
  areas.PushBack(Vector(1107, 404, 50));
  areas.PushBack(Vector(1164, 415, 38));
  areas.PushBack(Vector(1234, 373, 45));
  areas.PushBack(Vector(1307, 367, 31));
  areas.PushBack(Vector(1013, 213, 177));
  areas.PushBack(Vector(834, -89, 165));
  areas.PushBack(Vector(570, 13, 84));
  areas.PushBack(Vector(803, -310, 274));

  // 1. finding the closest area
  distance_from_closest_area = 10000000;

  for (i = 0; i < areas.Size(); i += 1) {
    distance_from_area = VecDistanceSquared2D(point, areas[i]);

    if (distance_from_area < distance_from_closest_area) {
      distance_from_closest_area = distance_from_area;
      closest_area = areas[i];
    }
  }

  return RER_placeCircleCoordinatesAroundPoint(
    RER_mapSquareToCircleCoordinates(
      Vector(x_percent, y_percent)
    ),
    closest_area
  );
  
  return point;
}

// the safe areas are Vectors where X and Y are used for the coordinates,
// and Z is the radius. I didn't want to create yet another struct for it.
function RER_getSafeAreasByRegion(region: string): array<Vector> {
  var areas: array<Vector>;

  /*
  // the javascript code used to generate the coordinates.
  // combined with the rergetpincoord command
  {
  // center of the circle
  const a = { x: -340, y: -450 };
  // edge of the circle
  const b = { x: -140, y: -320 };

  const radius = Math.sqrt(Math.pow(a.x - b.x, 2) + Math.pow(a.y - b.y, 2));

  `areas.PushBack(Vector(${a.x}, ${a.y}, ${Math.round(radius)}));`
  }

  */

  switch (region) {
    case "prolog_village":
    case "prolog_village_winter":
    break;

    case "no_mans_land":
    case "novigrad":
    areas.PushBack(Vector(340, 1980, 502)); // novigrad
    areas.PushBack(Vector(1760, 900, 215)); // oxenfurt
    areas.PushBack(Vector(193, -790, 362)); // lake around fyke island
    // huge circle on the left of the map,
    // a bit below novigrad on the Y axis
    areas.PushBack(Vector(-1368, 2139, 1778)); 

    areas.PushBack(Vector(2369, -235, 310)); // lake on the bottom right part

    break;

    case "skellige":
    areas.PushBack(Vector(-100, -636, 110)); // kaer trolde
    areas.PushBack(Vector(-90, -800, 162)); // big mountain south of the main island
    areas.PushBack(Vector(-1700, -1000, 304)); // forge mountain on the giant's island
    break;

    case "kaer_morhen":
    areas.PushBack(Vector(-11, 19, 95)); // the keep
    areas.PushBack(Vector(130, 210, 183)); // the big mountain north of the keep
    areas.PushBack(Vector(-500, -700, 330)); // the mountain south west of the map
    areas.PushBack(Vector(-340, -450, 239)); // same
    areas.PushBack(Vector(-620, 500, 330)); // a mountain north west of the map
    areas.PushBack(Vector(-100, -106, 30)); // the tower near the keep
    break;

    case "bob":
    areas.PushBack(Vector(-2430, 1230, 2077)); // top left mountain
    areas.PushBack(Vector(1840, 1070, 1729)); // top right mountain
    areas.PushBack(Vector(1920, -2700, 1809)); // bottom right mountain
    areas.PushBack(Vector(-1700, -2700, 1294)); // bottom left mountain
    break;
  }

  return areas;
}