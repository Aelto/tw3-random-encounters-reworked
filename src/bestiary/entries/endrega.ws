
class RER_BestiaryEndrega extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureENDREGA;
    this.menu_name = 'Endrega';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\endriaga_lvl1__worker.w2ent",,,
      "gameplay\journal\bestiary\bestiaryendriag.journal"
    )
  );      // small endrega
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\endriaga_lvl2__tailed.w2ent", 2,,
      "gameplay\journal\bestiary\endriagatruten.journal"
    )
  );      // bigger tailed endrega
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\endriaga_lvl3__spikey.w2ent", 1,,
      "gameplay\journal\bestiary\endriagaworker.journal"
    ),
  );      // big tailless endrega

  this.template_list.difficulty_factor.minimum_count_easy = 2;
  this.template_list.difficulty_factor.maximum_count_easy = 3;
  this.template_list.difficulty_factor.minimum_count_medium = 2;
  this.template_list.difficulty_factor.maximum_count_medium = 4;
  this.template_list.difficulty_factor.minimum_count_hard = 3;
  this.template_list.difficulty_factor.maximum_count_hard = 5;

  

    this.trophy_names.PushBack('modrer_endrega_trophy_low');
    this.trophy_names.PushBack('modrer_endrega_trophy_medium');
    this.trophy_names.PushBack('modrer_endrega_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences): RER_CreaturePreferences {
    return super.setCreaturePreferences(preferences)
    .addLikedBiome(BiomeForest);
  }
}
