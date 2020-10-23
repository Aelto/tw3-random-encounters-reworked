
class RER_BestiaryBoar extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureBOAR;
    this.menu_name = 'Boars';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\ep1\data\characters\npc_entities\monsters\wild_boar_ep1.w2ent",,,
      "dlc\bob\journal\bestiary\ep2boar.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 2;

  

    this.trophy_names.PushBack('modrer_beast_trophy_low');
    this.trophy_names.PushBack('modrer_beast_trophy_medium');
    this.trophy_names.PushBack('modrer_beast_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeForest);
  }
}
