
class RER_BestiaryGryphon extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureGRYPHON;
    this.menu_name = 'Gryphons';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\gryphon_lvl1.w2ent",,,
        "gameplay\journal\bestiary\griffin.journal"
      )
    );

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\gryphon_lvl3__volcanic.w2ent",,,
        "gameplay\journal\bestiary\bestiarymonsterhuntmh301.journal"
      )
    );

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\gryphon_mh__volcanic.w2ent",,,
        "gameplay\journal\bestiary\bestiarymonsterhuntmh301.journal"
      )
    );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;

    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;

    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_griffin_trophy_low');
    this.trophy_names.PushBack('modrer_griffin_trophy_medium');
    this.trophy_names.PushBack('modrer_griffin_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeForest);
  }
}
