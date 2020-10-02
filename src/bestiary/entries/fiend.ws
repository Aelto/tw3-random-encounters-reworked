
class RER_BestiaryFiend extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureFIEND;
    this.menu_name = 'Fiends';

    this.template_list.templates.PushBack(makeEnemyTemplate(
      "characters\npc_entities\monsters\bies_lvl1.w2ent",,,
      "gameplay\journal\bestiary\fiends.journal" // TODO: confirm journal
      )
    );  // fiends        
    this.template_list.templates.PushBack(makeEnemyTemplate(
      "characters\npc_entities\monsters\bies_lvl2.w2ent",,,
      "gameplay\journal\bestiary\fiends.journal" // TODO: confirm journal
      )
    );  // red fiend

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_fiend_trophy_low');
    this.trophy_names.PushBack('modrer_fiend_trophy_medium');
    this.trophy_names.PushBack('modrer_fiend_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeSwamp);
  }
}
