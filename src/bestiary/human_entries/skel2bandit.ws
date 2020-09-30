
class RER_BestiaryHumanSkel2bandit extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureHUMAN;
    this.menu_name = 'Humans';

    

  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_axe1h_normal.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_axe1h_hard.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_blunt_normal.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_blunt_hard.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_shield_axe1h_normal.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_shield_mace1h_normal.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_axe2h.w2ent", 2));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_sword_easy.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_sword_hard.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_sword_normal.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_hammer2h.w2ent", 1));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_bow.w2ent", 2));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_crossbow.w2ent", 1));

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

  public function setCreaturePreferences(preferences: RER_CreaturePreferences): RER_CreaturePreferences {
    return super.setCreaturePreferences(preferences);
  }
}
