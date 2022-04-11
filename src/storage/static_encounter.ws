
class RER_StaticEncounterStorage extends RER_BaseStorage {
    default id = 'RandomEncountersReworked';
    default containerId = 'static_encounter';

    var playthrough_seed: string;
    var placeholder_static_encounters: 
}

// an helper function to get ecosystem storage
function RER_loadStaticEncounterStorage(): RER_StaticEncounterStorage {
  var storage: RER_StaticEncounterStorage;

  storage = (RER_StaticEncounterStorage)GetModStorage()
    .load('RandomEncountersReworked', 'static_encounter');

  // the first time we load, there is no data so we have to create something from
  // scratch.
  if (!IsNameValid(storage.id) && !IsNameValid(storage.containerId)) {
    LogChannel('RER', "RER_loadStaticEncounterStorage - instantiating new RER_StaticEncounterStorage");

    storage = new RER_StaticEncounterStorage in thePlayer;
  }

  return storage;
}