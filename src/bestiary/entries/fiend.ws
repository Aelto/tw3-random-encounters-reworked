
class RER_BestiaryFiend extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureFIEND;
    this.menu_name = 'Fiends';

    this.template_list.templates.PushBack(makeEnemyTemplate(
      "characters\npc_entities\monsters\bies_lvl1.w2ent",,,
      "gameplay\journal\bestiary\fiend2.journal" // TODO: confirm journal
      )
    );     
    this.template_list.templates.PushBack(makeEnemyTemplate(
      "characters\npc_entities\monsters\bies_lvl2.w2ent",,,
      "gameplay\journal\bestiary\fiend2.journal" // TODO: confirm journal
      )
    );

      this.template_list.difficulty_factor.minimum_count_easy = 1;
      this.template_list.difficulty_factor.maximum_count_easy = 1;
      this.template_list.difficulty_factor.minimum_count_medium = 1;
      this.template_list.difficulty_factor.maximum_count_medium = 1;
      this.template_list.difficulty_factor.minimum_count_hard = 1;
      this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_fiend_trophy_low');
    this.trophy_names.PushBack('modrer_fiend_trophy_medium');
    this.trophy_names.PushBack('modrer_fiend_trophy_high');

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
    .addLikedBiome(BiomeSwamp);
  }
}
