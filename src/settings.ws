
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

  function loadXMLSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    this.loadMonsterHuntsChances(inGameConfigWrapper);
    this.loadMonsterContractsChances(inGameConfigWrapper);
    this.loadMonsterAmbushChances(inGameConfigWrapper);
    this.loadCustomFrequencies(inGameConfigWrapper);

    // this.loadTrophiesSettings(inGameConfigWrapper);
    this.loadDifficultySettings(inGameConfigWrapper);
    this.loadCitySpawnSettings(inGameConfigWrapper);

    this.fillSettingsArrays();
    this.loadCreaturesSpawningChances(inGameConfigWrapper);
    this.loadGeraltCommentsSettings(inGameConfigWrapper);
    this.loadHideNextNotificationsSettings(inGameConfigWrapper);
    this.loadEnableEncountersLootSettings(inGameConfigWrapper);
    this.loadExternalFactorsCoefficientSettings(inGameConfigWrapper);
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

  public function setHideNextNotificationsSettings(value: bool) {
    if (value) {
      theGame.GetInGameConfigWrapper()
        .SetVarValue('RandomEncountersMENU', 'hideNextNotifications', 1);
    }
    else {
      theGame.GetInGameConfigWrapper()
        .SetVarValue('RandomEncountersMENU', 'hideNextNotifications', 0);
    }

    theGame.SaveUserSettings();
  }

  private function loadTrophiesSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    enableTrophies = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'enableTrophies');
  }

  private function loadCustomFrequencies(inGameConfigWrapper: CInGameConfigWrapper) {
    customDayMax = StringToInt(inGameConfigWrapper.GetVarValue('custom', 'customdFrequencyHigh'));
    customDayMin = StringToInt(inGameConfigWrapper.GetVarValue('custom', 'customdFrequencyLow'));
    customNightMax = StringToInt(inGameConfigWrapper.GetVarValue('custom', 'customnFrequencyHigh'));
    customNightMin = StringToInt(inGameConfigWrapper.GetVarValue('custom', 'customnFrequencyLow'));  
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
  

  private function fillSettingsArrays() {
    var i: int;

    if (this.creatures_chances_day.Size() == 0) {
      for (i = 0; i < CreatureMAX; i += 1) {
        this.creatures_chances_day.PushBack(0);
        this.creatures_chances_night.PushBack(0);
        this.creatures_city_spawns.PushBack(false);
      }
    }
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
    this.creatures_chances_night[CreatureBEAR]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Bears'));
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
    this.creatures_chances_night[CreatureCYCLOPS]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Cyclops'));
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
    this.creatures_city_spawns[CreatureBARGHEST]   = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Barghest')) 
    this.creatures_city_spawns[CreatureECHINOPS]   = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Echinops')) 
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
