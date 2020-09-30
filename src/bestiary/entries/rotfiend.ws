
class RER_BestiaryRotfiend extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureROTFIEND;
    this.menu_name = 'Rotfiends';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\rotfiend_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarygreaterrotfiend.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\rotfiend_lvl2.w2ent", 1,,
      "gameplay\journal\bestiary\bestiarygreaterrotfiend.journal"
    )
  );

  this.template_list.difficulty_factor.minimum_count_easy = 1;
  this.template_list.difficulty_factor.maximum_count_easy = 3;
  this.template_list.difficulty_factor.minimum_count_medium = 2;
  this.template_list.difficulty_factor.maximum_count_medium = 4;
  this.template_list.difficulty_factor.minimum_count_hard = 3;
  this.template_list.difficulty_factor.maximum_count_hard = 6;

  

    this.trophy_names.PushBack('modrer_necrophage_trophy_low');
    this.trophy_names.PushBack('modrer_necrophage_trophy_medium');
    this.trophy_names.PushBack('modrer_necrophage_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences): RER_CreaturePreferences {
    return super.setCreaturePreferences(preferences)
    .addLikedBiome(BiomeSwamp)
    .addLikedBiome(BiomeWater);
  }
}
