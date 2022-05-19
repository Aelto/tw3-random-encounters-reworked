state CreateBounty in RER_BountyMasterManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_BountyMasterManager - CreateBounty");

    this.CreateBounty_main();
  }

  entry function CreateBounty_main() {
    parent.bounty_manager.startBounty(parent.picked_seed);
    parent.GotoState('Waiting');
  }
}