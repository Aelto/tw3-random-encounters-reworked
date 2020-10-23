
class RER_BestiaryDracolizard extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureDRACOLIZARD;
    this.menu_name = 'Dracolizards';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "dlc\bob\data\characters\npc_entities\monsters\oszluzg_young.w2ent",,,
        "dlc\bob\journal\bestiary\dracolizard.journal"
      )
    );

      this.template_list.difficulty_factor.minimum_count_easy = 1;
      this.template_list.difficulty_factor.maximum_count_easy = 1;
      this.template_list.difficulty_factor.minimum_count_medium = 1;
      this.template_list.difficulty_factor.maximum_count_medium = 1;
      this.template_list.difficulty_factor.minimum_count_hard = 1;
      this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_dracolizard_trophy_low');
    this.trophy_names.PushBack('modrer_dracolizard_trophy_medium');
    this.trophy_names.PushBack('modrer_dracolizard_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}
