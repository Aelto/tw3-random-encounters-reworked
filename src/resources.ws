
class RE_Resources {
  public var novbandit, pirate, skelpirate, bandit, nilf, cannibal, renegade, skelbandit, skel2bandit, whunter: EnemyTemplateList;
  public var gryphon, gryphonf, forktail, wyvern, cockatrice, cockatricef, basilisk, basiliskf, wight, sharley  : EnemyTemplateList;
  public var fiend, chort, wildHunt, endrega, fogling, ghoul, alghoul, bear, skelbear, golem, elemental, hag, nekker : EnemyTemplateList;
  public var ekimmara, katakan, whh, drowner, rotfiend, nightwraith, noonwraith, troll, skeltroll, wolf, skelwolf, wraith : EnemyTemplateList;
  public var spider, harpy, leshen, werewolf, cyclop, arachas, vampire, skelelemental, bruxacity : EnemyTemplateList;
  public var centipede, giant, panther, kikimore, gravier, garkain, fleder, echinops, bruxa, barghest, skeleton, detlaff, boar : EnemyTemplateList;

  public var blood_splats : array<string>;

  public var small_creatures_resources: array<EnemyTemplateList>;
  public var large_creatures_resources: array<EnemyTemplateList>;
  public var humans_resources: array<EnemyTemplateList>;


  function load_resources() {
    var i: int;
    var empty_enemy_template_list: EnemyTemplateList;

    if (this.small_creatures_resources.Size() == 0) {
      for (i = 0; i < SmallCreatureMAX; i += 1) {
        this.small_creatures_resources.PushBack(empty_enemy_template_list);
      }
    }

    if (this.large_creatures_resources.Size() == 0) {
      for (i = 0; i < LargeCreatureMAX; i += 1) {
        this.large_creatures_resources.PushBack(empty_enemy_template_list);
      }
    }

    if (this.humans_resources.Size() == 0) {
      for (i = 0; i < HT_MAX; i += 1) {
        this.humans_resources.PushBack(empty_enemy_template_list);
      }
    }

    this.load_blood_splats();
    this.load_default_entities();

    if (isBloodAndWineActive()) {
      this.loadBloodAndWineResources();
    }

    if (isHeartOfStoneActive()) {
      this.loadHearOfStoneResources();
    }
  }

  public function getHumanResourcesByHumanType(human_type: EHumanType): EnemyTemplateList {
    LogChannel('modRandomEncounters', "get human resource by human type: " + human_type);

    return this.humans_resources[human_type];
  }

  public function getCreatureResourceBySmallCreatureType(creature_type: SmallCreatureType, out rExtra: CModRExtra): EnemyTemplateList {
    LogChannel('modRandomEncounters', "get creature resource by small creature type: " + creature_type);

    if (creature_type == SmallCreatureHuman) {
      return this.getHumanResourcesByHumanType(
        rExtra.getRandomHumanTypeByCurrentArea()
      );
    }

    return this.small_creatures_resources[creature_type];
  }

  public function getCreatureResourceByLargeCreatureType(creature_type: LargeCreatureType): EnemyTemplateList {
    LogChannel('modRandomEncounters', "get creature resource by large creature type: " + creature_type);

    return this.large_creatures_resources[creature_type];
  }

  private function load_blood_splats() {
    blood_splats.PushBack("quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_big.w2ent");  
    blood_splats.PushBack("quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_medium.w2ent");    
    blood_splats.PushBack("quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_medium_2.w2ent");  
    blood_splats.PushBack("living_world\treasure_hunting\th1003_lynx\entities\generic_clue_blood_splat.w2ent");
  }

  private function loadBloodAndWineResources() {
    this.large_creatures_resources[LargeCreatureWIGHT] = re_wight();
    this.large_creatures_resources[LargeCreatureSHARLEY] = re_sharley();
    this.small_creatures_resources[SmallCreatureCENTIPEDE] = re_centipede();
    this.large_creatures_resources[LargeCreatureGIANT] = re_giant();
    this.small_creatures_resources[SmallCreaturePANTHER] = re_panther();
    this.small_creatures_resources[SmallCreatureKIKIMORE] = re_kikimore();
    this.small_creatures_resources[SmallCreatureDROWNERDLC] = re_gravier();
    this.large_creatures_resources[LargeCreatureGARKAIN] = re_garkain();
    this.large_creatures_resources[LargeCreatureFLEDER] = re_fleder();
    this.small_creatures_resources[SmallCreatureECHINOPS] = re_echinops();
    this.large_creatures_resources[LargeCreatureBRUXA] = re_bruxa();
    this.small_creatures_resources[SmallCreatureBARGHEST] = re_barghest();
    this.small_creatures_resources[SmallCreatureSKELETON] = re_skeleton();
    this.large_creatures_resources[LargeCreatureDETLAFF] = re_detlaff();
  }

  private function loadHearOfStoneResources() {
    this.small_creatures_resources[SmallCreatureSPIDER] = re_spider();
    this.small_creatures_resources[SmallCreatureBOAR] = re_boar();
  }

  private function load_default_entities() {
    this.large_creatures_resources[LargeCreatureGRYPHON] = re_gryphon();
    this.large_creatures_resources[LargeCreatureFORKTAIL] = re_forktail();
    this.large_creatures_resources[LargeCreatureWYVERN] = re_wyvern();
    this.large_creatures_resources[LargeCreatureCOCKATRICE] = re_cockatrice();
    //cockatricef = re_cockatricef();
    this.large_creatures_resources[LargeCreatureBASILISK] = re_basilisk();
    //basiliskf = re_basiliskf();
    this.small_creatures_resources[LargeCreatureFIEND] = re_fiend();
    this.large_creatures_resources[LargeCreatureCHORT] = re_chort();
    this.small_creatures_resources[SmallCreatureENDREGA] = re_endrega();
    this.large_creatures_resources[LargeCreatureFOGLET] = re_fogling();
    this.small_creatures_resources[SmallCreatureGHOUL] = re_ghoul();
    this.small_creatures_resources[SmallCreatureALGHOUL] = re_alghoul();
    this.small_creatures_resources[SmallCreatureBEAR] = re_bear();
    
    
    this.large_creatures_resources[LargeCreatureGOLEM] = re_golem();
    this.large_creatures_resources[LargeCreatureELEMENTAL] = re_elemental();
    this.large_creatures_resources[LargeCreatureHAG] = re_hag();
    this.small_creatures_resources[SmallCreatureNEKKER] = re_nekker();
    this.large_creatures_resources[LargeCreatureEKIMMARA] = re_ekimmara();
    this.large_creatures_resources[LargeCreatureKATAKAN] = re_katakan();
    
    
    this.small_creatures_resources[SmallCreatureDROWNER] = re_drowner();
    this.small_creatures_resources[SmallCreatureROTFIEND] = re_rotfiend();
    this.large_creatures_resources[LargeCreatureNIGHTWRAITH] = re_nightwraith();
    this.large_creatures_resources[LargeCreatureNOONWRAITH] = re_noonwraith();
    this.large_creatures_resources[LargeCreatureTROLL] = re_troll();
    
    this.small_creatures_resources[SmallCreatureWOLF] = re_wolf();
    
    this.small_creatures_resources[SmallCreatureWRAITH] = re_wraith();    
    this.small_creatures_resources[SmallCreatureHARPY] = re_harpy();
    this.large_creatures_resources[LargeCreatureLESHEN] = re_leshen();
    this.large_creatures_resources[LargeCreatureWEREWOLF] = re_werewolf();
    this.large_creatures_resources[LargeCreatureCYCLOPS] = re_cyclop();
    this.small_creatures_resources[SmallCreatureARACHAS] = re_arachas();
    this.large_creatures_resources[LargeCreatureBRUXA] = re_bruxacity();

    this.large_creatures_resources[LargeCreatureSKELTROLL] = re_skeltroll();
    this.small_creatures_resources[SmallCreatureSKELBEAR] = re_skelbear();
    this.small_creatures_resources[SmallCreatureSKELWOLF] = re_skelwolf();

    // whh = re_whh();
    this.small_creatures_resources[SmallCreatureWILDHUNT] = re_wildhunt();

    this.humans_resources[HT_BANDIT] = re_bandit();
    this.humans_resources[HT_NOVBANDIT] = re_novbandit();
    this.humans_resources[HT_SKELBANDIT] = re_skelbandit();
    this.humans_resources[HT_SKELBANDIT2] = re_skel2bandit();
    this.humans_resources[HT_CANNIBAL] = re_cannibal();
    this.humans_resources[HT_RENEGADE] = re_renegade();
    this.humans_resources[HT_PIRATE] = re_pirate();
    this.humans_resources[HT_SKELPIRATE] = re_skelpirate();
    this.humans_resources[HT_NILFGAARDIAN] = re_nilf();
    this.humans_resources[HT_WITCHHUNTER] = re_whunter();
  }
}

function isHeartOfStoneActive(): bool {
  return theGame.GetDLCManager().IsEP1Available() && theGame.GetDLCManager().IsEP1Enabled();
}

function isBloodAndWineActive(): bool {
  return theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled();
}
