
class RER_BestiaryGolem extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureGOLEM;
    this.menu_name = 'Golems';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\golem_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarygolem.journal"
    )
  );          // normal greenish golem        
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\golem_lvl2__ifryt.w2ent",,,
      "gameplay\journal\bestiary\bestiarygolem.journal"
    )
  );      // fire golem  
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\golem_lvl3.w2ent",,,
      "gameplay\journal\bestiary\bestiarygolem.journal"
    )
  );          // weird yellowish golem

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
