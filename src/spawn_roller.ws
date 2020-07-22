


struct LargeCreatureCounter {
  var type: LargeCreatureType;
  var counter: int;
}

struct SmallCreatureCounter {
  var type: SmallCreatureType;
  var counter: int;
}

// I could not find a better name for it so `SpawnRoller` it is!
// It's a huge list of all entities and a counter for each one
// whenever you want to randomly pick an entity, you call
// one of the roll methods and it gives you a random entity in return.
//
//
// You're maybe asking yourself "why did he make all this?"
// well, the old solution of adding types to an array and picking into the array
// was great until we had to push more than 200 times into the array!
// so much memory write/delete for so little...
// and instead we use much more CPU power, i don't know which is better.
// 
// NOTE: the class currently uses arrays, i could not find a hashmap type/class.
// It would greatly improve performances though...
class SpawnRoller {

  // It uses the enums LargeCreatureType & SmallCreatureType as the index
  // and the value as the counter.
  private var large_creatures_counters: array<int>;
  private var small_creatures_counters: array<int>;

  public function fill_arrays() {
    var i: int;

    for (i = 0; i < SmallCreatureMAX; i += 1) {
      this.small_creatures_counters.PushBack(0);
    }

    for (i = 0; i < LargeCreatureMAX; i += 1) {
      this.large_creatures_counters.PushBack(0);
    }
  }

  // To use before rolling,
  // set all the counters to 0.
  public function reset() {
    var i: int;
    
    for (i = 0; i < SmallCreatureMAX; i += 1) {
      small_creatures_counters[i] = 0;
    }

    for (i = 0; i < LargeCreatureMAX; i += 1) {
      large_creatures_counters[i] = 0;
    }
  }

  public function setLargeCreatureCounter(type: LargeCreatureType, count: int) {
    this.large_creatures_counters[type] = count;
  }

  public function setSmallCreatureCounter(type: SmallCreatureType, count: int) {
    LogChannel('modRandomEncounter', "set small creature: " + type + " counter to " + count);
    
    this.small_creatures_counters[type] = count;
  }

  public function rollSmallCreatures(): SmallCreatureType {
    var current_position: int;
    var total: int;
    var roll: int;
    var i: int;

    for (i = 0; i < SmallCreatureMAX; i += 1) {
      total += this.small_creatures_counters[i];
    }

    roll = RandRange(total);

    current_position = 0;

    for (i = 0; i < SmallCreatureMAX; i += 1) {
      if (roll <= current_position + this.small_creatures_counters[i]) {
        return i;
      }

      current_position += this.small_creatures_counters[i];
    }

    // not supposed to get here but hey, who knows.
    return SmallCreatureNONE;
  }

  public function rollLargeCreatures(): LargeCreatureType {
    var current_position: int;
    var total: int;
    var roll: int;
    var i: int;

    for (i = 0; i < LargeCreatureMAX; i += 1) {
      total += this.large_creatures_counters[i];
    }

    roll = RandRange(total);

    current_position = 0;

    for (i = 0; i < LargeCreatureMAX; i += 1) {
      if (roll <= current_position + this.large_creatures_counters[i]) {
        return i;
      }

      current_position += this.large_creatures_counters[i];
    }

    // not supposed to get here but hey, who knows.
    return LargeCreatureNONE;
  }

  
}