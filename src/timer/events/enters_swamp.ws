
// When the player enters a swamp, there is a small chance for drowners or hags to appear
class RER_ListenerEntersSwamp extends RER_EventsListener {
  var was_in_swamp_last_run: bool;
  var type: CreatureType;

  public latent function onInterval(was_spawn_already_triggered: bool, master: CRandomEncounters, delta: float): bool {
    var is_in_swamp_now: bool;

    if (was_spawn_already_triggered) {
      return false;
    }

    is_in_swamp_now = master.rExtra.IsPlayerInSwamp();

    // the player is now in a swamp and was not in one last run
    // it means he just entered it this run.
    // 10% chance of trigger, depending on the scale and the delta between the two runs.
    if (is_in_swamp_now && !was_in_swamp_last_run && RandRangeF(100) < 10 * delta * master.settings.event_system_chances_scale) {
      type = this.getRandomSwampCreatureType(master);

      LogChannel('modRandomEncounters', "RER_ListenerEntersSwamp - swamp ambush triggered, " + type);

      createRandomCreatureAmbush(master, type);

      return true;
    }

    return false;
  }

  private latent function getRandomSwampCreatureType(master: CRandomEncounters): CreatureType {
    var spawn_roller: SpawnRoller;
    var creatures_preferences: RER_CreaturePreferences;
    var i: int;
    var can_spawn_creature: bool;
    var manager : CWitcherJournalManager;

    spawn_roller = new SpawnRoller in this;
    spawn_roller.fill_arrays();

    creatures_preferences = new RER_CreaturePreferences in this;
    creatures_preferences
      .setIsNight(theGame.envMgr.IsNight())
      .setExternalFactorsCoefficient(master.settings.external_factors_coefficient)
      .setIsNearWater(master.rExtra.IsPlayerNearWater())
      .setIsInForest(master.rExtra.IsPlayerInForest())
      .setIsInSwamp(master.rExtra.IsPlayerInSwamp())
      .setChancesDay(master.settings.creatures_chances_day)
      .setChancesNight(master.settings.creatures_chances_night);

    creatures_preferences
      .reset()

      .setCreatureType(CreatureDROWNER)
      .addOnlyBiome(BiomeSwamp)
      .addOnlyBiome(BiomeWater)
      .addLikedBiome(BiomeSwamp)
      .addLikedBiome(BiomeWater)
      .fillSpawnRoller(spawn_roller)

      .setCreatureType(CreatureDROWNERDLC)
      .addOnlyBiome(BiomeSwamp)
      .addOnlyBiome(BiomeWater)
      .addLikedBiome(BiomeSwamp)
      .addLikedBiome(BiomeWater)
      .fillSpawnRoller(spawn_roller)

      .setCreatureType(CreatureROTFIEND)
      .fillSpawnRoller(spawn_roller)

      .setCreatureType(CreatureWEREWOLF)
      .fillSpawnRoller(spawn_roller)

      .setCreatureType(CreatureHAG)
      .addOnlyBiome(BiomeSwamp)
      .addOnlyBiome(BiomeWater)
      .addLikedBiome(BiomeSwamp)
      .addLikedBiome(BiomeWater)
      .fillSpawnRoller(spawn_roller)

      .setCreatureType(CreatureFOGLET)
      .addOnlyBiome(BiomeSwamp)
      .addOnlyBiome(BiomeWater)
      .addLikedBiome(BiomeSwamp)
      .addLikedBiome(BiomeWater)
      .fillSpawnRoller(spawn_roller);

    // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/14
    // when a creature is set to NO in the city spawn menu, 
    // we remove it from the spawning pool.
    if (master.rExtra.isPlayerInSettlement()) {
      LogChannel('modRandomEncounters', "player in settlement, removing city spawns");

      for (i = 0; i < CreatureMAX; i += 1) {
        if (!master.settings.creatures_city_spawns[i]) {
          spawn_roller.setCreatureCounter(i, 0);
        }
      }
    }

    // when the option "Only known bestiary creatures" is ON
    // we remove every unknown creatures from the spawning pool
    if (master.settings.only_known_bestiary_creatures) {
      manager = theGame.GetJournalManager();

      for (i = 0; i < CreatureMAX; i += 1) {
        can_spawn_creature = bestiaryCanSpawnEnemyTemplateList(master.resources.creatures_resources[i], manager);
        
        if (!can_spawn_creature) {
          spawn_roller.setCreatureCounter(i, 0);
        }
      }
    }

    return spawn_roller.rollCreatures();
  }
}
