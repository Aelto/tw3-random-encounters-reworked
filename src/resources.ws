
class RE_Resources {
  public var novbandit, pirate, skelpirate, bandit, nilf, cannibal, renegade, skelbandit, skel2bandit, whunter: EnemyTemplateList;
  public var gryphon, gryphonf, forktail, wyvern, cockatrice, cockatricef, basilisk, basiliskf, wight, sharley  : EnemyTemplateList;
  public var fiend, chort, wildHunt, endrega, fogling, ghoul, alghoul, bear, skelbear, golem, elemental, hag, nekker : EnemyTemplateList;
  public var ekimmara, katakan, whh, drowner, rotfiend, nightwraith, noonwraith, troll, skeltroll, wolf, skelwolf, wraith : EnemyTemplateList;
  public var spider, harpy, leshen, werewolf, cyclop, arachas, vampire, skelelemental, bruxacity : EnemyTemplateList;
  public var centipede, giant, panther, kikimore, gravier, garkain, fleder, echinops, bruxa, barghest, skeleton, detlaff, boar : EnemyTemplateList;

  public var blood_splats : array<string>;


  function load_resources() {
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
    if (human_type == HT_BANDIT) {
      return this.bandit;
    }
    else if (human_type == HT_NOVBANDIT) {
      return this.novbandit;
    }
    else if (human_type == HT_SKELBANDIT) {
      return this.skelbandit;
    }
    else if (human_type == HT_SKELBANDIT2) {
      return this.skel2bandit;
    }
    else if (human_type == HT_CANNIBAL) {
      return this.cannibal;
    }
    else if (human_type == HT_RENEGADE) {
      return this.renegade;
    }
    else if (human_type == HT_PIRATE) {
      return this.pirate;
    }
    else if (human_type == HT_SKELPIRATE) {
      return this.skelpirate;
    }
    else if (human_type == HT_NILFGAARDIAN) {
      return this.nilf;
    }
    else if (human_type == HT_WITCHHUNTER) {
      return this.whunter;
    }
    
    return this.bandit;
  }

  public function getCreatureResourceBySmallCreatureType(creature_type: SmallCreatureType, out rExtra: CModRExtra): EnemyTemplateList {
    LogChannel('modRandomEncounters', "get creature resource by small creature type: " + creature_type);

    switch (creature_type) {
      case SmallCreatureHuman:
        return this.getHumanResourcesByHumanType(
          rExtra.getRandomHumanTypeByCurrentArea()
        );

      case (SmallCreatureARACHAS):
        return this.arachas;

      case (SmallCreatureENDREGA):
        return this.endrega;
      
      case (SmallCreatureGHOUL):
        return this.ghoul;

      case (SmallCreatureALGHOUL):
        return this.alghoul;
      
      case (SmallCreatureNEKKER):
        return this.nekker;

      case (SmallCreatureDROWNER):
        return this.drowner;

      case (SmallCreatureROTFIEND):
        return this.rotfiend;

      case (SmallCreatureWOLF):
        return this.wolf;

      case (SmallCreatureWRAITH):
        return this.wraith;

      case (SmallCreatureHARPY):
        return this.harpy;

      case (SmallCreatureSPIDER):
        return this.spider;

      case (SmallCreatureCENTIPEDE):
        return this.centipede;

      case (SmallCreatureDROWNERDLC):
        return this.gravier;

      case (SmallCreatureBOAR):
        return this.boar;

      case (SmallCreatureBEAR):
        return this.bear;

      case (SmallCreaturePANTHER):
        return this.panther;

      case (SmallCreatureSKELETON):
        return this.skeleton;

      case (SmallCreatureBARGHEST):
        return this.barghest;

      case (SmallCreatureKIKIMORE):
        return this.kikimore;
    }

    LogChannel('modRandomEncounters', "unhandled small creature type, default to human: " + creature_type);

    return this.getHumanResourcesByHumanType(
      rExtra.getRandomHumanTypeByCurrentArea()
    );
  }

  public function getCreatureResourceByLargeCreatureType(creature_type: LargeCreatureType): EnemyTemplateList {
    switch (creature_type) {
      case (LargeCreatureLESHEN):
        return this.leshen;

      case (LargeCreatureWEREWOLF):
        return this.werewolf;

      case (LargeCreatureFIEND):
        return this.fiend;

      case (LargeCreatureEKIMMARA):
        return this.ekimmara;

      case (LargeCreatureKATAKAN):
        return this.katakan;

      case (LargeCreatureGOLEM):
        return this.golem;

      case (LargeCreatureELEMENTAL):
        return this.elemental;

      case (LargeCreatureNIGHTWRAITH):
        return this.nightwraith;

      case (LargeCreatureNOONWRAITH):
        return this.noonwraith;

      case (LargeCreatureCHORT):
        return this.chort;

      case (LargeCreatureCYCLOPS):
        return this.cyclop;

      case (LargeCreatureTROLL):
        return this.troll;

      case (LargeCreatureHAG):
        return this.hag;

      case (LargeCreatureFOGLET):
        return this.fogling;

      case (LargeCreatureBRUXA):
        return this.bruxa;

      case (LargeCreatureFLEDER):
        return this.fleder;

      case (LargeCreatureGARKAIN):
        return this.garkain;

      case (LargeCreatureDETLAFF):
        return this.detlaff;

      case (LargeCreatureGIANT):
        return this.giant;

      case (LargeCreatureSHARLEY):
        return this.sharley;

      case (LargeCreatureWIGHT):
        return this.wight;

      case (LargeCreatureVAMPIRE):
        return this.vampire;

      case (LargeCreatureGRYPHON):
        return this.gryphon;

      case (LargeCreatureCOCKATRICE):
        return this.cockatrice;

      case (LargeCreatureBASILISK):
        return this.basilisk;

      case (LargeCreatureWYVERN):
        return this.wyvern;

      case (LargeCreatureFORKTAIL):
        return this.forktail;
    }

    LogChannel('modRandomEncounters', "unhandled small creature type, default to werewolf: " + creature_type);

    return this.werewolf;
  }

  private function load_blood_splats() {
    blood_splats.PushBack("quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_big.w2ent");  
    blood_splats.PushBack("quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_medium.w2ent");    
    blood_splats.PushBack("quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_medium_2.w2ent");  
    blood_splats.PushBack("living_world\treasure_hunting\th1003_lynx\entities\generic_clue_blood_splat.w2ent");
  }

  private function loadBloodAndWineResources() {
    wight = re_wight();
    sharley = re_sharley();
    centipede = re_centipede();
    giant = re_giant();
    panther = re_panther();
    kikimore = re_kikimore();
    gravier = re_gravier();
    garkain = re_garkain();
    fleder = re_fleder();
    echinops = re_echinops();
    bruxa = re_bruxa();
    barghest = re_barghest();
    skeleton = re_skeleton();
    detlaff = re_detlaff();
  }

  private function loadHearOfStoneResources() {
    spider = re_spider();
    boar = re_boar();
  }

  private function load_default_entities() {
    novbandit = re_novbandit();
    pirate = re_pirate();
    skelpirate = re_skelpirate();
    bandit = re_bandit();
    nilf = re_nilf();
    cannibal = re_cannibal();
    renegade = re_renegade();
    skelbandit = re_skelbandit();
    skel2bandit = re_skel2bandit();
    whunter = re_whunter();
    gryphon = re_gryphon();
    //gryphonf = re_gryphonf();
    forktail = re_forktail();
    wyvern = re_wyvern();
    cockatrice = re_cockatrice();
    //cockatricef = re_cockatricef();
    basilisk = re_basilisk();
    //basiliskf = re_basiliskf();
    fiend = re_fiend();
    chort = re_chort();
    endrega = re_endrega();
    fogling = re_fogling();
    ghoul = re_ghoul();
    alghoul = re_alghoul();
    bear = re_bear();
    skelbear = re_skelbear();
    golem = re_golem();
    elemental = re_elemental();
    hag = re_hag();
    nekker = re_nekker();
    ekimmara = re_ekimmara();
    katakan = re_katakan();
    whh = re_whh();
    wildHunt = re_wildhunt();
    drowner = re_drowner();
    rotfiend = re_rotfiend();
    nightwraith = re_nightwraith();
    noonwraith = re_noonwraith();
    troll = re_troll();
    skeltroll = re_skeltroll();
    wolf = re_wolf();
    skelwolf = re_skelwolf();
    wraith = re_wraith();    
    harpy = re_harpy();
    leshen = re_leshen();
    werewolf = re_werewolf();
    cyclop = re_cyclop();
    arachas = re_arachas();
    bruxacity = re_bruxacity();
  }
}

function isHeartOfStoneActive(): bool {
  return theGame.GetDLCManager().IsEP1Available() && theGame.GetDLCManager().IsEP1Enabled();
}

function isBloodAndWineActive(): bool {
  return theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled();
}
