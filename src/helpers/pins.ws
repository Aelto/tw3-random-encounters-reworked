
function RER_toggleSkullPinAtPosition(position: Vector): bool {
  var manager  : CCommonMapManager;
  var id_to_add, id_to_remove: int;

  manager = theGame.GetCommonMapManager();

  manager
  .ToggleUserMapPin(
    manager.GetCurrentArea(),
    position,
    1, // 1 for the red skull
    false,
    id_to_add, // out variable, doesn't matter
    id_to_remove // out variable, doesn't matter
  );

  // returns true if it was added, false if it was removed
  return id_to_add > 0;
}

function RER_toggleInfoPinAtPosition(position: Vector): bool {
  var manager  : CCommonMapManager;
  var id_to_add, id_to_remove: int;

  manager = theGame.GetCommonMapManager();

  manager
  .ToggleUserMapPin(
    manager.GetCurrentArea(),
    position,
    3, // 3 for the yellow I info icon
    false,
    id_to_add, // out variable, doesn't matter
    id_to_remove // out variable, doesn't matter
  );

  // returns true if it was added, false if it was removed
  return id_to_add > 0;
}