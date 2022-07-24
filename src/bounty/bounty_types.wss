
struct RER_Bounty {
  var seed: int;

  // contains information about the different groups of creature the bounty is
  // composed of.
  var random_data: RER_BountyRandomData;

  var is_active: bool;
}

struct RER_BountyRandomData {
  var main_group: RER_BountyRandomMonsterGroupData;
  var side_groups: array<RER_BountyRandomMonsterGroupData>;
}


struct RER_BountyRandomMonsterGroupData {
  // the creature type that composes this group
  var type: CreatureType;
  
  // the enemy count
  var count: int;

  var position: Vector;

  var was_killed: bool;
}