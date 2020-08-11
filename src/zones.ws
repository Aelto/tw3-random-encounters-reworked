
//--- RandomEncounters ---
// Made by Erxv
enum EREZone {
  REZ_UNDEF   = 0,
  REZ_NOSPAWN = 1,
  REZ_SWAMP   = 2,
  REZ_CITY    = 3,
}

class CModRExtra { 
  public function getCustomZone(pos : Vector) : EREZone {
    var zone : EREZone;
    var currentArea : string;
     
    zone = REZ_UNDEF;
    currentArea = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());
     
    if (currentArea == "novigrad")
    {
      if ( (pos.X < 730 && pos.X > 290)  && (pos.Y < 2330 && pos.Y > 1630))
      {
        //zone = "novigrad";
        zone = REZ_CITY;
      } 
      else if ( (pos.X < 730 && pos.X > 450)  && (pos.Y < 1640 && pos.Y > 1530))
      {
        //zone = "novigrad";
        zone = REZ_CITY;
      } 
      else if ( (pos.X < 930 && pos.X > 700)  && (pos.Y < 2080 && pos.Y > 1635))
      {
        //zone = "novigrad";
        zone = REZ_CITY;
      } 
      else if ( (pos.X < 1900 && pos.X > 1600)  && (pos.Y < 1200 && pos.Y > 700))
      {
        //zone = "oxenfurt";
        zone = REZ_CITY;
      }
      else if ( (pos.X < 315 && pos.X > 95)  && (pos.Y < 240 && pos.Y > 20))
      {
        //zone = "crows";
        zone = REZ_CITY;
      }
      else if ( (pos.X < 2350 && pos.X > 2200)  && (pos.Y < 2600 && pos.Y > 2450))
      {
        //zone = "HoS Wedding";
        zone = REZ_NOSPAWN;
      }
      else if ( (pos.X < 2255 && pos.X > 2135)  && (pos.Y < 2180 && pos.Y > 2010))
      {
        //zone = "HoS Creepy Mansion";
        zone = REZ_NOSPAWN;
      }
      else if ( (pos.X < 1550 && pos.X > 930)  && (pos.Y < 1320 && pos.Y > 950))
      {
        zone = REZ_SWAMP;
      }
      else if ( (pos.X < 1400 && pos.X > 940)  && (pos.Y < -460 && pos.Y > -720))
      {
        zone = REZ_SWAMP;
      }
      else if ( (pos.X < 1790 && pos.X > 1320)  && (pos.Y < -400 && pos.Y > -540))
      {
        zone = REZ_SWAMP;
      }
      else if ( (pos.X < 2150 && pos.X > 1750)  && (pos.Y < -490 && pos.Y > -1090))
      {
        zone = REZ_SWAMP;
      }
    }
    else if (currentArea == "skellige")
    {
      if ( (pos.X < 30 && pos.X > -290)  && (pos.Y < 790 && pos.Y > 470))
      {
        //zone = "trolde";
        zone = REZ_CITY;
      }
    }
    else if (currentArea == "bob")
    {
      if ( (pos.X < -292 && pos.X > -417)  && (pos.Y < -755 && pos.Y > -872))
      {
        //zone = "corvo";
        zone = REZ_NOSPAWN;
      }
      else if ( (pos.X < -414 && pos.X > -636)  && (pos.Y < -863 && pos.Y > -1088))
      {
        //zone = "tourney";
        zone = REZ_NOSPAWN;
      }
      else if ( (pos.X < -142 && pos.X > -871)  && (pos.Y < -1082 && pos.Y > -1637))
      {
        //zone = "city";
        zone = REZ_CITY;
      }
    } 
    else if (currentArea == "wyzima_castle" || currentArea == "island_of_mist" || currentArea == "spiral")
    {
      zone = REZ_NOSPAWN;
    } 
  
    return zone; 
  }

  public function isNearNoticeboard(): bool {
    var entities: array<CGameplayEntity>;

     // 'W3NoticeBoard' for noticeboards, 'W3FastTravelEntity' for signpost
    FindGameplayEntitiesInRange(
      entities,
      thePlayer,
      50, // range, we'll have to check if 50 is too big/small
      1, // max results
      , // tag: optional value
      FLAG_ExcludePlayer,
      , // optional value
      'W3NoticeBoard'
    );

    return entities.Size() > 0;
  } 

  public function getRandomHumanTypeByCurrentArea(): EHumanType {
    var current_area: string;
    var spawn_roller: SpawnRoller;

    spawn_roller = new SpawnRoller in this;
    spawn_roller.fill_arrays();
    spawn_roller.reset();

    current_area = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

    if (current_area == "prolog_village") {
      spawn_roller.setHumanVariantCounter(HT_BANDIT, 3);
      spawn_roller.setHumanVariantCounter(HT_CANNIBAL, 2);
      spawn_roller.setHumanVariantCounter(HT_RENEGADE, 2);
    }
    else if (current_area == "skellige") {
      spawn_roller.setHumanVariantCounter(HT_SKELBANDIT, 3);
      spawn_roller.setHumanVariantCounter(HT_SKELBANDIT2, 3);
      spawn_roller.setHumanVariantCounter(HT_SKELPIRATE, 2);
    }
    else if (current_area == "kaer_morhen") {
      spawn_roller.setHumanVariantCounter(HT_BANDIT, 3);
      spawn_roller.setHumanVariantCounter(HT_CANNIBAL, 2);
      spawn_roller.setHumanVariantCounter(HT_RENEGADE, 2);
    }
    else if (current_area == "novigrad" || current_area == "no_mans_land") {
      spawn_roller.setHumanVariantCounter(HT_NOVBANDIT, 2);
      spawn_roller.setHumanVariantCounter(HT_PIRATE, 2);
      spawn_roller.setHumanVariantCounter(HT_NILFGAARDIAN, 1);
      spawn_roller.setHumanVariantCounter(HT_CANNIBAL, 2);
      spawn_roller.setHumanVariantCounter(HT_RENEGADE, 2);
      spawn_roller.setHumanVariantCounter(HT_WITCHHUNTER, 1);
    }
    else if (current_area == "bob") {
      spawn_roller.setHumanVariantCounter(HT_NOVBANDIT, 1);
      spawn_roller.setHumanVariantCounter(HT_BANDIT, 4);
      spawn_roller.setHumanVariantCounter(HT_NILFGAARDIAN, 1);
      spawn_roller.setHumanVariantCounter(HT_CANNIBAL, 1);
      spawn_roller.setHumanVariantCounter(HT_RENEGADE, 2);
    }
    else {
      spawn_roller.setHumanVariantCounter(HT_NOVBANDIT, 1);
      spawn_roller.setHumanVariantCounter(HT_BANDIT, 4);
      spawn_roller.setHumanVariantCounter(HT_NILFGAARDIAN, 1);
      spawn_roller.setHumanVariantCounter(HT_CANNIBAL, 1);
      spawn_roller.setHumanVariantCounter(HT_RENEGADE, 2);
    }

    return spawn_roller.rollHumansVariants();
  }

  public function getRandomSmallCreatureByCurrentArea(out settings: RE_Settings, out spawn_roller: SpawnRoller): SmallCreatureType {
    var is_in_forest: bool;
    var is_near_water: bool;
    var is_in_swamp: bool;

    var i: int;
    var current_area: string;

    is_in_forest = this.IsPlayerInForest();
    is_near_water = this.IsPlayerNearWater();
    is_in_swamp = this.IsPlayerInSwamp();

    current_area = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

    spawn_roller.reset();

    if (theGame.envMgr.IsNight()) {
      // first set all the counters to the settings value.
      for (i = 0; i < SmallCreatureMAX; i += 1) {
        spawn_roller.setSmallCreatureCounter(i, settings.small_creatures_chances_night[i]);
      }
    }
    else {
      for (i = 0; i < SmallCreatureMAX; i += 1) {
        spawn_roller.setSmallCreatureCounter(i, settings.small_creatures_chances_day[i]);
      }
    }

    // then handle special cases by hand
    
    if (current_area == "prolog_village") {
      // we remove some creatures in the prolog area
      spawn_roller.setSmallCreatureCounter(SmallCreatureHARPY, 0);
      spawn_roller.setSmallCreatureCounter(SmallCreatureCENTIPEDE, 0);
      spawn_roller.setSmallCreatureCounter(SmallCreatureECHINOPS, 0);
      spawn_roller.setSmallCreatureCounter(SmallCreatureBARGHEST, 0);
    }

    if (current_area != "skellige") {
      spawn_roller.setSmallCreatureCounter(SmallCreatureSKELWOLF, 0);
      spawn_roller.setSmallCreatureCounter(SmallCreatureSKELBEAR, 0);
    }

    // and now special cases depending on areas
    if (!is_near_water && !is_in_swamp) {
      // well, no water no drowners!
      spawn_roller.setSmallCreatureCounter(SmallCreatureDROWNER, 0);
      spawn_roller.setSmallCreatureCounter(SmallCreatureDROWNERDLC, 0);
    }

    if (!is_in_forest) {
      // no forest, no plants
      spawn_roller.setSmallCreatureCounter(SmallCreatureARACHAS, 0);
      spawn_roller.setSmallCreatureCounter(SmallCreatureENDREGA, 0);
      spawn_roller.setSmallCreatureCounter(SmallCreatureECHINOPS, 0);
      spawn_roller.setSmallCreatureCounter(SmallCreatureSPIDER, 0);
    }

    if (is_near_water || is_in_swamp) {
      spawn_roller.setSmallCreatureCounter(SmallCreatureCENTIPEDE, 0);
      spawn_roller.setSmallCreatureCounter(SmallCreatureHARPY, 0);
    }

    return spawn_roller.rollSmallCreatures();
  }

  public function getRandomLargeCreatureByCurrentArea(settings: RE_Settings, out spawn_roller: SpawnRoller): LargeCreatureType {
    var i: int;
    var current_area: string;
    var is_in_forest: bool;
    var is_near_water: bool;
    var is_in_swamp: bool;

    is_in_forest = this.IsPlayerInForest();
    is_near_water = this.IsPlayerNearWater();
    is_in_swamp = this.IsPlayerInSwamp();

    current_area = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

    spawn_roller.reset();

    if (theGame.envMgr.IsNight()) {
      // first set all the counters to the settings value.
      for (i = 0; i < LargeCreatureMAX; i += 1) {
        spawn_roller.setLargeCreatureCounter(i, settings.large_creatures_chances_night[i]);
      }
    }
    else {
      for (i = 0; i < LargeCreatureMAX; i += 1) {
        spawn_roller.setLargeCreatureCounter(i, settings.large_creatures_chances_day[i]);
      }
    }

    // then handle special cases by hand
    
    if (current_area == "prolog_village") {
      // we remove some creatures in the prolog area
      spawn_roller.setLargeCreatureCounter(LargeCreatureGIANT, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureEKIMMARA, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureKATAKAN, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureGOLEM, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureELEMENTAL, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureCYCLOPS, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureBRUXA, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureFLEDER, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureGARKAIN, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureDETLAFF, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureGIANT, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureSHARLEY, 0);
    }

    if (current_area != "skellige") {
      spawn_roller.setLargeCreatureCounter(LargeCreatureSKELTROLL, 0);
    }

    // and now special cases depending on areas
    if (is_in_forest) {
      if (theGame.envMgr.IsNight()) {
        spawn_roller.setLargeCreatureCounter(LargeCreatureCOCKATRICE, settings.large_creatures_chances_night[LargeCreatureCOCKATRICE] / 2);
        spawn_roller.setLargeCreatureCounter(LargeCreatureBASILISK, settings.large_creatures_chances_night[LargeCreatureBASILISK] / 2);
        spawn_roller.setLargeCreatureCounter(LargeCreatureWYVERN, settings.large_creatures_chances_night[LargeCreatureWYVERN] / 2);
        spawn_roller.setLargeCreatureCounter(LargeCreatureFORKTAIL, settings.large_creatures_chances_night[LargeCreatureFORKTAIL] / 2);
        spawn_roller.setLargeCreatureCounter(LargeCreatureGRYPHON, settings.large_creatures_chances_night[LargeCreatureGRYPHON] / 2);
      }
      else {
        spawn_roller.setLargeCreatureCounter(LargeCreatureCOCKATRICE, settings.large_creatures_chances_day[LargeCreatureCOCKATRICE] / 2);
        spawn_roller.setLargeCreatureCounter(LargeCreatureBASILISK, settings.large_creatures_chances_day[LargeCreatureBASILISK] / 2);
        spawn_roller.setLargeCreatureCounter(LargeCreatureWYVERN, settings.large_creatures_chances_day[LargeCreatureWYVERN] / 2);
        spawn_roller.setLargeCreatureCounter(LargeCreatureFORKTAIL, settings.large_creatures_chances_day[LargeCreatureFORKTAIL] / 2);
        spawn_roller.setLargeCreatureCounter(LargeCreatureGRYPHON, settings.large_creatures_chances_day[LargeCreatureGRYPHON] / 2);
      }
    }
    else {
      spawn_roller.setLargeCreatureCounter(LargeCreatureLESHEN, 0);
    }

    if (is_in_swamp) {
      spawn_roller.setLargeCreatureCounter(LargeCreatureWEREWOLF, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureELEMENTAL, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureNOONWRAITH, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureNIGHTWRAITH, 0);
    }
    else {
      spawn_roller.setLargeCreatureCounter(LargeCreatureHAG, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureFOGLET, 0);
    }

    if (theGame.envMgr.IsNight()) {
      spawn_roller.setLargeCreatureCounter(LargeCreatureNOONWRAITH, 0);
    }
    else {
      spawn_roller.setLargeCreatureCounter(LargeCreatureNIGHTWRAITH, 0);
    }

    return spawn_roller.rollLargeCreatures();
  }

  public function IsPlayerNearWater() : bool {
    var i, j : int;
    var pos, newPos : Vector;
    var vectors : array<Vector>;
    var world : CWorld;
    var waterDepth : float;

    pos = thePlayer.GetWorldPosition();

    world = theGame.GetWorld();

    for (i = 2; i <= 50; i += 2) {
      vectors = VecSphere(10, i);

      for (j = 0; j < vectors.Size(); j += 1) {
        newPos = pos + vectors[j];
        FixZAxis(newPos);
        waterDepth = world.GetWaterDepth(newPos, true);

        if (waterDepth > 1.0f && waterDepth != 10000.0) {
          return true;
        }
      }
    }

    return false;
  }

  public function IsPlayerInSwamp() : bool {
    var i, j : int;
    var pos, newPos : Vector;
    var vectors : array<Vector>;
    var world : CWorld;
    var waterDepth : float;
    var wetTerrainQuantity : int;

    pos = thePlayer.GetWorldPosition();

    world = theGame.GetWorld();

    wetTerrainQuantity = 0;

    for (i = 2; i <= 50; i += 2) {
      vectors = VecSphere(10, i);
  
      for (j = 0; j < vectors.Size(); j += 1) {
        newPos = pos + vectors[j];
        FixZAxis(newPos);
        waterDepth = world.GetWaterDepth(newPos, true);

        if (waterDepth > 0 && waterDepth < 1.5f) {
          wetTerrainQuantity += 1;
        }
        else {
          wetTerrainQuantity -= 1;
        }
      }
    }

    return wetTerrainQuantity > -300;
  }

  public function IsPlayerInForest() : bool
  {
    var cg : array<name>;
    var i, j, k : int;
    var compassPos : array<Vector>;
    var angles : array<int>;
    var angle : int;
    var vectors : array<Vector>;
    var tracePosStart, tracePosEnd : Vector;
    var material : name;
    var component : CComponent;
    var outPos, normal : Vector;
    var angularQuantity, totalQuantity : int;
    var lastPos : Vector;
    var skip : bool;
    var skipIdx : int;

    cg.PushBack('Foliage');

    compassPos = VecSphere(90, 20);
    compassPos.Insert(0, thePlayer.GetWorldPosition());

    for (i = 1; i < compassPos.Size(); i += 1) {
      compassPos[i] = compassPos[0] + compassPos[i];
      FixZAxis(compassPos[i]);
      compassPos[i].Z += 10;
    }

    compassPos[0].Z += 10;

    angles.PushBack(0);
    angles.PushBack(90);
    angles.PushBack(180);
    angles.PushBack(270);

    totalQuantity = 0;

    skip = false;
    skipIdx = -1;

    for (i = 0; i < compassPos.Size(); i += 1) {
      for (j = 0; j < angles.Size(); j += 1) {
        angularQuantity = 0;
        angle = angles[j];
        vectors = VecArc(angle, angle+90, 5, 25);

        for (k = 0; k < vectors.Size(); k += 1) {
          tracePosStart = compassPos[i];
          tracePosEnd = tracePosStart;
          tracePosEnd.Z -= 10;
          tracePosEnd = tracePosEnd + vectors[k];
          FixZAxis(tracePosEnd);
          tracePosEnd.Z += 10;

          if (theGame.GetWorld().StaticTraceWithAdditionalInfo(tracePosStart, tracePosEnd, outPos, normal, material, component, cg)) {
            if (material == 'default' && !component) {
              if (VecDistanceSquared(lastPos, outPos) > 10) {
                lastPos = outPos;
                angularQuantity += 1;
                totalQuantity += 1;
              }
            }
          }
        }

        if (angularQuantity < 1) {
          if (i > 0 && (!skip || skipIdx == i)) {
            skip = true;
            skipIdx = i;
          }
          else {
            return false;
          }
        }
      }
    }

    return totalQuantity > 10;
  }
}


function FixZAxis(out pos : Vector) {
  var world : CWorld;
  var z : float;

  world = theGame.GetWorld();

  if (world.NavigationComputeZ(pos, pos.Z - 128, pos.Z + 128, z)) {
    pos.Z = z;
  }

  if (world.PhysicsCorrectZ(pos, z)) {
    pos.Z = z;
  }
}

function VecArc(angleStart : int, angleEnd : int, angleStep : int, radius : float) : array<Vector> {
  var i : int;
  var angle : float;
  var v : Vector;
  var vectors: array<Vector>;

  for (i = angleStart; i < angleEnd; i += angleStep)
  {
      angle = Deg2Rad(i);
      v = Vector(radius * CosF(angle), radius * SinF(angle), 0.0, 1.0);
      vectors.PushBack(v);
  }

  return vectors;
}

function VecSphere(angleStep : int, radius : float) : array<Vector> {
  var i : int;
  var angle : float;
  var v : Vector;
  var vectors: array<Vector>;

  for (i = 0; i < 360; i += angleStep)
  {
      angle = Deg2Rad(i);
      v = Vector(radius * CosF(angle), radius * SinF(angle), 0.0, 1.0);
      vectors.PushBack(v);
  }

  return vectors;
}
