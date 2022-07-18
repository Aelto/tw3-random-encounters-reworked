// Everything about the contain refill feature for the rewards system.
// This feature aims to refill random container in the world when Geralt kills
// monsters.
//
// A list of loot tables are available and their chance to be picked can be
// changed in the menus.

/**
 * This function does a random roll, if it succeeds it calls the function to
 * fill a random container
 */
latent function RER_tryRefillRandomContainer(master: CRandomEncounters) {
  var inGameConfigWrapper: CInGameConfigWrapper;
  var menu_chance: float;
  
  inGameConfigWrapper = theGame.GetInGameConfigWrapper();

  menu_chance = StringToFloat(
    inGameConfigWrapper.GetVarValue(
      'RERcontainerRefill',
      'RERcontainerRefillTriggerChance'
    )
  );

  NLOG("container refill called");

  if (RandRange(100) > menu_chance) {
    return;
  }

  RER_refillRandomContainer(master, inGameConfigWrapper);
}

/**
 * This function refills X containers around the player using a random loot
 * table for each container.
 */
latent function RER_refillRandomContainer(master: CRandomEncounters, inGameConfigWrapper: CInGameConfigWrapper) {
  var containers: array<CGameplayEntity>;
  var number_of_containers: int;
  var only_empty_containers: bool;
  var loot_table: RER_LootTable;
  var container: W3Container;
  var has_added: bool;
  var radius: float;
  var i: int;

  radius = StringToFloat(
    inGameConfigWrapper.GetVarValue(
      'RERcontainerRefill',
      'RERcontainerRefillRadius'
    )
  );

  number_of_containers = StringToInt(
    inGameConfigWrapper.GetVarValue(
      'RERcontainerRefill',
      'RERcontainerRefillNumberOfContainers'
    )
  );

  only_empty_containers = inGameConfigWrapper.GetVarValue(
    'RERcontainerRefill',
    'RERcontainerRefillOnlyEmptyContainers'
  );

  FindGameplayEntitiesInRange(
    containers,
    thePlayer,
    radius, // radius
    50 + number_of_containers * 10, // max number of entities
    , // tag
    ,
    , // target
    'W3Container'
  );

  for (i = 0; i < containers.Size(); i += 1) {
    if (number_of_containers == 0) {
      break;
    }

    loot_table = RER_getRandomLootTable(inGameConfigWrapper);

    container = (W3Container)containers[i];

    if (container) {
      has_added = RER_tryRefillContainer(master, container, loot_table, only_empty_containers);
      
      if (has_added) {
        number_of_containers -= 1;
      }
    }
  }
}

/**
 * This function returns a random loot table based on the ratios the user set
 * in the menus.
 */
function RER_getRandomLootTable(inGameConfigWrapper: CInGameConfigWrapper): RER_LootTable {
  var loot_tables: array<RER_LootTable>;
  var current_position: int;
  var total: int;
  var roll: int;
  var i: int;

  loot_tables = RER_getLootTables(inGameConfigWrapper);

  for (i = 0; i < loot_tables.Size(); i += 1) {
    total += loot_tables[i].menu_value;
  }

  roll = RandRange(total);
  current_position = 0;

  NLOG("refill - roll = " + roll);

  for (i = 0; i < loot_tables.Size(); i += 1) {
    current_position += loot_tables[i].menu_value;

    if (loot_tables[i].menu_value > 0 && roll <= current_position) {
      return loot_tables[i];
    }
  }

  return loot_tables[0];
}

struct RER_LootTable {
  var table_name: name;
  var menu_value: int;
}

function RER_getLootTables(inGameConfigWrapper: CInGameConfigWrapper): array<RER_LootTable> {
  var loot_tables: array<RER_LootTable>;

  loot_tables.PushBack(RER_LootTable('_generic food_everywhere', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__generic_food_everywhere'))));
  loot_tables.PushBack(RER_LootTable('_generic alco_everywhere', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__generic_alco_everywhere'))));
  loot_tables.PushBack(RER_LootTable('_generic gold_everywhere', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__generic_gold_everywhere'))));
  loot_tables.PushBack(RER_LootTable('_loot dwarven body_everywhere', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__loot_dwarven_body_everywhere'))));
  loot_tables.PushBack(RER_LootTable('_loot badit body_everywhere', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__loot_badit_body_everywhere'))));
  loot_tables.PushBack(RER_LootTable('_generic chest_everywhere', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__generic_chest_everywhere'))));
  loot_tables.PushBack(RER_LootTable('_herbalist area_prolog', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__herbalist_area_prolog'))));
  loot_tables.PushBack(RER_LootTable('_herbalist area_nml', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__herbalist_area_nml'))));
  loot_tables.PushBack(RER_LootTable('_herbalist area_novigrad', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__herbalist_area_novigrad'))));
  loot_tables.PushBack(RER_LootTable('_herbalist area_skelige', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__herbalist_area_skelige'))));
  loot_tables.PushBack(RER_LootTable('_dungeon_everywhere', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__dungeon_everywhere'))));
  loot_tables.PushBack(RER_LootTable('_treasure_q1', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__treasure_q1'))));
  loot_tables.PushBack(RER_LootTable('_treasure_q2', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__treasure_q2'))));
  loot_tables.PushBack(RER_LootTable('_treasure_q3', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__treasure_q3'))));
  loot_tables.PushBack(RER_LootTable('_treasure_q4', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__treasure_q4'))));
  loot_tables.PushBack(RER_LootTable('_treasure_q5', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__treasure_q5'))));
  loot_tables.PushBack(RER_LootTable('_unique_runes', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__unique_runes'))));
  loot_tables.PushBack(RER_LootTable('_unique_armorupgrades', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__unique_armorupgrades'))));
  loot_tables.PushBack(RER_LootTable('_unique_ingr', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__unique_ingr'))));
  loot_tables.PushBack(RER_LootTable('_weapons_nml', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__weapons_nml'))));
  loot_tables.PushBack(RER_LootTable('_unique_weapons_epic_dungeon_nml', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__unique_weapons_epic_dungeon_nml'))));
  loot_tables.PushBack(RER_LootTable('_uniqe_weapons_epic_dungeon_skelige', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__uniqe_weapons_epic_dungeon_skelige'))));
  loot_tables.PushBack(RER_LootTable('_loot_monster_treasure_uniq_swords', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__loot_monster_treasure_uniq_swords'))));
  loot_tables.PushBack(RER_LootTable('_uniq_armors', StringToInt(inGameConfigWrapper.GetVarValue('RERcontainerRefill', 'RERlootTable__uniq_armors'))));

  return loot_tables;
}

/**
 * This function tries to refill the supplied container. The return value tells
 * if it did or not.
 *
 * There is a chance it doesn't refill the container because it's up to the user
 * to tell if it should refill container that are not empty or not.
 */
latent function RER_tryRefillContainer(master: CRandomEncounters, container: W3Container, loot_table: RER_LootTable, only_if_empty: bool): bool {
  var loot_table_container: W3AnimatedContainer;

  if (only_if_empty && !container.IsEmpty()) {
    return false;
  }

  NLOG("container refilled with loot table: " + loot_table.table_name);

  loot_table_container = RER_createSourceContainerForLootTables(master);
  RER_addItemsFromLootTable(loot_table_container, container.GetInventory(), loot_table.table_name);
  container.GetInventory().UpdateLoot();
  container.Enable(true);

  loot_table_container.Destroy();

  return true;
}

latent function RER_createSourceContainerForLootTables(master: CRandomEncounters): W3AnimatedContainer {
  var container: W3AnimatedContainer;
  var template: CEntityTemplate;
  var position: Vector;

  template = (CEntityTemplate)LoadResourceAsync(
    "dlc\modtemplates\randomencounterreworkeddlc\data\container_all_loottables.w2ent",
    true
  );

  // always spawn the barrel under the bounty master since we know it is always
  // on ground.
  position = master.bounty_manager.bounty_master_manager.bounty_master_entity.GetWorldPosition() - Vector(0, 0, 5);
  container = (W3AnimatedContainer)theGame.CreateEntity(
    template, position,
    thePlayer.GetWorldRotation(),
    true,
    false,
    false,
    PM_DontPersist
  );

  return container;
}

latent function RER_addItemsFromLootTable(loot_table_container: W3AnimatedContainer, target_inventory: CInventoryComponent, loot_table: name): array<RER_LootTableItemResult> {
  var output: array<RER_LootTableItemResult>;
  var inventory: CInventoryComponent;
  var items: array<SItemUniqueId>;
  var i: int;

  inventory = loot_table_container.GetInventory();
  inventory.RemoveAllItems();
  inventory.AddItemsFromLootDefinition(loot_table);
  inventory.UpdateLoot();
  loot_table_container.Enable(true);

  inventory.GetAllItems(items);
  for (i = 0; i < items.Size(); i += 1) {
    output.PushBack(RER_LootTableItemResult(
      items[i],
      inventory.GetItemQuantity(items[i])
    ));
  }

  inventory.GiveAllItemsTo(target_inventory);

    // remove tags:
  // target_inventory.ManageItemsTag(items, theGame.params.TAG_DONT_SHOW, false);
  // target_inventory.ManageItemsTag(items, 'NoDrop', false);
  // target_inventory.ManageItemsTag(items, 'EncumbranceOff', false);
  // target_inventory.ManageItemsTag(items, 'NoUse', false);

  return output;
}

struct RER_LootTableItemResult {
  var item_id: SItemUniqueId;
  var quantity: int;
}