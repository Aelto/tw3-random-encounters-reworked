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
        .play((CActor)(parent.bounty_master_entity), true);

      (new RER_RandomDialogBuilder in thePlayer).start()
        .dialog(new REROL_farewell in thePlayer, true)
        .play(, true);

      return false;
    }

    dialog_builder.play(npc, true);

    return true;
  }

  function openHaggleWindow() {
    var haggle_module_dialog: RER_BountyModuleDialog;

    haggle_module_dialog = new RER_BountyModuleDialog in parent;
    haggle_module_dialog.openSeedSelectorWindow(parent);
  }
}