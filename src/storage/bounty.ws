
// in this class you will find all persistent data about the bounties the mod
// stores in the user save files.
class RER_BountyStorage extends RER_BaseStorage {
    default id = 'RandomEncountersReworked';
    default containerId = 'bounty';

    var bounty_level: int;
    var current_bounty: RER_Bounty;
}

// an helper function to get ecosystem storage
function RER_loadBountyStorage(): RER_BountyStorage {
  var storage: RER_BountyStorage;

  storage = (RER_BountyStorage)GetModStorage()
    .load('RandomEncountersReworked', 'bounty');

  // the first time we load, there is no data so we have to create something from
  // scratch.
  if (!IsNameValid(storage.id) && !IsNameValid(storage.containerId)) {
    LogChannel('RER', "RER_loadBountyStorage - instantiating new RER_BountyStorage");

    storage = new RER_BountyStorage in thePlayer;
  }

  return storage;
}