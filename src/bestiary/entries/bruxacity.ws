
class RER_BestiaryBruxacity extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureBRUXA;
    this.menu_name = 'Bruxacity';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\bruxa_alp_cloak_always_spawn.w2ent",,,
      "dlc\bob\journal\bestiary\alp.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\bruxa_cloak_always_spawn.w2ent",,,
      "dlc\bob\journal\bestiary\bruxa.journal"
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
    return super.setCreaturePreferences(preferences);
  }
}
