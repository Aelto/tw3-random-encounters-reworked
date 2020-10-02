
class RER_BestiaryWraith extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureWRAITH;
    this.menu_name = 'Wraiths';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wraith_lvl1.w2ent",,,
      "gameplay\journal\bestiary\wraith.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wraith_lvl2.w2ent",,,
      "gameplay\journal\bestiary\wraith.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wraith_lvl2_customize.w2ent",,,
      "gameplay\journal\bestiary\wraith.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wraith_lvl3.w2ent",,,
      "gameplay\journal\bestiary\wraith.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wraith_lvl4.w2ent", 2,,
      "gameplay\journal\bestiary\wraith.journal"
    )
  );

  this.template_list.difficulty_factor.minimum_count_easy = 1;
  this.template_list.difficulty_factor.maximum_count_easy = 2;
  this.template_list.difficulty_factor.minimum_count_medium = 2;
  this.template_list.difficulty_factor.maximum_count_medium = 3;
  this.template_list.difficulty_factor.minimum_count_hard = 3;
  this.template_list.difficulty_factor.maximum_count_hard = 4;

  

    this.trophy_names.PushBack('modrer_wraith_trophy_low');
    this.trophy_names.PushBack('modrer_wraith_trophy_medium');
    this.trophy_names.PushBack('modrer_wraith_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}
