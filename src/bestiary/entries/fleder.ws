
class RER_BestiaryFleder extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureFLEDER;
    this.menu_name = 'Fleder';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\fleder.w2ent", 1,,
      "dlc\bob\journal\bestiary\fleder.journal"
    )
  );this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\quests\main_quests\quest_files\q704_truth\characters\q704_protofleder.w2ent", 1,,
      "dlc\bob\journal\bestiary\protofleder.journal"
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

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}
