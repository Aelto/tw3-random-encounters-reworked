
class RER_BountyModuleDialog extends CR4HudModuleDialog {

  var bounty_master_manager: RER_BountyMasterManager;
  
  function DialogueSliderDataPopupResult(value: float, optional isItemReward: bool) {
    super.DialogueSliderDataPopupResult(0,false);

    this.bounty_master_manager.bountySeedSelected((int)value);
  }

  function openSeedSelectorWindow(bounty_master_manager: RER_BountyMasterManager) {
    var data: BettingSliderData;
    var bounty_level: int;

    this.bounty_master_manager = bounty_master_manager;

    bounty_level = bounty_master_manager
      .bounty_manager
      .master
      .storages
      .bounty
      .bounty_level;

    data = new BettingSliderData in this;
    data.ScreenPosX = 0.62;
    data.ScreenPosY = 0.65;

    data.SetMessageTitle( GetLocStringByKey("panel_hud_dialogue_title_bet_rer"));
		data.dialogueRef = this;
		data.BlurBackground = false;

    data.minValue = 0;
		data.maxValue = bounty_master_manager.bounty_manager.getSeedBountyLevelStep() * bounty_level;
    data.currentValue = 0;

    theGame.RequestMenu('PopupMenu', data);

  }
}