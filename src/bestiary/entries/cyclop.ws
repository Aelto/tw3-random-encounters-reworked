
class RER_BestiaryCyclop extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureCYCLOP;
    this.menu_name = 'Cyclops';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\cyclop_lvl1.w2ent",,,
        "gameplay\journal\bestiary\cyclops.journal"
      )
    );

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\ice_giant.w2ent",,,
        "gameplay\journal\bestiary\icegiant.journal"
      )
    );

      this.template_list.difficulty_factor.minimum_count_easy = 1;
      this.template_list.difficulty_factor.maximum_count_easy = 1;
      this.template_list.difficulty_factor.minimum_count_medium = 1;
      this.template_list.difficulty_factor.maximum_count_medium = 1;
      this.template_list.difficulty_factor.minimum_count_hard = 1;
      this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_cyclop_trophy_low');
    this.trophy_names.PushBack('modrer_cyclop_trophy_medium');
    this.trophy_names.PushBack('modrer_cyclop_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}
