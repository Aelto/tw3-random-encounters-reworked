
class RER_BestiaryDrowner extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureDROWNER;
    this.menu_name = 'Drowners';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\drowner_lvl1.w2ent",,,
      "gameplay\journal\bestiary\drowner.journal"
    )
  );        // drowner
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\drowner_lvl2.w2ent",,,
      "gameplay\journal\bestiary\drowner.journal"
    )
  );        // drowner
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\drowner_lvl3.w2ent",,,
      "gameplay\journal\bestiary\drowner.journal"
    )
  );        // pink drowner
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\drowner_lvl4__dead.w2ent", 2,,
      "gameplay\journal\bestiary\drowner.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 2;
    this.template_list.difficulty_factor.maximum_count_easy = 3;
    this.template_list.difficulty_factor.minimum_count_medium = 3;
    this.template_list.difficulty_factor.maximum_count_medium = 4;
    this.template_list.difficulty_factor.minimum_count_hard = 4;
    this.template_list.difficulty_factor.maximum_count_hard = 5;

  

    this.trophy_names.PushBack('modrer_necrophage_trophy_low');
    this.trophy_names.PushBack('modrer_necrophage_trophy_medium');
    this.trophy_names.PushBack('modrer_necrophage_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addOnlyBiome(BiomeSwamp)
    .addOnlyBiome(BiomeWater);
  }
}
