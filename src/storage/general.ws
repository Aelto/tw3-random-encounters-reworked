
/**
 * A general storage for generic data
 */
class RER_GeneralStorage extends RER_BaseStorage {
    default id = 'RandomEncountersReworked';
    default containerId = 'general';

    var playthrough_seed: int;

    placeholder_static_encounters: array<RER_PlaceholderStaticEncounter>;
}

// an helper function to get ecosystem storage
function RER_loadGeneralStorage(): RER_GeneralStorage {
  var storage: RER_GeneralStorage;

  storage = (RER_GeneralStorage)GetModStorage()
    .load('RandomEncountersReworked', 'general');

  // the first time we load, there is no data so we have to create something from
  // scratch.
  if (!IsNameValid(storage.id) && !IsNameValid(storage.containerId)) {
    LogChannel('RER', "RER_loadGeneralStorage - instantiating new RER_GeneralStorage");

    storage = new RER_GeneralStorage in thePlayer;
  }

  return storage;
}