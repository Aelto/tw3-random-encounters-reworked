
// a collection of all storage classes the mod uses
struct RER_StorageCollection {
  var general: RER_GeneralStorage;
  var ecosystem: RER_EcosystemStorage;
  var bounty: RER_BountyStorage;
  var contract: RER_ContractStorage;
}

// an helper function to get the full storage collection
function RER_loadStorageCollection(): RER_StorageCollection {
  var collection: RER_StorageCollection;

  collection.general = RER_loadGeneralStorage();
  collection.ecosystem = RER_loadEcosystemStorage();
  collection.bounty = RER_loadBountyStorage();
  collection.contract = RER_loadContractStorage();

  return collection;
}

function RER_saveStorageCollection(collection: RER_StorageCollection): bool {
  return collection.ecosystem.save();
}