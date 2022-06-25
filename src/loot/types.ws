
enum RER_LootTableId {
  RERLTID_NONE = 0,
}

class RER_LootTable extends SU_HashMapValue {
  var entries: array<RER_LootTableEntry>;
  var minimum_drop_count: int;

  /**
   * the maximum range is included, if it is equal to 3 then it goes up to 3
   * drops included.
   */
  var maximum_drop_count: int;

  public function add(table_entry: RER_LootTableEntry): RER_LootTable {
    this.entries.PushBack(table_entry);

    return this;
  }

  public function roll(optional seed: int): array<name> {
    var rng: RandomNumberGenerator;
    var rolled_chance: float;
    var total_chance: float;
    var output: array<name>;
    var drop_count: int;
    var i: int;

    rng = (new RandomNumberGenerator in this).setSeed(seed)
      .useSeed(seed != 0);

    drop_count = (int)rng.nextRange(
      this.maximum_drop_count,
      this.minimum_drop_count
    );

    for (drop_count; drop_count > 0; drop_count -= 1) {
      for (i = 0; i < this.entries.Size(); i += 1) {
        total_chance += this.entries[i].drop_chance;
      }

      rolled_chance = (int)roll.nextRange(total_chance, 0);

      for (i = this.entries.Size() - 1; i >= 0 ; i -= 1) {
        rolled_chance -= this.entries[i].drop_chance;

        if (rolled_chance <= 0) {
          break;
        }
      }

      if (i < 0) {
        continue;
      }

      output.PushBack(this.entries[i].item_name);
    }

    return output;
  }
}

struct RER_LootTableEntry {
  var item_name: name;

  var drop_chance: float;

  var minimum_drop_count: int;
  var maximum_drop_count: int;
}