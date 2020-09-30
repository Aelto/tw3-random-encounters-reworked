
class RER_BestiaryHarpy extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureHARPY;
    this.menu_name = 'Harpies';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\harpy_lvl1.w2ent",,,
      "gameplay\journal\bestiary\harpy.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\harpy_lvl2.w2ent",,,
      "gameplay\journal\bestiary\harpy.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\harpy_lvl2_customize.w2ent",,,
      "gameplay\journal\bestiary\harpy.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\harpy_lvl3__erynia.w2ent", 1,,
      "gameplay\journal\bestiary\erynia.journal"
    )
  );

  this.template_list.difficulty_factor.minimum_count_easy = 3;
  this.template_list.difficulty_factor.maximum_count_easy = 4;
  this.template_list.difficulty_factor.minimum_count_medium = 4;
  this.template_list.difficulty_factor.maximum_count_medium = 5;
  this.template_list.difficulty_factor.minimum_count_hard = 5;
  this.template_list.difficulty_factor.maximum_count_hard = 7;
  
  

    this.trophy_names.PushBack('modrer_harpy_trophy_low');
    this.trophy_names.PushBack('modrer_harpy_trophy_medium');
    this.trophy_names.PushBack('modrer_harpy_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences): RER_CreaturePreferences {
    return super.setCreaturePreferences(preferences)
    .addDislikedBiome(BiomeSwamp)
    .addDislikedBiome(BiomeWater)
    .addLikedBiome(BiomeForest);
  }
}
