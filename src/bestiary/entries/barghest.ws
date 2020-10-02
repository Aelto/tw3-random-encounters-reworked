
class RER_BestiaryBarghest extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureBARGHEST;
    this.menu_name = 'Barghest';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\barghest.w2ent",,,
      "dlc\bob\journal\bestiary\barghests.journal"
    )
  );

  this.template_list.difficulty_factor.minimum_count_easy = 1;
  this.template_list.difficulty_factor.maximum_count_easy = 1;
  this.template_list.difficulty_factor.minimum_count_medium = 1;
  this.template_list.difficulty_factor.maximum_count_medium = 2;
  this.template_list.difficulty_factor.minimum_count_hard = 2;
  this.template_list.difficulty_factor.maximum_count_hard = 2;

  

    this.trophy_names.PushBack('modrer_spirit_trophy_low');
    this.trophy_names.PushBack('modrer_spirit_trophy_medium');
    this.trophy_names.PushBack('modrer_spirit_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeSwamp);
  }
}
