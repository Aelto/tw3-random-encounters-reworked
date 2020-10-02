
class RER_BestiaryGargoyle extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureGARGOYLE;
    this.menu_name = 'Gargoyles';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "gameplay\templates\monsters\gargoyle_lvl1_lvl25.w2ent",,,
      "gameplay\journal\bestiary\gargoyle.journal"
    )
  );

  this.template_list.difficulty_factor.minimum_count_easy = 1;
  this.template_list.difficulty_factor.maximum_count_easy = 1;
  this.template_list.difficulty_factor.minimum_count_medium = 1;
  this.template_list.difficulty_factor.maximum_count_medium = 1;
  this.template_list.difficulty_factor.minimum_count_hard = 1;
  this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_elemental_trophy_low');
    this.trophy_names.PushBack('modrer_elemental_trophy_medium');
    this.trophy_names.PushBack('modrer_elemental_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}
