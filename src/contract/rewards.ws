
function RER_contractRewardTypeToItemName(type: RER_ContractRewardType): name {
  var item_name: name;

  switch (type):
    case ContractRewardType_GEAR:
      item_name = 'rer_token_gear'
      break;

    case ContractRewardType_MATERIALS:
      item_name = 'rer_token_materials'
      break;

    case ContractRewardType_CONSUMABLES:
      item_name = 'rer_token_consumables'
      break;

    case ContractRewardType_EXPERIENCE:
      item_name = 'rer_token_experience'
      break;

    case ContractRewardType_GOLD:
      item_name = 'rer_token_gold'
      break;
  }

  return item_name;
}

function RER_applyLootFromContractTokenName(inventory: CInventoryComponent, item: name) {
  var loot_tables: array<name>;
  var index: int;

  theSound.SoundEvent("gui_inventory_buy");

  if (item == 'rer_token_experience') {
    // re-use the index variable here
    index =  thePlayer.GetLevel() * 10;

    GetWitcherPlayer()
    .AddPoints(EExperiencePoint, index, true);

    thePlayer.DisplayItemRewardNotification('experience', index);

    return;
  }

  switch (item) {
    case 'rer_token_gear':
      loot_tables.PushBack('_weapons_nml');
      loot_tables.PushBack('_unique_weapons_epic_dungeon_nml');
      loot_tables.PushBack('_uniqe_weapons_epic_dungeon_skelige');
      loot_tables.PushBack('_loot_monster_treasure_uniq_swords');
      loot_tables.PushBack('_uniq_armors');
      break;
    
    case 'rer_token_consumables':
      loot_tables.PushBack('_generic food_everywhere');
      loot_tables.PushBack('_generic alco_everywhere');
      break;
    
    case 'rer_token_gold':
      loot_tables.PushBack('_generic gold_everywhere');
      break;
    
    case 'rer_token_materials':
      loot_tables.PushBack('_dungeon_everywhere');
      loot_tables.PushBack('_treasure_q1');
      loot_tables.PushBack('_treasure_q2');
      loot_tables.PushBack('_treasure_q3');
      loot_tables.PushBack('_treasure_q4');
      loot_tables.PushBack('_treasure_q5');
      loot_tables.PushBack('_unique_armorupgrades');
      loot_tables.PushBack('_unique_ingr');
      break;
  }

  index = RandRange(loot_tables.Size());

  inventory.AddItemsFromLootDefinition(
    loot_tables[index]
  );

  thePlayer.DisplayItemRewardNotification(loot_tables[index], -1);
}

function RER_getLocalizedRewardType(type: RER_ContractRewardType): string {
  return GetLocStringByKey(
    NameToString(RER_contractRewardTypeToItemName()) + "_short"
  );
}

function RER_getLocalizedRewardTypesFromFlag(flag: RER_ContractRewardType): string {
  var output: string;

  if (RER_flagEnabled(flag, ContractRewardType_GEAR)) {
    output += RER_getLocalizedRewardType(ContractRewardType_GEAR);
  }

  if (RER_flagEnabled(flag, ContractRewardType_CONSUMABLES)) {
    if (StrLen(output) > 0) {
      output += ", ";
    }

    output += RER_getLocalizedRewardType(ContractRewardType_CONSUMABLES);
  }

  if (RER_flagEnabled(flag, ContractRewardType_EXPERIENCE)) {
    if (StrLen(output) > 0) {
      output += ", ";
    }

    output += RER_getLocalizedRewardType(ContractRewardType_EXPERIENCE);
  }

  if (RER_flagEnabled(flag, ContractRewardType_GOLD)) {
    if (StrLen(output) > 0) {
      output += ", ";
    }

    output += RER_getLocalizedRewardType(ContractRewardType_GOLD);
  }

  if (RER_flagEnabled(flag, ContractRewardType_MATERIALS)) {
    if (StrLen(output) > 0) {
      output += ", ";
    }

    output += RER_getLocalizedRewardType(ContractRewardType_MATERIALS);
  }

  return output;
}

function RER_getRandomContractRewardTypeFromFlag(flag: RER_ContractRewardType, rng: RandomNumberGenerator): RER_ContractRewardType {
  var enabled_types: array<RER_ContractRewardType>;
  var index: int;

  if (RER_flagEnabled(flag, ContractRewardType_GEAR)) {
    enabled_types.PushBack(ContractRewardType_GEAR);
  }

  if (RER_flagEnabled(flag, ContractRewardType_CONSUMABLES)) {
    enabled_types.PushBack(ContractRewardType_CONSUMABLES);
  }

  if (RER_flagEnabled(flag, ContractRewardType_EXPERIENCE)) {
    enabled_types.PushBack(ContractRewardType_EXPERIENCE);
  }

  if (RER_flagEnabled(flag, ContractRewardType_GOLD)) {
    enabled_types.PushBack(ContractRewardType_GOLD);
  }

  if (RER_flagEnabled(flag, ContractRewardType_MATERIALS)) {
    enabled_types.PushBack(ContractRewardType_MATERIALS);
  }

  index = rng.nextRange(enabled_types.Size(), 0);

  return enabled_types[index];
}

function RER_getAllowedContractRewardsMaskFromRegion(): RER_ContractRewardType {
  var region: string;

  // we don't use the sharedutils function because we need to know
  // when the player is in novigrad or no_mans_land
  region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

  if (region == "prolog_village_winter") {
    region = "prolog_village";
  }

  if (region == "no_mans_land") {
    return ContractRewardType_EXPERIENCE
         | ContractRewardType_MATERIALS;
  }
  else if (region == "novigrad") {
    return ContractRewardType_GOLD
         | ContractRewardType_GEAR;
  }
  else if (region == "skellige") {
    return ContractRewardType_CONSUMABLES
         | ContractRewardType_GEAR;
  }
  else if (region == "bob") {
    return ContractRewardType_CONSUMABLES
         | ContractRewardType_GOLD;
  }
  // kaer_morhen, spiral, isle of mysts, etc...
  // places where contracts cannot happen without mods
  
  return ContractRewardType_ALL;
}

/**
 * contracts rewards are subject to region based restrictions
 * but some noticeboards break the rules, this adds some nice
 * variation.
 */
function RER_getRandomAllowedRewardType(contract_manager: RER_ContractManager, noticeboard_identifier: RER_NoticeboardIdentifier): RER_ContractRewardType {
  var allowed_reward: RER_ContractRewardType;
  var rng: RandomNumberGenerator;
  var roll: int;
  
  rng = (new RandomNumberGenerator in contract_manager).setSeed(noticeboard_identifier.identifier)
    .useSeed(true);

  allowed_reward = ContractRewardType_NONE;
  roll = (int)rng.nextRange(20, 0);

  switch (roll) {
    case 0:
      allowed_reward = ContractRewardType_GEAR;
      break;

    case 1:
      allowed_reward = ContractRewardType_MATERIALS;
      break;

    case 2:
      allowed_reward = ContractRewardType_EXPERIENCE;
      break;

    case 3:
      allowed_reward = ContractRewardType_CONSUMABLES;
      break;
    
    case 4:
      allowed_reward = ContractRewardType_GOLD;
  }

  return allowed_reward
}