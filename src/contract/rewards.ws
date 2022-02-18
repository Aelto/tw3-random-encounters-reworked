
function RER_contractRewardTypeToItemName(type: RER_ContractRewardType): name {
  var item_name: name;

  switch (type) {
    case ContractRewardType_GEAR:
      item_name = 'rer_token_gear';
      break;

    case ContractRewardType_MATERIALS:
      item_name = 'rer_token_materials';
      break;

    case ContractRewardType_CONSUMABLES:
      item_name = 'rer_token_consumables';
      break;

    case ContractRewardType_EXPERIENCE:
      item_name = 'rer_token_experience';
      break;

    case ContractRewardType_GOLD:
      item_name = 'rer_token_gold';
      break;
  }

  return item_name;
}

latent function RER_applyLootFromContractTokenName(master: CRandomEncounters, inventory: CInventoryComponent, item: name) {
  var loot_table_container: W3AnimatedContainer;
  var loot_tables: array<name>;
  var amount: int;
  var index: int;

  thePlayer.GetInventory().RemoveItemByName(item, 1);

  if (item == 'rer_token_experience') {
    // re-use the index variable here
    index =  thePlayer.GetLevel() * 10;

    GetWitcherPlayer()
    .AddPoints(EExperiencePoint, index, true);

    thePlayer.DisplayItemRewardNotification('experience', index);

    return;
  }

  amount = 1;

  switch (item) {
    case 'rer_token_gear':
      loot_tables.PushBack('_weapons_nml');
      loot_tables.PushBack('_unique_weapons_epic_dungeon_nml');
      loot_tables.PushBack('_uniqe_weapons_epic_dungeon_skelige');
      loot_tables.PushBack('_loot_monster_treasure_uniq_swords');
      loot_tables.PushBack('_uniq_armors');

      theSound.SoundEvent("gui_inventory_weapon_attach");
      break;
    
    case 'rer_token_consumables':
      loot_tables.PushBack('_generic food_everywhere');
      loot_tables.PushBack('_generic alco_everywhere');
      loot_tables.PushBack('q401_cooking_container');
      loot_tables.PushBack('sq301_container_fancy_food');
      loot_tables.PushBack('sq301_container_drinks_only');
      loot_tables.PushBack('sq301_container_countryside_food');
      loot_tables.PushBack('sq301_container_countryside_drinks');

      amount = 5;
      theSound.SoundEvent("gui_pick_up_herbs");
      break;
    
    case 'rer_token_gold':
      if (RER_playerUsesEnhancedEditionRedux()) {
        loot_tables.PushBack('sk30_treasure_chest'); // valuables
        loot_tables.PushBack('Nest addon upgrade'); // valuables

        // this loot table was removed because it is now missing in EE Redux
        // loot_tables.PushBack('cp14_chest'); // orens

        amount = 2;
      }
      else {
        loot_tables.PushBack('_generic gold_everywhere');
        loot_tables.PushBack('_valuables');

        amount = 10;
      }

      theSound.SoundEvent("gui_inventory_buy");
      break;
    
    case 'rer_token_materials':
      loot_tables.PushBack('Siren Nest');
      loot_tables.PushBack('Rotfiend Nest');
      loot_tables.PushBack('Nekker Nest');
      loot_tables.PushBack('Harpy Nest');
      loot_tables.PushBack('Ghoul Nest');
      loot_tables.PushBack('Endriaga Nest');
      loot_tables.PushBack('Drowner Nest');
      loot_tables.PushBack('Draconide Nest');
      loot_tables.PushBack('Ghoul Nest');
      loot_tables.PushBack('Ghoul Nest');
      loot_tables.PushBack('Ghoul Nest');
      loot_tables.PushBack('q401_trial_additional_ingredients_container');

      if (!RER_playerUsesEnhancedEditionRedux()) {
        loot_tables.PushBack('_dungeon_everywhere');
        loot_tables.PushBack('_treasure_q1');
        loot_tables.PushBack('_treasure_q2');
        loot_tables.PushBack('_treasure_q3');
        loot_tables.PushBack('_treasure_q4');
        loot_tables.PushBack('_treasure_q5');
        loot_tables.PushBack('_unique_armorupgrades');
        loot_tables.PushBack('_unique_ingr');
      }

      amount = 5;

      theSound.SoundEvent("gui_inventory_potion_attach");
      break;
  }

  loot_table_container = RER_createSourceContainerForLootTables(master);
  while (amount > 0) {
    index = RandRange(loot_tables.Size());
    amount -= 1;

    NLOG("RER_applyLootFromContractTokenName =" + index + ", " + loot_tables[index]);

    Sleep(0.2);

    RER_addItemsFromLootTable(loot_table_container, inventory, loot_tables[index]);
  }
  loot_table_container.Destroy();
}

function RER_getLocalizedRewardType(type: RER_ContractRewardType): string {
  var item_name: string;

  item_name = NameToString(RER_contractRewardTypeToItemName(type)) + "_short";

  return GetLocStringByKey(item_name);
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

  index = (int)rng.nextRange(enabled_types.Size(), 0);

  return enabled_types[index];
}

function RER_getAllowedContractRewardsMaskFromRegion(): RER_ContractRewardType {
  var region: string;
  var position: Vector;
  region = SUH_getCurrentRegion();

  NLOG("RER_getAllowedContractRewardsMaskFromRegion, region = " + region);

  if (region == "prolog_village_winter") {
    region = "prolog_village";
  }

  if (region == "no_mans_land") {
    position = thePlayer.GetWorldPosition();

    // novigrad, higher than oxenfurt on the map
    if (position.X < 1150) {
      return ContractRewardType_GOLD
         | ContractRewardType_GEAR;
    }
    else {
      return ContractRewardType_EXPERIENCE
         | ContractRewardType_MATERIALS;
    }
  }
  // should never enter this one, but left just in case it happens
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
  
  rng = (new RandomNumberGenerator in contract_manager).setSeed(RER_identifierToInt(noticeboard_identifier.identifier))
    .useSeed(true);

  allowed_reward = ContractRewardType_NONE;
  roll = (int)rng.nextRange(15, 0);

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

  NLOG("RER_getRandomAllowedRewardType, allowed_reward = " + allowed_reward);

  return allowed_reward;
}