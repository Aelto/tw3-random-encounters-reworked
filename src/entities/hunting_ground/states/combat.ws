
state Combat in RandomEncountersReworkedHuntingGroundEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "RandomEncountersReworkedHuntingGroundEntity - State Combat");

    this.Combat_Main();
  }

  entry function Combat_Main() {
    this.resetEntitiesAttitudes();
    this.makeEntitiesTargetPlayer();
    this.waitUntilPlayerFinishesCombat();

    if (parent.entity_settings.allow_trophy_pickup_scene) {
      parent
        .master
        .requestOutOfCombatAction(OutOfCombatRequest_TROPHY_CUTSCENE);
    }

    this.Combat_goToNextState();
  }

  private latent function resetEntitiesAttitudes() {
    var i: int;

    for (i = 0; i < parent.entities.Size(); i += 1) {
      ((CActor)parent.entities[i])
        .ResetTemporaryAttitudeGroup(AGP_Default);
    }
  }

  private latent function makeEntitiesTargetPlayer() {
    var i: int;

    for (i = 0; i < parent.entities.Size(); i += 1) {
      if (((CActor)parent.entities[i]).GetTarget() != thePlayer && !((CActor)parent.entities[i]).HasAttitudeTowards(thePlayer)) {
        ((CNewNPC)parent.entities[i]).NoticeActor(thePlayer);
        ((CActor)parent.entities[i]).SetAttitude(thePlayer, AIA_Hostile);
      }
    }
  }

  latent function waitUntilPlayerFinishesCombat() {
    // sleep a bit before entering the loop, to avoid a really fast loop if the
    // player runs away from the monster
    Sleep(3);

    while (!parent.areAllEntitiesDead() && !parent.areAllEntitiesFarFromPlayer()) {
      this.makeEntitiesTargetPlayer();
      parent.removeDeadEntities();

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
