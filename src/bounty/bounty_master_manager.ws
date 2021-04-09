
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
    var template_path: string;

    this.bounty_master_entity = theGame.GetEntityByTag('RER_bounty_master');

    template_path = "quests\secondary_npcs\graden.w2ent";

    // every hour of playtime it changes the index in the valid positions
    valid_positions = this.getBountyMasterValidPositions();
    position_index = (int)RandNoiseF(
      GameTimeHours(theGame.CalculateTimePlayed()),
      valid_positions.Size()
    ) % valid_positions.Size(); // the % is just in case

    if (position_index < 0 || position_index > valid_positions.Size() - 1) {
      position_index = (int)RandNoiseF(thePlayer.GetLevel(), valid_positions.Size() - 1) % valid_positions.Size();
    }

    if (position_index < 0 || position_index > valid_positions.Size() - 1) {
      position_index = 0;
    }

    // the bounty master already exist
    if (this.bounty_master_entity) {
      NLOG("bounty master exists, template = " + StrAfterFirst(this.bounty_master_entity.ToString(), "::"));

      // not the same template as the one asked, we kill the current bounty master

      if (StrAfterFirst(this.bounty_master_entity.ToString(), "::") != template_path) {
        NLOG("bounty master wrong template");
        // ((CActor)this.bounty_master_entity).Kill('RER');
        this.bounty_master_entity.Destroy();
        delete this.bounty_master_entity;
      }
      else {
        // teleport the bounty master at the current position based on the current playtime
        bounty_master_entity.Teleport(valid_positions[position_index]);
      }

    }
    
    if (!this.bounty_master_entity) {
      NLOG("bounty master doesn't exist");

      template = (CEntityTemplate)LoadResourceAsync(template_path, true);

      this.bounty_master_entity = theGame.CreateEntity(
        template,
        valid_positions[position_index],
        thePlayer.GetWorldRotation(),,,,
        PM_Persist
      );

      this.bounty_master_entity.AddTag('RER_bounty_master');
    }

    if (theGame.GetInGameConfigWrapper()
        .GetVarValue('RERoptionalFeatures', 'RERmarkersBountyHunting')) {

      this.bounty_manager.master.pin_manager.addPinHere(
        valid_positions[position_index],
        RER_InterestPin
      );

      NLOG("bounty master placed at " + VecToString(valid_positions[position_index]));
    }

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
        output.PushBack(Vector(11.5, -24.9, 2.3));
        
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
        output.PushBack(Vector(707.6, 1751.2, 4.3));

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

    can_talk_again = theGame.GetEngineTimeAsSeconds() - parent.last_talking_time > 15;

    // 
    while (distance_from_player > radius || !can_talk_again) {
      distance_from_player = VecDistance(
        thePlayer.GetWorldPosition(),
        parent.bounty_master_entity.GetWorldPosition()
      );
      
      can_talk_again = theGame.GetEngineTimeAsSeconds() - parent.last_talking_time > 15;

      if (distance_from_player > radius * 2) {
        if (theGame.GetInGameConfigWrapper()
        .GetVarValue('RERoptionalFeatures', 'RERmarkersBountyHunting')) {

          parent.bounty_manager.master.pin_manager.addPinHere(
            parent.bounty_master_entity.GetWorldPosition(),
            RER_InterestPin
          );
        }
      }

      // sleep for:
      // 0.5s at 10 meters
      // 1s at 20 meters
      // 1.5s at 30 meters
      // ...
      //
      // Capped at 60s
      Sleep(MinF(distance_from_player / 20, 60));
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
    parent.GotoState('Waiting');
  }

  latent function runConversation() {
    var npc_actor: CActor;
    var distance_from_player: float;
    var radius: float;
    var max_radius: float;
    var crowns_from_trophies: int;
    var should_continue: bool;
    var shorten_conversation: bool;

    npc_actor = (CActor)(parent.bounty_master_entity);
    max_radius = 10 * 10;

    // 1. first we wait for the player to get near enough so that the bounty master
    //    starts calling him.
    radius = 3 * 3;
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

    crowns_from_trophies = this.convertTrophiesIntoCrowns();

    if (crowns_from_trophies > 0) {
      NDEBUG("The bounty master bought your trophies for " + RER_yellowFont(crowns_from_trophies) + " crowns");
    }

    { // graden dialogs
      shorten_conversation = theGame.GetInGameConfigWrapper()
        .GetVarValue('RERoptionalFeatures', 'RERshortenBountyMasterConversation');

      // plays the voicelines only the first time the player meets Graden
      if (parent.bounty_manager.master.storages.bounty.bounty_level == 0) {
        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_graden_youre_a_witcher_will_you_help in thePlayer, true),
          npc_actor
        );

        if (!should_continue) {
          return;
        }

        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_i_am_dont_seen_notice in thePlayer, true)
        );

        if (!should_continue) {
          return;
        }

        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_graden_noble_of_you_thank_you in thePlayer, true),
          npc_actor
        );

        if (!should_continue) {
          return;
        }

        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_glad_you_know_who_i_am in thePlayer, true)
        );

        if (!should_continue) {
          return;
        }

        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_graden_certain_youve_heard_of_us in thePlayer, true),
          npc_actor
        );

        if (!should_continue) {
          return;
        }

        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_rings_a_bell in thePlayer, true)
        );

        if (!should_continue) {
          return;
        }

        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
        .dialog(new REROL_graden_matter_to_resolve in thePlayer, true),
          npc_actor
        );

        if (!should_continue) {
          return;
        }

        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_mhm_2 in thePlayer, true)
        );

        if (!should_continue) {
          return;
        }
      }
      else {
        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_graden_witcher in thePlayer, true),
          npc_actor
        );

        if (!should_continue) {
          return;
        }

        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_greetings in thePlayer, true)
        );

        if (!should_continue) {
          return;
        }
      }

      should_continue = this.playDialogue(
        (new RER_RandomDialogBuilder in thePlayer).start()
        .either(new REROL_what_surprise_new_monster_to_kill in thePlayer, true, 1)
        .either(new REROL_lemme_guess_monster_needs_killing in thePlayer, true, 1)
      );

      if (!should_continue) {
        return;
      }

      if (!shorten_conversation) {
        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_graden_ive_lost_five_men in thePlayer, true),
          npc_actor
        );

        if (!should_continue) {
          return;
        }

        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_i_see_the_wounds in thePlayer, true)
          .dialog(new REROL_any_witnesses in thePlayer, true)
        );

        if (!should_continue) {
          return;
        }

        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .either(new REROL_graden_didnt_sound_like_wolves in thePlayer, true, 1)
          .either(new REROL_graden_looked_a_fiend in thePlayer, true, 1),
          npc_actor
        );

        if (!should_continue) {
          return;
        }
      }

      should_continue = this.playDialogue(
        (new RER_RandomDialogBuilder in thePlayer).start()
        .dialog(new REROL_mhm_2 in thePlayer, true)
        .then(0.2)
      );

      if (!should_continue) {
        return;
      }

      if (!shorten_conversation && RandRange(10) > 5) {
        should_continue = this.playDialogue(
          (new RER_RandomDialogBuilder in thePlayer).start()
          .dialog(new REROL_really_helpful_that in thePlayer, true)
        );

        if (!should_continue) {
          return;
        }
      }

      should_continue = this.playDialogue(
        (new RER_RandomDialogBuilder in thePlayer).start()
        .either(new REROL_fine_show_me_where_monsters in thePlayer, true, 1)
        .either(new REROL_fine_ill_see_what_i_can_do in thePlayer, true, 1)
      );

      if (!should_continue) {
        return;
      }

      should_continue = this.playDialogue(
        (new RER_RandomDialogBuilder in thePlayer).start()
        .dialog(new REROL_graden_eternal_fire_protect_you in thePlayer, true),
        npc_actor
      );

      if (!should_continue) {
        return;
      }

      should_continue = this.playDialogue(
        (new RER_RandomDialogBuilder in thePlayer).start()
        .dialog(new REROL_farewell in thePlayer, true)
      );

      if (!should_continue) {
        return;
      }
    }

    distance_from_player = VecDistanceSquared(
      thePlayer.GetWorldPosition(),
      parent.bounty_master_entity.GetWorldPosition()
    );

    // start the bounty only if the player is close to the bounty master
    if (distance_from_player < radius) {
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

  private function shouldCancelDialogue(squared_radius: float): bool {
    return VecDistanceSquared(
      thePlayer.GetWorldPosition(),
      parent.bounty_master_entity.GetWorldPosition()
    ) > squared_radius;
  }

  private latent function playDialogue(dialog_builder: RER_RandomDialogBuilder, optional npc: CActor): bool {
    if (this.shouldCancelDialogue(3 * 3)) {
      (new RER_RandomDialogBuilder in thePlayer).start()
        .dialog(new REROL_graden_eternal_fire_protect_you in thePlayer, true)
        .play((CActor)(parent.bounty_master_entity));

      (new RER_RandomDialogBuilder in thePlayer).start()
        .dialog(new REROL_farewell in thePlayer, true)
        .play();

      return false;
    }

    dialog_builder.play(npc);

    return true;
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

      inventory.AddMoney(price);
      inventory.RemoveItem(guid, quantity);

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
    var bounty: RER_Bounty;

    bounty = parent.bounty_manager.getNewBounty(parent.picked_seed);

    parent.bounty_manager
      .startBounty(bounty);

      parent.GotoState('Waiting');
  }
}