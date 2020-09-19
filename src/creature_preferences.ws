
enum RER_Biome {
  BiomeForest = 0,
  BiomeSwamp = 1,
  BiomeWater = 2
}

class RER_CreaturePreferences {

  public function reset(): RER_CreaturePreferences {
    this.only_biomes.Clear();
    this.disliked_biomes.Clear();
    this.liked_biomes.Clear();

    return this;
  }

  public var creature_type: CreatureType;
  public function setCreatureType(type: CreatureType): RER_CreaturePreferences {
    this.creature_type = type;

    return this;
  }

  // If the creature can only spawn in a biome
  public var only_biomes: array<RER_Biome>;
  public function addOnlyBiome(biome: RER_Biome): RER_CreaturePreferences {
    this.only_biomes.PushBack(biome);

    return this;
  }

  // If the creature has its chance reduce by the external factor
  // when in the biomes
  public var disliked_biomes: array<RER_Biome>;
  public function addDislikedBiome(biome: RER_Biome): RER_CreaturePreferences {
    this.disliked_biomes.PushBack(biome);

    return this;
  }

  // If the creature has its chance increased by the external factor
  // when in the biomes
  public var liked_biomes: array<RER_Biome>;
  public function addLikedBiome(biome: RER_Biome): RER_CreaturePreferences {
    this.liked_biomes.PushBack(biome);

    return this;
  }

  //#region persistent values
  // value is not reset
  public var is_night: bool;
  public function setIsNight(value: bool): RER_CreaturePreferences {
    this.is_night = value;

    return this;
  }

  // value is not reset
  public var external_factors_coefficient: float;
  public function setExternalFactorsCoefficient(value: float): RER_CreaturePreferences {
    this.external_factors_coefficient = value;
    
    return this;
  }

  // value is not reset
  public var is_near_water: bool;
  public function setIsNearWater(value: bool): RER_CreaturePreferences {
    this.is_near_water = value;

    return this;
  }

  // value is not reset
  public var is_in_forest: bool;
  public function setIsInForest(value: bool): RER_CreaturePreferences {
    this.is_in_forest = value;

    return this;
  }

  // value is not reset
  public var is_in_swamp: bool;
  public function setIsInSwamp(value: bool): RER_CreaturePreferences {
    this.is_in_swamp = value;

    return this;
  }

  // value is not reset
  public var chances_day: array<int>;
  public function setChancesDay(value: array<int>): RER_CreaturePreferences {
    this.chances_day = value;

    return this;
  }

  // value is not reset
  public var chances_night: array<int>;
  public function setChancesNight(value: array<int>): RER_CreaturePreferences {
    this.chances_night = value;

    return this;
  }
  //#endregion persistent values

  public function getChances(): int {
    var i: int;
    var can_spawn: bool;
    var spawn_chances: int;
    var is_in_disliked_biome: bool;
    var is_in_liked_biome: bool;

    can_spawn = false;

    for (i = 0; i < this.only_biomes.Size(); i += 1) {
      if (this.only_biomes[i] == BiomeSwamp && this.is_in_swamp) {
        can_spawn = true;
      }

      if (this.only_biomes[i] == BiomeForest && this.is_in_forest) {
        can_spawn = true;
      }

      if (this.only_biomes[i] == BiomeWater && this.is_near_water) {
        can_spawn = true;
      }
    }

    // no allowed biome, return 0 directly.
    if (this.only_biomes.Size() > 0 && !can_spawn) {
      return 0;
    }

    if (this.is_night) {
      spawn_chances = this.chances_night[this.creature_type];
    }
    else {
      spawn_chances = this.chances_day[this.creature_type];
    }

    
    // being in a disliked biome reduces the spawn chances
    is_in_disliked_biome = false;
    for (i = 0; i < this.disliked_biomes.Size(); i += 1) {
      if (this.disliked_biomes[i] == BiomeSwamp && this.is_in_swamp) {
        is_in_disliked_biome = true;
      }

      if (this.disliked_biomes[i] == BiomeForest && this.is_in_forest) {
        is_in_disliked_biome = true;
      }

      if (this.disliked_biomes[i] == BiomeWater && this.is_near_water) {
        is_in_disliked_biome = true;
      }
    }

    if (is_in_disliked_biome) {
      spawn_chances = this.applyCoefficientToCreatureDivide(spawn_chances);
    }

    // being in a liked biome increases the spawn chances
    is_in_liked_biome = false;
    for (i = 0; i < this.liked_biomes.Size(); i += 1) {
      if (this.liked_biomes[i] == BiomeSwamp && this.is_in_swamp) {
        is_in_liked_biome = true;
      }

      if (this.liked_biomes[i] == BiomeForest && this.is_in_forest) {
        is_in_liked_biome = true;
      }

      if (this.liked_biomes[i] == BiomeWater && this.is_near_water) {
        is_in_liked_biome = true;
      }
    }

    if (is_in_disliked_biome) {
      spawn_chances = this.applyCoefficientToCreature(spawn_chances);
    }

    return spawn_chances;
  }

  public function fillSpawnRoller(spawn_roller: SpawnRoller):  RER_CreaturePreferences {
    spawn_roller.setCreatureCounter(this.creature_type, this.getChances());

    return this.reset();
  }

  private function applyCoefficientToCreature(chances: int): int {
    return (int)(chances * this.external_factors_coefficient);
  }

  private function applyCoefficientToCreatureDivide(chances: int): int {
    return (int)(chances / this.external_factors_coefficient);
  }
}

function makeCreaturePreferences(type: CreatureType): RER_CreaturePreferences {
  var creature_preferences: RER_CreaturePreferences;

  creature_preferences.creature_type = type;

  return creature_preferences;
}