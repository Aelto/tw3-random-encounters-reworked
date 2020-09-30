
class RER_BestiaryAlghoul extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureALGHOUL;
    this.menu_name = 'Alghouls';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\alghoul_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiaryalghoul.journal"
    )
  );        // dark
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\alghoul_lvl2.w2ent", 3,,
      "gameplay\journal\bestiary\bestiaryalghoul.journal"
    )
  );        // dark reddish
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\alghoul_lvl3.w2ent", 2,,
      "gameplay\journal\bestiary\bestiaryalghoul.journal"
    )
  );        // greyish
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\alghoul_lvl4.w2ent", 1,,
      "gameplay\journal\bestiary\bestiaryalghoul.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\_quest__miscreant_greater.w2ent",,,
      "gameplay\journal\bestiary\bestiarymiscreant.journal"
    )
  );

  this.template_list.difficulty_factor.minimum_count_easy = 2;
  this.template_list.difficulty_factor.maximum_count_easy = 2;
  this.template_list.difficulty_factor.minimum_count_medium = 2;
  this.template_list.difficulty_factor.maximum_count_medium = 3;
  this.template_list.difficulty_factor.minimum_count_hard = 3;
  this.template_list.difficulty_factor.maximum_count_hard = 4;

  

    this.trophy_names.PushBack('modrer_necrophage_trophy_low');
    this.trophy_names.PushBack('modrer_necrophage_trophy_medium');
    this.trophy_names.PushBack('modrer_necrophage_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences): RER_CreaturePreferences {
    return super.setCreaturePreferences(preferences);
  }
}
