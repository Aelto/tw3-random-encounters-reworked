
// a collection of all storage classes the mod uses
struct RER_StorageCollection {
  var ecosystem: RER_EcosystemStorage;
}

// an helper function to get the full storage collection
function RER_loadStorageCollection(): RER_StorageCollection {
  var collection: RER_StorageCollection;

  collection.ecosystem = RER_loadEcosystemStorage();

  return collection;
}

function RER_saveStorageCollection(collection: RER_StorageCollection): bool {
  return collection.ecosystem.save();
}