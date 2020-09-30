
class RER_Bestiary {
  var entries: array<RER_BestiaryEntry>;
  var human_entries: array<RER_BestiaryEntry>;

  public function loadSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;
    var i: int;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    for (i = 0; i < this.entries.Size(); i += 1) {
      this.entries[i].loadSettings(inGameConfigWrapper);
    }

    for (i = 0; i < this.human_entries.Size(); i += 1) {
      this.human_entries[i].loadSettings(inGameConfigWrapper);
    }
  }

  public latent function getRandomEntryFromBestiary(master: CRandomEncounters): RER_BestiaryEntry {
    var creatures_preferences: RER_CreaturePreferences;
    var creature_type: CreatureType;
    var manager : CWitcherJournalManager;
    var can_spawn_creature: bool;
    var i: int;

    master.spawn_roller.reset();

    creatures_preferences = new RER_CreaturePreferences in this;
    creatures_preferences
      .setIsNight(theGame.envMgr.IsNight())
      .setExternalFactorsCoefficient(master.settings.external_factors_coefficient)
      .setIsNearWater(master.rExtra.IsPlayerNearWater())
      .setIsInForest(master.rExtra.IsPlayerInForest())
      .setIsInSwamp(master.rExtra.IsPlayerInSwamp())
      .setCurrentRegion(AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea()))
      .setIsInCity(master.rExtra.isPlayerInSettlement() || master.rExtra.getCustomZone(thePlayer.GetWorldPosition()) == REZ_CITY);

    for (i = 0; i < CreatureMAX; i += 1) {
      this.entries[i]
        .setCreaturePreferences(creatures_preferences)
        .fillSpawnRoller(master.spawn_roller);
    }

    // when the option "Only known bestiary creatures" is ON
    // we remove every unknown creatures from the spawning pool
    if (master.settings.only_known_bestiary_creatures) {
      manager = theGame.GetJournalManager();

      for (i = 0; i < CreatureMAX; i += 1) {
        can_spawn_creature = bestiaryCanSpawnEnemyTemplateList(this.entries[i].template_list, manager);
        
        if (!can_spawn_creature) {
          master.spawn_roller.setCreatureCounter(i, 0);
        }
      }
    }

    creature_type = master.spawn_roller.rollCreatures();

    if (creature_type == CreatureNONE) {
      return new RER_BestiaryEntryNull in this;
    }

    if (creature_type == CreatureHUMAN) {
      return this.human_entries[master.rExtra.getRandomHumanTypeByCurrentArea()];
    }

    return this.entries[creature_type];
  }

  public function init() {
    var empty_entry: RER_BestiaryEntry;
    var i: int;

    for (i = 0; i < CreatureMAX; i += 1) {
      this.entries.PushBack(empty_entry);
    }

    for (i = 0; i < HT_MAX; i += 1) {
      this.human_entries.PushBack(empty_entry);
    }

    this.entries[CreatureALGHOUL] = new RER_BestiaryAlghoul in this;
    this.entries[CreatureARACHAS] = new RER_BestiaryArachas in this;
    this.entries[CreatureBARGHEST] = new RER_BestiaryBarghest in this;
    this.entries[CreatureBASILISK] = new RER_BestiaryBasilisk in this;
    this.entries[CreatureBEAR] = new RER_BestiaryBear in this;
    this.entries[CreatureBERSERKER] = new RER_BestiaryBerserker in this;
    this.entries[CreatureBOAR] = new RER_BestiaryBoar in this;
    this.entries[CreatureBRUXA] = new RER_BestiaryBruxa in this;
    // this.entries[CreatureBRUXACITY] = new RER_BestiaryBruxacity in this;
    this.entries[CreatureCENTIPEDE] = new RER_BestiaryCentipede in this;
    this.entries[CreatureCHORT] = new RER_BestiaryChort in this;
    this.entries[CreatureCOCKATRICE] = new RER_BestiaryCockatrice in this;
    this.entries[CreatureCYCLOP] = new RER_BestiaryCyclop in this;
    this.entries[CreatureDETLAFF] = new RER_BestiaryDetlaff in this;
    this.entries[CreatureDRACOLIZARD] = new RER_BestiaryDracolizard in this;
    this.entries[CreatureDROWNER] = new RER_BestiaryDrowner in this;
    this.entries[CreatureECHINOPS] = new RER_BestiaryEchinops in this;
    this.entries[CreatureEKIMMARA] = new RER_BestiaryEkimmara in this;
    this.entries[CreatureELEMENTAL] = new RER_BestiaryElemental in this;
    this.entries[CreatureENDREGA] = new RER_BestiaryEndrega in this;
    this.entries[CreatureFIEND] = new RER_BestiaryFiend in this;
    this.entries[CreatureFLEDER] = new RER_BestiaryFleder in this;
    this.entries[CreatureFOGLET] = new RER_BestiaryFogling in this;
    this.entries[CreatureFORKTAIL] = new RER_BestiaryForktail in this;
    this.entries[CreatureGARGOYLE] = new RER_BestiaryGargoyle in this;
    this.entries[CreatureGARKAIN] = new RER_BestiaryGarkain in this;
    this.entries[CreatureGHOUL] = new RER_BestiaryGhoul in this;
    this.entries[CreatureGIANT] = new RER_BestiaryGiant in this;
    this.entries[CreatureGOLEM] = new RER_BestiaryGolem in this;
    this.entries[CreatureDROWNERDLC] = new RER_BestiaryGravier in this;
    this.entries[CreatureGRYPHON] = new RER_BestiaryGryphon in this;
    this.entries[CreatureHAG] = new RER_BestiaryHag in this;
    this.entries[CreatureHARPY] = new RER_BestiaryHarpy in this;
    this.entries[CreatureHUMAN] = new RER_BestiaryHuman in this;
    this.entries[CreatureKATAKAN] = new RER_BestiaryKatakan in this;
    this.entries[CreatureKIKIMORE] = new RER_BestiaryKikimore in this;
    this.entries[CreatureLESHEN] = new RER_BestiaryLeshen in this;
    this.entries[CreatureNEKKER] = new RER_BestiaryNekker in this;
    this.entries[CreatureNIGHTWRAITH] = new RER_BestiaryNightwraith in this;
    this.entries[CreatureNOONWRAITH] = new RER_BestiaryNoonwraith in this;
    this.entries[CreaturePANTHER] = new RER_BestiaryPanther in this;
    this.entries[CreatureROTFIEND] = new RER_BestiaryRotfiend in this;
    this.entries[CreatureSHARLEY] = new RER_BestiarySharley in this;
    this.entries[CreatureSIREN] = new RER_BestiarySiren in this;
    this.entries[CreatureSKELBEAR] = new RER_BestiarySkelbear in this;
    this.entries[CreatureSKELETON] = new RER_BestiarySkeleton in this;
    this.entries[CreatureSKELTROLL] = new RER_BestiarySkeltroll in this;
    this.entries[CreatureSKELWOLF] = new RER_BestiarySkelwolf in this;
    this.entries[CreatureSPIDER] = new RER_BestiarySpider in this;
    this.entries[CreatureTROLL] = new RER_BestiaryTroll in this;
    this.entries[CreatureWEREWOLF] = new RER_BestiaryWerewolf in this;
    this.entries[CreatureWIGHT] = new RER_BestiaryWight in this;
    this.entries[CreatureWILDHUNT] = new RER_BestiaryWildhunt in this;
    this.entries[CreatureWOLF] = new RER_BestiaryWolf in this;
    this.entries[CreatureWRAITH] = new RER_BestiaryWraith in this;
    this.entries[CreatureWYVERN] = new RER_BestiaryWyvern in this;

    this.human_entries[HT_BANDIT] = new RER_BestiaryHumanBandit in this;
    this.human_entries[HT_CANNIBAL] = new RER_BestiaryHumanCannibal in this;
    this.human_entries[HT_NILFGAARDIAN] = new RER_BestiaryHumanNilf in this;
    this.human_entries[HT_NOVBANDIT] = new RER_BestiaryHumanNovbandit in this;
    this.human_entries[HT_PIRATE] = new RER_BestiaryHumanPirate in this;
    this.human_entries[HT_RENEGADE] = new RER_BestiaryHumanRenegade in this;
    this.human_entries[HT_SKELBANDIT2] = new RER_BestiaryHumanSkel2bandit in this;
    this.human_entries[HT_SKELBANDIT] = new RER_BestiaryHumanSkelbandit in this;
    this.human_entries[HT_SKELPIRATE] = new RER_BestiaryHumanSkelpirate in this;
    this.human_entries[HT_WITCHHUNTER] = new RER_BestiaryHumanWhunter in this;

    for (i = 0; i < CreatureMAX; i += 1) {
      this.entries[i].init();
    }

    for (i = 0; i < HT_MAX; i += 1) {
      this.human_entries[i].init();
    }
  }
}
