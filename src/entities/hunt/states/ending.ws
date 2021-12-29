
state Ending in RandomEncountersReworkedHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "RandomEncountersReworkedHuntEntity - State Ending");

    this.Ending_main();
  }

  entry function Ending_main() {
    if (VecDistanceSquared(thePlayer.GetWorldPosition(), parent.bait_entity.GetWorldPosition()) < 50 * 50) {
      RER_tryRefillRandomContainer(parent.master);
    }
    parent.clean();
  }
}
