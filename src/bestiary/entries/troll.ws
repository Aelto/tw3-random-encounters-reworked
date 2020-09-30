
class RER_BestiaryTroll extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureTROLL;
    this.menu_name = 'Troll';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\troll_cave_lvl1.w2ent",,,
      "gameplay\journal\bestiary\trollcave.journal"
    )
  );    // grey

  this.template_list.difficulty_factor.minimum_count_easy = 1;
  this.template_list.difficulty_factor.maximum_count_easy = 1;
  this.template_list.difficulty_factor.minimum_count_medium = 1;
  this.template_list.difficulty_factor.maximum_count_medium = 1;
  this.template_list.difficulty_factor.minimum_count_hard = 1;
  this.template_list.difficulty_factor.maximum_count_hard = 3;

  

    this.trophy_names.PushBack('modrer_troll_trophy_low');
    this.trophy_names.PushBack('modrer_troll_trophy_medium');
    this.trophy_names.PushBack('modrer_troll_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences): RER_CreaturePreferences {
    return super.setCreaturePreferences(preferences);
  }
}
