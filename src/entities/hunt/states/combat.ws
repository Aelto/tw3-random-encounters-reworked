
state Combat in RandomEncountersReworkedHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Hunt - State Combat");

    this.Combat_Main();
  }

  entry function Combat_Main() {
    this.makeEntitiesTargetPlayer();
    this.waitUntilPlayerFinishesCombat();

    parent
      .master
      .requestOutOfCombatAction(OutOfCombatRequest_TROPHY_CUTSCENE);

    this.Combat_goToNextState();
  }

  private latent function makeEntitiesTargetPlayer() {
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
    // sleep a bit before entering the loop, to avoid a really fast loop if the
    // player runs away from the monster
    Sleep(3);

    // 1. we wait until the player is out of combat
    // the && is important, because it allows the player to flee the combat
    // and if he flees far enough and get out of combat it will go back to
    // the wandering state.
    while (!parent.areAllEntitiesDead() && thePlayer.IsInCombat()) {
      Sleep(1);
    }
  }

  latent function Combat_goToNextState() {
    if (parent.areAllEntitiesDead()) {
      parent.GotoState('Ending');
    }
    else {
      parent.GotoState('Wandering');
    }
  }
}
