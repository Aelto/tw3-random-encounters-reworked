state DialogChoice in RER_BountyMasterManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_BountyMasterManager - DialogChoice");

    this.DialogChoice_main();
  }

  entry function DialogChoice_main() {
    var choices: array<SSceneChoice>;
    var has_completed_a_bounty: bool;
    var crowns_from_trophies: int;

    has_completed_a_bounty = parent.bounty_manager.master.storages.bounty.bounty_level > 0;

    this.doMovementAdjustment();

    // TODO: add option to trade tokens into items

    choices.PushBack(SSceneChoice(
      GetLocStringByKey("rer_dialog_start_bounty"),
      true,
      has_completed_a_bounty,
      false,
      DialogAction_MONSTERCONTRACT,
      'StartBounty'
    ));

    if (has_completed_a_bounty) {
      choices.PushBack(SSceneChoice(
        GetLocStringByKey("rer_dialog_start_bounty_no_conversation"),
        true,
        false,
        false,
        DialogAction_MONSTERCONTRACT,
        'StartBountySkipConversation'
      ));
    }

    crowns_from_trophies = this.convertTrophiesIntoCrowns(true);

    choices.PushBack(SSceneChoice(
      StrReplace(
        GetLocStringByKey("rer_dialog_sell_trophies"),
        "{{crowns_amount}}",
        crowns_from_trophies
      ),
      false,
      // set the choice as `previously_chosen` to make it gray when selling the
      // trophies (if there are any trophy) would reward 0 crowns.
      crowns_from_trophies <= 0,
      false,
      DialogAction_SHOPPING,
      'SellTrophies'
    ));

    choices.PushBack(SSceneChoice(
      GetLocStringByKey("rer_dialog_farewell"),
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

    // while on gamepad, the interact input is directly sent in the dialog choice
    // it is safer to wait a bit before capturing the input.
    Sleep(0.25);

    while (true) {
      response = SU_setDialogChoicesAndWaitForResponse(choices);
      SU_closeDialogChoiceInterface();

      if (response.playGoChunk == 'CloseDialog') {
        (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_farewell in thePlayer, true)
          .play();

        (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_graden_eternal_fire_protect_you in thePlayer, true)
          .play((CActor)(parent.bounty_master_entity));

        parent.GotoState('Waiting');
        return;
      }

      if (response.playGoChunk == 'StartBounty') {
        parent.GotoState('Talking');
        return;
      }

      if (response.playGoChunk == 'StartBountySkipConversation') {
        parent.GotoState('SeedSelection');
        return;
      }

      (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_thanks_all_i_need_for_now in thePlayer, true)
          .play();

      this.convertTrophiesIntoCrowns();
      this.removeTrophyChoiceFromList(choices);
    }

  }

  function removeTrophyChoiceFromList(out choices: array<SSceneChoice>) {
    var i: int;

    for (i = 0; i < choices.Size(); i += 1) {
      if (choices[i].playGoChunk == 'SellTrophies') {
        choices.Erase(i);
        return;
      }
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

    if (output > 0 && !ignore_item_transaction) {
      NDEBUG(
        StrReplace(
          GetLocStringByKey("rer_bounty_master_trophies_bought_notification"),
          "{{crowns_amount}}",
          RER_yellowFont(output)
        )
      );
    }
    
    return output;
  }

  function doMovementAdjustment() {
    var movement_adjustor: CMovementAdjustor;
    var slide_ticket: SMovementAdjustmentRequestTicket;
    var target: CActor;

    target = thePlayer;

    movement_adjustor = ((CActor)parent.bounty_master_entity)
      .GetMovingAgentComponent()
      .GetMovementAdjustor();

    slide_ticket = movement_adjustor.GetRequest( 'RotateTowardsPlayer' );

    // cancel any adjustement made with the same name
    movement_adjustor.CancelByName( 'RotateTowardsPlayer' );

    // and now we create a new request
    slide_ticket = movement_adjustor.CreateNewRequest( 'RotateTowardsPlayer' );

    movement_adjustor.AdjustmentDuration(
      slide_ticket,
      1 // 500ms
    );

    movement_adjustor.RotateTowards(
      slide_ticket,
      target
    );
  }
}