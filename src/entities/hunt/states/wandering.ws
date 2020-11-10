
state Wandering in RandomEncountersReworkedHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "RandomEncountersReworkedHuntEntity - State Wandering");
    this.Wandering_main();
  }

  entry function Wandering_main() {
    this.makeEntitiesMoveTowardsBait();

    parent.GotoState('Combat');
  }

  latent function makeEntitiesMoveTowardsBait() {
    var distance_from_player: float;
    var distance_from_bait: float;
    var current_entity: CEntity;
    var i: int;

    do {
      if (parent.areAllEntitiesDead()) {
        parent.GotoState('Ending');

        break;
      }

      // i'm doing it in reverse because why not?
      // i thought to myself, isn't it better to start from the higher end
      // and go lower.
      // Is it unnecessary micro optimization? Totally!
      for (i = parent.entities.Size() - 1; i >= 0; i -= 1) {
        current_entity = parent.entities[i];

        distance_from_player = VecDistance(
          current_entity.GetWorldPosition(),
          thePlayer.GetWorldPosition()
        );

        if (distance_from_player > parent.entity_settings.kill_threshold_distance) {
          LogChannel('modRandomEncounters', "killing entity - threshold distance reached: " + parent.entity_settings.kill_threshold_distance);

          parent.killEntity(current_entity);

          continue;
        }

        if (distance_from_player < 20) {
          // leave the function, it will automatically enter in the Combat state
          // and the creatures will attack the player.
          return;
        }

        distance_from_bait = VecDistanceSquared(
          current_entity.GetWorldPosition(),
          parent.bait_entity.GetWorldPosition()
        );

        if (distance_from_bait < 5 * 5) {
          this.teleportBaitEntity();
        }

        // ((CNewNPC)current_entity)
        //   .NoticeActor((CActor)parent.bait_entity);

        ((CNewNPC)current_entity)
        .ActionMoveTo(parent.bait_entity.GetWorldPosition());
      }

      Sleep(5);
    } while (true);
  }

  private function teleportBaitEntity() {
    var new_bait_position: Vector;
    var new_bait_rotation: EulerAngles;

    // NDEBUG("towards player " + parent.bait_moves_towards_player);

    if (parent.bait_moves_towards_player) {
      new_bait_position = parent.bait_entity.GetWorldPosition() 
        + VecConeRand(
          VecHeading(thePlayer.GetWorldPosition() - parent.bait_entity.GetWorldPosition()),
          90,
          10,
          20
        );
      new_bait_rotation = parent.bait_entity.GetWorldRotation();
    }
    else {
      new_bait_position = parent.bait_entity.GetWorldPosition() + VecConeRand(parent.GetHeading(), 90, 10, 20);
      new_bait_rotation = parent.bait_entity.GetWorldRotation();
      new_bait_rotation.Yaw += RandRange(-20,20);
    }
    
    parent.bait_entity.TeleportWithRotation(
      new_bait_position,
      new_bait_rotation
    );
  }
}
