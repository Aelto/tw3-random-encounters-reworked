
class RE_Resources {
  public var blood_splats : array<string>;

  public var creatures_resources: array<EnemyTemplateList>;
  public var humans_resources: array<EnemyTemplateList>;

  function load_resources() {
    var i: int;
    var empty_enemy_template_list: EnemyTemplateList;

    if (this.creatures_resources.Size() == 0) {
      for (i = 0; i < CreatureMAX; i += 1) {
        this.creatures_resources.PushBack(empty_enemy_template_list);
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

  public function getCreatureResourceByCreatureType(creature_type: CreatureType, out rExtra: CModRExtra): EnemyTemplateList {
    LogChannel('modRandomEncounters', "get creature resource by creature type: " + creature_type);

    if (creature_type == CreatureHuman) {
      return this.getHumanResourcesByHumanType(
        rExtra.getRandomHumanTypeByCurrentArea()
      );
    }

    return this.creatures_resources[creature_type];
  }

  private function load_blood_splats() {
    blood_splats.PushBack("quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_big.w2ent");  
    blood_splats.PushBack("quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_medium.w2ent");    
    blood_splats.PushBack("quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_medium_2.w2ent");  
    blood_splats.PushBack("living_world\treasure_hunting\th1003_lynx\entities\generic_clue_blood_splat.w2ent");
  }

  private function loadBloodAndWineResources() {
    this.creatures_resources[CreatureWIGHT] = re_wight();
    this.creatures_resources[CreatureSHARLEY] = re_sharley();
    this.creatures_resources[CreatureCENTIPEDE] = re_centipede();
    this.creatures_resources[CreatureGIANT] = re_giant();
    this.creatures_resources[CreaturePANTHER] = re_panther();
    this.creatures_resources[CreatureKIKIMORE] = re_kikimore();
    this.creatures_resources[CreatureDROWNERDLC] = re_gravier();
    this.creatures_resources[CreatureGARKAIN] = re_garkain();
    this.creatures_resources[CreatureFLEDER] = re_fleder();
    this.creatures_resources[CreatureECHINOPS] = re_echinops();
    this.creatures_resources[CreatureBRUXA] = re_bruxa();
    this.creatures_resources[CreatureBARGHEST] = re_barghest();
    this.creatures_resources[CreatureSKELETON] = re_skeleton();
    this.creatures_resources[CreatureDETLAFF] = re_detlaff();
  }

  private function loadHearOfStoneResources() {
    this.creatures_resources[CreatureSPIDER] = re_spider();
    this.creatures_resources[CreatureBOAR] = re_boar();
  }

  private function load_default_entities() {
    this.creatures_resources[CreatureGRYPHON] = re_gryphon();
    this.creatures_resources[CreatureFORKTAIL] = re_forktail();
    this.creatures_resources[CreatureWYVERN] = re_wyvern();
    this.creatures_resources[CreatureCOCKATRICE] = re_cockatrice();
    this.creatures_resources[CreatureBASILISK] = re_basilisk();
    this.creatures_resources[CreatureFIEND] = re_fiend();
    this.creatures_resources[CreatureCHORT] = re_chort();
    this.creatures_resources[CreatureENDREGA] = re_endrega();
    this.creatures_resources[CreatureFOGLET] = re_fogling();
    this.creatures_resources[CreatureGHOUL] = re_ghoul();
    this.creatures_resources[CreatureALGHOUL] = re_alghoul();
    this.creatures_resources[CreatureBEAR] = re_bear();
    
    
    this.creatures_resources[CreatureGOLEM] = re_golem();
    this.creatures_resources[CreatureELEMENTAL] = re_elemental();
    this.creatures_resources[CreatureHAG] = re_hag();
    this.creatures_resources[CreatureNEKKER] = re_nekker();
    this.creatures_resources[CreatureEKIMMARA] = re_ekimmara();
    this.creatures_resources[CreatureKATAKAN] = re_katakan();
    
    
    this.creatures_resources[CreatureDROWNER] = re_drowner();
    this.creatures_resources[CreatureROTFIEND] = re_rotfiend();
    this.creatures_resources[CreatureNIGHTWRAITH] = re_nightwraith();
    this.creatures_resources[CreatureNOONWRAITH] = re_noonwraith();
    this.creatures_resources[CreatureTROLL] = re_troll();
    
    this.creatures_resources[CreatureWOLF] = re_wolf();
    
    this.creatures_resources[CreatureWRAITH] = re_wraith();    
    this.creatures_resources[CreatureHARPY] = re_harpy();
    this.creatures_resources[CreatureLESHEN] = re_leshen();
    this.creatures_resources[CreatureWEREWOLF] = re_werewolf();
    this.creatures_resources[CreatureCYCLOPS] = re_cyclop();
    this.creatures_resources[CreatureARACHAS] = re_arachas();
    this.creatures_resources[CreatureBRUXA] = re_bruxacity();

    this.creatures_resources[CreatureSKELTROLL] = re_skeltroll();
    this.creatures_resources[CreatureSKELBEAR] = re_skelbear();
    this.creatures_resources[CreatureSKELWOLF] = re_skelwolf();

    this.creatures_resources[CreatureDRACOLIZARD] = re_dracolizard();
    this.creatures_resources[CreatureBERSERKER] = re_berserker();
    this.creatures_resources[CreatureGARGOYLE] = re_gargoyle();
    this.creatures_resources[CreatureSIREN] = re_siren();
    

    // whh = re_whh();
    this.creatures_resources[CreatureWILDHUNT] = re_wildhunt();

    // this resource is almost never used.
    // there a functions to get random human resources
    // but it is used for its bestiary entry
    this.creatures_resources[CreatureHuman] = re_bandit();

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

                  //////////////////////
                  // PUBLIC FUNCTIONS //
                  //////////////////////

  public latent function getBloodSplatsResources(): array<CEntityTemplate> {
    var i: int;
    var output: array<CEntityTemplate>;

    for (i = 0; i < this.blood_splats.Size(); i += 1) {
      output.PushBack(
        (CEntityTemplate)LoadResourceAsync(
          this.blood_splats[i],
          true
        )
      );
    }

    return output;
  }

  public latent function getPortalResource(): CEntityTemplate {
    var entity_template: CEntityTemplate;

    entity_template = (CEntityTemplate)LoadResourceAsync( "gameplay\interactive_objects\rift\rift.w2ent", true);
    
    return entity_template;
  }

  public function getCreatureTrophy(creature_type: CreatureType, trophy_price: TrophyVariant): name {
    switch (creature_type) {
      case CreatureHuman:
        return getTrophyName(Trophy_HUMAN, trophy_price);
        break;
      case CreatureARACHAS:
        return getTrophyName(Trophy_ARACHAS, trophy_price);
        break;
      case CreatureKIKIMORE:
      case CreatureENDREGA:
      case CreatureECHINOPS:
      case CreatureSPIDER:
      case CreatureCENTIPEDE:
        return getTrophyName(Trophy_INSECTOID, trophy_price);
        break;
      case CreatureGHOUL:
      case CreatureALGHOUL:
      case CreatureDROWNER:
      case CreatureROTFIEND:
      case CreatureDROWNERDLC:
        return getTrophyName(Trophy_NECROPHAGE, trophy_price);
        break;
      
      case CreatureNEKKER:
        return getTrophyName(Trophy_NEKKER, trophy_price);

      case CreatureWRAITH:
        return getTrophyName(Trophy_WRAITH, trophy_price);
        break;
      case CreatureHARPY:
      case CreatureSIREN:
        return getTrophyName(Trophy_HARPY, trophy_price);
        break;
      case CreatureBARGHEST:
      case CreatureSKELETON:
        return getTrophyName(Trophy_SPIRIT, trophy_price);
        break;
      case CreatureWOLF:
      case CreatureBOAR:
      case CreatureBEAR:
      case CreatureBERSERKER:
      case CreaturePANTHER:
      case CreatureSKELWOLF:
      case CreatureSKELBEAR:
        return getTrophyName(Trophy_BEAST, trophy_price);
        break;
      case CreatureWILDHUNT:
        return getTrophyName(Trophy_WILDHUNT, trophy_price);
        break;
      case CreatureLESHEN:
        return getTrophyName(Trophy_LESHEN, trophy_price);
        break;
      case CreatureWEREWOLF:
        return getTrophyName(Trophy_WEREWOLF, trophy_price);
        break;
      case CreatureFIEND:
        return getTrophyName(Trophy_FIEND, trophy_price);
        break;
      case CreatureEKIMMARA:
        return getTrophyName(Trophy_EKIMMARA, trophy_price);
        break;
      case CreatureKATAKAN:
        return getTrophyName(Trophy_KATAKAN, trophy_price);
        break;
      case CreatureGOLEM:
      case CreatureELEMENTAL:
      case CreatureGARGOYLE:
        return getTrophyName(Trophy_ELEMENTAL, trophy_price);
        break;
      case CreatureNIGHTWRAITH:
        return getTrophyName(Trophy_NIGHTWRAITH, trophy_price);
        break;
      case CreatureNOONWRAITH:
        return getTrophyName(Trophy_NOONWRAITH, trophy_price);
        break;
      case CreatureCHORT:
        return getTrophyName(Trophy_CZART, trophy_price);
        break;
      case CreatureCYCLOPS:
        return getTrophyName(Trophy_CYCLOP, trophy_price);
        break;
      case CreatureSKELTROLL:
      case CreatureTROLL:
        return getTrophyName(Trophy_TROLL, trophy_price);
        break;
      case CreatureHAG:
        return getTrophyName(Trophy_GRAVE_HAG, trophy_price);
        break;
      case CreatureFOGLET:
        return getTrophyName(Trophy_FOGLING, trophy_price);
        break;

      case CreatureFLEDER:
      case CreatureGARKAIN:
        return getTrophyName(Trophy_GARKAIN, trophy_price);
        break;
      case CreatureBRUXA:
      case CreatureDETLAFF:
        return getTrophyName(Trophy_VAMPIRE, trophy_price);
        break;

      case CreatureGIANT:
        return getTrophyName(Trophy_GIANT, trophy_price);
        break;
      case CreatureSHARLEY:
        return getTrophyName(Trophy_SHARLEY, trophy_price);
        break;
      case CreatureWIGHT:
        return getTrophyName(Trophy_WIGHT, trophy_price);
        break;
      case CreatureGRYPHON:
        return getTrophyName(Trophy_GRIFFIN, trophy_price);
        break;
      case CreatureCOCKATRICE:
        return getTrophyName(Trophy_COCKATRICE, trophy_price);
        break;
      case CreatureBASILISK:
        return getTrophyName(Trophy_BASILISK, trophy_price);
        break;
      case CreatureWYVERN:
        return getTrophyName(Trophy_WYVERN, trophy_price);
        break;
      case CreatureFORKTAIL:
        return getTrophyName(Trophy_FORKTAIL, trophy_price);
        break;
      case CreatureDRACOLIZARD:
        return getTrophyName(Trophy_DRACOLIZARD, trophy_price);
        break;
    }
  }
}

function isHeartOfStoneActive(): bool {
  return theGame.GetDLCManager().IsEP1Available() && theGame.GetDLCManager().IsEP1Enabled();
}

function isBloodAndWineActive(): bool {
  return theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled();
}
