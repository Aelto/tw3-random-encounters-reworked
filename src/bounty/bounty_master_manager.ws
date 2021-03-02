
statemachine class RER_BountyMasterManager {

  var bounty_master_entity: CEntity;

  var last_talking_time: float;

  var bounty_manager: RER_BountyManager;

  var picked_seed: int;

  public latent function init(bounty_manager: RER_BountyManager) {
    this.bounty_manager = bounty_manager;
    this.spawnBountyMaster();
    this.GotoState('Waiting');
  }

  public latent function spawnBountyMaster() {
    var valid_positions: array<Vector>;
    var template: CEntityTemplate;
    var position_index: int;

    this.bounty_master_entity = theGame.GetEntityByTag('RER_bounty_master');

    // every hour of playtime it changes the index in the valid positions
    valid_positions = this.getBountyMasterValidPositions();
    position_index = (int)RandNoiseF(
      GameTimeHours(theGame.CalculateTimePlayed()),
      valid_positions.Size()
    );

    // the bounty master already exist
    if (bounty_master_entity) {
      // remove a pin, and if there was no pin and it returns true, remove the
      // one we added just now then.
      if (RER_toggleInterestPinAtPosition(bounty_master_entity.GetWorldPosition())) {
        RER_toggleInterestPinAtPosition(bounty_master_entity.GetWorldPosition());
      }

      // teleport the bounty master at the current position based on the current playtime
      bounty_master_entity.Teleport(valid_positions[position_index]);
    }
    else {
      // TODO: spawn him
      template = (CEntityTemplate)LoadResourceAsync("dlc\bob\data\quests\secondary_npcs\damien.w2ent", true);

      this.bounty_master_entity = theGame.CreateEntity(
        template,
        valid_positions[position_index],
        thePlayer.GetWorldRotation(),,,,
        PM_Persist
      );

      this.bounty_master_entity.AddTag('RER_bounty_master');
    }

    if (!RER_toggleInterestPinAtPosition(bounty_master_entity.GetWorldPosition())) {
      RER_toggleInterestPinAtPosition(bounty_master_entity.GetWorldPosition());
    }

    NLOG("bounty master placed at " + VecToString(valid_positions[position_index]));

  }

  public function getBountyMasterValidPositions(): array<Vector> {
    var area: EAreaName;
    var area_string: string;
    var output: array<Vector>;

    area = theGame.GetCommonMapManager().GetCurrentArea();

    switch (area) {
      case AN_Prologue_Village:
      case AN_Prologue_Village_Winter:
        // Nilfgaardian garrison
        output.PushBack(Vector(-371.5, 372.5, 1.9));

        // Ransacked village
        output.PushBack(Vector(491.3, -64.7, 8.9));

        // Woeson Bridge - white orchard blacksmith
        output.PushBack(Vector(11.5, -24.9, 2.2));
        
        break;

      case AN_Skellige_ArdSkellig:
        // Holmstein port
        output.PushBack(Vector(-297.9, -1049, 6));

        // Holmstein port
        output.PushBack(Vector(-36, 619, 2));

        // Urialla harbor
        output.PushBack(Vector(1488, 1907, 4.7));
        break;

      case AN_Kaer_Morhen:
        // Crows perch
        output.PushBack(Vector(-91, -22.8, 146));
        break;

      case AN_NMLandNovigrad:
      case AN_Velen:
        // Blackbough
        output.PushBack(Vector(-186, 187, 7.6));

        // Crows perch
        output.PushBack(Vector(175, 7, 13.8));

        // Nilfgaardian camp
        output.PushBack(Vector(2321, -881, 16.1));

        // Novigrad - gregory bridge
        output.PushBack(Vector(691, 2025, 33.4));

        // Novigrad - portside gate
        output.PushBack(Vector(543, 1669, 4.12));

        // Novigrad - rosemary and thyme
        output.PushBack(Vector(707.6, 1751.2, 4.2));

        // Oxenfurt - novigrad gate
        output.PushBack(Vector(1758, 1049, 6.8));

        // Oxenfurt - western gate
        output.PushBack(Vector(1714.3, 918, 14));

        // Upper mill
          output.PushBack(Vector(2497, 2497, 2.8));
        break;

      default:
        area_string = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

        if (area_string == "bob") {
          // Beauclair port
          output.PushBack(Vector(-229, -1184, 3.7));

          // Castel vineyard
          output.PushBack(Vector(-745, -321, 29.4));

          // Cockatrice inn
          output.PushBack(Vector(-148.6, -635.4, 11.4));

          // Tourney grounds
          output.PushBack(Vector(-490.4, -954.3, 61.2));
        }
        else {
          // the real default
        }

        break;
    }

    return output;
  }

  public function bountySeedSelected(seed: int) {
    this.picked_seed = seed;

    this.GotoState('CreateBounty');
  }

}

state Waiting in RER_BountyMasterManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_BountyMasterManager - Waiting");

    this.Waiting_main();
  }

  entry function Waiting_main() {
    var distance_from_player: float;
    var can_talk_again: bool;
    var radius: float;

    radius = 10;
    distance_from_player = VecDistance(
      thePlayer.GetWorldPosition(),
      parent.bounty_master_entity.GetWorldPosition()
    );

    can_talk_again = theGame.GetEngineTimeAsSeconds() - parent.last_talking_time > 60;

    // 
    while (distance_from_player > radius || !can_talk_again) {
      distance_from_player = VecDistance(
        thePlayer.GetWorldPosition(),
        parent.bounty_master_entity.GetWorldPosition()
      );
      
      can_talk_again = theGame.GetEngineTimeAsSeconds() - parent.last_talking_time > 60;

      // sleep for:
      // 1s at 10 meters
      // 2s at 20 meters
      // 3s at 30 meters
      // ...
      //
      // Capped at 60s
      Sleep(MinF(distance_from_player / 10, 60));
    }

    parent.GotoState('Talking');
  }
}

state Talking in RER_BountyMasterManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_BountyMasterManager - Talking");

    this.Talking_main();
  }

  entry function Talking_main() {
    this.runConversation();
  }

  latent function runConversation() {
    var npc_actor: CActor;
    var distance_from_player: float;
    var radius: float;
    var max_radius: float;
    var crowns_from_trophies: int;

    npc_actor = (CActor)(parent.bounty_master_entity);
    max_radius = 10 * 10;

    // 1. first we wait for the player to get near enough so that the bounty master
    //    starts calling him.
    radius = 5 * 5;
    distance_from_player = VecDistanceSquared(
      thePlayer.GetWorldPosition(),
      parent.bounty_master_entity.GetWorldPosition()
    );

    while (distance_from_player > radius) {
      distance_from_player = VecDistanceSquared(
        thePlayer.GetWorldPosition(),
        parent.bounty_master_entity.GetWorldPosition()
      );

      SleepOneFrame();

      if (distance_from_player > max_radius) {
        return;
      }
    }

    { // dialogs
      (new RER_RandomDialogBuilder in thePlayer)
      .start()
      .dialog(new REROL_damien_greetings_witcher in thePlayer, true)
      .play(npc_actor);

      crowns_from_trophies = this.convertTrophiesIntoCrowns();
      if (crowns_from_trophies > 0) {
        NDEBUG("The bounty master bought your trophies for " + RER_yellowFont(crowns_from_trophies) + " crowns");
      }

      (new RER_RandomDialogBuilder in thePlayer)
          .start()
          .dialog(new REROL_what_surprise_new_monster_to_kill in thePlayer, true)
          .play();

      (new RER_RandomDialogBuilder in thePlayer)
        .start()
        .dialog(new REROL_damien_will_start_at_the_beginning in thePlayer, true)
        .dialog(new REROL_damien_crespi_was_the_first_to_die in thePlayer, true)
        .dialog(new REROL_damien_he_died_claws in thePlayer, true)
        .play(npc_actor);

      (new RER_RandomDialogBuilder in thePlayer)
              .start()
              .dialog(new REROL_i_see_the_wounds in thePlayer, true)
              .dialog(new REROL_any_witnesses in thePlayer, true)
              .play();

      if (RandRange(10) > 5) {
        (new RER_RandomDialogBuilder in thePlayer)
            .start()
            .dialog(new REROL_damien_you_insinuate_investigation_has_been_sloppy in thePlayer, true)
            .play(npc_actor);

        (new RER_RandomDialogBuilder in thePlayer)
              .start()
              .dialog(new REROL_see_the_wounds_what_kind_of_monster in thePlayer, true)
              .play();
      }

      (new RER_RandomDialogBuilder in thePlayer)
            .start()
            .either(new REROL_damien_do_you_believe_me_an_amateur in thePlayer, true, 0.5)
            .either(new REROL_damien_i_told_you_what_i_saw in thePlayer, true, 1)
            .play(npc_actor);

      (new RER_RandomDialogBuilder in thePlayer)
              .start()
              .either(new REROL_fine_show_me_where_monsters in thePlayer, true, 1)
              .either(new REROL_fine_ill_see_what_i_can_do in thePlayer, true, 1)
              .play();

      if (RandRange(10) > 5) {
          (new RER_RandomDialogBuilder in thePlayer)
              .start()
              .dialog(new REROL_damien_i_should_double_patrols in thePlayer, true)
              .play(npc_actor);

          (new RER_RandomDialogBuilder in thePlayer)
                .start()
                .either(new REROL_this_is_work_for_witcher in thePlayer, true, 1)
                .either(new REROL_send_them_certain_death in thePlayer, true, 1)
                .either(new REROL_boys_could_handle_monsters in thePlayer, true, 1)
                .play();

          if (RandRange(10) > 5) {
            (new RER_RandomDialogBuilder in thePlayer)
              .start()
              .either(new REROL_damien_to_a_lone_witcher in thePlayer, true, 1)
              .either(new REROL_damien_my_guardsmen_in_action in thePlayer, true, 1)
              .play(npc_actor);
          }
      }
      else {
        (new RER_RandomDialogBuilder in thePlayer)
          .start()
          .either(new REROL_damien_thank_you_i_hope_youre_worth_the_coin in thePlayer, true, 1)
          .either(new REROL_damien_good_luck in thePlayer, true, 1)
          .either(new REROL_damien_i_see_the_effort_you_put in thePlayer, true, 1)
          .play(npc_actor);
      }

      (new RER_RandomDialogBuilder in thePlayer)
        .start()
        .then(1)
        .dialog(new REROL_damien_do_not_tarry_time_is_not_our_friend in thePlayer, true)
        .play(npc_actor);

    }

    distance_from_player = VecDistanceSquared(
      thePlayer.GetWorldPosition(),
      parent.bounty_master_entity.GetWorldPosition()
    );

    // start the bounty only if the player is close to the bounty master
    if (distance_from_player < radius) {
      parent.last_talking_time = theGame.GetEngineTimeAsSeconds();
      this.openHaggleWindow();
    }
    else {
      parent.GotoState('Waiting');
    }
  }

  // returns the amount of crowns the player received from the trophies
  function convertTrophiesIntoCrowns(): int {
    var trophy_guids: array<SItemUniqueId>;
    var inventory: CInventoryComponent;
    var guid: SItemUniqueId;
    var price: int;
    var i: int;
    var output: int;
    var buying_price: float;
    
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

      price = (int)(inventory.GetItemPrice(guid) * buying_price);

      inventory.AddMoney(price);
      inventory.RemoveItem(guid);

      output += price;
    }
    
    return output;
  }

  function openHaggleWindow() {
    var haggle_module_dialog: RER_BountyModuleDialog;

    haggle_module_dialog = new RER_BountyModuleDialog in parent;
    haggle_module_dialog.openSeedSelectorWindow(parent);
  }
}

state CreateBounty in RER_BountyMasterManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_BountyMasterManager - CreateBounty");

    this.CreateBounty_main();
  }

  entry function CreateBounty_main() {
    parent.bounty_manager
      .startBounty(parent.bounty_manager.getNewBounty(parent.picked_seed));

      parent.GotoState('Waiting');
  }
}