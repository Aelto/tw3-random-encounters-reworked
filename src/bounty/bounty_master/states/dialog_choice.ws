state DialogChoice in RER_BountyMasterManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_BountyMasterManager - DialogChoice");

    this.DialogChoice_main();
  }

  entry function DialogChoice_main() {
    var choices: array<SSceneChoice>;
    var crowns_from_trophies: int;

    choices.PushBack(SSceneChoice(
      "Start bounty",
      true,
      false,
      false,
      DialogAction_MONSTERCONTRACT,
      'StartBounty'
    ));

    crowns_from_trophies = this.convertTrophiesIntoCrowns(true);

    choices.PushBack(SSceneChoice(
      StrReplace(
        "Sell trophies ({{crowns}})",
        "{{crowns}}",
        crowns_from_trophies
      ),
      false,
      false,
      false,
      DialogAction_SHOPPING,
      'SellTrophies'
    ));

    choices.PushBack(SSceneChoice(
      "Farewell.",
      false,
      false,
      false,
      DialogAction_GETBACK,
      'CloseDialog'
    ));

    this.displayDialogChoices(choices);
  }

  latent function displayDialogChoices(choices: array<SSceneChoice>) {
    var response: SSceneChoice;

    while (true) {
      response = SU_setDialogChoicesAndWaitForResponse(choices);
      SU_closeDialogChoiceInterface();

      if (response.playGoChunk == 'CloseDialog') {
        parent.GotoState('Waiting');
        return;
      }

      if (response.playGoChunk == 'StartBounty') {
        parent.GotoState('Talking');
        return;
      }

      this.convertTrophiesIntoCrowns();
    }

  }

  // returns the amount of crowns the player received from the trophies
  function convertTrophiesIntoCrowns(optional ignore_item_transaction: bool): int {
    var trophy_guids: array<SItemUniqueId>;
    var inventory: CInventoryComponent;
    var guid: SItemUniqueId;
    var price: int;
    var i: int;
    var output: int;
    var buying_price: float;
    var quantity: int;
    
    buying_price = StringToFloat(
      theGame.GetInGameConfigWrapper()
      .GetVarValue('RERmonsterTrophies', 'RERtrophyMasterBuyingPrice')
    ) / 100;

    inventory = thePlayer
      .GetInventory();

    trophy_guids = inventory
      .GetItemsByTag('RER_Trophy');

    for (i = 0; i < trophy_guids.Size(); i += 1) {
      guid = trophy_guids[i];
      quantity = inventory.GetItemQuantity(guid);

      price = (int)(inventory.GetItemPrice(guid) * buying_price) * quantity;

      if (!ignore_item_transaction) {
        inventory.AddMoney(price);
        inventory.RemoveItem(guid, quantity);
      }

      output += price;
    }

    if (output > 0) {
      NDEBUG("The bounty master bought your trophies for " + RER_yellowFont(output) + " crowns");
    }
    
    return output;
  }
}