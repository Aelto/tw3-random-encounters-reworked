
class RER_BestiaryFogling extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureFOGLET;
    this.menu_name = 'Fogling';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\fogling_lvl1.w2ent",,,
      "gameplay\journal\bestiary\fogling.journal"
    )
  );          // normal fogling
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\fogling_lvl2.w2ent",,,
      "gameplay\journal\bestiary\fogling.journal"
    )
  );        // normal fogling
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\fogling_lvl3__willowisp.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh108.journal"
    )
  );  // green fogling

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\fogling_mh.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh108.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_fogling_trophy_low');
    this.trophy_names.PushBack('modrer_fogling_trophy_medium');
    this.trophy_names.PushBack('modrer_fogling_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeSwamp)
    .addLikedBiome(BiomeWater);
  }
}
