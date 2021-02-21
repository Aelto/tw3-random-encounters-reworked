
state Wandering in RandomEncountersReworkedHuntingGroundEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "RandomEncountersReworkedHuntingGroundEntity - State Wandering");
    this.Wandering_main();
  }

  entry function Wandering_main() {
    this.resetEntitiesActions();
    this.makeEntitiesMoveTowardsBait();
    this.resetEntitiesActions();

    parent.GotoState('Combat');
  }

  latent function makeEntitiesMoveTowardsBait() {
    var distance_from_player: float;
    var distance_from_bait: float;
    var current_entity: CEntity;
    var current_heading: float;
    var is_player_busy: bool;
    var i: int;

    do {
      if (parent.areAllEntitiesDead()) {
        LogChannel('modRandomEncounters', "HuntEntity - wandering state, all entities dead");

        parent.GotoState('Ending');

        break;
      }

      for (i = parent.entities.Size() - 1; i >= 0; i -= 1) {
        current_entity = parent.entities[i];
        is_player_busy = isPlayerInScene();

        distance_from_player = VecDistance(
          current_entity.GetWorldPosition(),
          thePlayer.GetWorldPosition()
        );

        if (distance_from_player > parent.entity_settings.kill_threshold_distance) {
          LogChannel('modRandomEncounters', "killing entity - threshold distance reached: " + parent.entity_settings.kill_threshold_distance);

          parent.killEntity(current_entity);

          continue;
        }

        if (distance_from_player < 15
        || distance_from_player < 20 && ((CActor)current_entity).HasAttitudeTowards(thePlayer)) {
          // leave the function, it will automatically enter in the Combat state
          // and the creatures will attack the player.
          return;
        }

        distance_from_bait = VecDistanceSquared(
          current_entity.GetWorldPosition(),
          parent.bait_entity.GetWorldPosition()
        );

        if (distance_from_bait > 20 * 20) {
          ((CActor)parent.entities[i]).SetTemporaryAttitudeGroup(
            'monsters',
            AGP_Default
          );

          ((CActor)current_entity).ActionCancelAll();

          ((CNewNPC)current_entity)
            .NoticeActor((CActor)parent.bait_entity);
        }
      }

      Sleep(0.5);
    } while (true);
  }

  latent function resetEntitiesActions() {
    var i: int;
    var current_entity: CEntity;
    
    for (i = parent.entities.Size() - 1; i >= 0; i -= 1) {
      current_entity = parent.entities[i];

      ((CActor)current_entity).ActionCancelAll();

      ((CActor)current_entity)
          .GetMovingAgentComponent()
          .ResetMoveRequests();

      ((CActor)current_entity)
          .GetMovingAgentComponent()
          .SetGameplayMoveDirection(0.0f);
    }
  }
}
