
class RER_BestiaryCentipede extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureCENTIPEDE;
    this.menu_name = 'Centipede';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\scolopendromorph.w2ent",,,
      "dlc\bob\journal\bestiary\scolopedromorph.journal"
    )
  ); //worm
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\mq7023_albino_centipede.w2ent",,,
      "dlc\bob\journal\bestiary\scolopedromorph.journal"
    )
  );

  this.template_list.difficulty_factor.minimum_count_easy = 1;
  this.template_list.difficulty_factor.maximum_count_easy = 1;
  this.template_list.difficulty_factor.minimum_count_medium = 1;
  this.template_list.difficulty_factor.maximum_count_medium = 2;
  this.template_list.difficulty_factor.minimum_count_hard = 2;
  this.template_list.difficulty_factor.maximum_count_hard = 3;

  

    this.trophy_names.PushBack('modrer_insectoid_trophy_low');
    this.trophy_names.PushBack('modrer_insectoid_trophy_medium');
    this.trophy_names.PushBack('modrer_insectoid_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addDislikedBiome(BiomeWater)
    .addLikedBiome(BiomeForest);
  }
}
