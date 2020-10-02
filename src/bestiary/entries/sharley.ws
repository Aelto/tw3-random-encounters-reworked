
class RER_BestiarySharley extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureSHARLEY;
    this.menu_name = 'Sharley';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\sharley.w2ent",,,
      "dlc\bob\journal\bestiary\ep2sharley.journal"
    )
  );  // rock boss things
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\sharley_mh.w2ent",,,
      "dlc\bob\journal\bestiary\ep2sharley.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\sharley_q701.w2ent",,,
      "dlc\bob\journal\bestiary\ep2sharley.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\sharley_q701_normal_scale.w2ent",,,
      "dlc\bob\journal\bestiary\ep2sharley.journal"
    )
  );

  this.template_list.difficulty_factor.minimum_count_easy = 1;
  this.template_list.difficulty_factor.maximum_count_easy = 1;
  this.template_list.difficulty_factor.minimum_count_medium = 1;
  this.template_list.difficulty_factor.maximum_count_medium = 1;
  this.template_list.difficulty_factor.minimum_count_hard = 1;
  this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_sharley_trophy_low');
    this.trophy_names.PushBack('modrer_sharley_trophy_medium');
    this.trophy_names.PushBack('modrer_sharley_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addDislikedBiome(BiomeSwamp)
    .addDislikedBiome(BiomeWater);
  }
}
