
// This phase waits for a bit, then wait until all current creatures are killed
// and finally waits until Geralt leaves combat (because other creatures could
// have joined the fight in the meantime)
state Combat in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State Combat");

    this.Combat_main();
  }

  entry function Combat_main() {
    this.makeEntitiesTargetPlayer();
    this.waitUntilPlayerFinishesCombat();

    parent.GotoState('PhasePick');
  }

  function makeEntitiesTargetPlayer() {
    var i: int;

    for (i = 0; i < parent.entities.Size(); i += 1) {
      ((CActor)parent.entities[i]).SetTemporaryAttitudeGroup(
        'monsters',
        AGP_Default
      );

      ((CNewNPC)parent.entities[i]).NoticeActor(thePlayer);
    }
  }

  latent function waitUntilPlayerFinishesCombat() {
    // sometimes the game takes time to set the player in combat, in this case
    // we wait a few seconds and then start looping.
    if (!thePlayer.IsInCombat()) {
      Sleep(2);
    }

    // 1. we wait until the player is out of combat
    while (!parent.areAllEntitiesFarFromPlayer() || thePlayer.IsInCombat()) {
      parent.removeDeadEntities();
      Sleep(1);
    }
  }
}
