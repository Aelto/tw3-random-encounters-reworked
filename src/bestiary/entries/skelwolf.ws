
class RER_BestiarySkelwolf extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureSKELWOLF;
    this.menu_name = 'wolves';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wolf_white_lvl2.w2ent",,,
      "gameplay\journal\bestiary\wolf.journal"
    )
  );    // lvl 51 white wolf    STEEL     
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wolf_white_lvl3__alpha.w2ent", 1,,
      "gameplay\journal\bestiary\wolf.journal"
    )
  );  // lvl 51 white wolf     STEEL  37

  this.template_list.difficulty_factor.minimum_count_easy = 2;
  this.template_list.difficulty_factor.maximum_count_easy = 3;
  this.template_list.difficulty_factor.minimum_count_medium = 2;
  this.template_list.difficulty_factor.maximum_count_medium = 4;
  this.template_list.difficulty_factor.minimum_count_hard = 3;
  this.template_list.difficulty_factor.maximum_count_hard = 6;

  

    this.trophy_names.PushBack('modrer_beast_trophy_low');
    this.trophy_names.PushBack('modrer_beast_trophy_medium');
    this.trophy_names.PushBack('modrer_beast_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences): RER_CreaturePreferences {
    return super.setCreaturePreferences(preferences)
    .addLikedBiome(BiomeForest);
  }
}
