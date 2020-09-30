
class RER_BestiaryWildhunt extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureWILDHUNT;
    this.menu_name = 'WildHunt';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_axe.w2ent", 2,,
        "gameplay\journal\bestiary\whminion.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_halberd.w2ent", 2,,
        "gameplay\journal\bestiary\whminion.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_hammer.w2ent", 1,,
        "gameplay\journal\bestiary\whminion.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_spear.w2ent", 2,,
        "gameplay\journal\bestiary\whminion.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_sword.w2ent", 1,,
        "gameplay\journal\bestiary\whminion.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\wildhunt_minion_lvl1.w2ent", 2,,
        "gameplay\journal\bestiary\whminion.journal"
      )
    );  // hound of the wild hunt   
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\wildhunt_minion_lvl2.w2ent", 1,,
        "gameplay\journal\bestiary\whminion.journal"
      )
    );  // spikier hound

    this.template_list.difficulty_factor.minimum_count_easy = 3;
    this.template_list.difficulty_factor.maximum_count_easy = 4;
    this.template_list.difficulty_factor.minimum_count_medium = 4;
    this.template_list.difficulty_factor.maximum_count_medium = 6;
    this.template_list.difficulty_factor.minimum_count_hard = 5;
    this.template_list.difficulty_factor.maximum_count_hard = 7;

    this.trophy_names.PushBack('modrer_wildhunt_trophy_low');
    this.trophy_names.PushBack('modrer_wildhunt_trophy_medium');
    this.trophy_names.PushBack('modrer_wildhunt_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences): RER_CreaturePreferences {
    return super.setCreaturePreferences(preferences);
  }
}
