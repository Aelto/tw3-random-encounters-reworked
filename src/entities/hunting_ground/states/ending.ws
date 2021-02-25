
state Ending in RandomEncountersReworkedHuntingGroundEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "RandomEncountersReworkedHuntingGroundEntity - State Ending");

    this.Ending_main();
  }

  entry function Ending_main() {
    if (parent.is_bounty) {
      parent.bounty_manager.notifyHuntingGroundKilled(parent.bounty_group_index);
      RER_toggleSkullPinAtPosition(parent.GetWorldPosition());
    }

    parent.clean();
  }
}
