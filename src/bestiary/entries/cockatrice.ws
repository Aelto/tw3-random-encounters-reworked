
class RER_BestiaryCockatrice extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureCOCKATRICE;
    this.menu_name = 'Cockatrice';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\cockatrice_lvl1.w2ent",,,
        "gameplay\journal\bestiary\bestiarycockatrice.journal"
      )
    );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_cockatrice_trophy_low');
    this.trophy_names.PushBack('modrer_cockatrice_trophy_medium');
    this.trophy_names.PushBack('modrer_cockatrice_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}
