///////////////////////////////
// a set of constants structs //
// that you can instantiate  //
///////////////////////////////

struct RER_Constants {

  /**
   * If you update that number, remember to maybe add an update function in
   * the Initialising state.
   */
  var version: float;
  default version = 2.10;
}

// used to define influences the
// currenth creature has over
// other creatures. Part of the
// Ecosystem feature.
struct RER_ConstantInfluences {
  // when the current creature
  // kills the other creature.
  var kills_them: float;
  default kills_them = -1.5;

  // when the current creature
  // is friend with the other
  // creature.
  var friend_with: float;
  default friend_with = 2.5;

  // when the current creature
  // has no influence over the
  // other creature.
  var no_influence: float;
  default no_influence = 0;

  // when the current creature
  // indirectly increases the
  // other creature spawn rate
  var low_indirect_influence: float;
  default low_indirect_influence = 1;

  var high_indirect_influence: float;
  default high_indirect_influence = 2;

  // when the current creature
  // doesn't directly kill the
  // other creature but when
  // it stills decreases the
  // spawn rate by a bit
  var low_bad_influence: float;
  default low_bad_influence = -0.5;

  var high_bad_influence: float;
  default high_bad_influence = -1;

  var self_influence: float;
  default self_influence = 3;

}

struct RER_ConstantCreatureTypes {
  var small_creature_begin: CreatureType;
  default small_creature_begin = CreatureHUMAN;

  var small_creature_begin_no_humans: CreatureType;
  default small_creature_begin_no_humans = CreatureARACHAS;

  var small_creature_max: CreatureType;
  default small_creature_max = CreatureDRACOLIZARD;

  var large_creature_begin: CreatureType;
  default large_creature_begin = CreatureDRACOLIZARD;

  var large_creature_max: CreatureType;
  default large_creature_max = CreatureMAX;
}