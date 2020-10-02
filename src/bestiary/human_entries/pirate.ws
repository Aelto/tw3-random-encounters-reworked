
class RER_BestiaryHumanPirate extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureHUMAN;
    this.menu_name = 'Humans';

    

  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_axe_normal.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_blunt.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_bow.w2ent", 2));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_crossbow.w2ent", 1));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_sword_easy.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_sword_hard.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_sword_normal.w2ent"));

  this.template_list.difficulty_factor.minimum_count_easy = 3;
  this.template_list.difficulty_factor.maximum_count_easy = 4;
  this.template_list.difficulty_factor.minimum_count_medium = 3;
  this.template_list.difficulty_factor.maximum_count_medium = 5;
  this.template_list.difficulty_factor.minimum_count_hard = 4;
  this.template_list.difficulty_factor.maximum_count_hard = 6;

  

    this.trophy_names.PushBack('modrer_human_trophy_low');
    this.trophy_names.PushBack('modrer_human_trophy_medium');
    this.trophy_names.PushBack('modrer_human_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}
