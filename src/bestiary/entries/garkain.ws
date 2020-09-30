
class RER_BestiaryGarkain extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureGARKAIN;
    this.menu_name = 'Garkain';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\garkain.w2ent",,,
      "dlc\bob\journal\bestiary\garkain.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\garkain_mh.w2ent",,,
      "dlc\bob\journal\bestiary\q704alphagarkain.journal"
    )
  );

  this.template_list.difficulty_factor.minimum_count_easy = 1;
  this.template_list.difficulty_factor.maximum_count_easy = 1;
  this.template_list.difficulty_factor.minimum_count_medium = 1;
  this.template_list.difficulty_factor.maximum_count_medium = 1;
  this.template_list.difficulty_factor.minimum_count_hard = 1;
  this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_garkain_trophy_low');
    this.trophy_names.PushBack('modrer_garkain_trophy_medium');
    this.trophy_names.PushBack('modrer_garkain_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences): RER_CreaturePreferences {
    return super.setCreaturePreferences(preferences);
  }
}
