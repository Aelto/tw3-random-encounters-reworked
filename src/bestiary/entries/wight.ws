
class RER_BestiaryWight extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureWIGHT;
    this.menu_name = 'Wight';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\spooncollector.w2ent",1,,
      "dlc\bob\journal\bestiary\wicht.journal"
    )
  );  // spoon
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\wicht.w2ent",2,,
      "dlc\bob\journal\bestiary\wicht.journal"
    )
  );     // wight

  this.template_list.difficulty_factor.minimum_count_easy = 1;
  this.template_list.difficulty_factor.maximum_count_easy = 1;
  this.template_list.difficulty_factor.minimum_count_medium = 1;
  this.template_list.difficulty_factor.maximum_count_medium = 1;
  this.template_list.difficulty_factor.minimum_count_hard = 1;
  this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_wight_trophy_low');
    this.trophy_names.PushBack('modrer_wight_trophy_medium');
    this.trophy_names.PushBack('modrer_wight_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeSwamp)
    .addLikedBiome(BiomeWater)
    .addDislikedBiome(BiomeForest);
  }
}
