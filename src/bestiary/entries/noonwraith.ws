
class RER_BestiaryNoonwraith extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureNOONWRAITH;
    this.menu_name = 'NoonWraiths';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\noonwraith_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarynoonwright.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\noonwraith_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiarynoonwright.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\noonwraith_lvl3.w2ent",,,
      "gameplay\journal\bestiary\bestiarynoonwright.journal"
    )
  );       
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\_quest__noonwright_pesta.w2ent",,,
      "gameplay\journal\bestiary\bestiarynoonwright.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_noonwraith_trophy_low');
    this.trophy_names.PushBack('modrer_noonwraith_trophy_medium');
    this.trophy_names.PushBack('modrer_noonwraith_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}
