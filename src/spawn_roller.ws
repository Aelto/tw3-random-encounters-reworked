
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

  // It uses the enum CreatureType as the index
  // and the value as the counter.
  private var creatures_counters: array<int>;
  private var humans_variants_counters: array<int>;

  public function fill_arrays() {
    var i: int;

    for (i = 0; i < CreatureMAX; i += 1) {
      this.creatures_counters.PushBack(0);
    }

    for (i = 0; i < HT_MAX; i += 1) {
      this.humans_variants_counters.PushBack(0);
    }
  }

  // To use before rolling,
  // set all the counters to 0.
  public function reset() {
    var i: int;
    
    for (i = 0; i < CreatureMAX; i += 1) {
      this.creatures_counters[i] = 0;
    }

    for (i = 0; i < HT_MAX; i += 1) {
      this.humans_variants_counters[i] = 0;
    }
  }

  public function setCreatureCounter(type: CreatureType, count: int) {
    this.creatures_counters[type] = count;
  }

  public function setHumanVariantCounter(type: EHumanType, count: int) {
    this.humans_variants_counters[type] = count;
  }

  public function rollCreatures(): CreatureType {
    var current_position: int;
    var total: int;
    var roll: int;
    var i: int;

    total = 0;

    for (i = 0; i < CreatureMAX; i += 1) {
      total += this.creatures_counters[i];
    }

    // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/5:
    // added so the user can disable all CreatureType and it would
    // cancel the spawn. Useful when the user wants no spawn during the day.
    if (total <= 0) {
      return CreatureNONE;
    }

    roll = RandRange(total);

    current_position = 0;

    for (i = 0; i < CreatureMAX; i += 1) {
      // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/5:
      // `this.creatures_counters[i] > 0` is add so the user can
      // disable a CreatureType completely.
      if (this.creatures_counters[i] > 0 && roll <= current_position + this.creatures_counters[i]) {
        return i;
      }

      current_position += this.creatures_counters[i];
    }

    // not supposed to get here but hey, who knows.
    return CreatureNONE;
  }

  public function rollHumansVariants(): EHumanType {
    var current_position: int;
    var total: int;
    var roll: int;
    var i: int;

    for (i = 0; i < HT_MAX; i += 1) {
      total += this.humans_variants_counters[i];
    }

    // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/5:
    // if for any reason no human variant is available return HT_NONE
    if (total <= 0) {
      return HT_NONE;
    }

    roll = RandRange(total);

    current_position = 0;

    for (i = 0; i < HT_MAX; i += 1) {
      // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/5:
      // ignore the variants at 0
      if (this.humans_variants_counters[i] > 0 && roll <= current_position + this.humans_variants_counters[i]) {
        return i;
      }

      current_position += this.humans_variants_counters[i];
    }

    // not supposed to get here but hey, who knows.
    return HT_NONE;
  }

}
