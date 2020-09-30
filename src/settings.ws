
class RE_Settings {

  public var is_enabled: bool;
  
  public var customDayMax, customDayMin, customNightMax, customNightMin  : int;
  public var all_monster_hunt_chance: int;
  public var all_monster_contract_chance: int;
  public var all_monster_ambush_chance: int;
  public var enableTrophies : bool;
  public var selectedDifficulty : int;

  // uses the enum `Creature` and its values for the index/key.
  // and the `int` for the value/chance.
  public var creatures_chances_day: array<int>;
  public var creatures_chances_night: array<int>;

  // use the enums `Creature` & `Creature` for the indices.
  // and the `bool` for the value.
  public var creatures_city_spawns: array<bool>;

  public var allow_big_city_spawns: bool;

  // controls whether or not geralt will comment
  // when an encounter appears
  public var geralt_comments_enabled: bool;

  // controls whether or not RER shows notifications
  public var hide_next_notifications: bool;

  // controls whether or not RER encounters will drop loot
  public var enable_encounters_loot: bool;

  // tells how much impact an external factor has on a creature
  // spawning chances.
  public var external_factors_coefficient: float;

  public var monster_trophies_chances: array<int>;

  public var minimum_spawn_distance: float;
  public var spawn_diameter: float;
  public var kill_threshold_distance: float;

  public var trophies_enabled_by_encounter: array<bool>;

  public var trophy_pickup_scene: bool;

  public var only_known_bestiary_creatures: bool;

  public var max_level_allowed: int;
  public var min_level_allowed: int;

  public var trophy_price: TrophyVariant;

  public var event_system_interval: float;

  function loadXMLSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    if (this.shouldResetRERSettings(inGameConfigWrapper)) {
      LogChannel('modRandomEncounters', 'reset RER settings');
      this.resetRERSettings(inGameConfigWrapper);
    }

    this.loadModEnabledSettings(inGameConfigWrapper);
    this.loadMonsterHuntsChances(inGameConfigWrapper);
    this.loadMonsterContractsChances(inGameConfigWrapper);
    this.loadMonsterAmbushChances(inGameConfigWrapper);
    this.loadCustomFrequencies(inGameConfigWrapper);

    this.loadDifficultySettings(inGameConfigWrapper);
    this.loadCitySpawnSettings(inGameConfigWrapper);

    this.fillSettingsArrays();
    this.loadTrophiesSettings(inGameConfigWrapper);
    this.loadGeraltCommentsSettings(inGameConfigWrapper);
    this.loadHideNextNotificationsSettings(inGameConfigWrapper);
    this.loadEnableEncountersLootSettings(inGameConfigWrapper);
    this.loadExternalFactorsCoefficientSettings(inGameConfigWrapper);
    this.loadAdvancedDistancesSettings(inGameConfigWrapper);
    this.loadAdvancedLevelsSettings(inGameConfigWrapper);
    this.loadOnlyKnownBestiaryCreaturesSettings(inGameConfigWrapper);
    this.loadAdvancedEventSystemSettings(inGameConfigWrapper);
  }

  function loadXMLSettingsAndShowNotification() {
    this.loadXMLSettings();

    theGame
    .GetGuiManager()
    .ShowNotification("Random Encounters XML settings loaded");
  }

  private function loadDifficultySettings(inGameConfigWrapper: CInGameConfigWrapper) {
    selectedDifficulty = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'Difficulty'));
  }

  private function loadGeraltCommentsSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.geralt_comments_enabled = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'geraltComments');
  }

  private function loadHideNextNotificationsSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.hide_next_notifications = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'hideNextNotifications');
  }

  private function loadEnableEncountersLootSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.enable_encounters_loot = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'enableEncountersLoot');
  }

  private function loadExternalFactorsCoefficientSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.external_factors_coefficient = StringToFloat(
      inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'externalFactorsImpact')
    );
  }

  private function loadOnlyKnownBestiaryCreaturesSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.only_known_bestiary_creatures = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'RERonlyKnownBestiaryCreatures');
  }

  private function loadTrophiesSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.trophies_enabled_by_encounter[EncounterType_DEFAULT] = inGameConfigWrapper.GetVarValue('RERadvancedTrophies', 'RERtrophiesAmbush');
    this.trophies_enabled_by_encounter[EncounterType_HUNT] = inGameConfigWrapper.GetVarValue('RERadvancedTrophies', 'RERtrophiesHunt');
    this.trophies_enabled_by_encounter[EncounterType_CONTRACT] = inGameConfigWrapper.GetVarValue('RERadvancedTrophies', 'RERtrophiesContract');
    this.trophy_pickup_scene = inGameConfigWrapper.GetVarValue('RERadvancedTrophies', 'RERtrophyPickupAnimation');


    this.trophy_price = StringToInt(inGameConfigWrapper.GetVarValue('RERadvancedTrophies', 'RERtrophiesPrices'));

    LogChannel('modRandomEncounters', "RERadvancedTrophies RERtrophiesPrices - " + this.trophy_price);
  }

  private function loadCustomFrequencies(inGameConfigWrapper: CInGameConfigWrapper) {
    customDayMax = StringToInt(inGameConfigWrapper.GetVarValue('RERcreatureFrequency', 'customdFrequencyHigh'));
    customDayMin = StringToInt(inGameConfigWrapper.GetVarValue('RERcreatureFrequency', 'customdFrequencyLow'));
    customNightMax = StringToInt(inGameConfigWrapper.GetVarValue('RERcreatureFrequency', 'customnFrequencyHigh'));
    customNightMin = StringToInt(inGameConfigWrapper.GetVarValue('RERcreatureFrequency', 'customnFrequencyLow'));  
  }

  private function loadMonsterHuntsChances(inGameConfigWrapper: CInGameConfigWrapper) {
    this.all_monster_hunt_chance = StringToInt(inGameConfigWrapper.GetVarValue('RERencounterTypes', 'allMonsterHuntChance'));
  }

  private function loadMonsterContractsChances(inGameConfigWrapper: CInGameConfigWrapper) {
    this.all_monster_contract_chance = StringToInt(
      inGameConfigWrapper.GetVarValue('RERencounterTypes', 'allMonsterContractChance')
    );
  }

  private function loadMonsterAmbushChances(inGameConfigWrapper: CInGameConfigWrapper) {
    this.all_monster_ambush_chance = StringToInt(
      inGameConfigWrapper.GetVarValue('RERencounterTypes', 'allMonsterAmbushChance')
    );
  }

  private function shouldResetRERSettings(inGameConfigWrapper: CInGameConfigWrapper): bool {
    return !inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'RERmodInitialized');
  }

  private function loadModEnabledSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.is_enabled = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'RERmodEnabled');
  }

  private function resetRERSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    inGameConfigWrapper.ApplyGroupPreset('RandomEncountersMENU', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERencounterTypes', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERcreatureFrequency', 1); // medium frequency
    inGameConfigWrapper.ApplyGroupPreset('customGroundDay', 0);
    inGameConfigWrapper.ApplyGroupPreset('customGroundNight', 0);
    inGameConfigWrapper.ApplyGroupPreset('RER_CitySpawns', 0);
    inGameConfigWrapper.ApplyGroupPreset('RER_monsterTrophies', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERadvancedDistances', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERadvancedLevels', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERadvancedTrophies', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERadvancedEvents', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERregionConstraints', 0);
    
    inGameConfigWrapper.SetVarValue('RandomEncountersMENU', 'RERmodInitialized', 1);
    theGame.SaveUserSettings();
  }
  

  private function fillSettingsArrays() {
    var i: int;

    if (this.creatures_chances_day.Size() == 0) {
      for (i = 0; i < CreatureMAX; i += 1) {
        this.creatures_chances_day.PushBack(0);
        this.creatures_chances_night.PushBack(0);
        this.creatures_city_spawns.PushBack(false);
        this.monster_trophies_chances.PushBack(0);
      }

      for (i = 0; i < EncounterType_MAX; i += 1) {
        this.trophies_enabled_by_encounter.PushBack(false);
      }
    }
  }

  private function loadAdvancedEventSystemSettings(out inGameConfigWrapper : CInGameConfigWrapper) {
    this.event_system_interval = StringToFloat(inGameConfigWrapper.GetVarValue('RERadvancedEvents', 'eventSystemInterval'));
  }

  private function loadAdvancedDistancesSettings(out inGameConfigWrapper : CInGameConfigWrapper) {
    this.minimum_spawn_distance   = StringToFloat(inGameConfigWrapper.GetVarValue('RERadvancedDistances', 'minSpawnDistance'));
    this.spawn_diameter           = StringToFloat(inGameConfigWrapper.GetVarValue('RERadvancedDistances', 'spawnDiameter'));
    this.kill_threshold_distance  = StringToFloat(inGameConfigWrapper.GetVarValue('RERadvancedDistances', 'killThresholdDistance'));

    if (this.minimum_spawn_distance < 20 || this.spawn_diameter < 10 || this.kill_threshold_distance < 100) {
      inGameConfigWrapper.ApplyGroupPreset('RERadvancedDistances', 0);

      this.minimum_spawn_distance   = StringToInt(inGameConfigWrapper.GetVarValue('RERadvancedDistances', 'minSpawnDistance'));
      this.spawn_diameter           = StringToInt(inGameConfigWrapper.GetVarValue('RERadvancedDistances', 'spawnDiameter'));
      this.kill_threshold_distance  = StringToInt(inGameConfigWrapper.GetVarValue('RERadvancedDistances', 'killThresholdDistance'));
      theGame.SaveUserSettings();
    }
  }

  private function loadAdvancedLevelsSettings(out inGameConfigWrapper: CInGameConfigWrapper) {
    this.min_level_allowed = StringToInt(inGameConfigWrapper.GetVarValue('RERadvancedLevels', 'RERminLevelRange'));
    this.max_level_allowed = StringToInt(inGameConfigWrapper.GetVarValue('RERadvancedLevels', 'RERmaxLevelRange'));

    LogChannel('modRandomEncounters', "settings - min_level_allowed = " + this.min_level_allowed);
    LogChannel('modRandomEncounters', "settings - max_level_allowed = " + this.max_level_allowed);
  }

  private function loadCitySpawnSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.allow_big_city_spawns = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'allowSpawnInBigCities');
  }

  public function doesAllowCitySpawns(): bool {
    var i: int;

    for (i = 0; i < CreatureMAX; i += 1) {
      if (this.creatures_city_spawns[i]) {
        return true;
      }
    }

    return false;
  }

  public function toggleEnabledSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    inGameConfigWrapper.SetVarValue(
      'RandomEncountersMENU',
      'RERmodEnabled',
      !this.is_enabled
    );

    theGame.SaveUserSettings();

    this.loadModEnabledSettings(inGameConfigWrapper);
  }
}
