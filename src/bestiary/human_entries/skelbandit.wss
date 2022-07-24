
class RER_BestiaryHumanSkelbandit extends RER_BestiaryEntry {
  public function init() {
    var influences: RER_ConstantInfluences;
    influences = RER_ConstantInfluences();

    this.type = CreatureHUMAN;
    this.menu_name = 'Humans';

    

  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_1h_axe_t1.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_1h_club.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_bow.w2ent", 3));        
  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_2h_spear.w2ent", 3));        
  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_shield_axe_t1.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_shield_club.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_1h_axe_t2.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_1h_sword.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_shield_axe_t2.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_shield_sword.w2ent"));

    this.template_list.difficulty_factor.minimum_count_easy = 3;
    this.template_list.difficulty_factor.maximum_count_easy = 4;
    this.template_list.difficulty_factor.minimum_count_medium = 3;
    this.template_list.difficulty_factor.maximum_count_medium = 5;
    this.template_list.difficulty_factor.minimum_count_hard = 4;
    this.template_list.difficulty_factor.maximum_count_hard = 6;

  
    this.ecosystem_delay_multiplier = 2.5;

    this.trophy_names.PushBack('modrer_human_trophy_low');
    this.trophy_names.PushBack('modrer_human_trophy_medium');
    this.trophy_names.PushBack('modrer_human_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}
