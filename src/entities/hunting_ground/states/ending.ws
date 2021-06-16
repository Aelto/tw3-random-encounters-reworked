
state Ending in RandomEncountersReworkedHuntingGroundEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "RandomEncountersReworkedHuntingGroundEntity - State Ending");

    this.Ending_main();
  }

  entry function Ending_main() {
    if (parent.is_bounty) {
      parent.bounty_manager.notifyHuntingGroundKilled(parent.bounty_group_index);

      SU_removeCustomPinByPosition(parent.GetWorldPosition());
    }

    if (VecDistanceSquared(thePlayer.GetWorldPosition(), parent.bait_entity.GetWorldPosition()) < 50 * 50) {
      RER_tryRefillRandomContainer();
    }

    parent.clean();
  }
}
