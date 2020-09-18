
class RE_Settings {

  
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

  function loadXMLSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    if (this.shouldResetRERSettings(inGameConfigWrapper)) {
      LogChannel('modRandomEncounters', 'reset RER settings');
      this.resetRERSettings(inGameConfigWrapper);
    }

    this.loadMonsterHuntsChances(inGameConfigWrapper);
    this.loadMonsterContractsChances(inGameConfigWrapper);
    this.loadMonsterAmbushChances(inGameConfigWrapper);
    this.loadCustomFrequencies(inGameConfigWrapper);

    this.loadDifficultySettings(inGameConfigWrapper);
    this.loadCitySpawnSettings(inGameConfigWrapper);

    this.fillSettingsArrays();
    this.loadTrophiesSettings(inGameConfigWrapper);
    this.loadCreaturesSpawningChances(inGameConfigWrapper);
    this.loadGeraltCommentsSettings(inGameConfigWrapper);
    this.loadHideNextNotificationsSettings(inGameConfigWrapper);
    this.loadEnableEncountersLootSettings(inGameConfigWrapper);
    this.loadExternalFactorsCoefficientSettings(inGameConfigWrapper);
    this.loadMonsterTrophiesSettings(inGameConfigWrapper);
    this.loadAdvancedDistancesSettings(inGameConfigWrapper);
    this.loadAdvancedLevelsSettings(inGameConfigWrapper);
    this.loadTrophyPickupAnimationSettings(inGameConfigWrapper);
    this.loadOnlyKnownBestiaryCreaturesSettings(inGameConfigWrapper);
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

    this.trophy_price = StringToInt(inGameConfigWrapper.GetVarValue('RERadvancedTrophies', 'RERtrophiesPrices'));

    LogChannel('modRandomEncounters', "RERadvancedTrophies RERtrophiesPrices - " + this.trophy_price);
  }

  private function loadTrophyPickupAnimationSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.trophy_pickup_scene = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'RERtrophyPickupAnimation');
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
   
  private function loadCreaturesSpawningChances (out inGameConfigWrapper : CInGameConfigWrapper) {
    this.creatures_chances_day[CreatureHARPY]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Harpies'));
    this.creatures_chances_day[CreatureENDREGA]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Endrega'));
    this.creatures_chances_day[CreatureGHOUL]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Ghouls'));
    this.creatures_chances_day[CreatureALGHOUL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Alghouls'));
    this.creatures_chances_day[CreatureNEKKER]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Nekkers'));
    this.creatures_chances_day[CreatureDROWNER]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Drowners'));
    this.creatures_chances_day[CreatureROTFIEND]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Rotfiends'));
    this.creatures_chances_day[CreatureWOLF]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wolves'));
    this.creatures_chances_day[CreatureSKELWOLF]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wolves'));
    this.creatures_chances_day[CreatureWRAITH]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wraiths'));
    this.creatures_chances_day[CreatureSPIDER]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Spiders'));
    this.creatures_chances_day[CreatureWILDHUNT]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'WildHunt'));
    this.creatures_chances_day[CreatureHuman]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Humans'));
    this.creatures_chances_day[CreatureSKELETON]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Skeleton'));

    // Blood and Wine
    this.creatures_chances_day[CreatureBARGHEST]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Barghest')); 
    this.creatures_chances_day[CreatureECHINOPS]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Echinops')); 
    this.creatures_chances_day[CreatureCENTIPEDE]  = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Centipede'));
    this.creatures_chances_day[CreatureKIKIMORE]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Kikimore'));
    this.creatures_chances_day[CreatureDROWNERDLC] = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'DrownerDLC'));
    this.creatures_chances_day[CreatureARACHAS]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Arachas'));
    this.creatures_chances_day[CreatureBEAR]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Bears'));
    this.creatures_chances_day[CreatureSKELBEAR]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Bears'));
    this.creatures_chances_day[CreaturePANTHER]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Panther'));
    this.creatures_chances_day[CreatureBOAR]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Boars'));

    this.creatures_chances_day[CreatureLESHEN]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Leshens'));
    this.creatures_chances_day[CreatureWEREWOLF]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Werewolves'));
    this.creatures_chances_day[CreatureFIEND]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Fiends'));
    this.creatures_chances_day[CreatureEKIMMARA]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Ekimmara'));
    this.creatures_chances_day[CreatureKATAKAN]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Katakan'));
    this.creatures_chances_day[CreatureGOLEM]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Golems'));
    this.creatures_chances_day[CreatureELEMENTAL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Elementals'));
    this.creatures_chances_day[CreatureNIGHTWRAITH]  = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'NightWraiths'));
    this.creatures_chances_day[CreatureNOONWRAITH]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'NoonWraiths'));
    this.creatures_chances_day[CreatureCHORT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Chorts'));
    this.creatures_chances_day[CreatureCYCLOPS]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Cyclops'));
    this.creatures_chances_day[CreatureTROLL]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Troll'));
    this.creatures_chances_day[CreatureSKELTROLL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Troll'));
    this.creatures_chances_day[CreatureHAG]          = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Hags'));
    this.creatures_chances_day[CreatureFOGLET]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Fogling'));
    this.creatures_chances_day[CreatureBRUXA]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Bruxa'));
    this.creatures_chances_day[CreatureFLEDER]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Fleder'));
    this.creatures_chances_day[CreatureGARKAIN]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Garkain'));
    this.creatures_chances_day[CreatureDETLAFF]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'HigherVamp'));
    this.creatures_chances_day[CreatureGIANT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Giant'));
    this.creatures_chances_day[CreatureSHARLEY]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Sharley'));
    this.creatures_chances_day[CreatureWIGHT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wight'));
    this.creatures_chances_day[CreatureGRYPHON]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Gryphons'));
    this.creatures_chances_day[CreatureCOCKATRICE]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Cockatrice'));
    this.creatures_chances_day[CreatureBASILISK]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Basilisk'));
    this.creatures_chances_day[CreatureWYVERN]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wyverns'));
    this.creatures_chances_day[CreatureFORKTAIL]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Forktails'));

    this.creatures_chances_night[CreatureHARPY]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Harpies'));
    this.creatures_chances_night[CreatureENDREGA]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Endrega'));
    this.creatures_chances_night[CreatureGHOUL]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Ghouls'));
    this.creatures_chances_night[CreatureALGHOUL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Alghouls'));
    this.creatures_chances_night[CreatureNEKKER]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Nekkers'));
    this.creatures_chances_night[CreatureDROWNER]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Drowners'));
    this.creatures_chances_night[CreatureROTFIEND]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Rotfiends'));
    this.creatures_chances_night[CreatureWOLF]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Wolves'));
    this.creatures_chances_night[CreatureWRAITH]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Wraiths'));
    this.creatures_chances_night[CreatureSPIDER]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Spiders'));
    this.creatures_chances_night[CreatureWILDHUNT]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'WildHunt'));
    this.creatures_chances_night[CreatureHuman]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Humans'));
    this.creatures_chances_night[CreatureSKELETON]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Skeleton'));


    // Blood and Wine
    this.creatures_chances_night[CreatureBARGHEST]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Barghest')); 
    this.creatures_chances_night[CreatureECHINOPS]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Echinops')); 
    this.creatures_chances_night[CreatureCENTIPEDE]  = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Centipede'));
    this.creatures_chances_night[CreatureKIKIMORE]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Kikimore'));
    this.creatures_chances_night[CreatureDROWNERDLC] = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'DrownerDLC'));
    this.creatures_chances_night[CreatureARACHAS]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Arachas'));
    this.creatures_chances_night[CreatureBEAR]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Bears'));
    this.creatures_chances_night[CreaturePANTHER]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Panther'));
    this.creatures_chances_night[CreatureBOAR]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Boars'));

    this.creatures_chances_night[CreatureLESHEN]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Leshens'));
    this.creatures_chances_night[CreatureWEREWOLF]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Werewolves'));
    this.creatures_chances_night[CreatureFIEND]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Fiends'));
    this.creatures_chances_night[CreatureEKIMMARA]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Ekimmara'));
    this.creatures_chances_night[CreatureKATAKAN]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Katakan'));
    this.creatures_chances_night[CreatureGOLEM]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Golems'));
    this.creatures_chances_night[CreatureELEMENTAL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Elementals'));
    this.creatures_chances_night[CreatureNIGHTWRAITH]  = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'NightWraiths'));
    this.creatures_chances_night[CreatureNOONWRAITH]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'NoonWraiths'));
    this.creatures_chances_night[CreatureCHORT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Chorts'));
    this.creatures_chances_night[CreatureCYCLOPS]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Cyclops'));
    this.creatures_chances_night[CreatureTROLL]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Troll'));
    this.creatures_chances_night[CreatureHAG]          = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Hags'));
    this.creatures_chances_night[CreatureFOGLET]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Fogling'));
    this.creatures_chances_night[CreatureBRUXA]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Bruxa'));
    this.creatures_chances_night[CreatureFLEDER]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Fleder'));
    this.creatures_chances_night[CreatureGARKAIN]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Garkain'));
    this.creatures_chances_night[CreatureDETLAFF]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'HigherVamp'));
    this.creatures_chances_night[CreatureGIANT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Giant'));
    this.creatures_chances_night[CreatureSHARLEY]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Sharley'));
    this.creatures_chances_night[CreatureWIGHT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Wight'));
    this.creatures_chances_night[CreatureGRYPHON]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Gryphons'));
    this.creatures_chances_night[CreatureCOCKATRICE]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Cockatrice'));
    this.creatures_chances_night[CreatureBASILISK]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Basilisk'));
    this.creatures_chances_night[CreatureWYVERN]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Wyverns'));
    this.creatures_chances_night[CreatureFORKTAIL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Forktails'));
  }

  private function loadCitySpawnSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.creatures_city_spawns[CreatureHARPY]      = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Harpies');
    this.creatures_city_spawns[CreatureENDREGA]    = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Endrega');
    this.creatures_city_spawns[CreatureGHOUL]      = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Ghouls');
    this.creatures_city_spawns[CreatureALGHOUL]    = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Alghouls');
    this.creatures_city_spawns[CreatureNEKKER]     = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Nekkers');
    this.creatures_city_spawns[CreatureDROWNER]    = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Drowners');
    this.creatures_city_spawns[CreatureROTFIEND]   = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Rotfiends');
    this.creatures_city_spawns[CreatureWOLF]       = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Wolves');
    this.creatures_city_spawns[CreatureWRAITH]     = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Wraiths');
    this.creatures_city_spawns[CreatureSPIDER]     = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Spiders');
    this.creatures_city_spawns[CreatureWILDHUNT]   = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'WildHunt');
    this.creatures_city_spawns[CreatureHuman]      = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Humans');
    this.creatures_city_spawns[CreatureSKELETON]   = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Skeleton');
    this.creatures_city_spawns[CreatureBARGHEST]   = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Barghest');
    this.creatures_city_spawns[CreatureECHINOPS]   = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Echinops');
    this.creatures_city_spawns[CreatureCENTIPEDE]  = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Centipede');
    this.creatures_city_spawns[CreatureKIKIMORE]   = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Kikimore');
    this.creatures_city_spawns[CreatureDROWNERDLC] = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'DrownerDLC');
    this.creatures_city_spawns[CreatureARACHAS]    = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Arachas');
    this.creatures_city_spawns[CreatureBEAR]       = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Bears');
    this.creatures_city_spawns[CreaturePANTHER]    = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Panther');
    this.creatures_city_spawns[CreatureBOAR]       = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Boars');

    this.creatures_city_spawns[CreatureLESHEN]       = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Leshens');
    this.creatures_city_spawns[CreatureWEREWOLF]     = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Werewolves');
    this.creatures_city_spawns[CreatureFIEND]        = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Fiends');
    this.creatures_city_spawns[CreatureEKIMMARA]     = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Ekimmara');
    this.creatures_city_spawns[CreatureKATAKAN]      = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Katakan');
    this.creatures_city_spawns[CreatureGOLEM]        = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Golems');
    this.creatures_city_spawns[CreatureELEMENTAL]    = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Elementals');
    this.creatures_city_spawns[CreatureNIGHTWRAITH]  = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'NightWraiths');
    this.creatures_city_spawns[CreatureNOONWRAITH]   = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'NoonWraiths');
    this.creatures_city_spawns[CreatureCHORT]        = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Chorts');
    this.creatures_city_spawns[CreatureCYCLOPS]      = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Cyclops');
    this.creatures_city_spawns[CreatureTROLL]        = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Troll');
    this.creatures_city_spawns[CreatureHAG]          = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Hags');
    this.creatures_city_spawns[CreatureFOGLET]       = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Fogling');
    this.creatures_city_spawns[CreatureBRUXA]        = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Bruxa');
    this.creatures_city_spawns[CreatureFLEDER]       = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Fleder');
    this.creatures_city_spawns[CreatureGARKAIN]      = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Garkain');
    this.creatures_city_spawns[CreatureDETLAFF]      = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'HigherVamp');
    this.creatures_city_spawns[CreatureGIANT]        = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Giant');
    this.creatures_city_spawns[CreatureSHARLEY]      = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Sharley');
    this.creatures_city_spawns[CreatureWIGHT]        = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Wight');
    this.creatures_city_spawns[CreatureGRYPHON]      = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Gryphons');
    this.creatures_city_spawns[CreatureCOCKATRICE]   = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Cockatrice');
    this.creatures_city_spawns[CreatureBASILISK]     = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Basilisk');
    this.creatures_city_spawns[CreatureWYVERN]       = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Wyverns');
    this.creatures_city_spawns[CreatureFORKTAIL]     = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Forktails');
  }

  private function loadMonsterTrophiesSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.monster_trophies_chances[CreatureHARPY]      = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Harpies'));
    this.monster_trophies_chances[CreatureENDREGA]    = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Endrega'));
    this.monster_trophies_chances[CreatureGHOUL]      = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Ghouls'));
    this.monster_trophies_chances[CreatureALGHOUL]    = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Alghouls'));
    this.monster_trophies_chances[CreatureNEKKER]     = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Nekkers'));
    this.monster_trophies_chances[CreatureDROWNER]    = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Drowners'));
    this.monster_trophies_chances[CreatureROTFIEND]   = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Rotfiends'));
    this.monster_trophies_chances[CreatureWOLF]       = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Wolves'));
    this.monster_trophies_chances[CreatureWRAITH]     = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Wraiths'));
    this.monster_trophies_chances[CreatureSPIDER]     = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Spiders'));
    this.monster_trophies_chances[CreatureWILDHUNT]   = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'WildHunt'));
    this.monster_trophies_chances[CreatureHuman]      = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Humans'));
    this.monster_trophies_chances[CreatureSKELETON]   = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Skeleton'));
    this.monster_trophies_chances[CreatureBARGHEST]   = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Barghest'));
    this.monster_trophies_chances[CreatureECHINOPS]   = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Echinops'));
    this.monster_trophies_chances[CreatureCENTIPEDE]  = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Centipede'));
    this.monster_trophies_chances[CreatureKIKIMORE]   = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Kikimore'));
    this.monster_trophies_chances[CreatureDROWNERDLC] = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'DrownerDLC'));
    this.monster_trophies_chances[CreatureARACHAS]    = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Arachas'));
    this.monster_trophies_chances[CreatureBEAR]       = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Bears'));
    this.monster_trophies_chances[CreaturePANTHER]    = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Panther'));
    this.monster_trophies_chances[CreatureBOAR]       = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Boars'));

    this.monster_trophies_chances[CreatureLESHEN]       = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Leshens'));
    this.monster_trophies_chances[CreatureWEREWOLF]     = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Werewolves'));
    this.monster_trophies_chances[CreatureFIEND]        = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Fiends'));
    this.monster_trophies_chances[CreatureEKIMMARA]     = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Ekimmara'));
    this.monster_trophies_chances[CreatureKATAKAN]      = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Katakan'));
    this.monster_trophies_chances[CreatureGOLEM]        = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Golems'));
    this.monster_trophies_chances[CreatureELEMENTAL]    = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Elementals'));
    this.monster_trophies_chances[CreatureNIGHTWRAITH]  = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'NightWraiths'));
    this.monster_trophies_chances[CreatureNOONWRAITH]   = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'NoonWraiths'));
    this.monster_trophies_chances[CreatureCHORT]        = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Chorts'));
    this.monster_trophies_chances[CreatureCYCLOPS]      = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Cyclops'));
    this.monster_trophies_chances[CreatureTROLL]        = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Troll'));
    this.monster_trophies_chances[CreatureHAG]          = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Hags'));
    this.monster_trophies_chances[CreatureFOGLET]       = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Fogling'));
    this.monster_trophies_chances[CreatureBRUXA]        = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Bruxa'));
    this.monster_trophies_chances[CreatureFLEDER]       = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Fleder'));
    this.monster_trophies_chances[CreatureGARKAIN]      = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Garkain'));
    this.monster_trophies_chances[CreatureDETLAFF]      = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'HigherVamp'));
    this.monster_trophies_chances[CreatureGIANT]        = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Giant'));
    this.monster_trophies_chances[CreatureSHARLEY]      = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Sharley'));
    this.monster_trophies_chances[CreatureWIGHT]        = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Wight'));
    this.monster_trophies_chances[CreatureGRYPHON]      = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Gryphons'));
    this.monster_trophies_chances[CreatureCOCKATRICE]   = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Cockatrice'));
    this.monster_trophies_chances[CreatureBASILISK]     = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Basilisk'));
    this.monster_trophies_chances[CreatureWYVERN]       = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Wyverns'));
    this.monster_trophies_chances[CreatureFORKTAIL]     = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Forktails'));
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
}
