
state Combat in RandomEncountersReworkedHuntingGroundEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "RandomEncountersReworkedHuntingGroundEntity - State Combat");

    this.Combat_Main();
  }

  entry function Combat_Main() {
    SUH_resetEntitiesAttitudes(parent.entities);
    SUH_makeEntitiesTargetPlayer(parent.entities);

    while (SUH_waitUntilPlayerFinishesCombatStep(parent.entities)) {
      RER_moveCreaturesAwayIfPlayerIsInCutscene(parent.entities, 30);

      Sleep(1);
    }

    if (parent.entity_settings.allow_trophy_pickup_scene) {
      parent
        .master
        .requestOutOfCombatAction(OutOfCombatRequest_TROPHY_CUTSCENE);
    }

    this.Combat_goToNextState();
  }

  latent function Combat_goToNextState() {
    if (SUH_areAllEntitiesDead(parent.entities)) {
      parent.GotoState('Ending');
    }
    else {
      parent.GotoState('Wandering');
    }
  }
}
