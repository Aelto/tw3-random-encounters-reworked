
class RER_BestiaryNekker extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureNEKKER;
    this.menu_name = 'Nekkers';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_lvl1.w2ent",,,
      "gameplay\journal\bestiary\nekker.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_lvl2.w2ent",,,
      "gameplay\journal\bestiary\nekker.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_lvl2_customize.w2ent",,,
      "gameplay\journal\bestiary\nekker.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_lvl3_customize.w2ent",,,
      "gameplay\journal\bestiary\nekker.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_lvl3__warrior.w2ent", 2,,
      "gameplay\journal\bestiary\nekker.journal"
    )
  );

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_mh__warrior.w2ent", 1,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh202.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 4;
    this.template_list.difficulty_factor.maximum_count_easy = 5;
    this.template_list.difficulty_factor.minimum_count_medium = 4;
    this.template_list.difficulty_factor.maximum_count_medium = 6;
    this.template_list.difficulty_factor.minimum_count_hard = 5;
    this.template_list.difficulty_factor.maximum_count_hard = 7;

  

    this.trophy_names.PushBack('modrer_nekker_trophy_low');
    this.trophy_names.PushBack('modrer_nekker_trophy_medium');
    this.trophy_names.PushBack('modrer_nekker_trophy_high');

    this.ecosystem_impact = (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build();
  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeForest);
  }
}
