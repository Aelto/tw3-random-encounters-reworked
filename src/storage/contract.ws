
// in this class you will find all persistent data about the contracts the mod
// stores in the user save files.
class RER_ContractStorage extends RER_BaseStorage {
  default id = 'RandomEncountersReworked';
  default containerId = 'contract';

  /**
   * the time the contracts were last generated. The int value in the hours
   * of playtime the player has spent in the save.
   */
  var last_generation_time: RER_GenerationTime;

  /**
   * an array of the currently completed contracts. It is flushed if the
   * last_errand_injection_time is refreshed.
   */
  var completed_contracts: array<RER_ContractIdentifier>;

  var active_contract: RER_ContractRepresentation;

  var has_ongoing_contract: bool;

  var noticeboards_reputation: array<RER_NoticeboardReputation>;
}

// an helper function to get contract storage
function RER_loadContractStorage(): RER_ContractStorage {
  var storage: RER_ContractStorage;

  storage = (RER_ContractStorage)GetModStorage()
    .load('RandomEncountersReworked', 'contract');

  // the first time we load, there is no data so we have to create something from
  // scratch.
  if (!IsNameValid(storage.id) && !IsNameValid(storage.containerId)) {
    LogChannel('RER', "RER_loadContractStorage - instantiating new RER_ContractStorage");

    storage = new RER_ContractStorage in thePlayer;
  }

  return storage;
}