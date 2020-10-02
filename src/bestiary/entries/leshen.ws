
class RER_BestiaryLeshen extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureLESHEN;
    this.menu_name = 'Leshens';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\lessog_lvl1.w2ent",,,
        "gameplay\journal\bestiary\leshy.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\lessog_lvl2__ancient.w2ent",,,
        "gameplay\journal\bestiary\sq204ancientleszen.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\lessog_mh.w2ent",,,
        "gameplay\journal\bestiary\bestiarymonsterhuntmh302.journal"
      )
    );
    
    if(theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled()){
      this.template_list.templates.PushBack(
        makeEnemyTemplate(
          "dlc\bob\data\characters\npc_entities\monsters\spriggan.w2ent",,,
          "dlc\bob\journal\bestiary\mq7002spriggan.journal"
        )
      );
    }

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_leshen_trophy_low');
    this.trophy_names.PushBack('modrer_leshen_trophy_medium');
    this.trophy_names.PushBack('modrer_leshen_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addOnlyBiome(BiomeForest);
  }
}
