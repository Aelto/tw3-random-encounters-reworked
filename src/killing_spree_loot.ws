
// The ecosystem strength is a value that goes from 0 to 1, and 1 means 100%
latent function RER_addKillingSpreeCustomLootToEntities(master: CRandomEncounters, entities: array<CEntity>, loot_tables: array<RER_KillingSpreeLootTable>, ecosystem_strength: float) {
  var table: RER_KillingSpreeLootTable;
  var entity: CEntity;
  var i: int;
  var k: int;

  NLOG("RER_addKillingSpreeCustomLootToEntities: ecosystem strength = " + ecosystem_strength * 100);


  // when it's a value in the ]0;1[ range, we bring it back to the [1;inf] range
  // For example if it is a 0.5, so a 50% ecosystem strength it should be considered
  // the same as a 200% ecosystem strength, so 2. And 1 / 0.5 = 2.
  if (ecosystem_strength < 1 && ecosystem_strength != 0) {
    ecosystem_strength = 1 / ecosystem_strength;
  } 

  NLOG("RER_addKillingSpreeCustomLootToEntities: ecosystem strength = " + ecosystem_strength * 100);

  for (i = 0; i < loot_tables.Size(); i += 1) {
    table = loot_tables[i];

    // the table unlock level was not reached yet, skip it.
    // the -100 to the ecosystem strength is because want to unlock new loot tables
    // only if the strength is above 100, so an unlock level of 50 should unlock
    // at 50% which is in reality a 150% ecosystem strength
    if (table.unlock_level > ecosystem_strength * 100 - 100) {
      continue;
    }

    NLOG("loot table unlocked: " + table.table_name + ", table.unlock_level " + table.unlock_level + " ecosystem strength = " + ecosystem_strength * 100);

    for (k = 0; k < entities.Size(); k += 1) {
      if (RandRange(100) <= table.droprate * (1 + ecosystem_strength)) {
        RER_addLootTableToEntity(master, entities[i], table);
      }
    }
  }
}

latent function RER_addLootTableToEntity(master: CRandomEncounters, entity: CEntity, loot_table: RER_KillingSpreeLootTable) {
  var loot_table_container: W3AnimatedContainer;

  NLOG("loot table applied to entity: " + loot_table.table_name);

  loot_table_container = RER_createSourceContainerForLootTables(master);

  RER_addItemsFromLootTable(
    loot_table_container,
    ((CGameplayEntity)entity).GetInventory(),
    loot_table.table_name
  );

  loot_table_container.Destroy();
}


class RER_KillingSpreeLootTable {
  var table_name: name;
  var unlock_level: float;
  var droprate: float;
}

function RER_makeKillingSpreeLootTable(table_name: name, unlock_level: float, droprate: float): RER_KillingSpreeLootTable {
  var table: RER_KillingSpreeLootTable;

  table = new RER_KillingSpreeLootTable in thePlayer;
  table.table_name = table_name;
  table.unlock_level = unlock_level;
  table.droprate = droprate;

  return table;
}

function RER_getKillingSpreeLootTables(inGameConfigWrapper: CInGameConfigWrapper): array<RER_KillingSpreeLootTable> {
  var loot_tables: array<RER_KillingSpreeLootTable>;

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      'rer_gold',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock_gold')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate_gold'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      'rer_gear',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock_gear')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate_gear'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      'rer_consumables',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock_consumables')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate_consumables'))
    )
  );

  loot_tables.PushBack(
    RER_makeKillingSpreeLootTable(
      'rer_materials',
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_unlock_materials')),
      StringToFloat(inGameConfigWrapper.GetVarValue('RERkillingSpreeCustomLoot', 'RERlootTable_droprate_materials'))
    )
  );

  return loot_tables;
}