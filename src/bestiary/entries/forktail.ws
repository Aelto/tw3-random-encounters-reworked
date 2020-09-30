
class RER_BestiaryForktail extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureFORKTAIL;
    this.menu_name = 'Forktails';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\forktail_lvl1.w2ent",,,
        "gameplay\journal\bestiary\bestiaryforktail.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\forktail_lvl2.w2ent",,,
        "gameplay\journal\bestiary\bestiaryforktail.journal"
      )
    );

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\forktail_mh.w2ent",,,
        "gameplay\journal\bestiary\bestiarymonsterhuntmh208.journal"
      )
    );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_forktail_trophy_low');
    this.trophy_names.PushBack('modrer_forktail_trophy_medium');
    this.trophy_names.PushBack('modrer_forktail_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences): RER_CreaturePreferences {
    return super.setCreaturePreferences(preferences);
  }
}
