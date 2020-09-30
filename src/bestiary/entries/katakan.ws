
class RER_BestiaryKatakan extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureKATAKAN;
    this.menu_name = 'Katakan';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\vampire_katakan_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarykatakan.journal"
    )
  );  // cool blinky vampire     
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\vampire_katakan_lvl3.w2ent",,,
      "gameplay\journal\bestiary\bestiarykatakan.journal"
    )
  );  // cool blinky vamp
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\vampire_katakan_mh.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh304.journal"
    )
  );

  this.template_list.difficulty_factor.minimum_count_easy = 1;
  this.template_list.difficulty_factor.maximum_count_easy = 1;
  this.template_list.difficulty_factor.minimum_count_medium = 1;
  this.template_list.difficulty_factor.maximum_count_medium = 1;
  this.template_list.difficulty_factor.minimum_count_hard = 1;
  this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_katakan_trophy_low');
    this.trophy_names.PushBack('modrer_katakan_trophy_medium');
    this.trophy_names.PushBack('modrer_katakan_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences): RER_CreaturePreferences {
    return super.setCreaturePreferences(preferences);
  }
}
