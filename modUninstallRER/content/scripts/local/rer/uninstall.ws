
exec function reruninstall() {
  var entities: array<CEntity>;
  var i: int;

  // remove all RER entities
  theGame.GetEntitiesByTag('RandomEncountersReworked_Entity', entities);

  for (i = 0; i < entities.Size(); i += 1) {
    (entities[i] as CNewNPC).Destroy();
  }

  // remove the bounty master
  theGame.GetEntitiesByTag('RER_bounty_master', entities);

  for (i = 0; i < entities.Size(); i += 1) {
    (entities[i] as CNewNPC).Destroy();
  }
}