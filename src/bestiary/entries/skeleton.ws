
class RER_BestiarySkeleton extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureSKELETON;
    this.menu_name = 'Skeleton';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\nightwraith_banshee_summon.w2ent",,,
      "dlc\bob\journal\bestiary\beanshie.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\nightwraith_banshee_summon_skeleton.w2ent",,,
      "dlc\bob\journal\bestiary\beanshie.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 2;
    this.template_list.difficulty_factor.maximum_count_easy = 3;
    this.template_list.difficulty_factor.minimum_count_medium = 3;
    this.template_list.difficulty_factor.maximum_count_medium = 4;
    this.template_list.difficulty_factor.minimum_count_hard = 4;
    this.template_list.difficulty_factor.maximum_count_hard = 6;

  

    this.trophy_names.PushBack('modrer_spirit_trophy_low');
    this.trophy_names.PushBack('modrer_spirit_trophy_medium');
    this.trophy_names.PushBack('modrer_spirit_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}
