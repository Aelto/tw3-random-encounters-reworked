
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
function RER_getRandomAllowedRewardType(rng: RandomNumberGenerator): RER_ContractRewardType {
  var allowed_reward: RER_ContractRewardType;
  var roll: int;
  
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