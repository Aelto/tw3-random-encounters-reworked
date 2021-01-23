///////////////////////////////
// a set a constants structs //
// that you can instantiate  //
///////////////////////////////


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
  default friend_with = 2;

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
  default self_influence = 1;

}