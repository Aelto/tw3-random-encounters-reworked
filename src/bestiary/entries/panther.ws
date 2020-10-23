
class RER_BestiaryPanther extends RER_BestiaryEntry {
  public function init() {
    this.type = CreaturePANTHER;
    this.menu_name = 'Panther';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\panther_black.w2ent",,,
      "dlc\bob\journal\bestiary\panther.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\panther_leopard.w2ent",,,
      "dlc\bob\journal\bestiary\panther.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\panther_mountain.w2ent",,,
      "dlc\bob\journal\bestiary\panther.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 2;

  

    this.trophy_names.PushBack('modrer_beast_trophy_low');
    this.trophy_names.PushBack('modrer_beast_trophy_medium');
    this.trophy_names.PushBack('modrer_beast_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addDislikedBiome(BiomeSwamp)
    .addDislikedBiome(BiomeWater)
    .addLikedBiome(BiomeForest);
  }
}
