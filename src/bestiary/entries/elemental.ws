
class RER_BestiaryElemental extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureELEMENTAL;
    this.menu_name = 'Elementals';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\elemental_dao_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiaryelemental.journal"
    )
  );      // earth elemental        
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\elemental_dao_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiaryelemental.journal"
    )
  );      // stronger and cliffier elemental
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\elemental_dao_lvl3__ice.w2ent",,,
      "gameplay\journal\bestiary\bestiaryelemental.journal"
    )
  );

  if(theGame.GetDLCManager().IsEP2Available()  &&   theGame.GetDLCManager().IsEP2Enabled()){
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "dlc\bob\data\characters\npc_entities\monsters\mq7007_item__golem_grafitti.w2ent",,,
        "gameplay\journal\bestiary\bestiaryelemental.journal"
      )
    );
  }

  this.template_list.difficulty_factor.minimum_count_easy = 1;
  this.template_list.difficulty_factor.maximum_count_easy = 1;
  this.template_list.difficulty_factor.minimum_count_medium = 1;
  this.template_list.difficulty_factor.maximum_count_medium = 1;
  this.template_list.difficulty_factor.minimum_count_hard = 1;
  this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_elemental_trophy_low');
    this.trophy_names.PushBack('modrer_elemental_trophy_medium');
    this.trophy_names.PushBack('modrer_elemental_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}
