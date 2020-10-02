
class RER_BestiaryHag extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureHAG;
    this.menu_name = 'Hags';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\hag_grave_lvl1.w2ent",,,
      "gameplay\journal\bestiary\gravehag.journal"
    )
  );          // grave hag 1        
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\hag_water_lvl1.w2ent",,,
      "gameplay\journal\bestiary\waterhag.journal"
    )
  );          // grey  water hag    
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\hag_water_lvl2.w2ent",,,
      "gameplay\journal\bestiary\waterhag.journal"
    )
  );          // greenish water hag

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\hag_water_mh.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh203.journal"
    )
  );

  this.template_list.difficulty_factor.minimum_count_easy = 1;
  this.template_list.difficulty_factor.maximum_count_easy = 1;
  this.template_list.difficulty_factor.minimum_count_medium = 1;
  this.template_list.difficulty_factor.maximum_count_medium = 1;
  this.template_list.difficulty_factor.minimum_count_hard = 1;
  this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_grave_hag_trophy_low');
    this.trophy_names.PushBack('modrer_grave_hag_trophy_medium');
    this.trophy_names.PushBack('modrer_grave_hag_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addOnlyBiome(BiomeSwamp)
    .addOnlyBiome(BiomeWater);
  }
}
