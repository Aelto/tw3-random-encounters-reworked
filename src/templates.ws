
struct SEnemyTemplate {
  var template : string;
  var max      : int;
  var count    : int;
  var bestiary_entry: string;
}

function makeEnemyTemplate(template: string, optional max: int, optional count: int, optional bestiary_entry: string): SEnemyTemplate {
  var enemy_template: SEnemyTemplate;

  enemy_template.template = template;
  enemy_template.max = max;
  enemy_template.count = count;
  enemy_template.bestiary_entry = bestiary_entry;

  return enemy_template;
}
 
struct DifficultyFactor {
  var minimum_count_easy: int;
  var maximum_count_easy: int;
  
  var minimum_count_medium: int;
  var maximum_count_medium: int;
  
  var minimum_count_hard: int;
  var maximum_count_hard: int;
}

struct EnemyTemplateList {
  var templates: array<SEnemyTemplate>;
  var difficulty_factor: DifficultyFactor;
}

function mergeEnemyTemplateLists(a, b: EnemyTemplateList): EnemyTemplateList {
  var output: EnemyTemplateList;
  var i: int;

  output.difficulty_factor.minimum_count_easy
    = a.difficulty_factor.minimum_count_easy
    + b.difficulty_factor.minimum_count_easy;

  output.difficulty_factor.maximum_count_easy
    = a.difficulty_factor.maximum_count_easy
    + b.difficulty_factor.maximum_count_easy;
  
  output.difficulty_factor.minimum_count_medium
    = a.difficulty_factor.minimum_count_medium
    + b.difficulty_factor.minimum_count_medium;
  
  output.difficulty_factor.maximum_count_medium 
    = a.difficulty_factor.maximum_count_medium
    + b.difficulty_factor.maximum_count_medium;
  
  output.difficulty_factor.minimum_count_hard
    = a.difficulty_factor.minimum_count_hard
    + b.difficulty_factor.minimum_count_hard;

  output.difficulty_factor.maximum_count_hard
    = a.difficulty_factor.maximum_count_hard
    + b.difficulty_factor.maximum_count_hard;

  for (i = 0; i < a.templates.Size(); i += 1) {
    output.templates.PushBack(a.templates[i]);
  }

  for (i = 0; i < b.templates.Size(); i += 1) {
    output.templates.PushBack(b.templates[i]);
  }

  return output;
}

function getMaximumCountBasedOnDifficulty(out factor: DifficultyFactor, difficulty: int, optional added_factor: float): int {
  if (added_factor == 0) {
    added_factor = 1;
  }

  if (difficulty >= 2) {
    return FloorF(factor.maximum_count_hard * added_factor);
  }

  if (difficulty >= 1) {
    return FloorF(factor.maximum_count_medium * added_factor);
  }

  return FloorF(factor.maximum_count_easy * added_factor);
}

function getMinimumCountBasedOnDifficulty(out factor: DifficultyFactor, difficulty: int, optional added_factor: float): int {
  if (added_factor == 0) {
    added_factor = 1;
  }

  if (difficulty >= 2) {
    return FloorF(factor.minimum_count_hard * added_factor);
  }

  if (difficulty >= 1) {
    return FloorF(factor.minimum_count_medium * added_factor);
  }

  return FloorF(factor.minimum_count_easy * added_factor);
}

function rollDifficultyFactor(out factor: DifficultyFactor, difficulty: int, optional added_factor: float): int {
  if (added_factor == 0) {
    added_factor = 1;
  }
  
  return RandRange(
    getMinimumCountBasedOnDifficulty(factor, difficulty, added_factor),
    getMaximumCountBasedOnDifficulty(factor, difficulty, added_factor) + 1  // +1 because RandRange is [min;max[
  );
}

// return true if atleast of the bestiary entries is known.
// if all entries are unknown then return false
latent function bestiaryCanSpawnEnemyTemplateList(template_list: EnemyTemplateList, manager: CWitcherJournalManager): bool {
  // we use a list too avoid loading twice the same journal entry
  var already_checked_journals: array<string>;
  var can_spawn: bool;
	
  var i, j: int;

  var resource : CJournalResource;
	var entryBase : CJournalBase;

  for (i = 0; i < template_list.templates.Size(); i += 1) {
    // 1. first checking if the entry was already checked
    for (j = 0; j < already_checked_journals.Size(); j += 1) {
      // 2. the entry was checked already, we skip it
      if (already_checked_journals[j] == template_list.templates[i].bestiary_entry) {
        continue;
      }
    }

    // 3. check the entry
    can_spawn = bestiaryCanSpawnEnemyTemplate(template_list.templates[i], manager);
    if (can_spawn) {
      return true;
    }

    // 4. entry unknown, add it to the checked list
    already_checked_journals.PushBack(template_list.templates[i].bestiary_entry);
  }

  return false;
}

latent function bestiaryCanSpawnEnemyTemplate(enemy_template: SEnemyTemplate, manager: CWitcherJournalManager): bool {
  var resource : CJournalResource;
	var entryBase : CJournalBase;

  LogChannel('modRandomEncounters', "bestiary can spawn enemy: " + enemy_template.bestiary_entry);

  if (enemy_template.bestiary_entry == "") {
    LogChannel('modRandomEncounters', "bestiary entry has no value, returning true");

    return true;
  }

  resource = (CJournalResource)LoadResourceAsync(
    enemy_template.bestiary_entry, true
  );

  if (resource) {
    entryBase = resource.GetEntry();

    if (entryBase) {
      if (manager.GetEntryHasAdvancedInfo(entryBase)) {
        return true;
      }
    }
    else {
      LogChannel('modRandomEncounters', "unknown bestiary entryBase for entry " + enemy_template.bestiary_entry);
    }
  }
  else {
    LogChannel('modRandomEncounters', "unknown bestiary resource: " + enemy_template.bestiary_entry);
  }

  return false;
}

function re_gryphon() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\gryphon_lvl1.w2ent",,,
      "gameplay\journal\bestiary\griffin.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\gryphon_lvl3__volcanic.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh301.journal"
    )
  ); 
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\gryphon_mh__volcanic.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh301.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;

  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;

  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  
  return enemy_template_list;
}

function re_cockatrice() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;  

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\cockatrice_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarycockatrice.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_basilisk() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\basilisk_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarybasilisk.journal"
      )
    );
  
  if(theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled()){
    enemy_template_list.templates.PushBack(
      makeEnemyTemplate(
        "dlc\bob\data\characters\npc_entities\monsters\basilisk_white.w2ent",,,
        "dlc\bob\journal\bestiary\mq7018basilisk.journal"
      )
    );
  }

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_wyvern() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wyvern_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarywyvern.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wyvern_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiarywyvern.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_dracolizard() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\oszluzg_young.w2ent",,,
      "dlc\bob\journal\bestiary\dracolizard.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_forktail() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\forktail_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiaryforktail.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\forktail_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiaryforktail.journal"
    )
  );

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\forktail_mh.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh208.journal"
    )
  );

  

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_novbandit() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "gameplay\templates\characters\presets\novigrad\nov_1h_club.w2ent"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "gameplay\templates\characters\presets\novigrad\nov_1h_mace_t1.w2ent"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "gameplay\templates\characters\presets\novigrad\nov_2h_hammer.w2ent"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "gameplay\templates\characters\presets\novigrad\nov_1h_sword_t1.w2ent"
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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_axe_normal.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_blunt.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_bow.w2ent", 2));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_crossbow.w2ent", 1));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_sword_easy.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_sword_hard.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_sword_normal.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_axe1h_hard.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_axe1h_normal.w2ent"));      
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_axe2h.w2ent", 2));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_blunt_hard.w2ent"));     
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_blunt_normal.w2ent"));  
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_bow.w2ent", 2));    
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_crossbow.w2ent", 1));    
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_hammer2h.w2ent", 1));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_swordshield.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_sword_easy.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_sword_hard.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_sword_normal.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_deserters_axe_normal.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_deserters_bow.w2ent", 3));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_deserters_sword_easy.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\novigrad_bandit_shield_1haxe.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\novigrad_bandit_shield_1hclub.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nilfgaardian_deserter_bow.w2ent", 3));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nilfgaardian_deserter_shield.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nilfgaardian_deserter_sword_hard.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\lw_giggler_boss.w2ent", 1));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\lw_giggler_melee.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\lw_giggler_melee_spear.w2ent", 3));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\lw_giggler_ranged.w2ent", 3));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_2h_axe.w2ent", 2));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_axe.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_blunt.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_boss.w2ent", 1));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_bow.w2ent", 2));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_crossbow.w2ent", 1));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_shield.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_sword_hard.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_sword_normal.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_1h_axe_t1.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_1h_club.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_bow.w2ent", 3));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_2h_spear.w2ent", 3));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_shield_axe_t1.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_shield_club.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_1h_axe_t2.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_1h_sword.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_shield_axe_t2.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_shield_sword.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_axe1h_normal.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_axe1h_hard.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_blunt_normal.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_blunt_hard.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_shield_axe1h_normal.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_shield_mace1h_normal.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_axe2h.w2ent", 2));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_sword_easy.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_sword_hard.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_sword_normal.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_hammer2h.w2ent", 1));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_bow.w2ent", 2));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_crossbow.w2ent", 1));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\inquisition\inq_1h_sword_t2.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\inquisition\inq_1h_mace_t2.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\inquisition\inq_crossbow.w2ent", 2));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\inquisition\inq_2h_sword.w2ent"));

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_wildhunt() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_axe.w2ent", 2,,
      "gameplay\journal\bestiary\whminion.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_halberd.w2ent", 2,,
      "gameplay\journal\bestiary\whminion.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_hammer.w2ent", 1,,
      "gameplay\journal\bestiary\whminion.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_spear.w2ent", 2,,
      "gameplay\journal\bestiary\whminion.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_sword.w2ent", 1,,
      "gameplay\journal\bestiary\whminion.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wildhunt_minion_lvl1.w2ent", 2,,
      "gameplay\journal\bestiary\whminion.journal"
    )
  );  // hound of the wild hunt   
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wildhunt_minion_lvl2.w2ent", 1,,
      "gameplay\journal\bestiary\whminion.journal"
    )
  );  // spikier hound

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 4;
  enemy_template_list.difficulty_factor.maximum_count_medium = 6;
  enemy_template_list.difficulty_factor.minimum_count_hard = 5;
  enemy_template_list.difficulty_factor.maximum_count_hard = 7;

  return enemy_template_list;
}


function re_arachas() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\arachas_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarycrabspider.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\arachas_lvl2__armored.w2ent", 2,,
      "gameplay\journal\bestiary\armoredarachas.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\arachas_lvl3__poison.w2ent", 2,,
      "gameplay\journal\bestiary\poisonousarachas.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 2;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 3;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 4;

  return enemy_template_list;
}

function re_cyclop() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\cyclop_lvl1.w2ent",,,
      "gameplay\journal\bestiary\cyclops.journal"
    )
  );

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\ice_giant.w2ent",,,
      "gameplay\journal\bestiary\icegiant.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_leshen() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\lessog_lvl1.w2ent",,,
      "gameplay\journal\bestiary\leshy.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\lessog_lvl2__ancient.w2ent",,,
      "gameplay\journal\bestiary\sq204ancientleszen.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\lessog_mh.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh302.journal"
    )
  );
  
  if(theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled()){
    enemy_template_list.templates.PushBack(
      makeEnemyTemplate(
        "dlc\bob\data\characters\npc_entities\monsters\spriggan.w2ent",,,
        "dlc\bob\journal\bestiary\mq7002spriggan.journal"
      )
    );
  }

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_werewolf() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\werewolf_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarywerewolf.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\werewolf_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiarywerewolf.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\werewolf_lvl3__lycan.w2ent",,,
      "gameplay\journal\bestiary\lycanthrope.journal"
    )
  );  
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\werewolf_lvl4__lycan.w2ent",,,
      "gameplay\journal\bestiary\lycanthrope.journal"
    )
  );  
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\werewolf_lvl5__lycan.w2ent",,,
      "gameplay\journal\bestiary\lycanthrope.journal"
    )
  ); 
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\_quest__werewolf.w2ent",,,
      "gameplay\journal\bestiary\bestiarywerewolf.journal"
    )
  ); 
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\_quest__werewolf_01.w2ent",,,
      "gameplay\journal\bestiary\bestiarywerewolf.journal"
    )
  ); 
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\_quest__werewolf_02.w2ent",,,
      "gameplay\journal\bestiary\bestiarywerewolf.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_fiend() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate(
    "characters\npc_entities\monsters\bies_lvl1.w2ent",,,
    "gameplay\journal\bestiary\fiends.journal" // TODO: confirm journal
    )
  );  // fiends        
  enemy_template_list.templates.PushBack(makeEnemyTemplate(
    "characters\npc_entities\monsters\bies_lvl2.w2ent",,,
    "gameplay\journal\bestiary\fiends.journal" // TODO: confirm journal
    )
  );  // red fiend

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_chort() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\czart_lvl1.w2ent",,,
      "gameplay\journal\bestiary\czart.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_bear() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\bear_lvl1__black.w2ent",,,
      "gameplay\journal\bestiary\bear.journal"
    )
  );      // black, like it says :)      
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\bear_lvl2__grizzly.w2ent",,,
      "gameplay\journal\bestiary\bear.journal"
    )
  );      // light brown  
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\bear_lvl3__grizzly.w2ent",,,
      "gameplay\journal\bestiary\bear.journal"
    )
  );      // light brown  
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\bear_berserker_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bear.journal"
    )
  );    // red/brown

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 2;

  return enemy_template_list;
}

function re_berserker() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\bear_berserker_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bear.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 2;

  return enemy_template_list;
}

function re_skelbear() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\bear_lvl3__white.w2ent",,,
      "gameplay\journal\bestiary\bear.journal"
    )
  );      // polarbear

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 2;

  return enemy_template_list;
}

function re_golem() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\golem_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarygolem.journal"
    )
  );          // normal greenish golem        
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\golem_lvl2__ifryt.w2ent",,,
      "gameplay\journal\bestiary\bestiarygolem.journal"
    )
  );      // fire golem  
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\golem_lvl3.w2ent",,,
      "gameplay\journal\bestiary\bestiarygolem.journal"
    )
  );          // weird yellowish golem

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_gargoyle() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "gameplay\templates\monsters\gargoyle_lvl1_lvl25.w2ent",,,
      "gameplay\journal\bestiary\gargoyle.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_elemental() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\elemental_dao_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiaryelemental.journal"
    )
  );      // earth elemental        
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\elemental_dao_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiaryelemental.journal"
    )
  );      // stronger and cliffier elemental
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\elemental_dao_lvl3__ice.w2ent",,,
      "gameplay\journal\bestiary\bestiaryelemental.journal"
    )
  );

  if(theGame.GetDLCManager().IsEP2Available()  &&   theGame.GetDLCManager().IsEP2Enabled()){
    enemy_template_list.templates.PushBack(
      makeEnemyTemplate(
        "dlc\bob\data\characters\npc_entities\monsters\mq7007_item__golem_grafitti.w2ent",,,
        "gameplay\journal\bestiary\bestiaryelemental.journal"
      )
    );
  }

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_ekimmara() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\vampire_ekima_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh104.journal"
    )
  );    // white vampire

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_katakan() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\vampire_katakan_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarykatakan.journal"
    )
  );  // cool blinky vampire     
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\vampire_katakan_lvl3.w2ent",,,
      "gameplay\journal\bestiary\bestiarykatakan.journal"
    )
  );  // cool blinky vamp
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\vampire_katakan_mh.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh304.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_nightwraith() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nightwraith_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarymoonwright.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nightwraith_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiarymoonwright.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nightwraith_lvl3.w2ent",,,
      "gameplay\journal\bestiary\bestiarymoonwright.journal"
    )
  );

  if(theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled()){
    enemy_template_list.templates.PushBack(
      makeEnemyTemplate(
        "dlc\bob\data\characters\npc_entities\monsters\nightwraith_banshee.w2ent",,,
        "dlc\bob\journal\bestiary\beanshie.journal"
      )
    );
  }

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_noonwraith() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\noonwraith_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarynoonwright.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\noonwraith_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiarynoonwright.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\noonwraith_lvl3.w2ent",,,
      "gameplay\journal\bestiary\bestiarynoonwright.journal"
    )
  );       
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\_quest__noonwright_pesta.w2ent",,,
      "gameplay\journal\bestiary\bestiarynoonwright.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_troll() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\troll_cave_lvl1.w2ent",,,
      "gameplay\journal\bestiary\trollcave.journal"
    )
  );    // grey

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 3;

  return enemy_template_list;
}

function re_skeltroll() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\troll_cave_lvl3__ice.w2ent",,,
      "gameplay\journal\bestiary\icetroll.journal"
    )
  );  // ice   
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\troll_cave_lvl4__ice.w2ent",,,
      "gameplay\journal\bestiary\icetroll.journal"
    )
  );  // ice
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\troll_ice_lvl13.w2ent",,,
      "gameplay\journal\bestiary\icetroll.journal"
    )
  );    // ice

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 3;

  return enemy_template_list;
}

function re_hag() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\hag_grave_lvl1.w2ent",,,
      "gameplay\journal\bestiary\gravehag.journal"
    )
  );          // grave hag 1        
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\hag_water_lvl1.w2ent",,,
      "gameplay\journal\bestiary\waterhag.journal"
    )
  );          // grey  water hag    
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\hag_water_lvl2.w2ent",,,
      "gameplay\journal\bestiary\waterhag.journal"
    )
  );          // greenish water hag

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\hag_water_mh.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh203.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_harpy() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\harpy_lvl1.w2ent",,,
      "gameplay\journal\bestiary\harpy.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\harpy_lvl2.w2ent",,,
      "gameplay\journal\bestiary\harpy.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\harpy_lvl2_customize.w2ent",,,
      "gameplay\journal\bestiary\harpy.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\harpy_lvl3__erynia.w2ent", 1,,
      "gameplay\journal\bestiary\erynia.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 4;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 5;
  enemy_template_list.difficulty_factor.maximum_count_hard = 7;
  
  return enemy_template_list;
}

function re_siren() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\siren_lvl1.w2ent", 1,,
      "gameplay\journal\bestiary\siren.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\siren_lvl2__lamia.w2ent", 1,,
      "gameplay\journal\bestiary\siren.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\siren_lvl3.w2ent", 1,,
      "gameplay\journal\bestiary\siren.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 4;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 5;
  enemy_template_list.difficulty_factor.maximum_count_hard = 7;
  
  return enemy_template_list;
}

function re_endrega() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\endriaga_lvl1__worker.w2ent",,,
      "gameplay\journal\bestiary\bestiaryendriag.journal"
    )
  );      // small endrega
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\endriaga_lvl2__tailed.w2ent", 2,,
      "gameplay\journal\bestiary\endriagatruten.journal"
    )
  );      // bigger tailed endrega
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\endriaga_lvl3__spikey.w2ent", 1,,
      "gameplay\journal\bestiary\endriagaworker.journal"
    ),
  );      // big tailless endrega

  enemy_template_list.difficulty_factor.minimum_count_easy = 2;
  enemy_template_list.difficulty_factor.maximum_count_easy = 3;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 4;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 5;

  return enemy_template_list;
}

function re_fogling() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\fogling_lvl1.w2ent",,,
      "gameplay\journal\bestiary\fogling.journal"
    )
  );          // normal fogling
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\fogling_lvl2.w2ent",,,
      "gameplay\journal\bestiary\fogling.journal"
    )
  );        // normal fogling
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\fogling_lvl3__willowisp.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh108.journal"
    )
  );  // green fogling

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\fogling_mh.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh108.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_ghoul() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\ghoul_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiaryghoul.journal"
    )
  );          // normal ghoul   spawns from the ground
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\ghoul_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiaryghoul.journal"
    )
  );          // red ghoul   spawns from the ground
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\ghoul_lvl3.w2ent",,,
      "gameplay\journal\bestiary\bestiaryghoul.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 2;
  enemy_template_list.difficulty_factor.maximum_count_easy = 3;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 4;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 5;

  return enemy_template_list;
}

function re_alghoul() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\alghoul_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiaryalghoul.journal"
    )
  );        // dark
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\alghoul_lvl2.w2ent", 3,,
      "gameplay\journal\bestiary\bestiaryalghoul.journal"
    )
  );        // dark reddish
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\alghoul_lvl3.w2ent", 2,,
      "gameplay\journal\bestiary\bestiaryalghoul.journal"
    )
  );        // greyish
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\alghoul_lvl4.w2ent", 1,,
      "gameplay\journal\bestiary\bestiaryalghoul.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\_quest__miscreant_greater.w2ent",,,
      "gameplay\journal\bestiary\bestiarymiscreant.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 2;
  enemy_template_list.difficulty_factor.maximum_count_easy = 2;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 3;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 4;

  return enemy_template_list;
}

function re_nekker() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_lvl1.w2ent",,,
      "gameplay\journal\bestiary\nekker.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_lvl2.w2ent",,,
      "gameplay\journal\bestiary\nekker.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_lvl2_customize.w2ent",,,
      "gameplay\journal\bestiary\nekker.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_lvl3_customize.w2ent",,,
      "gameplay\journal\bestiary\nekker.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_lvl3__warrior.w2ent", 2,,
      "gameplay\journal\bestiary\nekker.journal"
    )
  );

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_mh__warrior.w2ent", 1,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh202.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 4;
  enemy_template_list.difficulty_factor.maximum_count_easy = 5;
  enemy_template_list.difficulty_factor.minimum_count_medium = 4;
  enemy_template_list.difficulty_factor.maximum_count_medium = 6;
  enemy_template_list.difficulty_factor.minimum_count_hard = 5;
  enemy_template_list.difficulty_factor.maximum_count_hard = 7;

  return enemy_template_list;
}

function re_drowner() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\drowner_lvl1.w2ent",,,
      "gameplay\journal\bestiary\drowner.journal"
    )
  );        // drowner
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\drowner_lvl2.w2ent",,,
      "gameplay\journal\bestiary\drowner.journal"
    )
  );        // drowner
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\drowner_lvl3.w2ent",,,
      "gameplay\journal\bestiary\drowner.journal"
    )
  );        // pink drowner
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\drowner_lvl4__dead.w2ent", 2,,
      "gameplay\journal\bestiary\drowner.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 2;
  enemy_template_list.difficulty_factor.maximum_count_easy = 3;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 4;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 5;

  return enemy_template_list;
}

function re_rotfiend() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\rotfiend_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarygreaterrotfiend.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\rotfiend_lvl2.w2ent", 1,,
      "gameplay\journal\bestiary\bestiarygreaterrotfiend.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 3;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 4;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_wolf() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wolf_lvl1.w2ent",,,
      "gameplay\journal\bestiary\wolf.journal"
    )
  );        // +4 lvls  grey/black wolf STEEL
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wolf_lvl1__alpha.w2ent", 1,,
      "gameplay\journal\bestiary\wolf.journal"
    )
  );    // +4 lvls brown warg      STEEL

  enemy_template_list.difficulty_factor.minimum_count_easy = 2;
  enemy_template_list.difficulty_factor.maximum_count_easy = 3;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 4;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_skelwolf() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wolf_white_lvl2.w2ent",,,
      "gameplay\journal\bestiary\wolf.journal"
    )
  );    // lvl 51 white wolf    STEEL     
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wolf_white_lvl3__alpha.w2ent", 1,,
      "gameplay\journal\bestiary\wolf.journal"
    )
  );  // lvl 51 white wolf     STEEL  37

  enemy_template_list.difficulty_factor.minimum_count_easy = 2;
  enemy_template_list.difficulty_factor.maximum_count_easy = 3;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 4;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_wraith() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wraith_lvl1.w2ent",,,
      "gameplay\journal\bestiary\wraith.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wraith_lvl2.w2ent",,,
      "gameplay\journal\bestiary\wraith.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wraith_lvl2_customize.w2ent",,,
      "gameplay\journal\bestiary\wraith.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wraith_lvl3.w2ent",,,
      "gameplay\journal\bestiary\wraith.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wraith_lvl4.w2ent", 2,,
      "gameplay\journal\bestiary\wraith.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 2;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 3;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 4;

  return enemy_template_list;
}

function re_spider() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\ep1\data\characters\npc_entities\monsters\black_spider.w2ent",,,
      "gameplay\journal\bestiary\bestiarycrabspider.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\ep1\data\characters\npc_entities\monsters\black_spider_large.w2ent",2,,
      "gameplay\journal\bestiary\bestiarycrabspider.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 2;
  enemy_template_list.difficulty_factor.maximum_count_easy = 3;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 3;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 4;

  return enemy_template_list;
}

function re_boar() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\ep1\data\characters\npc_entities\monsters\wild_boar_ep1.w2ent",,,
      "dlc\bob\journal\bestiary\ep2boar.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 2;

  return enemy_template_list;
}

function re_detlaff() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\dettlaff_vampire.w2ent", 1,,
      "dlc\bob\journal\bestiary\dettlaffmonster.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_skeleton() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\nightwraith_banshee_summon.w2ent",,,
      "dlc\bob\journal\bestiary\beanshie.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\nightwraith_banshee_summon_skeleton.w2ent",,,
      "dlc\bob\journal\bestiary\beanshie.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 2;
  enemy_template_list.difficulty_factor.maximum_count_easy = 3;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 4;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_barghest() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\barghest.w2ent",,,
      "dlc\bob\journal\bestiary\barghests.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 2;
  enemy_template_list.difficulty_factor.minimum_count_hard = 2;
  enemy_template_list.difficulty_factor.maximum_count_hard = 2;

  return enemy_template_list;
}

function re_bruxa() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\bruxa.w2ent",,,
      "dlc\bob\journal\bestiary\bruxa.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\bruxa_alp.w2ent",,,
      "dlc\bob\journal\bestiary\alp.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_echinops() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\echinops_hard.w2ent", 1,,
      "dlc\bob\journal\bestiary\archespore.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\echinops_normal.w2ent",,,
      "dlc\bob\journal\bestiary\archespore.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\echinops_normal_lw.w2ent",,,
      "dlc\bob\journal\bestiary\archespore.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\echinops_turret.w2ent", 1,,
      "dlc\bob\journal\bestiary\archespore.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 2;
  enemy_template_list.difficulty_factor.maximum_count_easy = 2;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 3;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 4;

  return enemy_template_list;
}

function re_fleder() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\fleder.w2ent", 1,,
      "dlc\bob\journal\bestiary\fleder.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\quests\main_quests\quest_files\q704_truth\characters\q704_protofleder.w2ent", 1,,
      "dlc\bob\journal\bestiary\protofleder.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_garkain() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\garkain.w2ent",,,
      "dlc\bob\journal\bestiary\garkain.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\garkain_mh.w2ent",,,
      "dlc\bob\journal\bestiary\q704alphagarkain.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_gravier() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\gravier.w2ent",,,
      "dlc\bob\journal\bestiary\parszywiec.journal"
    )
  ); // fancy drowner

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 3;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 4;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_kikimore() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\kikimore.w2ent", 1,,
      "dlc\bob\journal\bestiary\kikimoraworker.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\kikimore_small.w2ent",,,
      "dlc\bob\journal\bestiary\kikimora.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 2;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 3;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 4;

  return enemy_template_list;
}

function re_panther() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\panther_black.w2ent",,,
      "dlc\bob\journal\bestiary\panther.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\panther_leopard.w2ent",,,
      "dlc\bob\journal\bestiary\panther.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\panther_mountain.w2ent",,,
      "dlc\bob\journal\bestiary\panther.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 2;

  return enemy_template_list;
}

function re_giant() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\q701_dagonet_giant.w2ent",,,
      "dlc\bob\journal\bestiary\dagonet.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\q704_cloud_giant.w2ent",,,
      "dlc\bob\journal\bestiary\q704cloudgiant.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_centipede() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\scolopendromorph.w2ent",,,
      "dlc\bob\journal\bestiary\scolopedromorph.journal"
    )
  ); //worm
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\mq7023_albino_centipede.w2ent",,,
      "dlc\bob\journal\bestiary\scolopedromorph.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 2;
  enemy_template_list.difficulty_factor.minimum_count_hard = 2;
  enemy_template_list.difficulty_factor.maximum_count_hard = 3;

  return enemy_template_list;
}

function re_sharley() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\sharley.w2ent",,,
      "dlc\bob\journal\bestiary\ep2sharley.journal"
    )
  );  // rock boss things
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\sharley_mh.w2ent",,,
      "dlc\bob\journal\bestiary\ep2sharley.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\sharley_q701.w2ent",,,
      "dlc\bob\journal\bestiary\ep2sharley.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\sharley_q701_normal_scale.w2ent",,,
      "dlc\bob\journal\bestiary\ep2sharley.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_wight() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\spooncollector.w2ent",1,,
      "dlc\bob\journal\bestiary\wicht.journal"
    )
  );  // spoon
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\wicht.w2ent",2,,
      "dlc\bob\journal\bestiary\wicht.journal"
    )
  );     // wight

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_bruxacity() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\bruxa_alp_cloak_always_spawn.w2ent",,,
      "dlc\bob\journal\bestiary\alp.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\bruxa_cloak_always_spawn.w2ent",,,
      "dlc\bob\journal\bestiary\bruxa.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}
