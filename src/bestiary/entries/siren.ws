
class RER_BestiarySiren extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureSIREN;
    this.menu_name = 'Sirens';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\siren_lvl1.w2ent", 1,,
      "gameplay\journal\bestiary\siren.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\siren_lvl2__lamia.w2ent", 1,,
      "gameplay\journal\bestiary\siren.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\siren_lvl3.w2ent", 1,,
      "gameplay\journal\bestiary\siren.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 3;
    this.template_list.difficulty_factor.maximum_count_easy = 4;
    this.template_list.difficulty_factor.minimum_count_medium = 4;
    this.template_list.difficulty_factor.maximum_count_medium = 5;
    this.template_list.difficulty_factor.minimum_count_hard = 5;
    this.template_list.difficulty_factor.maximum_count_hard = 7;
  
  

    this.trophy_names.PushBack('modrer_harpy_trophy_low');
    this.trophy_names.PushBack('modrer_harpy_trophy_medium');
    this.trophy_names.PushBack('modrer_harpy_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addOnlyBiome(BiomeSwamp)
    .addOnlyBiome(BiomeWater);
  }
}
