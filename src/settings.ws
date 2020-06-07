
class RE_Settings {

  public var customFlying, customGround, customGroup : bool;
	
	
	public var isFlyingActiveD, isGroundActiveD, isHumanActiveD, isGroupActiveD, isWildHuntActiveD : int;
  public	var isFlyingActiveN, isGroundActiveN, isHumanActiveN, isGroupActiveN, isWildHuntActiveN : int;
	
	public var isGryphonsD, isCockatriceD, isWyvernsD, isForktailsD, isBasiliskD : int;
  public var isGryphonsN, isCockatriceN, isWyvernsN, isForktailsN, isBasiliskN : int;
  public var isCGryphons, isCCockatrice, isCWyverns, isCForktails, isCBasilisk : bool;
	
	public var isLeshensD, isWerewolvesD, isFiendsD, isBearsD, isGolemsD, isElementalsD, isHarpyD, isCyclopsD, isArachasD, isTrollD, isBoarD : int;
  public var isNightWraithsD, isNoonWraithsD, isHagsD, isFoglingD, isEndregaD, isGhoulsD, isAlghoulsD, isChortsD, isEkimmaraD, isKatakanD, isBruxaD : int;
  public var isNekkersD, isWildhuntHoundsD, isWildhuntSoldiersD, isDrownersD, isRotfiendsD, isWolvesD, isWraithsD, isHigherVampD, isFlederD, isGarkainD : int;
  public var isSpidersD, isPantherD, isSharleyD, isGiantD, isBarghestD, isEchinopsD, isCentipedeD, isKikimoreD, isWightD, isDrownerDLCD, isSkeletonD : int;
	
  public var isLeshensN, isWerewolvesN, isFiendsN, isBearsN, isGolemsN, isElementalsN, isHarpyN, isCyclopsN, isArachasN, isTrollN, isBoarN : int;
  public var isNightWraithsN, isNoonWraithsN, isHagsN, isFoglingN, isEndregaN, isGhoulsN, isAlghoulsN, isChortsN, isWightN, isEchinopsN, isDrownerDLCN : int;
  public var isNekkersN, isDrownersN, isRotfiendsN, isWolvesN, isWraithsN, isBruxaN, isHigherVampN, isGarkainN, isFlederN, isKikimoreN, isSkeletonN : int;
  public var isSpidersN, isWildhuntHoundsN, isWildhuntSoldiersN, isEkimmaraN, isKatakanN, isPantherN, isSharleyN, isGiantN, isBarghestN, isCentipedeN : int;
	
	public var isCHarpy, isCCyclops, isCArachas, isCChorts, isCTroll, isCEkimmara, isCKatakan, isCBruxa, isCHigherVamp, isCFleder, isCGarkain : bool;
  public var isCLeshens, isCWerewolves, isCFiends, isCVampires, isCBears, isCGolems, isCElementals, isCPanther, isCSharley, isCGiant, isCBoar : bool;
  public var isCNightWraiths, isCNoonWraiths, isCHags, isCFogling, isCEndrega, isCGhouls, isCAlghouls, isCNekkers, isCKikimore, isCWight : bool;
  public var isCDrowners, isCRotfiends, isCWolves, isCWraiths, isCSpiders, isCSkeleton, isCDrownerDLC, isCBarghest, isCEchinops, isCCentipede : bool;

	public	var customDayMax, customDayMin, customNightMax, customNightMin	: int;
	public var flyingMonsterHunts, groundMonsterHunts, groupMonsterHunts	: int;
	public var customFrequency, enableTrophies : bool;
  public var cityBruxa, citySpawn : int;
  public	var selectedDifficulty	: int;
  public var chanceDay, chanceNight : int;

  function loadXMLSettings(show: bool) {
    var inGameConfigWrapper : CInGameConfigWrapper;

    if (show) {
      theGame
      .GetGuiManager()
      .ShowNotification("Random Encounters XML settings loaded");
    }

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    this.loadDayEncounterChance(inGameConfigWrapper);
    this.loadNightEncounterChance(inGameConfigWrapper);

    this.loadMonsterHuntsChances(inGameConfigWrapper);
    this.loadCustomFrequencies(inGameConfigWrapper);

    this.loadDayFrequency(inGameConfigWrapper);
    this.loadNightFrequency(inGameConfigWrapper);

    this.loadTrophiesSettings(inGameConfigWrapper);
    this.loadDifficultySettings(inGameConfigWrapper);
    this.loadCitySpawnSettings(inGameConfigWrapper);

    this.flyingMonsterList(inGameConfigWrapper);
		this.customFlyingMonsterList(inGameConfigWrapper);
		this.groundMonsterList(inGameConfigWrapper);
		this.customGroundMonsterList(inGameConfigWrapper);
		this.groupMonsterList(inGameConfigWrapper);
		this.customGroupMonsterList(inGameConfigWrapper);
  }

  private function loadCitySpawnSettings(inGameConfigWrapper: CInGameConfigWrapper) {
		citySpawn = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'citySpawn'));
		cityBruxa = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'cityBruxa'));
  }

  private function loadDifficultySettings(inGameConfigWrapper: CInGameConfigWrapper) {
    selectedDifficulty = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'Difficulty'));
  }

  private function loadTrophiesSettings(inGameConfigWrapper: CInGameConfigWrapper) {
		enableTrophies = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'enableTrophies'); 	
  }

  private function loadDayFrequency(inGameConfigWrapper: CInGameConfigWrapper) {
		chanceDay = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'dayFrequency'));
  }

  private function loadNightFrequency(inGameConfigWrapper: CInGameConfigWrapper) {
		chanceNight = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'nightFrequency'));
  }

  private function loadDayEncounterChance(inGameConfigWrapper: CInGameConfigWrapper) {
    isFlyingActiveD  = StringToInt(inGameConfigWrapper.GetVarValue('encounterChanceDay', 'enableFlyingMonsters')); 
    isGroundActiveD = StringToInt(inGameConfigWrapper.GetVarValue('encounterChanceDay', 'enableGroundMonsters'));	
    isHumanActiveD = StringToInt(inGameConfigWrapper.GetVarValue('encounterChanceDay', 'enableHumanEnemies'));
    isWildHuntActiveD = StringToInt(inGameConfigWrapper.GetVarValue('encounterChanceDay', 'enableWildHunt'));
    isGroupActiveD = StringToInt(inGameConfigWrapper.GetVarValue('encounterChanceDay', 'enableGroupMonsters'));
  }

  private function loadNightEncounterChance(inGameConfigWrapper: CInGameConfigWrapper) {
    isFlyingActiveN  = StringToInt(inGameConfigWrapper.GetVarValue('encounterChanceNight', 'enableFlyingMonsters')); 
    isGroundActiveN = StringToInt(inGameConfigWrapper.GetVarValue('encounterChanceNight', 'enableGroundMonsters'));	
    isHumanActiveN = StringToInt(inGameConfigWrapper.GetVarValue('encounterChanceNight', 'enableHumanEnemies'));
    isWildHuntActiveN = StringToInt(inGameConfigWrapper.GetVarValue('encounterChanceNight', 'enableWildHunt'));
    isGroupActiveN = StringToInt(inGameConfigWrapper.GetVarValue('encounterChanceNight', 'enableGroupMonsters'));
  }

  private function loadCustomFrequencies(inGameConfigWrapper: CInGameConfigWrapper) {
    customFrequency = inGameConfigWrapper.GetVarValue('custom', 'customFrequencyToggle'); 		
		customDayMax = StringToInt(inGameConfigWrapper.GetVarValue('custom', 'customdFrequencyHigh'));
		customDayMin = StringToInt(inGameConfigWrapper.GetVarValue('custom', 'customdFrequencyLow'));
		customNightMax = StringToInt(inGameConfigWrapper.GetVarValue('custom', 'customnFrequencyHigh'));
		customNightMin = StringToInt(inGameConfigWrapper.GetVarValue('custom', 'customnFrequencyLow'));	
    customFlying = inGameConfigWrapper.GetVarValue('custom', 'customFlyingMonsters'); 		
    customGround = inGameConfigWrapper.GetVarValue('custom', 'customGroundMonsters'); 
    customGroup = inGameConfigWrapper.GetVarValue('custom', 'customGroundMonsters'); // used to be: customGroupMonsters
  }

  private function loadMonsterHuntsChances(inGameConfigWrapper: CInGameConfigWrapper) {
    flyingMonsterHunts = StringToInt(inGameConfigWrapper.GetVarValue('monsterHuntChance', 'flyingMonsterHunts'));
    groundMonsterHunts = StringToInt(inGameConfigWrapper.GetVarValue('monsterHuntChance', 'groundMonsterHunts'));
    groupMonsterHunts = StringToInt(inGameConfigWrapper.GetVarValue('monsterHuntChance', 'groupMonsterHunts'));	
  }
  
  private function flyingMonsterList (inGameConfigWrapper : CInGameConfigWrapper) {
    isCGryphons = inGameConfigWrapper.GetVarValue('monsterList', 'Gryphons');
    isCCockatrice = inGameConfigWrapper.GetVarValue('monsterList', 'Cockatrice');
    isCWyverns = inGameConfigWrapper.GetVarValue('monsterList', 'Wyverns');
    isCForktails = inGameConfigWrapper.GetVarValue('monsterList', 'Forktails');
  }

	private function customFlyingMonsterList (inGameConfigWrapper : CInGameConfigWrapper) {
    isGryphonsD = StringToInt(inGameConfigWrapper.GetVarValue('customFlyingDay', 'Gryphons'));
    isCockatriceD = StringToInt(inGameConfigWrapper.GetVarValue('customFlyingDay', 'Cockatrice'));
    isWyvernsD = StringToInt(inGameConfigWrapper.GetVarValue('customFlyingDay', 'Wyverns'));
    isForktailsD = StringToInt(inGameConfigWrapper.GetVarValue('customFlyingDay', 'Forktails'));

    isGryphonsN = StringToInt(inGameConfigWrapper.GetVarValue('customFlyingNight', 'Gryphons'));
    isCockatriceN = StringToInt(inGameConfigWrapper.GetVarValue('customFlyingNight', 'Cockatrice'));
    isWyvernsN = StringToInt(inGameConfigWrapper.GetVarValue('customFlyingNight', 'Wyverns'));
    isForktailsN = StringToInt(inGameConfigWrapper.GetVarValue('customFlyingNight', 'Forktails'));
  }	
	
  private function groundMonsterList (inGameConfigWrapper : CInGameConfigWrapper) {
    isCLeshens = inGameConfigWrapper.GetVarValue('monsterList', 'Leshens');
    isCWerewolves = inGameConfigWrapper.GetVarValue('monsterList', 'Werewolves');
    isCCyclops = inGameConfigWrapper.GetVarValue('monsterList', 'Cyclops');
    isCArachas = inGameConfigWrapper.GetVarValue('monsterList', 'Arachas');
    isCFiends = inGameConfigWrapper.GetVarValue('monsterList', 'Fiends');
    isCChorts = inGameConfigWrapper.GetVarValue('monsterList', 'Chorts');
    isCEkimmara = inGameConfigWrapper.GetVarValue('monsterList', 'Ekimmara');
    isCKatakan = inGameConfigWrapper.GetVarValue('monsterList', 'Katakan');
    isCBears = inGameConfigWrapper.GetVarValue('monsterList', 'Bears');
    isCGolems = inGameConfigWrapper.GetVarValue('monsterList', 'Golems');
    isCElementals = inGameConfigWrapper.GetVarValue('monsterList', 'Elementals');
    isCNightWraiths = inGameConfigWrapper.GetVarValue('monsterList', 'NightWraiths');
    isCNoonWraiths = inGameConfigWrapper.GetVarValue('monsterList', 'NoonWraiths');
    isCTroll = inGameConfigWrapper.GetVarValue('monsterList', 'Troll');
    isCHags = inGameConfigWrapper.GetVarValue('monsterList', 'Hags');

    // Blood and Wine
    isCBruxa = inGameConfigWrapper.GetVarValue('monsterList', 'Bruxa');
    isCHigherVamp = inGameConfigWrapper.GetVarValue('monsterList', 'HigherVamp');
    isCFleder = inGameConfigWrapper.GetVarValue('monsterList', 'Fleder');
    isCGarkain = inGameConfigWrapper.GetVarValue('monsterList', 'Garkain');
    isCPanther = inGameConfigWrapper.GetVarValue('monsterList', 'Panther');
    isCSharley = inGameConfigWrapper.GetVarValue('monsterList', 'Sharley');
    isCGiant = inGameConfigWrapper.GetVarValue('monsterList', 'Giant');
    isCBoar = inGameConfigWrapper.GetVarValue('monsterList', 'Boars');
  }

  private function customGroundMonsterList (inGameConfigWrapper : CInGameConfigWrapper) {
    isWerewolvesD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Werewolves'));
    isCyclopsD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Cyclops'));
    isArachasD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Arachas'));
    isFiendsD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Fiends'));
    isChortsD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Chorts'));
    isEkimmaraD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Ekimmara'));
    isKatakanD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Katakan'));
    isBearsD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Bears'));
    isGolemsD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Golems'));
    isElementalsD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Elementals'));
    isNightWraithsD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'NightWraiths'));
    isNoonWraithsD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'NoonWraiths'));
    isTrollD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Troll'));
    isHagsD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Hags'));

    isLeshensN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Leshens'));
    isWerewolvesN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Werewolves'));
    isCyclopsN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Cyclops'));
    isArachasN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Arachas'));
    isFiendsN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Fiends'));
    isChortsN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Chorts'));
    isEkimmaraN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Ekimmara'));
    isKatakanN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Katakan'));
    isBearsN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Bears'));
    isGolemsN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Golems'));
    isElementalsN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Elementals'));
    isNightWraithsN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'NightWraiths'));
    isNoonWraithsN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'NoonWraiths'));
    isTrollN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Troll'));
    isHagsN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Hags'));

		// Blood and Wine
		isBruxaD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Bruxa'));
		isHigherVampD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'HigherVamp'));
		isFlederD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Fleder'));
		isGarkainD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Garkain'));
		isPantherD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Panther'));
		isSharleyD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Sharley'));		
		isGiantD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Giant'));
		isBoarD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Boars'));
		
		isBruxaN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Bruxa'));
		isHigherVampN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'HigherVamp'));
		isFlederN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Fleder'));
		isGarkainN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Garkain'));
		isPantherN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Panther'));
		isSharleyN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Sharley'));		
		isGiantN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Giant'));
		isBoarN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Boars'));
  }		
	
  private function groupMonsterList (inGameConfigWrapper : CInGameConfigWrapper) {
    isCHarpy = inGameConfigWrapper.GetVarValue('monsterList', 'Harpies');
    isCFogling = inGameConfigWrapper.GetVarValue('monsterList', 'Fogling');
    isCEndrega = inGameConfigWrapper.GetVarValue('monsterList', 'Endrega');
    isCGhouls = inGameConfigWrapper.GetVarValue('monsterList', 'Ghouls');
    isCAlghouls = inGameConfigWrapper.GetVarValue('monsterList', 'Alghouls');
    isCNekkers = inGameConfigWrapper.GetVarValue('monsterList', 'Nekkers');
    isCDrowners = inGameConfigWrapper.GetVarValue('monsterList', 'Drowners');
    isCRotfiends = inGameConfigWrapper.GetVarValue('monsterList', 'Rotfiends');
    isCWolves = inGameConfigWrapper.GetVarValue('monsterList', 'Wolves');
    isCWraiths = inGameConfigWrapper.GetVarValue('monsterList', 'Wraiths');
    isCSpiders = inGameConfigWrapper.GetVarValue('monsterList', 'Spiders');

		// Blood and Wine
		isCDrownerDLC = inGameConfigWrapper.GetVarValue('monsterList', 'DrownerDLC');
		isCSkeleton = inGameConfigWrapper.GetVarValue('monsterList', 'Skeleton');
		isCBarghest = inGameConfigWrapper.GetVarValue('monsterList', 'Barghest');
		isCEchinops = inGameConfigWrapper.GetVarValue('monsterList', 'Echinops');
		isCCentipede = inGameConfigWrapper.GetVarValue('monsterList', 'Centipede');
		isCKikimore = inGameConfigWrapper.GetVarValue('monsterList', 'Kikimore');
		isCWight = inGameConfigWrapper.GetVarValue('monsterList', 'Wight');
  }
    
   
  private function customGroupMonsterList (inGameConfigWrapper : CInGameConfigWrapper) {
    isHarpyD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Harpies'));
    isFoglingD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Fogling'));
    isEndregaD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Endrega'));
    isGhoulsD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Ghouls'));
    isAlghoulsD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Alghouls'));
    isNekkersD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Nekkers'));
    isDrownersD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Drowners'));
    isRotfiendsD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Rotfiends'));
    isWolvesD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wolves'));
    isWraithsD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wraiths'));
    isSpidersD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Spiders'));

    isHarpyN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Harpies'));
    isFoglingN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Fogling'));
    isEndregaN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Endrega'));
    isGhoulsN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Ghouls'));
    isAlghoulsN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Alghouls'));
    isNekkersN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Nekkers'));
    isDrownersN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Drowners'));
    isRotfiendsN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Rotfiends'));
    isWolvesN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Wolves'));
    isWraithsN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Wraiths'));
    isSpidersN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Spiders'));

    // Blood and Wine
    isBarghestD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Barghest')); 
    isEchinopsD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Echinops')); 
    isCentipedeD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Centipede'));
    isKikimoreD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Kikimore'));
    isWightD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wight'));
    isSkeletonD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Skeleton'));
    isDrownerDLCD = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'DrownerDLC'));
    
    isBarghestN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Barghest')); 
    isEchinopsN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Echinops')); 
    isCentipedeN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Centipede'));
    isKikimoreN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Kikimore'));	
    isWightN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Wight'));
    isSkeletonN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Skeleton'));
    isDrownerDLCN = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'DrownerDLC'));
  }
}
