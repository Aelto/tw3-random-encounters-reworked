// Everything about the contain refill feature for the rewards system.
// This feature aims to refill random container in the world when Geralt kills
// monsters.
//
// A list of loot tables are available and their chance to be picked can be
// changed in the menus.

function RER_addKillingSpreeCustomLootToEntities(entities: array<CEntity>, loot_tables: array<RER_KillingSpreeLootTable>, ecosystem_strength: float) {
  var entity: CEntity;
  var loot
  var i: int;
  var k: int;

  for (i = 0; i < entities.Size(); i += 1) {
    entity = entities[i];


  }
}


class RER_KillingSpreeLootTable {
  var table_name: name;
  var unlock_level: float;
  var droprate: float;
}

function RER_makeKillingSpreeLootTable(table_name: name, unlock_level: float, droprate: float): RER_KillingSpreeLootTable {
  var table: RER_KillingSpreeLootTable;

  table = new RER_KillingSpreeLootTable in thePlayer;
}

function RER_getKillingSpreeLootTables(inGameConfigWrapper: CInGameConfigWrapper): array<RER_KillingSpreeLootTable> {
  var loot_tables: array<RER_KillingSpreeLootTable>;

  loot_tables.PushBack(
    RER_LootTable(
      '_generic food_everywhere',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__generic_food_everywhere')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__generic_food_everywhere'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_generic alco_everywhere',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__generic_alco_everywhere')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__generic_alco_everywhere'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_generic gold_everywhere',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__generic_gold_everywhere')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__generic_gold_everywhere'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_loot dwarven body_everywhere',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__loot_dwarven_body_everywhere')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__loot_dwarven_body_everywhere'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_loot badit body_everywhere',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__loot_badit_body_everywhere')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__loot_badit_body_everywhere'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_generic chest_everywhere',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__generic_chest_everywhere')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__generic_chest_everywhere'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_herbalist area_prolog',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__herbalist_area_prolog')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__herbalist_area_prolog'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_herbalist area_nml',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__herbalist_area_nml')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__herbalist_area_nml'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_herbalist area_novigrad',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__herbalist_area_novigrad')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__herbalist_area_novigrad'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_herbalist area_skelige',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__herbalist_area_skelige')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__herbalist_area_skelige'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_dungeon_everywhere',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__dungeon_everywhere')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__dungeon_everywhere'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_treasure_q1',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__treasure_q1')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__treasure_q1'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_treasure_q2',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__treasure_q2')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__treasure_q2'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_treasure_q3',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__treasure_q3')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__treasure_q3'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_treasure_q4',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__treasure_q4')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__treasure_q4'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_treasure_q5',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__treasure_q5')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__treasure_q5'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_unique_runes',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__unique_runes')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__unique_runes'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_unique_armorupgrades',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__unique_armorupgrades')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__unique_armorupgrades'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_unique_ingr',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__unique_ingr')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__unique_ingr'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_weapons_nml',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__weapons_nml')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__weapons_nml'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_unique_weapons_epic_dungeon_nml',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__unique_weapons_epic_dungeon_nml')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__unique_weapons_epic_dungeon_nml'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_uniqe_weapons_epic_dungeon_skelige',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__uniqe_weapons_epic_dungeon_skelige')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__uniqe_weapons_epic_dungeon_skelige'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_loot_monster_treasure_uniq_swords',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__loot_monster_treasure_uniq_swords')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__loot_monster_treasure_uniq_swords'))
    )
  );

  loot_tables.PushBack(
    RER_LootTable(
      '_uniq_armors',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock__uniq_armors')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate__uniq_armors'))
    )
  );


  return loot_tables;
}

/**
 * This function tries to refill the supplied container. The return value tells
 * if it did or not.
 *
 * There is a chance it doesn't refill the container because it's up to the user
 * to tell if it should refill container that are not empty or not.
 */
function RER_tryRefillContainer(container: W3Container, loot_table: RER_LootTable, only_if_empty: bool): bool {
  if (only_if_empty && !container.IsEmpty()) {
    return false;
  }

  NLOG("container refilled with loot table: " + loot_table.table_name);

  container.GetInventory().AddItemsFromLootDefinition(loot_table.table_name);
  container.GetInventory().UpdateLoot();
  container.Enable(true);

  return true;
}