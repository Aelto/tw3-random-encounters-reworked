state SeedSelection in RER_BountyMasterManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_BountyMasterManager - SeedSelection");

    this.SeedSelection_main();
  }

  entry function SeedSelection_main() {
    var distance_from_player: float;
    
    distance_from_player = VecDistanceSquared(
      thePlayer.GetWorldPosition(),
      parent.bounty_master_entity.GetWorldPosition()
    );

    // start the bounty only if the player is close to the bounty master
    if (distance_from_player < 10 * 10) {
      parent.last_talking_time = theGame.GetEngineTimeAsSeconds();

      // the player decided not to have the seed selector window show up. In this
      // case, we directly notify the bounty manager we want a bounty with the
      // seed 0.
      // The seed 0 is a special case, with this seed everything is completely
      // random and none of the values depend on the seed. Two bounties with
      // the seed 0 are not guaranteed to be the same unlike other seeds.
      if (theGame.GetInGameConfigWrapper().GetVarValue('RERoptionalFeatures', 'RERignoreSeedSelectorWindow')) {
        parent.bountySeedSelected(0);
      }
      else {
        this.openHaggleWindow();
      }
    }
    else {
      parent.GotoState('Waiting');
    }
  }

  

  function openHaggleWindow() {
    var haggle_module_dialog: RER_BountyModuleDialog;

    haggle_module_dialog = new RER_BountyModuleDialog in parent;
    haggle_module_dialog.openSeedSelectorWindow(parent);
  }
}
