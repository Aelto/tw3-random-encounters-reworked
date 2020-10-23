
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

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeForest);
  }
}
