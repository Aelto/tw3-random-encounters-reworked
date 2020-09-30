
class RER_BestiarySpider extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureSPIDER;
    this.menu_name = 'Spiders';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\ep1\data\characters\npc_entities\monsters\black_spider.w2ent",,,
      "gameplay\journal\bestiary\bestiarycrabspider.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\ep1\data\characters\npc_entities\monsters\black_spider_large.w2ent",2,,
      "gameplay\journal\bestiary\bestiarycrabspider.journal"
    )
  );

  this.template_list.difficulty_factor.minimum_count_easy = 2;
  this.template_list.difficulty_factor.maximum_count_easy = 3;
  this.template_list.difficulty_factor.minimum_count_medium = 2;
  this.template_list.difficulty_factor.maximum_count_medium = 3;
  this.template_list.difficulty_factor.minimum_count_hard = 3;
  this.template_list.difficulty_factor.maximum_count_hard = 4;

  

    this.trophy_names.PushBack('modrer_insectoid_trophy_low');
    this.trophy_names.PushBack('modrer_insectoid_trophy_medium');
    this.trophy_names.PushBack('modrer_insectoid_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences): RER_CreaturePreferences {
    return super.setCreaturePreferences(preferences)
    .addDislikedBiome(BiomeSwamp)
    .addDislikedBiome(BiomeWater)
    .addLikedBiome(BiomeForest);
  }
}
