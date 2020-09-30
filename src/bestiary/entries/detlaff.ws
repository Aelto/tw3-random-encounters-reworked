
class RER_BestiaryDetlaff extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureDETLAFF;
    this.menu_name = 'HigherVamp';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\dettlaff_vampire.w2ent", 1,,
      "dlc\bob\journal\bestiary\dettlaffmonster.journal"
    )
  );

  this.template_list.difficulty_factor.minimum_count_easy = 1;
  this.template_list.difficulty_factor.maximum_count_easy = 1;
  this.template_list.difficulty_factor.minimum_count_medium = 1;
  this.template_list.difficulty_factor.maximum_count_medium = 1;
  this.template_list.difficulty_factor.minimum_count_hard = 1;
  this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_vampire_trophy_low');
    this.trophy_names.PushBack('modrer_vampire_trophy_medium');
    this.trophy_names.PushBack('modrer_vampire_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences): RER_CreaturePreferences {
    return super.setCreaturePreferences(preferences)
    .addDislikedBiome(BiomeSwamp)
    .addDislikedBiome(BiomeWater)
    .addDislikedBiome(BiomeForest);
  }
}
