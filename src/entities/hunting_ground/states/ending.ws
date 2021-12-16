
state Ending in RandomEncountersReworkedHuntingGroundEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "RandomEncountersReworkedHuntingGroundEntity - State Ending");

    this.Ending_main();
  }

  entry function Ending_main() {
    if (parent.is_bounty) {
      parent.bounty_manager.notifyHuntingGroundKilled(parent.bounty_group_index);

      RER_removePinsInAreaAndWithTag("RER_bounty_target", parent.GetWorldPosition(), 100);
      SU_updateMinimapPins();
    }

    if (VecDistanceSquared(thePlayer.GetWorldPosition(), parent.bait_entity.GetWorldPosition()) < 50 * 50) {
      RER_tryRefillRandomContainer();
    }

    if (!parent.manual_destruction) {
      parent.clean();
    }
  }
}
