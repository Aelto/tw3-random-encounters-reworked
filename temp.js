const fs = require('fs');
const path = require('path');

const classTemplate = `
class RER_BestiaryHuman{{monstername}} extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureHUMAN;
    this.menu_name = 'Humans';

    {{templates}}

    this.trophy_names.PushBack('modrer_human_trophy_low');
    this.trophy_names.PushBack('modrer_human_trophy_medium');
    this.trophy_names.PushBack('modrer_human_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences): RER_CreaturePreferences {
    return super.setCreaturePreferences(preferences);
  }
}
`;

const sources = `

function re_novbandit() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "gameplay\\templates\\characters\\presets\\novigrad\\nov_1h_club.w2ent"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "gameplay\\templates\\characters\\presets\\novigrad\\nov_1h_mace_t1.w2ent"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "gameplay\\templates\\characters\\presets\\novigrad\\nov_2h_hammer.w2ent"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "gameplay\\templates\\characters\\presets\\novigrad\\nov_1h_sword_t1.w2ent"
    )
  );
  
  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_pirate() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\nml_pirates_axe_normal.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\nml_pirates_blunt.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\nml_pirates_bow.w2ent", 2));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\nml_pirates_crossbow.w2ent", 1));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\nml_pirates_sword_easy.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\nml_pirates_sword_hard.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\nml_pirates_sword_normal.w2ent"));

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_skelpirate() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_pirate_axe1h_hard.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_pirate_axe1h_normal.w2ent"));      
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_pirate_axe2h.w2ent", 2));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_pirate_blunt_hard.w2ent"));     
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_pirate_blunt_normal.w2ent"));  
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_pirate_bow.w2ent", 2));    
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_pirate_crossbow.w2ent", 1));    
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_pirate_hammer2h.w2ent", 1));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_pirate_swordshield.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_pirate_sword_easy.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_pirate_sword_hard.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_pirate_sword_normal.w2ent"));

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_bandit() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\nml_deserters_axe_normal.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\nml_deserters_bow.w2ent", 3));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\nml_deserters_sword_easy.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\novigrad_bandit_shield_1haxe.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\novigrad_bandit_shield_1hclub.w2ent"));

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_nilf() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\nilfgaardian_deserter_bow.w2ent", 3));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\nilfgaardian_deserter_shield.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\nilfgaardian_deserter_sword_hard.w2ent"));

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_cannibal() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\lw_giggler_boss.w2ent", 1));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\lw_giggler_melee.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\lw_giggler_melee_spear.w2ent", 3));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\lw_giggler_ranged.w2ent", 3));

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_renegade() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\baron_renegade_2h_axe.w2ent", 2));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\baron_renegade_axe.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\baron_renegade_blunt.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\baron_renegade_boss.w2ent", 1));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\baron_renegade_bow.w2ent", 2));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\baron_renegade_crossbow.w2ent", 1));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\baron_renegade_shield.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\baron_renegade_sword_hard.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\baron_renegade_sword_normal.w2ent"));

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_skelbandit() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\\templates\\characters\\presets\\skellige\\ske_1h_axe_t1.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\\templates\\characters\\presets\\skellige\\ske_1h_club.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\\templates\\characters\\presets\\skellige\\ske_bow.w2ent", 3));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\\templates\\characters\\presets\\skellige\\ske_2h_spear.w2ent", 3));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\\templates\\characters\\presets\\skellige\\ske_shield_axe_t1.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\\templates\\characters\\presets\\skellige\\ske_shield_club.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\\templates\\characters\\presets\\skellige\\ske_1h_axe_t2.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\\templates\\characters\\presets\\skellige\\ske_1h_sword.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\\templates\\characters\\presets\\skellige\\ske_shield_axe_t2.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\\templates\\characters\\presets\\skellige\\ske_shield_sword.w2ent"));

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_skel2bandit() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_bandit_axe1h_normal.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_bandit_axe1h_hard.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_bandit_blunt_normal.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_bandit_blunt_hard.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_bandit_shield_axe1h_normal.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_bandit_shield_mace1h_normal.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_bandit_axe2h.w2ent", 2));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_bandit_sword_easy.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_bandit_sword_hard.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_bandit_sword_normal.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_bandit_hammer2h.w2ent", 1));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_bandit_bow.w2ent", 2));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\\enemy_templates\\skellige_bandit_crossbow.w2ent", 1));

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_whunter() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\\templates\\characters\\presets\\inquisition\\inq_1h_sword_t2.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\\templates\\characters\\presets\\inquisition\\inq_1h_mace_t2.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\\templates\\characters\\presets\\inquisition\\inq_crossbow.w2ent", 2));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\\templates\\characters\\presets\\inquisition\\inq_2h_sword.w2ent"));

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

`;

const monsters = sources.split('function ')
  .map(s => s.trim())
  .filter(s => s.length)
  .map(s => ({
      name: s.split(' ')[0]
        .replace('()', '')
        .replace('re_', ''),
      template: s.split('var enemy_template_list: EnemyTemplateList;')[1]
        .split('return enemy_template_list;')[0]
  }))
  .forEach(o => {
    const result = classTemplate
    .replace('{{monsternamecaps}}', o.name.toUpperCase())
    .replace('{{monstername}}', o.name.split('').map((c, i) => i === 0 ? c.toUpperCase() : c).join(''))
    .replace('{{monstername}}', o.name.split('').map((c, i) => i === 0 ? c.toUpperCase() : c).join(''))
    .replace('{{templates}}', o.template);

    fs.writeFileSync(`src/bestiary/human_entries/${o.name}.ws`, result, 'utf-8')
  });
