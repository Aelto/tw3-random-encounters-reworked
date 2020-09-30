
class RER_BestiaryBasilisk extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureBASILISK;
    this.menu_name = 'Basilisk';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\basilisk_lvl1.w2ent",,,
        "gameplay\journal\bestiary\bestiarybasilisk.journal"
        )
      );
    
    if(theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled()){
      this.template_list.templates.PushBack(
        makeEnemyTemplate(
          "dlc\bob\data\characters\npc_entities\monsters\basilisk_white.w2ent",,,
          "dlc\bob\journal\bestiary\mq7018basilisk.journal"
        )
      );
    }

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_basilisk_trophy_low');
    this.trophy_names.PushBack('modrer_basilisk_trophy_medium');
    this.trophy_names.PushBack('modrer_basilisk_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences): RER_CreaturePreferences {
    return super.setCreaturePreferences(preferences)
    .addLikedBiome(BiomeForest);
  }
}
