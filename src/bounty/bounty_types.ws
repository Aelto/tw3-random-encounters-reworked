
struct RER_Bounty {
  // used to store the seed that was used to generate the bounty. Instead of storing
  // everything about the bounty simply store the seed and use the seed to generate
  // stuff. And because we use a seed everything should be same again.
  var seed: int;

  // contains information about the different groups of creature the bounty is
  // composed of.
  var random_data: RER_BountyRandomData;

  // used to store is the bounty is active or not. When the bounty will start
  // it will be set to true
  var is_active: bool;
}

// when a bounty is created with a seed, lots of random data is generated from
// the seed. And this data needs to be generated in the same order everytime or
// else it won't be the same data anymore.
// The BountyManager has a function for this.
struct RER_BountyRandomData {
  // the groups that will compose the bounty
  var groups: array<RER_BountyRandomMonsterGroupData>;
}


struct RER_BountyRandomMonsterGroupData {
  // the creature type that composes this group
  var type: CreatureType;
  
  // the enemy count
  var count: int;

  // the group position. They are float values because they are % values of the
  // usable coordinate space.
  // So lets imagine the X usable coordinate space in Velen goes from -2000 to
  // +2000, a position_x at 0.75 means it will be 75% of this range, meaning
  // +1000. 
  var position_x: float;
  var position_y: float;

  var was_spawned: bool;
  var was_killed: bool;
  // set to true when the group was picked and was set to appear on the map.
  // but it may not be spawned yet.
  var was_picked: bool;

  // used to store the current translation heading of the bounty target. This is
  // used to know where the bounty is currently heading to avoid erratic
  // movements between each tick
  var translation_heading: float;

  // controls whether the bounty target should spawn only after the player has
  // killed a given amount of small creatures in the area.
  // the value of that int is the number of creatures that should be spawned.
  var horde_before_bounty: int;

  // controls whether the bounty target will get help from monsters during the
  // fight.
  // the value of that int is the number of creatures that should be spawned.
  var horde_during_bounty: int;
}