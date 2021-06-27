
// in this class you will find all persistent data about the ecosystem the mod
// stores in the user save files.
class RER_ContractStorage extends RER_BaseStorage {
    default id = 'RandomEncountersReworked';
    default containerId = 'contract';

    /**
     * to know if a contract was running or not, check if the last_phase is a
     * valid name or not. If last_phase = '', then no contract was running.
     *
     * That means the code will do last_phase = ''; once a contract is finished
     * to declare no more contract is in progress.
     *
     * NOTE: because it can store only one last_phase, if the player starts a
     * second contract while a first one is in progress. The second contract
     * will override the current one and progress in the first one will be lost.
     */
    var last_phase: name;
    var last_checkpoint: Vector;
    var last_longevity: float;
    var last_picked_creature: CreatureType;
    var last_heading: float;
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