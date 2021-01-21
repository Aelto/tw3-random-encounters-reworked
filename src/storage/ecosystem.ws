
// in this class you will find all persistent data about the ecosystem the mod
// stores in the user save files.
class RER_EcosystemStorage extends RER_BaseStorage {
    default id = 'RandomEncountersReworked';
    default containerId = 'ecosystem';

    public var ecosystem_areas: array<EcosystemArea>;
}

// an helper function to get ecosystem storage
function RER_loadEcosystemStorage(): RER_EcosystemStorage {
  var storage: RER_EcosystemStorage;

  storage = (RER_EcosystemStorage)GetModStorage()
    .load('RandomEncountersReworked', 'ecosystem');

  // the first time we load, there is no data so we have to create something from
  // scratch.
  if (!IsNameValid(storage.id) && !IsNameValid(storage.containerId)) {
    storage = new RER_EcosystemStorage in thePlayer;
  }

  return storage;
}