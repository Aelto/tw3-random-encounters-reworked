
class RE_Settings {

	
	public var customDayMax, customDayMin, customNightMax, customNightMin	: int;
	public var all_monster_hunt_chance: int;
	public var enableTrophies : bool;
  public var cityBruxa, citySpawn : int;
  public var selectedDifficulty	: int;

  // uses the enum `SmallCreature` and its values for the index/key.
  // and the `int` for the value/chance.
  public var small_creatures_chances_day: array<int>;
  public var small_creatures_chances_night: array<int>;

  // uses the enum `LargeCreature` and its values for the index/key.
  // and the `int` for the value/chance.
  public var large_creatures_chances_day: array<int>;
  public var large_creatures_chances_night: array<int>;

  // used when picking the EncounterType Large/Small
  public var large_creature_chance: int;

  // controls whether or not geralt will comment
  // when an encounter appears
  public var geralt_comments_enabled: bool;

  function loadXMLSettings() {
    var inGameConfigWrapper : CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();


    this.loadMonsterHuntsChances(inGameConfigWrapper);
    this.loadLargeCreatureChance(inGameConfigWrapper);
    this.loadCustomFrequencies(inGameConfigWrapper);

    this.loadTrophiesSettings(inGameConfigWrapper);
    this.loadDifficultySettings(inGameConfigWrapper);
    this.loadCitySpawnSettings(inGameConfigWrapper);

    this.fillSettingsArrays();
		this.loadCreaturesSpawningChances(inGameConfigWrapper);
    this.loadGeraltCommentsSettings(inGameConfigWrapper);
  }

  function loadXMLSettingsAndShowNotification() {
    this.loadXMLSettings();

    theGame
    .GetGuiManager()
    .ShowNotification("Random Encounters XML settings loaded");
  }

  private function loadCitySpawnSettings(inGameConfigWrapper: CInGameConfigWrapper) {
		citySpawn = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'citySpawn'));
		cityBruxa = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'cityBruxa'));
  }

  private function loadDifficultySettings(inGameConfigWrapper: CInGameConfigWrapper) {
    selectedDifficulty = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'Difficulty'));
  }

  private function loadGeraltCommentsSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.geralt_comments_enabled = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'geraltComments');
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
    this.all_monster_hunt_chance = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'allMonsterHuntChance'));
  }

  private function loadLargeCreatureChance(inGameConfigWrapper: CInGameConfigWrapper) {
    this.large_creature_chance = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'largeCreatureChance'));
  }
  

	private function fillSettingsArrays() {
    var i: int;

    if (this.small_creatures_chances_day.Size() == 0) {
      for (i = 0; i < SmallCreatureMAX; i += 1) {
        this.small_creatures_chances_day.PushBack(0);
        this.small_creatures_chances_night.PushBack(0);
      }
    }

    if (this.large_creatures_chances_night.Size() == 0) {
      for (i = 0; i < LargeCreatureMAX; i += 1) {
        this.large_creatures_chances_day.PushBack(0);
        this.large_creatures_chances_night.PushBack(0);
      }
    }
  }

   
  private function loadCreaturesSpawningChances (out inGameConfigWrapper : CInGameConfigWrapper) {
    this.small_creatures_chances_day[SmallCreatureHARPY]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Harpies'));
    this.small_creatures_chances_day[SmallCreatureENDREGA]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Endrega'));
    this.small_creatures_chances_day[SmallCreatureGHOUL]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Ghouls'));
    this.small_creatures_chances_day[SmallCreatureALGHOUL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Alghouls'));
    this.small_creatures_chances_day[SmallCreatureNEKKER]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Nekkers'));
    this.small_creatures_chances_day[SmallCreatureDROWNER]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Drowners'));
    this.small_creatures_chances_day[SmallCreatureROTFIEND]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Rotfiends'));
    this.small_creatures_chances_day[SmallCreatureWOLF]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wolves'));
    this.small_creatures_chances_day[SmallCreatureSKELWOLF]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wolves'));
    this.small_creatures_chances_day[SmallCreatureWRAITH]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wraiths'));
    this.small_creatures_chances_day[SmallCreatureSPIDER]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Spiders'));
    this.small_creatures_chances_day[SmallCreatureWILDHUNT]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'WildHunt'));
    this.small_creatures_chances_day[SmallCreatureHuman]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Humans'));
    this.small_creatures_chances_day[SmallCreatureSKELETON]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Skeleton'));


    

    // Blood and Wine
    this.small_creatures_chances_day[SmallCreatureBARGHEST]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Barghest')); 
    this.small_creatures_chances_day[SmallCreatureECHINOPS]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Echinops')); 
    this.small_creatures_chances_day[SmallCreatureCENTIPEDE]  = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Centipede'));
    this.small_creatures_chances_day[SmallCreatureKIKIMORE]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Kikimore'));
    this.small_creatures_chances_day[SmallCreatureDROWNERDLC] = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'DrownerDLC'));
    this.small_creatures_chances_day[SmallCreatureARACHAS]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Arachas'));
    this.small_creatures_chances_day[SmallCreatureBEAR]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Bears'));
    this.small_creatures_chances_day[SmallCreatureSKELBEAR]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Bears'));
		this.small_creatures_chances_day[SmallCreaturePANTHER]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Panther'));
		this.small_creatures_chances_day[SmallCreatureBOAR]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Boars'));

		this.large_creatures_chances_day[LargeCreatureLESHEN]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Leshens'));
    this.large_creatures_chances_day[LargeCreatureWEREWOLF]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Werewolves'));
    this.large_creatures_chances_day[LargeCreatureFIEND]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Fiends'));
    this.large_creatures_chances_day[LargeCreatureEKIMMARA]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Ekimmara'));
    this.large_creatures_chances_day[LargeCreatureKATAKAN]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Katakan'));
    this.large_creatures_chances_day[LargeCreatureGOLEM]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Golems'));
    this.large_creatures_chances_day[LargeCreatureELEMENTAL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Elementals'));
    this.large_creatures_chances_day[LargeCreatureNIGHTWRAITH]  = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'NightWraiths'));
    this.large_creatures_chances_day[LargeCreatureNOONWRAITH]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'NoonWraiths'));
    this.large_creatures_chances_day[LargeCreatureCHORT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Chorts'));
    this.large_creatures_chances_day[LargeCreatureCYCLOPS]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Cyclops'));
    this.large_creatures_chances_day[LargeCreatureTROLL]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Troll'));
    this.large_creatures_chances_day[LargeCreatureSKELTROLL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Troll'));
    this.large_creatures_chances_day[LargeCreatureHAG]          = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Hags'));
    this.large_creatures_chances_day[LargeCreatureFOGLET]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Fogling'));
		this.large_creatures_chances_day[LargeCreatureBRUXA]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Bruxa'));
		this.large_creatures_chances_day[LargeCreatureFLEDER]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Fleder'));
		this.large_creatures_chances_day[LargeCreatureGARKAIN]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Garkain'));
		this.large_creatures_chances_day[LargeCreatureDETLAFF]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'HigherVamp'));
		this.large_creatures_chances_day[LargeCreatureGIANT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Giant'));
		this.large_creatures_chances_day[LargeCreatureSHARLEY]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Sharley'));
    this.large_creatures_chances_day[LargeCreatureWIGHT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wight'));
    this.large_creatures_chances_day[LargeCreatureGRYPHON]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Gryphons'));
    this.large_creatures_chances_day[LargeCreatureCOCKATRICE]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Cockatrice'));
    this.large_creatures_chances_day[LargeCreatureBASILISK]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Basilisk'));
    this.large_creatures_chances_day[LargeCreatureWYVERN]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wyverns'));
    this.large_creatures_chances_day[LargeCreatureFORKTAIL]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Forktails'));

    this.small_creatures_chances_night[SmallCreatureHARPY]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Harpies'));
    this.small_creatures_chances_night[SmallCreatureENDREGA]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Endrega'));
    this.small_creatures_chances_night[SmallCreatureGHOUL]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Ghouls'));
    this.small_creatures_chances_night[SmallCreatureALGHOUL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Alghouls'));
    this.small_creatures_chances_night[SmallCreatureNEKKER]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Nekkers'));
    this.small_creatures_chances_night[SmallCreatureDROWNER]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Drowners'));
    this.small_creatures_chances_night[SmallCreatureROTFIEND]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Rotfiends'));
    this.small_creatures_chances_night[SmallCreatureWOLF]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Wolves'));
    this.small_creatures_chances_night[SmallCreatureWRAITH]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Wraiths'));
    this.small_creatures_chances_night[SmallCreatureSPIDER]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Spiders'));
    this.small_creatures_chances_night[SmallCreatureWILDHUNT]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'WildHunt'));
    this.small_creatures_chances_night[SmallCreatureHuman]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Humans'));
    this.small_creatures_chances_night[SmallCreatureSKELETON]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Skeleton'));


    // Blood and Wine
    this.small_creatures_chances_night[SmallCreatureBARGHEST]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Barghest')); 
    this.small_creatures_chances_night[SmallCreatureECHINOPS]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Echinops')); 
    this.small_creatures_chances_night[SmallCreatureCENTIPEDE]  = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Centipede'));
    this.small_creatures_chances_night[SmallCreatureKIKIMORE]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Kikimore'));
    this.small_creatures_chances_night[SmallCreatureDROWNERDLC] = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'DrownerDLC'));
    this.small_creatures_chances_night[SmallCreatureARACHAS]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Arachas'));
    this.small_creatures_chances_night[SmallCreatureBEAR]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Bears'));
		this.small_creatures_chances_night[SmallCreaturePANTHER]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Panther'));
		this.small_creatures_chances_night[SmallCreatureBOAR]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Boars'));

		this.large_creatures_chances_night[LargeCreatureLESHEN]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Leshens'));
    this.large_creatures_chances_night[LargeCreatureWEREWOLF]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Werewolves'));
    this.large_creatures_chances_night[LargeCreatureFIEND]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Fiends'));
    this.large_creatures_chances_night[LargeCreatureEKIMMARA]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Ekimmara'));
    this.large_creatures_chances_night[LargeCreatureKATAKAN]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Katakan'));
    this.large_creatures_chances_night[LargeCreatureGOLEM]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Golems'));
    this.large_creatures_chances_night[LargeCreatureELEMENTAL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Elementals'));
    this.large_creatures_chances_night[LargeCreatureNIGHTWRAITH]  = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'NightWraiths'));
    this.large_creatures_chances_night[LargeCreatureNOONWRAITH]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'NoonWraiths'));
    this.large_creatures_chances_night[LargeCreatureCHORT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Chorts'));
    this.large_creatures_chances_night[LargeCreatureCYCLOPS]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Cyclops'));
    this.large_creatures_chances_night[LargeCreatureTROLL]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Troll'));
    this.large_creatures_chances_night[LargeCreatureHAG]          = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Hags'));
    this.large_creatures_chances_night[LargeCreatureFOGLET]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Fogling'));
		this.large_creatures_chances_night[LargeCreatureBRUXA]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Bruxa'));
		this.large_creatures_chances_night[LargeCreatureFLEDER]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Fleder'));
		this.large_creatures_chances_night[LargeCreatureGARKAIN]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Garkain'));
		this.large_creatures_chances_night[LargeCreatureDETLAFF]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'HigherVamp'));
		this.large_creatures_chances_night[LargeCreatureGIANT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Giant'));
		this.large_creatures_chances_night[LargeCreatureSHARLEY]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Sharley'));
    this.large_creatures_chances_night[LargeCreatureWIGHT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Wight'));
    this.large_creatures_chances_night[LargeCreatureGRYPHON]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Gryphons'));
    this.large_creatures_chances_night[LargeCreatureCOCKATRICE]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Cockatrice'));
    this.large_creatures_chances_night[LargeCreatureBASILISK]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Basilisk'));
    this.large_creatures_chances_night[LargeCreatureWYVERN]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Wyverns'));
    this.large_creatures_chances_night[LargeCreatureFORKTAIL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Forktails'));
  }
}
