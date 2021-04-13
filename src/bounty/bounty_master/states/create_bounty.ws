state CreateBounty in RER_BountyMasterManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_BountyMasterManager - CreateBounty");

    this.CreateBounty_main();
  }

  entry function CreateBounty_main() {
    var bounty: RER_Bounty;

    bounty = parent.bounty_manager.getNewBounty(parent.picked_seed);

    parent.bounty_manager
      .startBounty(bounty);

      parent.GotoState('Waiting');
  }
}