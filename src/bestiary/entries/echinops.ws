
class RER_BestiaryEchinops extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureECHINOPS;
    this.menu_name = 'Echinops';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\echinops_hard.w2ent", 1,,
      "dlc\bob\journal\bestiary\archespore.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\echinops_normal.w2ent",,,
      "dlc\bob\journal\bestiary\archespore.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\echinops_normal_lw.w2ent",,,
      "dlc\bob\journal\bestiary\archespore.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\echinops_turret.w2ent", 1,,
      "dlc\bob\journal\bestiary\archespore.journal"
    )
  );

  this.template_list.difficulty_factor.minimum_count_easy = 2;
  this.template_list.difficulty_factor.maximum_count_easy = 2;
  this.template_list.difficulty_factor.minimum_count_medium = 2;
  this.template_list.difficulty_factor.maximum_count_medium = 3;
  this.template_list.difficulty_factor.minimum_count_hard = 3;
  this.template_list.difficulty_factor.maximum_count_hard = 4;

  

    this.trophy_names.PushBack('modrer_insectoid_trophy_low');
    this.trophy_names.PushBack('modrer_insectoid_trophy_medium');
    this.trophy_names.PushBack('modrer_insectoid_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences): RER_CreaturePreferences {
    return super.setCreaturePreferences(preferences)
    .addLikedBiome(BiomeWater)
    .addLikedBiome(BiomeForest);
  }
}
