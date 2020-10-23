
class RER_BestiaryGiant extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureGIANT;
    this.menu_name = 'Giant';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\q701_dagonet_giant.w2ent",,,
      "dlc\bob\journal\bestiary\dagonet.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\q704_cloud_giant.w2ent",,,
      "dlc\bob\journal\bestiary\q704cloudgiant.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_giant_trophy_low');
    this.trophy_names.PushBack('modrer_giant_trophy_medium');
    this.trophy_names.PushBack('modrer_giant_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeForest);
  }
}
