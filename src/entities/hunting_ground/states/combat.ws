
state Combat in RandomEncountersReworkedHuntingGroundEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "RandomEncountersReworkedHuntingGroundEntity - State Combat");

    this.Combat_Main();
  }

  entry function Combat_Main() {
    SUH_resetEntitiesAttitudes(parent.entities);
    SUH_makeEntitiesTargetPlayer(parent.entities);

    if (parent.is_bounty) {
      this.sendHordeRequestForBounty(parent.bounty_group_index);
    }

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

  function sendHordeRequestForBounty(bounty_index: int) {
    var request: RER_HordeRequest;

    if (parent.master.storages.bounty.current_bounty.random_data.groups[bounty_index].horde_before_bounty_started) {
      return;
    }

    if (parent.master.storages.bounty.current_bounty.random_data.groups[bounty_index].horde_before_bounty == CreatureNONE) {
      return;
    }

    request = new RER_HordeRequest in parent;
    request.setCreatureCounter(
      parent.master.storages.bounty.current_bounty.random_data.groups[bounty_index].horde_before_bounty,
      parent.master.storages.bounty.current_bounty.random_data.groups[bounty_index].horde_before_bounty_count
    );

    parent.master.horde_manager.sendRequest(request);
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
