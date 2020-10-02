
class RER_BestiaryWolf extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureWOLF;
    this.menu_name = 'Wolves';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wolf_lvl1.w2ent",,,
      "gameplay\journal\bestiary\wolf.journal"
    )
  );        // +4 lvls  grey/black wolf STEEL
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wolf_lvl1__alpha.w2ent", 1,,
      "gameplay\journal\bestiary\wolf.journal"
    )
  );    // +4 lvls brown warg      STEEL

  this.template_list.difficulty_factor.minimum_count_easy = 2;
  this.template_list.difficulty_factor.maximum_count_easy = 3;
  this.template_list.difficulty_factor.minimum_count_medium = 2;
  this.template_list.difficulty_factor.maximum_count_medium = 4;
  this.template_list.difficulty_factor.minimum_count_hard = 3;
  this.template_list.difficulty_factor.maximum_count_hard = 6;

  

    this.trophy_names.PushBack('modrer_beast_trophy_low');
    this.trophy_names.PushBack('modrer_beast_trophy_medium');
    this.trophy_names.PushBack('modrer_beast_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeForest);
  }
}
