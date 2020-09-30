
class RER_BestiaryGhoul extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureGHOUL;
    this.menu_name = 'Ghouls';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\ghoul_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiaryghoul.journal"
    )
  );          // normal ghoul   spawns from the ground
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\ghoul_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiaryghoul.journal"
    )
  );          // red ghoul   spawns from the ground
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\ghoul_lvl3.w2ent",,,
      "gameplay\journal\bestiary\bestiaryghoul.journal"
    )
  );

  this.template_list.difficulty_factor.minimum_count_easy = 2;
  this.template_list.difficulty_factor.maximum_count_easy = 3;
  this.template_list.difficulty_factor.minimum_count_medium = 3;
  this.template_list.difficulty_factor.maximum_count_medium = 4;
  this.template_list.difficulty_factor.minimum_count_hard = 3;
  this.template_list.difficulty_factor.maximum_count_hard = 5;

  

    this.trophy_names.PushBack('modrer_necrophage_trophy_low');
    this.trophy_names.PushBack('modrer_necrophage_trophy_medium');
    this.trophy_names.PushBack('modrer_necrophage_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences): RER_CreaturePreferences {
    return super.setCreaturePreferences(preferences);
  }
}
