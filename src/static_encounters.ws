
class RER_StaticEncounterManager {

  var encounters: array<RER_StaticEncounter>;

  var already_spawned_registered_encounters: bool;
  default already_spawned_registered_encounters = false;

  public latent function registerStaticEncounter(master: CRandomEncounters, encounter: RER_StaticEncounter, optional do_not_spawn: bool) {
    this.encounters.PushBack(encounter);

    // instantly spawn the encounter if RER already spawned the registered
    // static encounters
    if (this.already_spawned_registered_encounters || !do_not_spawn) {
      this.trySpawnStaticEncounter(master, encounter);
    }
  }

  /**
   * Returns the amount of encounters spawned
   */
  public latent function spawnStaticEncounters(master: CRandomEncounters): int {
    var encounters_spawn_count: int;
    var has_spawned: bool;
    var i: int;

    encounters_spawn_count = 0;

    for (i = 0; i < this.encounters.Size(); i += 1) {
      has_spawned = this.trySpawnStaticEncounter(master, this.encounters[i]);

      // NDEBUG("has spawned: " + has_spawned);

      if (has_spawned) {
        encounters_spawn_count += 1;
      }
    }

    this.already_spawned_registered_encounters = true;

    return encounters_spawn_count;
  }

  private latent function trySpawnStaticEncounter(master: CRandomEncounters, encounter: RER_StaticEncounter): bool {

    if (!encounter.canSpawn()) {
      LogChannel('modRandomEncounters', "can spawn: NO");
      return false;
    }

    LogChannel('modRandomEncounters', "can spawn: YES");

    encounter.bestiary_entry.spawn(
      master,
      encounter.getSpawningPosition(),
      , // count
      , // density
      EncounterType_HUNTINGGROUND, // encounter type
      RER_flag(
        RER_BESF_NO_TROPHY, 
        !master
          .settings
          .trophies_enabled_by_encounter[EncounterType_HUNTINGGROUND]
      ) | RER_BESF_NO_PERSIST | RER_BESF_NO_ECOSYSTEM_EFFECT
    );

    return true;
  }

}

class RER_StaticEncounter {

  var bestiary_entry: RER_BestiaryEntry;

  var position: Vector;

  var region_constraint: RER_RegionConstraint;

  // used to fetch the spawning chance from the menu.
  var type: RER_StaticEncounterType;
  default type = StaticEncounterType_SMALL;

  var radius: float;
  default radius = 0.01;

  public function isInRegion(region: string): bool {
    if (this.region_constraint == RER_RegionConstraint_NO_VELEN && (region == "no_mans_land" || region == "novigrad")
    ||  this.region_constraint == RER_RegionConstraint_NO_SKELLIGE && (region == "skellige" || region == "kaer_morhen")
    ||  this.region_constraint == RER_RegionConstraint_NO_TOUSSAINT && region == "bob"
    ||  this.region_constraint == RER_RegionConstraint_NO_WHITEORCHARD && region == "prolog_village"
    ||  this.region_constraint == RER_RegionConstraint_ONLY_TOUSSAINT && region != "bob"
    ||  this.region_constraint == RER_RegionConstraint_ONLY_WHITEORCHARD && region != "prolog_village"
    ||  this.region_constraint == RER_RegionConstraint_ONLY_SKELLIGE && region != "skellige" && region != "kaer_morhen"
    ||  this.region_constraint == RER_RegionConstraint_ONLY_VELEN && region != "no_mans_land" && region != "novigrad") {
      return false;
    }

    return true;
  }

  public function canSpawn(): bool {
    var entities: array<CGameplayEntity>;
    var current_region: string;
    var radius: float;
    var i: int;

    if (thePlayer.IsCiri()) {
      return false;
    }

    current_region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

    if (!this.isInRegion(current_region)) {
      return false;
    }

    if (!this.rollSpawningChance()) {
      return false;
    }

    // check if the player is nearby, cancel spawn.
    radius = (this.radius * this.radius) * 5
           + 50 * 50; // also add 50 meters to the radius
    if (VecDistanceSquared(thePlayer.GetWorldPosition(), this.position) < radius) {
      NLOG("StaticEncounter player too close");
      return false;
    }

    // check if an enemy from the `bestiary_entry` is nearby, cancel spawn.
    FindGameplayEntitiesCloseToPoint(
      entities,
      this.position,
      this.radius + 20, // the +20 is to still catch monster on small radius in case they move
      1 * (int)this.radius,
      , // tags
      , // queryflags
      , // target
      'CNewNPC'
    );

    if (areThereEntitiesWithSameTemplate(entities)) {
      return false;
    }

    LogChannel('modRandomEncounters', "StaticEncounter can spawn");

    return true;
  }

  private function areThereEntitiesWithSameTemplate(entities: array<CGameplayEntity>): bool {
    var hashed_name: string;
    var i: int;

    for (i = 0; i < entities.Size(); i += 1) {
      hashed_name = entities[i].GetReadableName();

      // we found a nearby enemy that is from the same template
      if (this.isTemplateInEntry(hashed_name)) {
        LogChannel('modRandomEncounters', "StaticEncounter already spawned");

        return true;
      }
    }
    
    return false;
  }

  private function isTemplateInEntry(template: string): bool {
    var i: int;

    for (i = 0; i < this.bestiary_entry.template_list.templates.Size(); i += 1) {
      if (this.bestiary_entry.template_list.templates[i].template == template) {
        return true;
      }
    }

    return false;
  }

  public function getSpawningPosition(): Vector {
    var max_attempt_count: int;
    var current_spawn_position: Vector;
    var i: int;

    max_attempt_count = 10;

    for (i = 0; i < max_attempt_count; i += 1) {
      current_spawn_position = this.position
        + VecRingRand(0, this.radius);

      if (getGroundPosition(current_spawn_position, , this.radius)) {
        return current_spawn_position;
      }
    }

    return this.position;
  }

  //
  // return `true` if the roll succeeded, and false if it didn't.
  private function rollSpawningChance(): bool {
    var spawn_chance: float;

    spawn_chance = this.getSpawnChance();

    if (RandRangeF(100) < spawn_chance) {
      return true;
    }

    return false;
  }

  //
  // fetch the spawning chance from the mod menu based on the static encounter type
  private function getSpawnChance(): float {
    var config_wrapper: CInGameConfigWrapper;

    config_wrapper = theGame.GetInGameConfigWrapper();

    if (this.type == StaticEncounterType_LARGE) {
      return StringToFloat(
        config_wrapper
        .GetVarValue('RERencountersGeneral', 'RERstaticEncounterLargeSpawnChance')
      );
    }
    else {
      return StringToFloat(
        config_wrapper
        .GetVarValue('RERencountersGeneral', 'RERstaticEncounterSmallSpawnChance')
      );
    }
  }

}

enum RER_StaticEncounterType {
  StaticEncounterType_SMALL = 0,
  StaticEncounterType_LARGE = 1,
}

latent function RER_registerStaticEncounter(master: CRandomEncounters, type: CreatureType, position: Vector, constraint: RER_RegionConstraint, radius: float, encounter_type: RER_StaticEncounterType, optional do_not_spawn: bool) {
  var new_static_encounter: RER_StaticEncounter;

  new_static_encounter = new RER_StaticEncounter in master;
  new_static_encounter.bestiary_entry = master.bestiary.getEntry(master, type);
  new_static_encounter.position = position;
  new_static_encounter.region_constraint = constraint;
  new_static_encounter.radius = radius;
  new_static_encounter.type = encounter_type;

  master
    .static_encounter_manager
    .registerStaticEncounter(master, new_static_encounter);
}

latent function RER_registerStaticEncountersLucOliver(master: CRandomEncounters, optional do_not_spawn: bool) {
  // White Orchard swamp
  RER_registerStaticEncounter(
    master,
    CreatureHAG,
    Vector(-417, 246, -0.1),
    RER_RegionConstraint_ONLY_WHITEORCHARD,
    20,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // White Orchard Burned house
  RER_registerStaticEncounter(
    master,
    CreatureNOONWRAITH,
    Vector(-165, -104, 6.6),
    RER_RegionConstraint_ONLY_WHITEORCHARD,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // White Orchard Ghoul near power
  RER_registerStaticEncounter(
    master,
    CreatureGHOUL,
    Vector(-92, -330, 32),
    RER_RegionConstraint_ONLY_WHITEORCHARD,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // White Orchard By Well
  RER_registerStaticEncounter(
    master,
    CreatureHUMAN,
    Vector(32, -269, 13.3),
    RER_RegionConstraint_ONLY_WHITEORCHARD,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // White Orchard near pond
  RER_registerStaticEncounter(
    master,
    CreatureDROWNER,
    Vector(120, -220, 0.5),
    RER_RegionConstraint_ONLY_WHITEORCHARD,
    20,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // White Orchard near stones in forest
  RER_registerStaticEncounter(
    master,
    CreatureBEAR,
    Vector(92, -138, 4.2),
    RER_RegionConstraint_ONLY_WHITEORCHARD,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // White Orchard near fields
  RER_registerStaticEncounter(
    master,
    CreatureHUMAN,
    Vector(137, 38, 1.1),
    RER_RegionConstraint_ONLY_WHITEORCHARD,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // White Orchard Near thy graveyard
  RER_registerStaticEncounter(
    master,
    CreatureWRAITH,
    Vector(-78, 295, 4),
    RER_RegionConstraint_ONLY_WHITEORCHARD,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // White Orchard horpse corpse
  RER_registerStaticEncounter(
    master,
    CreatureGHOUL,
    Vector(73, 285, 8.3),
    RER_RegionConstraint_ONLY_WHITEORCHARD,
    20,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // White Orchard field with nothing
  RER_registerStaticEncounter(
    master,
    CreatureBARGHEST,
    Vector(142, 326, 14.4),
    RER_RegionConstraint_ONLY_WHITEORCHARD,
    20,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // White Orchard GATE
  RER_registerStaticEncounter(
    master,
    CreatureHUMAN,
    Vector(406, 211, 15.2),
    RER_RegionConstraint_ONLY_WHITEORCHARD,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // White Orchard Waterfall
  RER_registerStaticEncounter(
    master,
    CreatureHAG,
    Vector(421, 191, -0.3),
    RER_RegionConstraint_ONLY_WHITEORCHARD,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // White Orchard Bonus
  RER_registerStaticEncounter(
    master,
    CreatureCHORT,
    Vector(311, 49, 0.2),
    RER_RegionConstraint_ONLY_WHITEORCHARD,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // A random swamp in velen
  RER_registerStaticEncounter(
    master,
    CreatureDROWNER,
    Vector(360, -375, 0),
    RER_RegionConstraint_ONLY_VELEN,
    50,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // A burnt house near the water
  RER_registerStaticEncounter(
    master,
    CreatureHUMAN,
    Vector(620, -477, 0.9),
    RER_RegionConstraint_ONLY_VELEN,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Abandonned field
  RER_registerStaticEncounter(
    master,
    CreatureALGHOUL,
    Vector(796, 490, 13.4),
    RER_RegionConstraint_ONLY_VELEN,
    10,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // entrace to wyvern cave
  RER_registerStaticEncounter(
    master,
    CreatureTROLL,
    Vector(1889, 47, 41.8),
    RER_RegionConstraint_ONLY_VELEN,
    10,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Troll's swamp
  RER_registerStaticEncounter(
    master,
    CreatureHAG,
    Vector(1487, 1132, -0.3),
    RER_RegionConstraint_ONLY_VELEN,
    10,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Haunted forest
  RER_registerStaticEncounter(
    master,
    CreatureLESHEN,
    Vector(235, 1509, 19),
    RER_RegionConstraint_ONLY_VELEN,
    10,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Beach, near good troll
  RER_registerStaticEncounter(
    master,
    CreatureFORKTAIL,
    Vector(103, 892, 7.7),
    RER_RegionConstraint_ONLY_VELEN,
    10,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Basilisk place
  RER_registerStaticEncounter(
    master,
    CreatureBASILISK,
    Vector(-90, 1487, 9.3),
    RER_RegionConstraint_ONLY_VELEN,
    10,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // A abandonned house with skeletons 
  RER_registerStaticEncounter(
    master,
    CreatureHUMAN,
    Vector(1060, -305, 6),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Harpy location
  RER_registerStaticEncounter(
    master,
    CreatureHARPY,
    Vector(-98, 603, 11.1),
    RER_RegionConstraint_ONLY_VELEN,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // a flat surface in the mountain near the swamp
  RER_registerStaticEncounter(
    master,
    CreatureWYVERN,
    Vector(1329, -326, 50),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Near Graveyard, 
  RER_registerStaticEncounter(
    master,
    CreatureGHOUL,
    Vector(-218, 380, 15.4),
    RER_RegionConstraint_ONLY_VELEN,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // a beach in novigrad
  RER_registerStaticEncounter(
    master,
    CreatureDROWNER,
    Vector(375, 1963, 1),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // a random lost village
  RER_registerStaticEncounter(
    master,
    CreatureFIEND,
    Vector(1995, -643, 0),
    RER_RegionConstraint_ONLY_VELEN,
    25,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // people hanged on a tree
  RER_registerStaticEncounter(
    master,
    CreatureWRAITH,
    Vector(-447, -77, 10),
    RER_RegionConstraint_ONLY_VELEN,
    15,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Forest with insects
  RER_registerStaticEncounter(
    master,
    CreatureENDREGA,
    Vector(512, 1232, 11.3),
    RER_RegionConstraint_ONLY_VELEN,
    25,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // A pond near boat
  RER_registerStaticEncounter(
    master,
    CreatureHAG,
    Vector(-450, -440, 0),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // NORTH near endregas
  RER_registerStaticEncounter(
    master,
    CreatureARACHAS,
    Vector(797, 2318, 7),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Abandonned ilse
  RER_registerStaticEncounter(
    master,
    CreatureFOGLET,
    Vector(529, -117, -7.9),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // South of crow's perch
  RER_registerStaticEncounter(
    master,
    CreatureNEKKER,
    Vector(161, -108, 5.4),
    RER_RegionConstraint_ONLY_VELEN,
    20,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Middle of nowhere
  RER_registerStaticEncounter(
    master,
    CreatureBARGHEST,
    Vector(667, 150, 4.5),
    RER_RegionConstraint_ONLY_VELEN,
    20,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Unused Pong
  RER_registerStaticEncounter(
    master,
    CreatureHAG,
    Vector(1335, 524, 5.3),
    RER_RegionConstraint_ONLY_VELEN,
    20,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // rotfiend nest
  RER_registerStaticEncounter(
    master,
    CreatureROTFIEND,
    Vector(350, 980, 1.5),
    RER_RegionConstraint_ONLY_VELEN,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Mage House
  RER_registerStaticEncounter(
    master,
    CreatureELEMENTAL,
    Vector(2430, 977, 39.4),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Road to Lurtch
  RER_registerStaticEncounter(
    master,
    CreatureALGHOUL,
    Vector(1055, -1, 48.2),
    RER_RegionConstraint_ONLY_VELEN,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Contract mine
  RER_registerStaticEncounter(
    master,
    CreatureENDREGA,
    Vector(748, 902, 2.4),
    RER_RegionConstraint_ONLY_VELEN,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Near Toderas
  RER_registerStaticEncounter(
    master,
    CreatureENDREGA,
    Vector(1627, -11, 13.2),
    RER_RegionConstraint_ONLY_VELEN,
    15,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Near horse cadavar
  RER_registerStaticEncounter(
    master,
    CreatureGHOUL,
    Vector(1462, -850, 29.5),
    RER_RegionConstraint_ONLY_VELEN,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // in forest
  RER_registerStaticEncounter(
    master,
    CreatureARACHAS,
    Vector(-92, 31, 10.3),
    RER_RegionConstraint_ONLY_VELEN,
    10,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Field with people
  RER_registerStaticEncounter(
    master,
    CreatureHUMAN,
    Vector(625, 1403, 1.8),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Near Wyvern castle
  RER_registerStaticEncounter(
    master,
    CreatureWYVERN,
    Vector(-255, 863, 30.8),
    RER_RegionConstraint_ONLY_VELEN,
    15,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Near thy swamp
  RER_registerStaticEncounter(
    master,
    CreatureARACHAS,
    Vector(1070, -638, 0.4),
    RER_RegionConstraint_ONLY_VELEN,
    10,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Leshen Forest
  RER_registerStaticEncounter(
    master,
    CreatureLESHEN,
    Vector(1268, -166, 58.4),
    RER_RegionConstraint_ONLY_VELEN,
    30,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // South Velen
  RER_registerStaticEncounter(
    master,
    CreatureGRYPHON,
    Vector(-162, -1117, 16.4),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Haunted treasure
  RER_registerStaticEncounter(
    master,
    CreatureWRAITH,
    Vector(-213, -971, 7.8),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Very lost treasure
  RER_registerStaticEncounter(
    master,
    CreatureBARGHEST,
    Vector(634, -909, 9.1),
    RER_RegionConstraint_ONLY_VELEN,
    15,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Near a Grave
  RER_registerStaticEncounter(
    master,
    CreatureGARGOYLE,
    Vector(191, -1271, 3.3),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Near the city with ghouls
  RER_registerStaticEncounter(
    master,
    CreatureHUMAN,
    Vector(1570, 1375, 3.3),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Near forest near city
  RER_registerStaticEncounter(
    master,
    CreatureWEREWOLF,
    Vector(1178, 2117, 1.7),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // empty field
  RER_registerStaticEncounter(
    master,
    CreatureNOONWRAITH,
    Vector(1529, 1928, 5.7),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // empty field
  RER_registerStaticEncounter(
    master,
    CreatureNIGHTWRAITH,
    Vector(2070, 925, 0.1),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // a grotto in the middle of skellige
  RER_registerStaticEncounter(
    master,
    CreatureBEAR,
    Vector(671, 689, 81),
    RER_RegionConstraint_ONLY_SKELLIGE,
    40,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // a tomb in the middle of skellige
  RER_registerStaticEncounter(
    master,
    CreatureNIGHTWRAITH,
    Vector(589, 127, 40.1),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Road west of blandare
  RER_registerStaticEncounter(
    master,
    CreatureHUMAN,
    Vector(436, 67, 37.7),
    RER_RegionConstraint_ONLY_SKELLIGE,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Cyclops road
  RER_registerStaticEncounter(
    master,
    CreatureCYCLOP,
    Vector(517, 429, 55.4),
    RER_RegionConstraint_ONLY_SKELLIGE,
    10,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Near Troll cave
  RER_registerStaticEncounter(
    master,
    CreatureTROLL,
    Vector(430, 361, 44.6),
    RER_RegionConstraint_ONLY_SKELLIGE,
    10,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // House with skeleton
  RER_registerStaticEncounter(
    master,
    CreatureDROWNER,
    Vector(751, -149, 31.2),
    RER_RegionConstraint_ONLY_SKELLIGE,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // in Forest sawmill
  RER_registerStaticEncounter(
    master,
    CreatureEKIMMARA,
    Vector(866, 168, 66),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Elemental place
  RER_registerStaticEncounter(
    master,
    CreatureELEMENTAL,
    Vector(1171, 187, 89.1),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Forest exist
  RER_registerStaticEncounter(
    master,
    CreatureENDREGA,
    Vector(901, 328, 86.7),
    RER_RegionConstraint_ONLY_SKELLIGE,
    15,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Vamp lair
  RER_registerStaticEncounter(
    master,
    CreatureKATAKAN,
    Vector(713, 482, 146.2),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Bridge to Eldberg
  RER_registerStaticEncounter(
    master,
    CreatureHUMAN,
    Vector(-791, 210, 10.2),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Forest Between Cities
  RER_registerStaticEncounter(
    master,
    CreatureNEKKER,
    Vector(-415, -244, 42.3),
    RER_RegionConstraint_ONLY_SKELLIGE,
    20,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Leshen Forest
  RER_registerStaticEncounter(
    master,
    CreatureLESHEN,
    Vector(-107, -223, 49),
    RER_RegionConstraint_ONLY_SKELLIGE,
    10,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Near Crypt
  RER_registerStaticEncounter(
    master,
    CreatureALGHOUL,
    Vector(93, 373, 18.4),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Open Field
  RER_registerStaticEncounter(
    master,
    CreatureCYCLOP,
    Vector(313, -467, 10.2),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // North Castle
  RER_registerStaticEncounter(
    master,
    CreatureEKIMMARA,
    Vector(390, 738, 106.6),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Whale graves
  RER_registerStaticEncounter(
    master,
    CreatureCYCLOP,
    Vector(1024, 712, 1.6),
    RER_RegionConstraint_ONLY_SKELLIGE,
    10,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Abandonned Village
  RER_registerStaticEncounter(
    master,
    CreatureKATAKAN,
    Vector(1231, 27, 2),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Road to dream Cave
  RER_registerStaticEncounter(
    master,
    CreatureNOONWRAITH,
    Vector(-56, -1228, 5.2),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Left of Urialla
  RER_registerStaticEncounter(
    master,
    CreatureBERSERKER,
    Vector(1278, 1980, 29.50),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Right of Urialla
  RER_registerStaticEncounter(
    master,
    CreatureHAG,
    Vector(1600, 1873, 5.7),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Ulfedinn place
  RER_registerStaticEncounter(
    master,
    CreatureWEREWOLF,
    Vector(-12, -514, 66),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Cyclop place
  RER_registerStaticEncounter(
    master,
    CreatureCYCLOP,
    Vector(-608, -617, 5.2),
    RER_RegionConstraint_ONLY_SKELLIGE,
    20,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Mountain
  RER_registerStaticEncounter(
    master,
    CreatureHARPY,
    Vector(107, -686, 90.6),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // destroyed forest
  RER_registerStaticEncounter(
    master,
    CreatureFOGLET,
    Vector(995, -146, 18.4),
    RER_RegionConstraint_ONLY_SKELLIGE,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // destroyed forest beach
  RER_registerStaticEncounter(
    master,
    CreatureDROWNER,
    Vector(1116, -283, 1),
    RER_RegionConstraint_ONLY_SKELLIGE,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );


  // destroyed house on spikeroog
  RER_registerStaticEncounter(
    master,
    CreatureBERSERKER,
    Vector(-1416, 1510, 24.3),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // spikeroog south beah
  RER_registerStaticEncounter(
    master,
    CreatureCOCKATRICE,
    Vector(-1925, 1045, 7.7),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // spikeroog Neach near treasure
  RER_registerStaticEncounter(
    master,
    CreatureDRACOLIZARD,
    Vector(-1534, 1176, 7.6),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Faroe Left
  RER_registerStaticEncounter(
    master,
    CreatureBERSERKER,
    Vector(1679, -1805, 8.8),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Faroe near wolves
  RER_registerStaticEncounter(
    master,
    CreatureFIEND,
    Vector(1998, -1990, 12.9),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Hindarsal carrefour
  RER_registerStaticEncounter(
    master,
    CreatureNEKKER,
    Vector(2509, 154, 21.3),
    RER_RegionConstraint_ONLY_SKELLIGE,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Hindarsal carrefour
  RER_registerStaticEncounter(
    master,
    CreatureSKELTROLL,
    Vector(2238, 85, 48.3),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Hindarsal Beach
  RER_registerStaticEncounter(
    master,
    CreatureSIREN,
    Vector(2603,-196, 8.1),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Hindarsal Road
  RER_registerStaticEncounter(
    master,
    CreatureHUMAN,
    Vector(2711,-26, 30.6),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Hindarsal carrefour
  RER_registerStaticEncounter(
    master,
    CreatureSKELTROLL,
    Vector(2853, 50, 40.1),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Anti-Religion island
  RER_registerStaticEncounter(
    master,
    CreatureFORKTAIL,
    Vector(353, 1559, 8.5),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Island of sirens
  RER_registerStaticEncounter(
    master,
    CreatureCOCKATRICE,
    Vector(148, 2097, 7.2),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Island with corpses
  RER_registerStaticEncounter(
    master,
    CreatureHARPY,
    Vector(-508, 2115, 6.6),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Island with Bags
  RER_registerStaticEncounter(
    master,
    CreatureGRYPHON,
    Vector(-954, 1967, 7.2),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Island with Chest
  RER_registerStaticEncounter(
    master,
    CreatureARACHAS,
    Vector(-833, 2049, 1.3),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Island south
  RER_registerStaticEncounter(
    master,
    CreatureGRYPHON,
    Vector(-218, -1962, 7.5),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Island  with bear corpse
  RER_registerStaticEncounter(
    master,
    CreatureTROLL,
    Vector(-1770, -1898, 35.5),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Island  with bear corpse Beach
  RER_registerStaticEncounter(
    master,
    CreatureNEKKER,
    Vector(-1781, -1998, 1.4),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Island  with Cyclop
  RER_registerStaticEncounter(
    master,
    CreatureBERSERKER,
    Vector(-2603, 1599, 25.1),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Golem place
  RER_registerStaticEncounter(
    master,
    CreatureGOLEM,
    Vector(1664, 2560, 40.5),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Corpse 
  RER_registerStaticEncounter(
    master,
    CreatureALGHOUL,
    Vector(1536, 2612, 27.4),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Jade small deport
  RER_registerStaticEncounter(
    master,
    CreatureWEREWOLF,
    Vector(1249, 2534, 11,6),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Haunted forest
  RER_registerStaticEncounter(
    master,
    CreatureLESHEN,
    Vector(2716, 1725, 30.5),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Gryphon feeding
  RER_registerStaticEncounter(
    master,
    CreatureGRYPHON,
    Vector(2570, 1585, 53.7),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Road to Brunwich
  RER_registerStaticEncounter(
    master,
    CreatureSPIDER,
    Vector(2055, 2331, 20.2),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // River of house
  RER_registerStaticEncounter(
    master,
    CreatureSPIDER,
    Vector(2305, 1996, 25.3),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Slyzard nest
  RER_registerStaticEncounter(
    master,
    CreatureDRACOLIZARD,
    Vector(1087, -853, 45),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    15,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Ruin near Hanse
  RER_registerStaticEncounter(
    master,
    CreatureBRUXA,
    Vector(777, -681, 41.8),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Empty road north
  RER_registerStaticEncounter(
    master,
    CreatureSPIDER,
    Vector(-829, 4, 4.4),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Echinops nest
  RER_registerStaticEncounter(
    master,
    CreatureECHINOPS,
    Vector(-180, -816, 18.3),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Slyzard and chest
  RER_registerStaticEncounter(
    master,
    CreatureDRACOLIZARD,
    Vector(1055, -601, 80),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Echinops nest
  RER_registerStaticEncounter(
    master,
    CreatureECHINOPS,
    Vector(127, -1492, 5.7),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Haunted House
  RER_registerStaticEncounter(
    master,
    CreatureBARGHEST,
    Vector(525, -1833, 71.4),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Empty Pound
  RER_registerStaticEncounter(
    master,
    CreatureDROWNERDLC,
    Vector(-228, -1788, 43.4),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // mountain near Goylat
  RER_registerStaticEncounter(
    master,
    CreatureGRYPHON,
    Vector(-10, -363, 31.7),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Wraith Beach
  RER_registerStaticEncounter(
    master,
    CreatureNOONWRAITH,
    Vector(-446, -279, 1),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Wraith Beach
  RER_registerStaticEncounter(
    master,
    CreatureNIGHTWRAITH,
    Vector(-446, -269, 1),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Near Emerald Lake
  RER_registerStaticEncounter(
    master,
    CreatureDROWNERDLC,
    Vector(-853, -739, 61.1),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Forest between village
  RER_registerStaticEncounter(
    master,
    CreatureWEREWOLF,
    Vector(-1206, -938, 116.6),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Ruin of prison
  RER_registerStaticEncounter(
    master,
    CreatureBRUXA,
    Vector(-1195, -841, 117.2),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Clear Field
  RER_registerStaticEncounter(
    master,
    CreatureDRACOLIZARD,
    Vector(-868, -466, 57),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Near Town
  RER_registerStaticEncounter(
    master,
    CreatureBARGHEST,
    Vector(-1000, -266, 14.1),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // House with rotfiend
  RER_registerStaticEncounter(
    master,
    CreatureSKELTROLL,
    Vector(-746, -74, 0),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Cavern
  RER_registerStaticEncounter(
    master,
    CreatureLESHEN,
    Vector(-780, -228, 6.7),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Pond Near Carrefour
  RER_registerStaticEncounter(
    master,
    CreatureDROWNERDLC,
    Vector(-853, -739, 61.1),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Horse corpse
  RER_registerStaticEncounter(
    master,
    CreatureWIGHT,
    Vector(-229, 375, 8.3),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // North of Plegmund bridge
  RER_registerStaticEncounter(
    master,
    CreatureCENTIPEDE,
    Vector(-472, 5, 1.6),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Pond Near shealmar
  RER_registerStaticEncounter(
    master,
    CreatureDROWNERDLC,
    Vector(-380, 192, 0),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // South of occupied Town
  RER_registerStaticEncounter(
    master,
    CreatureFIEND,
    Vector(-339, 480, 1.5),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Carrefour in north of map
  RER_registerStaticEncounter(
    master,
    CreatureCYCLOP,
    Vector(-57, 481, 13.8),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // North of Plegmund bridge
  RER_registerStaticEncounter(
    master,
    CreatureCENTIPEDE,
    Vector(164, 224, 1.5),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Abandonned storage
  RER_registerStaticEncounter(
    master,
    CreatureWIGHT,
    Vector(-106, -184, 23.4),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Basilisk Place
  RER_registerStaticEncounter(
    master,
    CreatureBASILISK,
    Vector(-69, -65, 10),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Trolls
  RER_registerStaticEncounter(
    master,
    CreatureTROLL,
    Vector(281, -13, 0.5),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Respawn Barghest
  RER_registerStaticEncounter(
    master,
    CreatureBARGHEST,
    Vector(49, -817, 6.3),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Centipede love shaelmars
  RER_registerStaticEncounter(
    master,
    CreatureCENTIPEDE,
    Vector(200, -742, 0.3),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Pond Near graves
  RER_registerStaticEncounter(
    master,
    CreatureDROWNERDLC,
    Vector(531, -264, 12.1),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Grave with Alp
  RER_registerStaticEncounter(
    master,
    CreatureBRUXA,
    Vector(439, -215, 1.1),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Echinops nest
  RER_registerStaticEncounter(
    master,
    CreatureECHINOPS,
    Vector(273, -2136, 63.3),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Near Werewolf Cave
  RER_registerStaticEncounter(
    master,
    CreatureWEREWOLF,
    Vector(678, -69, 7.1),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Centipede Nest
  RER_registerStaticEncounter(
    master,
    CreatureCENTIPEDE,
    Vector(-1, -1989, 78.8),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // Super Random
  RER_registerStaticEncounter(
    master,
    CreatureWEREWOLF,
    Vector(473, -1559, 26.4),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Vampires place
  RER_registerStaticEncounter(
    master,
    CreatureFLEDER,
    Vector(732, -1603, 14.3),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Vampires place
  RER_registerStaticEncounter(
    master,
    CreatureKATAKAN,
    Vector(736, -1601, 13.9),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Vampires place
  RER_registerStaticEncounter(
    master,
    CreatureEKIMMARA,
    Vector(736, -1393, 13),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // Vampires place
  RER_registerStaticEncounter(
    master,
    CreatureGARKAIN,
    Vector(728, -1596, 13.9),
    RER_RegionConstraint_ONLY_TOUSSAINT,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );
}

latent function RER_registerStaticEncountersAeltoth(master: CRandomEncounters, optional do_not_spawn: bool) {

  // A random swamp in velen
  RER_registerStaticEncounter(
    master,
    CreatureDROWNER,
    Vector(360, -375, 0),
    RER_RegionConstraint_ONLY_VELEN,
    50,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // A burnt house near the water
  RER_registerStaticEncounter(
    master,
    CreatureHUMAN,
    Vector(620, -477, 0.9),
    RER_RegionConstraint_ONLY_VELEN,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // A forest near water
  RER_registerStaticEncounter(
    master,
    CreatureENDREGA,
    Vector(730, -500, 11),
    RER_RegionConstraint_ONLY_VELEN,
    50,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // A abandonned house with skeletons and hanged people in the forest
  RER_registerStaticEncounter(
    master,
    CreatureHUMAN,
    Vector(1060, -305, 6),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // a mountain near the swamp
  RER_registerStaticEncounter(
    master,
    CreatureFORKTAIL,
    Vector(1310, -373, 22),
    RER_RegionConstraint_ONLY_VELEN,
    50,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // a flat surface in the mountain near the swamp
  RER_registerStaticEncounter(
    master,
    CreatureWYVERN,
    Vector(1329, -326, 43),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // abandonned human camp
  RER_registerStaticEncounter(
    master,
    CreatureBEAR,
    Vector(990, -189, 15),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // a ruined castle near a swamp
  RER_registerStaticEncounter(
    master,
    CreatureENDREGA,
    Vector(1060, 1057, 7),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // mountains with lots of harpies
  RER_registerStaticEncounter(
    master,
    CreatureHARPY,
    Vector(-200, 795, 31),
    RER_RegionConstraint_ONLY_VELEN,
    25,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // castle with vanilla wyvern
  RER_registerStaticEncounter(
    master,
    CreatureWYVERN,
    Vector(-286, 920, 14),
    RER_RegionConstraint_ONLY_VELEN,
    25,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // castle basilisk from ciri scene
  RER_registerStaticEncounter(
    master,
    CreatureBASILISK,
    Vector(-240, 565, 11),
    RER_RegionConstraint_ONLY_VELEN,
    50,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // burning pyre full of human corpses
  RER_registerStaticEncounter(
    master,
    CreatureROTFIEND,
    Vector(530, 956, 1),
    RER_RegionConstraint_ONLY_VELEN,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // burning pyre full of human corpses
  RER_registerStaticEncounter(
    master,
    CreatureHAG,
    Vector(530, 956, 1),
    RER_RegionConstraint_ONLY_VELEN,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // forest full of endregas
  RER_registerStaticEncounter(
    master,
    CreatureENDREGA,
    Vector(567, 1246, 9),
    RER_RegionConstraint_ONLY_VELEN,
    15,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // forest full of endregas
  RER_registerStaticEncounter(
    master,
    CreatureGRYPHON,
    Vector(604, 1200, 12),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // a beach in novigrad
  RER_registerStaticEncounter(
    master,
    CreatureDROWNER,
    Vector(375, 1963, 1),
    RER_RegionConstraint_ONLY_VELEN,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // rotfiend nest
  RER_registerStaticEncounter(
    master,
    CreatureROTFIEND,
    Vector(350, 980, 1.5),
    RER_RegionConstraint_ONLY_VELEN,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // rotfiend nest
  RER_registerStaticEncounter(
    master,
    CreatureHAG,
    Vector(350, 980, 1.5),
    RER_RegionConstraint_ONLY_VELEN,
    20,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // abandoned village near the swamp with blood everywhere
  RER_registerStaticEncounter(
    master,
    CreatureWEREWOLF,
    Vector(638, -644, 2.5),
    RER_RegionConstraint_ONLY_VELEN,
    20,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // White Orchard: ghouls in the cemetery
  RER_registerStaticEncounter(
    master,
    CreatureGHOUL,
    Vector(-24, 284, 1.5),
    RER_RegionConstraint_ONLY_WHITEORCHARD,
    20,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // White Orchard: Devil by the well
  RER_registerStaticEncounter(
    master,
    CreatureHUMAN,
    Vector(22, -264, 13),
    RER_RegionConstraint_ONLY_WHITEORCHARD,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // White Orchard: Devil by the well, lake nearby
  RER_registerStaticEncounter(
    master,
    CreatureDROWNER,
    Vector(117, -208, -0.7),
    RER_RegionConstraint_ONLY_WHITEORCHARD,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // White Orchard: An autel, somewhere in the forest
  RER_registerStaticEncounter(
    master,
    CreatureBEAR,
    Vector(88, -136, 4.25),
    RER_RegionConstraint_ONLY_WHITEORCHARD,
    5,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // White Orchard: Wall with a gate, near the map limit
  RER_registerStaticEncounter(
    master,
    CreatureHUMAN,
    Vector(400, 208, 15),
    RER_RegionConstraint_ONLY_WHITEORCHARD,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // White Orchard: Battle field, with lots of corpses
  RER_registerStaticEncounter(
    master,
    CreatureGHOUL,
    Vector(552, 186, 20),
    RER_RegionConstraint_ONLY_WHITEORCHARD,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // White Orchard: Endregas near a tree behind the mill
  RER_registerStaticEncounter(
    master,
    CreatureKIKIMORE,
    Vector(138, 348, 14),
    RER_RegionConstraint_ONLY_WHITEORCHARD,
    20,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // skellige, wraiths on a house near a lake
  RER_registerStaticEncounter(
    master,
    CreatureNIGHTWRAITH,
    Vector(378, 173, 22),
    RER_RegionConstraint_ONLY_SKELLIGE,
    15,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // a random, lost village
  RER_registerStaticEncounter(
    master,
    CreatureFIEND,
    Vector(1995, -643, 0),
    RER_RegionConstraint_ONLY_VELEN,
    25,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // people hanged on a tree
  RER_registerStaticEncounter(
    master,
    CreatureWRAITH,
    Vector(-447, -77, 10),
    RER_RegionConstraint_ONLY_VELEN,
    15,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // near a water body where a cockatrice is in vanilla
  RER_registerStaticEncounter(
    master,
    CreatureCOCKATRICE,
    Vector(-90, -848, 6),
    RER_RegionConstraint_ONLY_VELEN,
    40,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // a big gcave
  RER_registerStaticEncounter(
    master,
    CreatureKATAKAN,
    Vector(1956, 32, 43),
    RER_RegionConstraint_ONLY_VELEN,
    20,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // cave where the two ladies want to cut the nails of the dead
  RER_registerStaticEncounter(
    master,
    CreatureKATAKAN,
    Vector(58, 487, 10.45),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // entrance of the cave where the two ladies want to cut the nails of
  // the dead
  RER_registerStaticEncounter(
    master,
    CreatureTROLL,
    Vector(140, 393, 23),
    RER_RegionConstraint_ONLY_SKELLIGE,
    5,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // a guarded treasure with a forktail
  RER_registerStaticEncounter(
    master,
    CreatureFORKTAIL,
    Vector(11, 237, 39),
    RER_RegionConstraint_ONLY_SKELLIGE,
    10,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // a big stone where there is sometimes a cyclop in vanilla
  RER_registerStaticEncounter(
    master,
    CreatureCYCLOP,
    Vector(420, 188, 64),
    RER_RegionConstraint_ONLY_SKELLIGE,
    20,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // a beach near kaer trolde
  RER_registerStaticEncounter(
    master,
    CreatureHAG,
    Vector(88, 167, 0),
    RER_RegionConstraint_ONLY_SKELLIGE,
    20,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // a mountain with lots of harpies
  RER_registerStaticEncounter(
    master,
    CreatureHARPY,
    Vector(645, 320, 87),
    RER_RegionConstraint_ONLY_SKELLIGE,
    50,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // a mountain peak
  RER_registerStaticEncounter(
    master,
    CreatureFIEND,
    Vector(737, 560, 155),
    RER_RegionConstraint_ONLY_SKELLIGE,
    30,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // a beach with broken boats
  RER_registerStaticEncounter(
    master,
    CreatureCYCLOP,
    Vector(1064, 570, 1),
    RER_RegionConstraint_ONLY_SKELLIGE,
    50,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // a beach with broken boats
  RER_registerStaticEncounter(
    master,
    CreatureARACHAS,
    Vector(978, 720, 18),
    RER_RegionConstraint_ONLY_SKELLIGE,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // a grotto in the middle of skellige
  RER_registerStaticEncounter(
    master,
    CreatureBEAR,
    Vector(671, 689, 81),
    RER_RegionConstraint_ONLY_SKELLIGE,
    40,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // a forest north east of skellige
  RER_registerStaticEncounter(
    master,
    CreatureLESHEN,
    Vector(546, 591, 63),
    RER_RegionConstraint_ONLY_SKELLIGE,
    55,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // a small lake near a forest
  RER_registerStaticEncounter(
    master,
    CreatureTROLL,
    Vector(426, 377, 44),
    RER_RegionConstraint_ONLY_SKELLIGE,
    20,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // lake south of skellige
  RER_registerStaticEncounter(
    master,
    CreatureHAG,
    Vector(-99, -525, 63),
    RER_RegionConstraint_ONLY_SKELLIGE,
    40,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // lake south of skellige
  RER_registerStaticEncounter(
    master,
    CreatureDROWNER,
    Vector(-99, -525, 63),
    RER_RegionConstraint_ONLY_SKELLIGE,
    40,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // lake south of skellige
  RER_registerStaticEncounter(
    master,
    CreatureNEKKER,
    Vector(-99, -525, 63),
    RER_RegionConstraint_ONLY_SKELLIGE,
    60,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // ruins south of skellige, near a lage
  RER_registerStaticEncounter(
    master,
    CreatureHUMAN,
    Vector(-10, -517, 66),
    RER_RegionConstraint_ONLY_SKELLIGE,
    10,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // a forest south of skellige
  RER_registerStaticEncounter(
    master,
    CreatureENDREGA,
    Vector(-450, -512, 38),
    RER_RegionConstraint_ONLY_SKELLIGE,
    60,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // a tomb in the middle of skellige
  RER_registerStaticEncounter(
    master,
    CreatureNIGHTWRAITH,
    Vector(588, 142, 35),
    RER_RegionConstraint_ONLY_SKELLIGE,
    10,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // abandoned house with skeleton
  RER_registerStaticEncounter(
    master,
    CreatureDROWNER,
    Vector(750, -149, 31),
    RER_RegionConstraint_ONLY_SKELLIGE,
    4,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // abandoned house with skeleton
  RER_registerStaticEncounter(
    master,
    CreatureCHORT,
    Vector(792, -529, 78),
    RER_RegionConstraint_ONLY_SKELLIGE,
    4,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // siren nest
  RER_registerStaticEncounter(
    master,
    CreatureSIREN,
    Vector(387, -1161, 0),
    RER_RegionConstraint_ONLY_SKELLIGE,
    20,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // random road
  RER_registerStaticEncounter(
    master,
    CreatureHUMAN,
    Vector(432, -3, 34),
    RER_RegionConstraint_ONLY_SKELLIGE,
    100,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // a place where this is already a cyclop
  RER_registerStaticEncounter(
    master,
    CreatureCYCLOP,
    Vector(-624, -617, 5),
    RER_RegionConstraint_ONLY_SKELLIGE,
    100,
    StaticEncounterType_LARGE,
    do_not_spawn
  );

  // a treasure near the water
  RER_registerStaticEncounter(
    master,
    CreatureHAG,
    Vector(-1489, 1248, 0),
    RER_RegionConstraint_ONLY_SKELLIGE,
    30,
    StaticEncounterType_SMALL,
    do_not_spawn
  );

  // an isolated beach
  RER_registerStaticEncounter(
    master,
    CreatureWYVERN,
    Vector(-1536, 1175, 0),
    RER_RegionConstraint_ONLY_SKELLIGE,
    30,
    StaticEncounterType_LARGE,
    do_not_spawn
  );


  // var example_static_encounter: RER_StaticEncounter;

  // example_static_encounter = new RER_StaticEncounter in this;
  // example_static_encounter.bestiary_entry = parent.bestiary.entries[CreatureTROLL];
  // example_static_encounter.position = Vector(2444, 2344, 3);
  // example_static_encounter.region_constraint = RER_RegionConstraint_ONLY_VELEN;
  // example_static_encounter.radius = 5;

  // parent
  //   .static_encounter_manager
  //   .registerStaticEncounter(parent, example_static_encounter);

  // this.test();
}