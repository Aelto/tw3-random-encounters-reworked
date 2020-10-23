
class RER_BestiaryArachas extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureARACHAS;
    this.menu_name = 'Arachas';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\arachas_lvl1.w2ent",,,
        "gameplay\journal\bestiary\bestiarycrabspider.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\arachas_lvl2__armored.w2ent", 2,,
        "gameplay\journal\bestiary\armoredarachas.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\arachas_lvl3__poison.w2ent", 2,,
        "gameplay\journal\bestiary\poisonousarachas.journal"
      )
    );

      this.template_list.difficulty_factor.minimum_count_easy = 1;
      this.template_list.difficulty_factor.maximum_count_easy = 2;
      this.template_list.difficulty_factor.minimum_count_medium = 2;
      this.template_list.difficulty_factor.maximum_count_medium = 3;
      this.template_list.difficulty_factor.minimum_count_hard = 3;
      this.template_list.difficulty_factor.maximum_count_hard = 4;

    this.trophy_names.PushBack('modrer_insectoid_trophy_low');
    this.trophy_names.PushBack('modrer_insectoid_trophy_medium');
    this.trophy_names.PushBack('modrer_insectoid_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addDislikedBiome(BiomeSwamp)
    .addDislikedBiome(BiomeWater)
    .addLikedBiome(BiomeForest);
  }
}
